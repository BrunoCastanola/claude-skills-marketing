# Skills e prompts de Claude para marketing e vendas

Skills e prompts que uso no dia a dia de marketing de performance e operação comercial com o Claude. Todos são **modelos**: a lógica está pronta e os dados da sua operação você preenche nos campos `[PREENCHA]`.

## O que tem aqui

| Arquivo | Tipo | O que faz |
|---|---|---|
| [`skills/revisar-copy`](skills/revisar-copy/SKILL.md) | Skill | Revisa e escreve copy (e-mail, WhatsApp, SMS, anúncio, LP) em três passes: conversão, voz da marca e padrões de texto de IA em PT-BR. Dá nota e só entrega acima de 90. |
| [`skills/disparos-whatsapp-api`](skills/disparos-whatsapp-api/SKILL.md) | Skill | Monta disparos de WhatsApp API de ponta a ponta: limpa e separa bases no banco, aplica tags no CRM, monta a campanha, filtra negativos, agenda e confere. |
| [`skills/disparos-whatsapp-api/references/query_bases_template.sql`](skills/disparos-whatsapp-api/references/query_bases_template.sql) | SQL | Modelo da query de limpeza de base usada pela skill de disparos. |
| [`prompts/revenue-intelligence.md`](prompts/revenue-intelligence.md) | Prompt | Analisa calls, conversas e anotações do CRM para achar dores, argumentos que funcionam, pontos cegos e o gap entre motivo de perda registrado e real. |

## Como instalar as skills

Uma skill é uma pasta com um `SKILL.md` (e, às vezes, arquivos de apoio em `references/`).

**Claude (app e web):** compacte a pasta da skill em `.zip` (ex.: `revisar-copy.zip`, com o `SKILL.md` dentro) e envie na área de Skills das configurações do Claude.

**Claude Code:** copie a pasta para `~/.claude/skills/` (vale para todos os projetos) ou para `.claude/skills/` dentro do projeto.

```bash
git clone https://github.com/<usuario>/<repositorio>.git
cp -r <repositorio>/skills/revisar-copy ~/.claude/skills/
```

## Antes de usar: preencha a configuração

1. Abra o `SKILL.md` e procure por `[PREENCHA]`.
2. Substitua pelos dados da sua operação: nome da marca, oferta, cases, IDs do CRM, nomes de tabela etc.
3. **Não coloque senhas, tokens ou chaves de API nos arquivos.** As skills foram pensadas para usar conectores (MCP) já autenticados no Claude.
4. Se você publicar a sua versão preenchida, deixe o repositório privado: ela passa a ter dados internos.

## Como usar o prompt

Abra o arquivo em `prompts/`, preencha a seção CONFIGURAÇÃO e cole numa conversa do Claude com o conector do seu CRM ativo.

## Contribuições

Achou um erro ou adaptou para outro CRM? Abra uma issue ou um pull request.
