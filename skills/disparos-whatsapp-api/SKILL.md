---
name: disparos-whatsapp-api
description: Monta e agenda disparos de WhatsApp API (templates de marketing) de ponta a ponta — separa bases limpas e sem cruzamento no banco de dados, cria e aplica tags no CRM, monta a campanha com fluxo de automação, filtra o público com os negativos (blacklist/opt-out), agenda e confere tudo no banco. Use quando pedirem para agendar, montar ou programar disparos, "disparos de amanhã", "separa as bases", "tagueia os leads", "monta a campanha", "plano de disparos da semana".
---

# Disparos de WhatsApp API

Skill-modelo. A lógica (limpeza de base, tags, campanha, conferência) é genérica. Tudo o que é específico da sua operação fica no bloco de configuração abaixo.

> **Antes de usar:** preencha todos os `[PREENCHA]` da seção "Configuração". Enquanto um campo estiver vazio, pergunte ao usuário em vez de supor. Nunca grave tokens, senhas ou chaves de API neste arquivo: use os conectores (MCP) já autenticados.

## Configuração [PREENCHA]

```yaml
quem_pede: "[Nome/área de quem solicita os disparos]"
idioma_resposta: "pt-BR"

# Ferramentas
crm: "[Nome do CRM / plataforma de disparo]"
url_do_app: "[https://...]"
banco_de_dados: "[ClickHouse / BigQuery / Postgres...] — via conector [nome do MCP]"
id_do_servico_ou_projeto: "[ID do serviço/projeto do banco]"
navegador_para_ui: "[Claude in Chrome / outro]"  # usado quando o conector não cobre a etapa

# Número e conta de envio
numero_de_envio: "[Nome do número/canal de envio]"
id_conta_de_envio: "[ID da conta do WhatsApp no CRM]"
id_tenant_ou_owner: "[ID da sua conta/workspace no banco, se o banco for multi-tenant]"

# Orçamento
verba_diaria: "[R$ ...]"
custo_por_mensagem_entregue: "[R$ ... — confira a tabela vigente da Meta para a categoria marketing no seu país]"
taxa_de_entrega_media: "[ex.: 80%]"
# envios_por_dia = verba_diaria / (custo_por_mensagem_entregue * taxa_de_entrega_media)

# Regras de frequência
intervalo_minimo_entre_disparos_por_contato: "[ex.: 7 dias]"
janela_de_exclusao_pos_disparo: "[ex.: 14 dias]"
janela_de_exclusao_pos_reuniao: "[ex.: 30 dias]"

# Convenção de tags
tag_da_base: "[ex.: [mkt]disparo_DD/MM_<GRUPO>_<NOME>]"
tag_de_lead_no_clique: "[ex.: dp_<nome>_DD/MM/AA]"
tag_optout: "[nome e ID da tag de opt-out]"
tags_blacklist: ["[nome e ID]", "[nome e ID]"]
tag_recebeu_no_mes: "[ex.: Recebeu - <Mês> <Ano>]"

# Destino do card criado no clique
pipe_dia_com_humano: { origem_id: "[ ]", etapa_id: "[ ]" }
pipe_dia_com_agente_ia: { origem_id: "[ ]", etapa_id: "[ ]" }   # ex.: fim de semana
utm_source_padrao: "[ex.: Disparo API]"

# Exclusões
motivos_de_perda_ruins: ["[IDs: fora do perfil, já é cliente, telefone errado...]"]
origens_validas_de_lead: ["[IDs das origens/pipes de lead]"]
pipes_a_excluir: ["[RH/candidatos]", "[testes]", "[CS/CX/clientes]", "[parceiros]"]

# Grupos de base (defina os seus)
grupos:
  - { letra: "[ex.: S]", criterio: "[ex.: segmento X por palavra-chave]" }
  - { letra: "[ex.: B]", criterio: "[ex.: perdeu depois de conversar, últimos 365 dias]" }
  - { letra: "[ex.: A]", criterio: "[ex.: perdido por tentativas esgotadas, entre 7 e 365 dias]" }

# Campanhas-modelo para duplicar (por tipo de botão)
modelo_quick_reply_agendamento: "[nome da campanha]"
modelo_botao_url: "[nome da campanha]"
modelo_conteudo_com_follow: "[nome da campanha]"
```

## Regras fixas

- **Regras da Meta para template:** a variável (`{{1}}`) não pode abrir nem fechar o texto; botão de quick reply tem no máximo 25 caracteres; template pode ser pausado por qualidade e o envio falha com erro de template pausado. Confira a documentação oficial da Meta se a regra mudar.
- **Nunca subir header com imagem de baixa resolução.** Na dúvida, o template vai sem imagem.
- **Nenhum contato recebe dois disparos dentro do `intervalo_minimo_entre_disparos_por_contato`**, mesmo entre bases montadas em conversas diferentes.
- `[PREENCHA: regras de conteúdo da sua empresa, ex. sem promoção/prazo em disparo de agendamento]`

## Passo 1. Plano do dia

Para cada disparo: template, base, contatos, horário, tag da base e tag de lead. Confira no banco o texto, os botões e o **status** do template antes (precisa estar aprovado, não pausado):

```sql
-- Adapte à tabela de templates do seu CRM/banco
SELECT name, status, components
FROM [tabela_de_templates]
WHERE [conta_de_envio] = '{{id_conta_de_envio}}' AND name IN (...)
```

