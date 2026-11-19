-- ============================================================================
-- TEMPLATE de query de base para disparo de WhatsApp
-- ----------------------------------------------------------------------------
-- Adapte os nomes de tabela/coluna ao seu banco e preencha os {{placeholders}}
-- com os valores da seção "Configuração" do SKILL.md.
-- Escrito em SQL próximo do padrão; funções de array/regex variam por banco
-- (ClickHouse, BigQuery, Postgres). Ajuste a sintaxe conforme o seu.
--
-- Tabelas esperadas (renomeie para as suas):
--   contacts        (id, name, phone, country_code, phone_is_valid, segment, deleted_at, archived_at, owner_id)
--   deals           (id, contact_id, origin_id, status, created_at, lost_at, last_stage_change_at, lost_reason_id, segment, utm_source, utm_campaign, owner_id)
--   tags            (id, name, owner_id)
--   contact_tags    (contact_id, tag_id)
--   campaigns       (id, type, scheduled_date, owner_id)
--   campaign_contacts (campaign_id, contact_id, created_at)
--   activities      (contact_id, type, created_at, owner_id)
--
-- Saída: contagem por grupo. Para puxar os ids, troque o SELECT final por:
--   SELECT base, contact_id, name FROM prio_ranked WHERE rn <= {{limite_por_grupo}}
-- ============================================================================

WITH
-- 1) Tags que tiram o contato da base (disparos recentes, opt-out, blacklist,
--    parceiros, colaboradores, clientes ativos, nutrição em andamento...)
excl_tags AS (
  SELECT id FROM tags
  WHERE owner_id = '{{id_tenant_ou_owner}}'
    AND (
         name LIKE '{{prefixo_tag_da_base}}%'          -- ex.: '[mkt]disparo_%'
      OR name LIKE '{{prefixo_tag_de_lead}}%'          -- ex.: 'dp\_%'
      OR lower(name) IN ({{lista_tags_negativas}})     -- opt-out, blacklist, cliente ativo, recebeu no mês...
      OR lower(name) LIKE '%parceir%'
    )
),
ex_tag AS (
  SELECT DISTINCT contact_id FROM contact_tags WHERE tag_id IN (SELECT id FROM excl_tags)
),

-- 2) Quem recebeu qualquer disparo na janela de exclusão
recent_camps AS (
  SELECT id FROM campaigns
  WHERE owner_id = '{{id_tenant_ou_owner}}'
    AND type = '{{tipo_campanha_whatsapp}}'
    AND scheduled_date >= CURRENT_DATE - INTERVAL '{{janela_de_exclusao_pos_disparo}}' DAY
),
ex_camp AS (
  SELECT DISTINCT contact_id FROM campaign_contacts WHERE campaign_id IN (SELECT id FROM recent_camps)
),

-- 3) Negócios: ganhos, perdidos por motivo ruim, abertos mexidos recentemente,
--    parceiros e qualquer negócio em pipes excluídos (RH, teste, CS/CX)
d AS (
  SELECT * FROM deals WHERE owner_id = '{{id_tenant_ou_owner}}' AND deleted_at IS NULL
),
ex_deal AS (
  SELECT DISTINCT contact_id FROM d
  WHERE status = 'WON'
     OR (status = 'LOST' AND lost_reason_id IN ({{motivos_de_perda_ruins}}))
     OR (status = 'OPEN' AND last_stage_change_at >= CURRENT_DATE - INTERVAL '{{janela_de_exclusao_pos_disparo}}' DAY)
     OR origin_id IN ({{pipes_a_excluir}})
     OR lower(coalesce(utm_source,'') || '|' || coalesce(utm_campaign,'')) LIKE '%parceir%'
),

-- 4) Reunião/agendamento recente
ex_act AS (
  SELECT DISTINCT contact_id FROM activities
  WHERE owner_id = '{{id_tenant_ou_owner}}'
    AND upper(type) IN ('SCHEDULE','MEETING')
    AND created_at >= CURRENT_DATE - INTERVAL '{{janela_de_exclusao_pos_reuniao}}' DAY
),

-- 5) Contatos com telefone válido
c AS (
  SELECT id, name FROM contacts
  WHERE owner_id = '{{id_tenant_ou_owner}}'
    AND deleted_at IS NULL AND archived_at IS NULL     -- se datas vazias vierem como 1970, use ano < 2000
    AND country_code = '{{ddi}}'                        -- ex.: '55'
    AND phone_is_valid
    AND length(regexp_replace(phone, '[^0-9]', '')) = {{digitos_do_telefone}}  -- ex.: 11 (sem o DDI)
),

ok AS (
  SELECT id FROM c
  WHERE id NOT IN (SELECT contact_id FROM ex_tag)
    AND id NOT IN (SELECT contact_id FROM ex_camp)
    AND id NOT IN (SELECT contact_id FROM ex_deal)
    AND id NOT IN (SELECT contact_id FROM ex_act)
),

-- 6) Candidatos por grupo (defina os seus em "grupos" no SKILL.md)
cand AS (
  -- Grupo por segmento (palavras-chave no segmento do negócio)
  SELECT contact_id, '{{grupo_1}}' AS base, DATE '2000-01-01' AS k FROM d
  WHERE origin_id IN ({{origens_validas_de_lead}})
    AND lower(coalesce(segment,'')) SIMILAR TO '%({{palavras_chave_segmento}})%'   -- ex.: 'clinica|odonto|estetica'

  UNION ALL
  -- Perdidos depois de conversar (motivos "bons" de reativação)
  SELECT contact_id, '{{grupo_2}}', lost_at FROM d
  WHERE status = 'LOST' AND lost_reason_id IN ({{motivos_reativaveis}})
    AND origin_id IN ({{origens_validas_de_lead}})
    AND lost_at >= CURRENT_DATE - INTERVAL '365' DAY

  UNION ALL
  -- Perdidos por tentativas de contato esgotadas
  SELECT contact_id, '{{grupo_3}}', lost_at FROM d
  WHERE status = 'LOST' AND lost_reason_id = '{{motivo_tentativas_esgotadas}}'
    AND origin_id IN ({{origens_validas_de_lead}})
    AND lost_at >= CURRENT_DATE - INTERVAL '365' DAY
    AND lost_at <  CURRENT_DATE - INTERVAL '7' DAY
),

-- 7) Cada contato fica em um grupo só (ordem de prioridade) e mais recente primeiro
prio AS (
  SELECT contact_id,
         MIN(CASE base WHEN '{{grupo_1}}' THEN 1 WHEN '{{grupo_2}}' THEN 2 ELSE 3 END) AS p,
         MAX(k) AS k
  FROM cand WHERE contact_id IN (SELECT id FROM ok)
  GROUP BY contact_id
),
prio_ranked AS (
  SELECT CASE p WHEN 1 THEN '{{grupo_1}}' WHEN 2 THEN '{{grupo_2}}' ELSE '{{grupo_3}}' END AS base,
         pr.contact_id, c.name,
         ROW_NUMBER() OVER (PARTITION BY p ORDER BY pr.k DESC, pr.contact_id) AS rn
  FROM prio pr JOIN c ON c.id = pr.contact_id
  WHERE NOT (lower(c.name) ~ '(^|[^a-z])(teste?|test)([^a-z]|$)')   -- tira nomes de teste
)

SELECT base, COUNT(*) FROM prio_ranked GROUP BY base ORDER BY base;
