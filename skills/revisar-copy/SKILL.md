---
name: revisar-copy
description: Use para revisar, dar nota, melhorar, humanizar ou escrever do zero qualquer copy da sua marca (e-mail, WhatsApp, SMS, anúncio, legenda, LP, roteiro). Revisa conversão, voz da marca e padrões de texto de IA numa passada só, com corte 90.
---

# Revisar copy (conversão + voz da marca + humanize)

Skill independente: tudo o que ela precisa está neste arquivo. Revisa copy existente numa passada única (conversão, voz da marca, padrões de texto de IA) e devolve a versão corrigida com nota. Se não houver copy, escreva primeiro com a §2 e depois revise com o resto.

> **Antes de usar:** preencha os blocos marcados com `[PREENCHA]` (§A, §4, §6 e §7). Enquanto um bloco estiver vazio, a skill pede o dado ao usuário ou marca como pendência, nunca inventa.

## A. Configuração da marca [PREENCHA]

```yaml
marca: "[Nome da marca]"            # como a marca é escrita (artigo incluído, ex.: "a Marca")
produto_em_uma_linha: "[O que o produto faz, com verbos concretos]"
publico: "[Quem compra: segmento, porte, cargo]"
oferta_de_entrada: "[Ex.: trial de X dias sem cartão / demo / diagnóstico gratuito]"
modelo_de_cobranca: "[Ex.: mensal, cancela quando quiser / anual]"
garantia_oficial: "[Ex.: 14 dias com devolução total / nenhuma]"
cta_padrao: "[Ex.: Quero testar X dias]"
assinatura_padrao: "[Nome de quem envia]"
campanha_vigente: "[Regra de campanha ativa, com prazo. Deixe vazio se não houver]"
```

## 0. Como trabalhar

- Entregar em texto na conversa, direto, sem preâmbulo.
- Revisar a copy do usuário antes de propor a sua: dizer o que está bom e manter. Só reescrever o que fura.
- Não inventar número, case, garantia, bônus, prazo, nome de método ou dado de concorrente. O que faltar vira pendência na entrega.
- Se o usuário tiver memória, projeto ou documentos com copies aprovadas e resultados de campanhas, consulte antes. Copy aprovada recente vale como referência de tom.

## 1. Contexto mínimo

Canal, base/público, por que essa base parou ou qual é a dor, destino do link, objetivo (resposta, clique, cadastro, reunião). O que faltar: inferir, declarar a suposição em 1 linha e seguir.

Regra de ouro: o gancho é o motivo real da parada da base, não a novidade de produto. Ex.: base que nunca respondeu porque o processo antigo exigia reunião → "na época tinha que marcar reunião pra testar; hoje não precisa".

## 2. Estrutura para escrever (e-mail; adaptar pela §7)

1. Abertura informal com o primeiro nome (ex.: `Oi {{nome}}, tudo certo?`).
2. Motivo do contato + reconhecer o passado sem culpar ("Você conheceu a [marca] faz um tempo e não seguiu, e tudo bem.").
3. O que mudou, ligado ao motivo da parada (não à feature).
4. Mecanismo único: a marca como sujeito, verbos concretos (atende, qualifica, faz o follow, recupera, registra), com o como específico.
5. Prova: um número + o mecanismo, uma só (§6).
6. Oferta com fricção declarada e a objeção dominante quebrada na mesma frase.
7. 1 CTA em 1ª pessoa como link em texto (ver `cta_padrao`).
8. Assinatura de pessoa: `Abraço,` / nome de quem envia.

Uma promessa por peça. Se o destino (LP) já mostra algo, corte do texto.

## 3. Passe 1: conversão (as 5 alavancas + fundamentos)

Para cada item: OK / fura (com o trecho) / sacrificado de propósito.

1. **Gancho** nasce do motivo real da base, não da feature.
2. **Promessa única.** Uma por peça; o resto cortado ou já coberto pelo destino.
3. **Mecanismo único.** Categoria genérica ("IA para vendas", "automação") virou commodity. Venda o COMO que ninguém descreve. Errado: "nossa ferramenta responde leads mais rápido". Certo: descrever o que acontece, em que canal, em quanto tempo e o que muda para o time. Teste: se um concorrente assina a frase sem mudar nada, fura. Nome próprio de método só se já existir e estiver aprovado.
4. **Prova específica (hard proof).** Elogio vira dado: quem (ou descrição do negócio), antes → depois, período, o que não mudou ("sem contratar ninguém"). Formato: "saiu de X para Y [métrica] por [período], sem [custo evitado]". Só número real (§6) ou extraído com janela declarada. Nunca ROI cru.
5. **Objeção antecipada.** A objeção dominante da base, uma por peça, quebrada junto da oferta. Mapeie as suas em §6.
6. **Oferta e risco reverso (valor percebido muito acima do preço).** Só o que existe na §A:
   - Oferta de entrada exatamente como configurada.
   - Modelo de cobrança e garantia oficial. Nunca garantia condicionada a resultado ("se não dobrar, devolvo").
   - Bônus: só material real aprovado para a campanha.
   - Ancoragem: comparar com o custo da alternativa (ex.: contratar alguém para fazer o mesmo), com fonte e URL. Preço só com aprovação para a peça.
   - Regra de `campanha_vigente` prevalece. Nunca citar condição que não esteja lá.
