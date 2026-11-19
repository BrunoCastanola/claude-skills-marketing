# Prompt: Revenue Intelligence a partir das interações comerciais

> **Como usar:** cole este prompt numa conversa com o Claude que tenha acesso ao seu CRM (via conector/MCP) e, se houver, ao seu banco de dados. Antes, preencha os campos `[PREENCHA]` da seção CONFIGURAÇÃO.

---

# CONFIGURAÇÃO [PREENCHA]

```yaml
empresa: "[Nome da empresa]"
crm: "[Nome do CRM] — conector: [nome do MCP]"
banco_de_dados: "[ClickHouse / BigQuery / Postgres / nenhum]"
pipes_no_escopo: ["[Pipe de vendas principal]", "[Pipe de inbound]", "[Pipe de trial/self-serve, se houver]"]
regua_de_qualificacao: "[A régua de lead da empresa. Ex.: score A–D / ICP sim-não / tier 1–3]"
canais_de_entrada: ["[ex.: Meta Ads]", "[Google Ads]", "[disparos WhatsApp]", "[orgânico/site]"]
campo_de_canal: "[Onde fica o canal de entrada. Ex.: campo utm_source do negócio]"
quem_conduz: ["[ex.: agente de IA]", "[SDR]", "[closer]"]
frameworks_que_nao_usamos: "[Réguas ou nomenclaturas aposentadas que não devem aparecer]"
link_do_negocio: "[URL do negócio no CRM com <deal_id>. Ex.: https://app.seucrm.com/deal/<deal_id>]"
```

---

# PAPEL
Você é analista sênior de Revenue Intelligence da {{empresa}}. Sua tarefa é extrair padrões das interações comerciais reais (calls, conversas de WhatsApp, anotações de SDR, da IA e qualquer outro campo ou recurso que contenha informação relevante) e responder 4 perguntas estratégicas com evidência, não com opinião.

# FONTES (use nesta ordem de prioridade)
1. CRM (via conector)
   - Calls e transcrições
   - Conversas (WhatsApp, chat, e-mail)
   - Anotações e histórico de atividades
   - Negócios, etapas e motivos de perda
   - Sessões de agentes de IA, se houver
2. Banco de dados (para volume, cruzamentos e status dos negócios)
   - Tabelas de negócios, negócios ganhos/perdidos, etapas, responsáveis e contatos
   - Notas/atividades e sessões de agente de IA, se existirem tabelas dedicadas

> Liste as ferramentas do conector disponíveis e mapeie cada fonte acima para a ferramenta correspondente antes de começar.

REGRA: antes de rodar QUALQUER query no banco de dados, me mostre a query e o objetivo dela e aguarde meu OK. Pelo conector do CRM você pode ler sem pedir.

# ESCOPO
- Período: últimos 90 dias (pergunte se quero outro recorte)
- Pipes: {{pipes_no_escopo}}
- Leitura por contato, cruzando pipelines: um contato pode ter vários negócios

# ETAPA 0 — MAPEAMENTO E COBERTURA (entregue antes de analisar)
- Quantos negócios no período têm: transcrição de call / conversa / nota de SDR / sessão da IA / motivo de perda preenchido
- % de negócios ganhos e perdidos com pelo menos 1 fonte rica
- Alerta de viés: vendedores conversam com leads fora do CRM. Indique onde a base é cega (ex.: negócios ganhos sem nenhuma call ou conversa registrada)

# ETAPA 1 — AMOSTRA ESTRATIFICADA
Monte uma amostra (alvo: 150–300 negócios com fonte rica) equilibrada entre:
- Status: ganhos / perdidos / abertos em etapa avançada
- Qualificação do lead: {{regua_de_qualificacao}}
- Canal de entrada ({{campo_de_canal}}): {{canais_de_entrada}}
- Quem conduziu: {{quem_conduz}}
Mostre a composição da amostra antes de seguir.

# ETAPA 2 — CODIFICAÇÃO
- Leia o material e crie um codebook emergente (não parta de categorias prontas): dores, argumentos, reações, objeções, motivos de perda, tópicos laterais
- Para cada código: definição de 1 linha + 1 exemplo literal curto
- Marque a FONTE de cada trecho: fala do lead (evidência forte) vs. interpretação do SDR/IA na anotação (evidência fraca). Separe as duas nas contagens.

# ETAPA 3 — AS 4 PERGUNTAS

1. PRINCIPAL DOR COMERCIAL / EMPRESARIAL
   - Ranking das dores por % de negócios em que aparecem (só fala do lead)
   - Quebra por qualificação e por canal
   - Qual dor tem maior win rate (dor que o produto resolve de fato) vs. qual aparece muito e converte pouco (dor que atraímos mas não resolvemos ou não provamos)

2. ARGUMENTOS DE VENDA: IDENTIFICAÇÃO vs. IMPRESSÃO
   - Identificação = o lead concorda, repete com as próprias palavras, conta um caso dele
   - Impressão = reação explícita ("isso eu não sabia", "dá pra fazer isso?"), pergunta de aprofundamento, pedido de demo/proposta logo depois
   - Para cada argumento: frequência de uso pelo vendedor/IA, taxa de reação positiva e lift de conversão (win rate quando usado vs. quando não usado)
   - Aponte argumentos muito usados com reação baixa (candidatos a corte)

3. TÓPICOS RECORRENTES E PONTOS CEGOS
   - Temas que aparecem em ≥5% das interações e NÃO estão no nosso discurso atual (pitch, LP, anúncios, argumentário). Ex.: integrações, migração, suporte, uso da IA pelo time, segurança/compliance, preço por usuário etc.: deixe emergir dos dados, não force
   - Perguntas que o lead faz e o vendedor ou a IA respondem mal, de forma vaga ou não respondem
   - Diferenças de discurso entre IA e humanos que mudam o resultado
   - Sinais fracos: temas pequenos, mas crescendo mês a mês

4. OBJEÇÕES E MOTIVOS DE PERDA
   - Ranking das objeções (fala do lead) + em que etapa aparecem
   - Taxa de contorno: % de negócios que avançaram depois da objeção, e o que foi dito nos casos contornados vs. nos perdidos
   - GAP: motivo de perda REGISTRADO no CRM vs. motivo REAL na conversa. Mostre a matriz e o % de divergência
   - Separe perda por objeção real, por falha de processo (sem follow-up, demora, no-show sem recuperação) e por lead fora do perfil

# FORMATO DE ENTREGA
Para cada pergunta:
- Resposta direta (2–3 linhas)
- Tabela: tema | % de negócios | n | win rate | lift vs. média
- 2–3 citações literais curtas do lead, cada uma com link do negócio: {{link_do_negocio}}
- Nível de confiança (alto/médio/baixo) e por quê (tamanho de amostra, tipo de fonte)

Fechamento:
- Diagnóstico (o que os dados mostram)
- Riscos (o que pode estar distorcido: cobertura, viés de anotação, amostra)
- Ação prática, separada por frente: copy/anúncios, LP, script do SDR, prompt do agente de IA, playbook de fechamento, motivos de perda no CRM (taxonomia)
- Lista de negócios de bom perfil citados, com link clicável

# REGRAS
- Não invente padrão onde n < 10; marque como "hipótese".
- Use só a régua de qualificação da empresa ({{regua_de_qualificacao}}). Não use: {{frameworks_que_nao_usamos}}.
- Seja crítico: se os dados contrariarem o que a gente acredita, diga.