Depois do envio, confira o status por contato (erros e mensagem de erro).

Tipos de botão e o que o fluxo faz com cada um:
- **Quick reply de contato** (ex.: "Quero agendar"): o clique cria o card no pipe.
- **Botão URL** (blog, vídeo): o clique não dispara fluxo. O fluxo fica só com o opt-out e a tag de recebido.
- **Quick reply de conteúdo** (ex.: "Ler agora"): manda o link, espera alguns minutos e faz um follow com "Falar com o time". Só o segundo clique cria o card.

## Passo 2. Bases

Use `references/query_bases_template.sql` (adapte nomes de tabela e coluna ao seu banco). Padrão de limpeza:

- **Fora por tag:** quem já recebeu disparo recente, quem clicou recente, nutrição em andamento, blacklist, opt-out, parceiros, colaboradores e clientes ativos.
- **Fora por histórico:** recebeu qualquer disparo na `janela_de_exclusao_pos_disparo`; tem negócio ganho; foi perdido por motivo ruim; tem negócio aberto movimentado recentemente; teve reunião/agendamento na `janela_de_exclusao_pos_reuniao`.
- **Fora por pipe:** qualquer negócio em `pipes_a_excluir` (candidatos a vaga são o erro mais comum: entram como "perdidos" e poluem a base).
- **Só origens de lead:** os grupos filtram por `origens_validas_de_lead`.
- **Telefone:** DDI do país, telefone válido, número de dígitos correto.
- **Nome:** tire teste/test. Para template com variável de nome, tire nomes de empresa (LTDA, ME, números, "comercial", "loja").
- **Prioridade:** cada contato entra em um grupo só (ordem definida em `grupos`), mais recente primeiro.
- **Gotchas comuns:** datas vazias podem vir como 1970 (`ano < 2000`); alias igual a nome de coluna quebra o WHERE em alguns bancos; resultado grande pode vir salvo em arquivo (leia com Python).
- O dia que pede agendamento com humano fica com os leads mais recentes; o de conteúdo, com o resto.
- Garanta com um `assert` em Python que nenhum id aparece em duas bases.

## Passo 3. Tags no CRM

- Crie a tag da base e a tag de lead com o conector do CRM, seguindo a convenção da configuração.
- Se o conector só aplica tag **um contato por vez**: divida os ids em arquivos de ~250 (`split -l 250`) e distribua entre subagentes em paralelo.
- **Subagente pode relatar 100% e ter aplicado menos.** Sempre confira no banco antes de montar o público: puxe os contatos com a tag, faça o diff contra a lista e aplique você mesmo o que faltou.

## Passo 4. Campanha no CRM

Use o conector quando ele cobrir a etapa; senão, o navegador.

1. **Duplicar** a campanha-modelo do tipo certo de botão (ver configuração).
2. **Tamanho do lote:** respeite o limite de contatos por campanha da sua plataforma. Se recusar por limite, deixe a campanha pronta e tente de novo mais tarde. Agende **só dentro da janela pedida** e **não refaça campanha já agendada** para corrigir detalhe.
3. **Nome, número e horário:** nome no padrão `[PREENCHA]`, número de envio da configuração, data e hora.
4. **Fluxo:**
   - Trocar o template no nó de envio e religar os botões (as ligações costumam cair ao trocar o template).
   - **Variável de nome:** mapear para o campo de nome correto do contato e conferir depois (campanha duplicada de modelo antigo pode vir com o campo errado).
   - Nó de criar negócio: tag de lead, `utm_source_padrao`, `utm_campaign` igual à tag de lead, pipe/etapa conforme o dia (humano ou agente de IA).
   - Botão de bloquear/sair → tag de opt-out.
   - Fim do fluxo → tag de recebido no mês.
5. **Público:** possui a tag da base **E** não possui opt-out, blacklist(s) e recebido no mês, tudo no mesmo grupo de condição. Cuidado com tags de nome parecido (acento, maiúscula, variações): selecione pelo nome exato ou pelo ID. Confira o número de selecionados.
6. **Confirmar:** confira nome, data, hora e quantidade antes de agendar.

## Passo 5. Conferir no banco

```sql
-- Adapte à tabela de campanhas do seu CRM/banco
SELECT name, status, scheduled_date, audience_filter
FROM [tabela_de_campanhas]
WHERE [owner] = '{{id_tenant_ou_owner}}' AND name LIKE '%DD/MM%'
```

Precisa sair agendada, no horário certo e com o filtro de público completo (tag da base + todos os negativos no mesmo grupo). Confira também o mapeamento da variável de nome no nó de envio do fluxo.

## Passo 6. Entrega

Uma tabela por dia: horário, campanha, template, contatos, tag da base e tag de lead. Inclua o custo estimado do dia (`contatos × custo_por_mensagem_entregue × taxa_de_entrega_media`) e qualquer desvio, por exemplo uma base que não chegou no número. Se for para o time comercial, ofereça o texto em formato WhatsApp (negrito com `*`): uma mensagem de instruções e uma por disparo, com a copy, a tag e o gancho de abordagem.

Se a tela travar durante a automação no navegador, espere e confira de novo: a ação normalmente já foi feita. Confirme sempre pelo banco.