7. **Perda e urgência (FOMO honesto).** Venda a perda, não a função: oportunidade que esfria, venda que vai para quem respondeu primeiro. Em anúncio: ameaça → vantagem de quem já resolveu → janela fechando → ação imediata. Prazo só se real. Afirmação sobre concorrente ou mercado só com fonte ("seu concorrente acabou de automatizar 100% dos leads" é inventado, vetado).
8. **Message match** com o destino: repete a promessa do hero da LP.
9. **CTA**: um só, em 1ª pessoa quando for link.

Em anúncio, conferir também a ordem Hook → Problema → Agitação → Mecanismo → Prova → Objeção → CTA, com a 1ª linha parando o scroll em até ~125 caracteres.

## 4. Passe 2: voz da marca [PREENCHA]

Regras universais (mantenha):
- A marca como sujeito, verbos concretos.
- Tecnologia pelo efeito, não pelo nome técnico.
- Zero superlativo ("melhor do mercado", "referência"), zero hedge ("acredito", "talvez").
- Culpa distribuída: "o follow que ninguém lembra de fazer", nunca "que você esquece".
- Um contraste por peça. Comparação só com fato verificável.
- Não prometer o que o produto não faz.

Regras da sua marca (preencha):
- Como escrever o nome da marca: `[ex.: "a Marca", nunca "o Marca"]`
- Palavras vetadas: `[ex.: "solução", "otimizar", "alavancar", "jornada", "potencializar"]`
- Termos permitidos só em certos canais: `[ex.: "agente de IA" só em SMS]`
- Tratamento: `[tu / você / misto]`
- O que nunca prometer: `[ex.: plano grátis permanente, 100% autônomo, preço sem aprovação]`

## 5. Passe 3: humanize em PT-BR

Pontuação começa em 100. ALTO = -3 por ocorrência, MÉDIO = -1.

**ALTO**
- Paralelismo negativo: "não é X, é Y", "não é sobre X, é sobre Y" (exceção: uma frase de marca já aprovada, se houver).
- Vocabulário de IA: "transformar", "revolucionar", "no cenário atual", "em um mundo cada vez mais", "o jogo mudou", "descubra", "desbloqueie", "robusto", "poderoso", "inovador".
- Inflação de importância: "divisor de águas", "essencial", "fundamental", "crucial".
- Gerúndio pendurado no fim: "..., garantindo mais vendas", "..., aumentando sua conversão".
- Par de adjetivos de enchimento: "rápido e eficiente", "simples e intuitivo".
- Regra de três forçada (trio de benefícios só pelo ritmo).
- Atribuição vaga: "especialistas dizem", "estudos mostram" sem fonte.
- Frase coloquial entre aspas como exemplo de fala do cliente (soa a texto de IA).
- Artefato de chat: "espero que ajude", "ótima pergunta".

**MÉDIO**
- Travessão (—). Trocar por vírgula, ponto ou parênteses.
- Emoji, hashtag, negrito mecânico, Title Case.
- Abertura clichê: "Imagine...", "Sabe aquele...?", "E se eu te dissesse...", "Enquanto você lê isso..." (aceitável só se o resto da frase for concreto e verificável).
- "E o melhor:", "Mas não para por aí", "Além disso" em série.
- Enchimento: "a fim de", "de forma a", "pode potencialmente".
- Perguntas retóricas em sequência.
- Cadência uniforme: todas as frases do mesmo tamanho. Variar.
- Fechamento vago: "o futuro é agora", "não fique para trás" sem fato.

A reescrita não pode criar padrão novo. Ler em voz alta: tem que soar como uma pessoa falando.

## 6. Provas e objeções [PREENCHA]

Uma prova por peça, nunca dois números do mesmo case.

