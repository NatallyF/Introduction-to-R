# AULA: INTRODUÇÃO AO R COM O DATASET IRIS
# Objetivo: criar objetos, explorar tabelas, selecionar dados e fazer gráficos.
# Este script usa somente funções que já acompanham o R.
# No RStudio, execute uma linha ou seleção com Ctrl + Enter.
# Linhas iniciadas com # são comentários e não são executadas.

# 1. R COMO CALCULADORA E CRIAÇÃO DE OBJETOS --------------------------------

2 + 3
10 / 2
2^3                          # Potência
sqrt(16)                     # Função para calcular a raiz quadrada

x <- 10                      # <- atribui um valor a um objeto
y <- 5
x + y

# c() reúne valores em um vetor. O R diferencia maiúsculas de minúsculas.
medidas <- c(4.8, 5.2, 5.0, 6.1)
medidas
length(medidas)               # Número de elementos
mean(medidas)                 # Média
medidas[1]                    # Primeiro elemento; a indexação começa em 1
medidas > 5                   # Comparação: retorna TRUE ou FALSE

# Exemplos de classes: número, texto, valor lógico e fator (categorias).
class(x)
class("setosa")
class(TRUE)
especies <- factor(c("setosa", "versicolor", "setosa"))
class(especies)
levels(especies)

# 2. CONHECENDO O DATASET --------------------------------------------------

# iris já está disponível no R: não é necessário importar uma planilha.
# São 150 flores, com 50 observações de cada uma das três espécies.
# As quatro medidas estão em centímetros.
# Sepal.Length: comprimento da sépala; Sepal.Width: largura da sépala.
# Petal.Length: comprimento da pétala; Petal.Width: largura da pétala.
# Species: espécie (setosa, versicolor ou virginica).

dados <- iris                 # Cria uma cópia para trabalhar
head(dados)                  # Primeiras seis linhas
tail(dados)                  # Últimas seis linhas
dim(dados)                   # Número de linhas e colunas
names(dados)                 # Nomes das colunas
str(dados)                   # Estrutura e classes das variáveis
summary(dados)               # Resumo de cada variável
# View(dados)                # Opcional: abre a tabela no RStudio
# ?iris                      # Opcional: abre a documentação do dataset

# 3. ACESSANDO LINHAS E COLUNAS --------------------------------------------

# O símbolo $ acessa uma coluna pelo nome.
dados$Sepal.Length
dados$Species

# Em uma tabela, usamos [linhas, colunas]. Espaço vazio seleciona tudo.
dados[1, ]                   # Primeira linha, todas as colunas
dados[, 1]                   # Primeira coluna
dados[1:5, ]                 # Linhas 1 a 5
dados[1:5, c("Species", "Petal.Length")]

# 4. FILTRANDO, ORDENANDO E CRIANDO VARIÁVEIS -------------------------------

# == significa igualdade; <- significa atribuição.
setosa <- dados[dados$Species == "setosa", ]
head(setosa)
nrow(setosa)                 # Quantas flores foram selecionadas?

# & exige que as duas condições sejam verdadeiras; | significa OU.
selecionados <- dados[
  dados$Species == "virginica" & dados$Petal.Length > 6,
]
selecionados

# order() fornece a ordem das linhas segundo uma variável.
ordenados <- dados[order(dados$Petal.Length, decreasing = TRUE), ]
head(ordenados)

# Criar uma coluna: conversão do comprimento da sépala de cm para mm.
dados$Sepal.Length.mm <- dados$Sepal.Length * 10
head(dados)

# 5. ESTATÍSTICA DESCRITIVA E VALORES AUSENTES ------------------------------

mean(dados$Petal.Length)
median(dados$Petal.Length)
min(dados$Petal.Length)
max(dados$Petal.Length)
sd(dados$Petal.Length)        # Desvio padrão: dispersão das observações
quantile(dados$Petal.Length)
table(dados$Species)         # Contagem por espécie

# NA representa um valor ausente. iris não contém valores ausentes.
colSums(is.na(dados))        # Quantidade de NA em cada coluna
exemplo_na <- c(4, 5, NA, 6)
mean(exemplo_na)             # Retorna NA
mean(exemplo_na, na.rm = TRUE) # Calcula usando somente valores disponíveis

# Média e desvio padrão do comprimento da pétala por espécie.
# aggregate() aplica uma função a cada grupo.
# Na fórmula, a variável à esquerda de ~ é resumida por grupos à direita.
medias <- aggregate(Petal.Length ~ Species, data = dados, FUN = mean)
desvios <- aggregate(Petal.Length ~ Species, data = dados, FUN = sd)
medias
desvios

# Pergunta: qual espécie tem a maior média? Qual tem maior dispersão?
# O resumo geral mistura espécies; comparar grupos ajuda na interpretação.

# 6. GRÁFICOS -------------------------------------------------------------

# Histograma: distribuição de uma variável numérica.
hist(dados$Sepal.Length,
     main = "Distribuição do comprimento da sépala",
     xlab = "Comprimento da sépala (cm)",
     ylab = "Frequência", col = "lightblue", border = "white")

# Boxplot: mediana, dispersão e pontos além dos limites dos bigodes.
# Esses pontos não são automaticamente erros e não devem ser excluídos
# somente porque aparecem destacados no gráfico.
boxplot(Petal.Length ~ Species, data = dados,
        main = "Comprimento da pétala por espécie",
        xlab = "Espécie", ylab = "Comprimento da pétala (cm)",
        col = c("lightgreen", "lightblue", "salmon"))

# Dispersão: relação entre duas variáveis; cores representam espécies.
cores <- c("forestgreen", "steelblue", "tomato")
plot(dados$Petal.Length, dados$Petal.Width,
     col = cores[as.integer(dados$Species)], pch = 19,
     xlab = "Comprimento da pétala (cm)",
     ylab = "Largura da pétala (cm)",
     main = "Relação entre comprimento e largura da pétala")
legend("topleft", legend = levels(dados$Species),
       col = cores, pch = 19, bty = "n")

# 7. CORRELAÇÃO -----------------------------------------------------------

# Correlação de Pearson: associação linear, variando de -1 a 1.
# Uma correlação não demonstra que uma variável causa a outra.
cor(dados$Petal.Length, dados$Petal.Width)

# A associação geral pode refletir diferenças entre as espécies.
# Por isso, também calculamos a correlação dentro de cada espécie.
cor_por_especie <- tapply(
  seq_len(nrow(dados)), dados$Species,
  function(i) cor(dados$Petal.Length[i], dados$Petal.Width[i])
)
cor_por_especie

# 8. EXPORTAÇÃO OPCIONAL --------------------------------------------------

# getwd() mostra a pasta de trabalho atual.
getwd()

# Descomente para salvar um CSV nessa pasta e depois importá-lo.
# row.names = FALSE evita exportar os números das linhas como uma coluna.
# write.csv(dados, "iris_aula.csv", row.names = FALSE)
# dados_importados <- read.csv("iris_aula.csv")

# 9. ANÁLISE ESTATÍSTICA SIMPLES ------------------------------

# Pergunta: o comprimento médio das pétalas difere entre as espécies?
# ANOVA de um fator; não há blocos ou repetições experimentais definidos
# neste dataset.
modelo <- aov(Petal.Length ~ Species, data = dados)
summary(modelo)

# Hipótese nula: as três médias populacionais são iguais.
# Um p-valor pequeno indica evidência contra essa hipótese, sob as suposições.
# Ele não informa sozinho quais espécies diferem ou a magnitude da diferença.

# Diagnóstico: resíduos versus ajustados e gráfico quantil-quantil.
# Procurar padrões, diferenças de dispersão e desvios da normalidade.
plot(modelo, which = 1)
plot(modelo, which = 2)

# O modelo clássico pressupõe independência, variância residual comum
# e normalidade dos resíduos para a inferência. iris apresenta diferenças
# de dispersão entre espécies.
# ANOVA de Welch permite variâncias diferentes (mantém outras suposições).
oneway.test(Petal.Length ~ Species, data = dados, var.equal = FALSE)

# Tukey compara os pares de médias sob o modelo clássico de variância comum.
# Não é o pós-teste da ANOVA de Welch. Aqui serve para ensinar o comando;
# sua interpretação depende da adequação do modelo clássico.
TukeyHSD(modelo)

# 10. EXERCÍCIOS ----------------------------------------------------------

# 1) Conte as linhas e colunas de iris sem usar dim().
# 2) Selecione apenas as flores da espécie versicolor.
# 3) Calcule a média e o desvio padrão de Sepal.Width por espécie.
# 4) Selecione as flores com Sepal.Length maior que 7 cm.
# 5) Crie a variável Petal.Width.mm e confira sua conversão.
# 6) Faça um boxplot de Sepal.Width por espécie.
# 7) Faça um gráfico de Sepal.Length versus Sepal.Width, colorido por espécie.
# 8) Compare a correlação geral com as correlações por espécie.

# Dica: modifique os exemplos anteriores e execute uma etapa por vez.
# Antes de interpretar um resultado, confira a variável e os dados utilizados.