| Case (nome ou descrição do negócio) | Resultado (antes → depois, período) | Melhor público / uso | Autorizado a citar nome? |
|---|---|---|---|
| `[ ]` | `[ ]` | `[ex.: reativação de base fria]` | `[sim/não]` |
| `[ ]` | `[ ]` | `[ ]` | `[ ]` |

Prova nova só com janela declarada (datas) e regra de atribuição. Cliente sem autorização: descrever o negócio, sem nome.

| Objeção dominante | Como quebrar (só o que o produto faz de verdade) |
|---|---|
| `[ex.: difícil de configurar]` | `[ex.: em quanto tempo e com que esforço fica rodando]` |
| `[ex.: vai parecer robô]` | `[ex.: mostrar a conversa real / repasse ao humano]` |
| `[ex.: caro]` | `[ex.: modelo de cobrança + ancoragem no custo da alternativa]` |

## 7. Formato por canal

| Canal | Tamanho | Regras |
|---|---|---|
| E-mail | 100-125 palavras | texto puro, 1 CTA; assunto 2-4 palavras, minúsculo, sem número, sem "grátis", sem urgência, versões A e B; preheader complementa e não repete a 1ª linha; UTM no link `[PREENCHA o padrão de UTM]` |
| WhatsApp | 40-70 palavras | pergunta fechada no fim que convide resposta, sem link no 1º toque frio, assinado por pessoa |
| SMS | até 160 caracteres com link | sem acento, link rastreável, aponta para a LP |
| Anúncio | 1ª linha até ~125 car., título até ~40 | Texto principal 1 e 2 para teste, sem emoji, hashtag ou travessão |

Assuntos de e-mail que já funcionaram na sua base: `[PREENCHA]`.

## 8. Notas e corte

- **Conversão**: cada item do Passe 1 + "Voz da marca" + "Formato do canal", 0-10; nota = média ×10. Item que não se aplica ao canal sai da média.
- **Humano**: 100 menos as deduções do Passe 3.
- **Corte**: as duas ≥ 90. Abaixo disso, reescrever e repontuar antes de mostrar (máx. 2 voltas; se não chegar, entregar com o motivo em 1 linha, geralmente falta de dado ou de aprovação).

## 9. Entrega (nesta ordem)

1. Veredito em 1 linha: Conversão X → Y · Humano X → Y.
2. O que fura: até 3 itens, cada um com o trecho citado e o porquê em 1 linha.
3. Versão revisada em blockquote, com contagem de palavras/caracteres e UTM corrigida se for o caso. Em e-mail, assunto A/B e preheader.
4. Scorecard compacto (critério | antes | depois).
5. Pendências: o que precisa de dado com fonte ou de aprovação (número, nome de método, preço, bônus).
6. Fontes com URL, se houver dado de terceiro.

## Referência: esqueleto de e-mail de reativação

Substitua o que está entre colchetes. Depois de aprovar um e-mail real, cole-o aqui como referência de tom.

```
Oi {{nome}}, tudo certo?

Você conheceu a [marca] faz um tempo e não seguiu, e tudo bem. Na época, [o que travava: ex. pra testar tinha que marcar reunião]. Hoje [o que mudou, ligado a essa trava].

A [marca] [mecanismo com verbos concretos: o que faz, onde, em quanto tempo]. [Case] [resultado com número e período].

Dá pra ver funcionando na tua operação [fricção declarada: ex. sem falar com ninguém]: [oferta de entrada]. [Objeção dominante quebrada]. [Modelo de cobrança].

[CTA em 1ª pessoa]

Abraço,
[Nome]
```

## Calibração: como a revisão trata um anúncio genérico

Entrada: "Enquanto você lê este post, seu concorrente direto acabou de automatizar o atendimento de 100% dos leads dele. 📉 O jogo mudou. [...] Não é sobre tecnologia, é sobre quem chega primeiro no cliente. A janela para dominar o seu nicho com IA está fechando."

Furos: dado inventado sobre o concorrente (Passe 1, item 7); "o jogo mudou" e "não é sobre X, é sobre Y" (Passe 3, ALTO); emoji; nenhum mecanismo, prova ou objeção; janela fechando sem prazo real.

Reescrita no padrão (esqueleto):

> [Perda concreta e presente: ex. tem lead teu esperando resposta agora]. [Dado de terceiro com fonte e ano], e [consequência para quem não age].
>
> A [marca] [mecanismo específico]. [Case com número].
>
> [Como começar, com a fricção declarada]. [Oferta de entrada].

Título: `[até ~40 caracteres, perda ou ganho concreto]` · Botão: `[CTA]`
