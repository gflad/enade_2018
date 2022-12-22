library(readr)
library(tidyverse)

setwd("C:\\Users\\gusta\\OneDrive\\FEARP\\2º semestre\\Didática\\trabalho\\microdados_enade_2018_LGPD\\microdados_Enade_2018_LGPD\\2.DADOS")


######### arquivo 1
arquivo1 <- read_delim("microdados2018_arq1.txt", 
                       delim = ";", escape_double = FALSE, trim_ws = TRUE) 

arq1 <- arquivo1 %>% 
  select(CO_CURSO, CO_CATEGAD, CO_GRUPO, CO_MODALIDADE, CO_UF_CURSO) %>% 
  # filtrando para cursos de economia
  filter(CO_GRUPO == 13) %>% 
  select(-CO_GRUPO)


######### arquivo 3
arquivo3 <- read_delim("microdados2018_arq3.txt", 
                       delim = ";", escape_double = FALSE, trim_ws = TRUE)

# variaveis de interesse (codigo de curso e nota na prova)
arq3 <- arquivo3 %>% 
  select(CO_CURSO, TP_PR_GER, NT_GER) %>% 
  # filtrando para os participantes com respostas validas
  filter(TP_PR_GER == 555) %>% 
  # fazendo a nota media do curso (CO_CURSO == 14366 ufrj)
  group_by(CO_CURSO) %>% 
  mutate(nota_media = mean(NT_GER, na.rm = T) %>% round(1)) %>% 
  select(-TP_PR_GER, -NT_GER) %>% 
  # removendo duplicatas
  distinct(CO_CURSO, .keep_all = TRUE) %>% 
  ungroup()

# join no dataset principal
df <- inner_join(arq1, arq3, by = "CO_CURSO") %>% 
  distinct(CO_CURSO, .keep_all = TRUE)


######### arquivo 5 (sexo)
arquivo5 <- read_delim("microdados2018_arq5.txt", 
                       delim = ";", escape_double = FALSE, trim_ws = TRUE)

arq5 <- arquivo5 %>% 
  filter(TP_SEXO %in% c("F", "M")) %>% 
  mutate(mulher_dummy = case_when(TP_SEXO == "M" ~ 0,
                                  TP_SEXO == "F" ~ 1)) %>% 
  group_by(CO_CURSO) %>% 
  mutate(media_mulheres = mean(mulher_dummy, na.rm = T)) %>% 
  # removendo duplicatas
  distinct(CO_CURSO, .keep_all = TRUE) %>% 
  ungroup()

# join no dataset principal
df <- inner_join(df, arq5, by = "CO_CURSO") %>% 
  distinct(CO_CURSO, .keep_all = TRUE) 

df <- df %>% 
  select(-c("NU_ANO", "TP_SEXO", "mulher_dummy"))

# grafico
ggplot(df) +
  aes(x = media_mulheres, y = nota_media) +
  geom_point(shape = "circle",
             size = 1.5,
             colour = "#112446",
             alpha = 0.8) +
  labs(x = "Média de mulheres na turma", y = "Nota média") +
  geom_smooth(method = "lm", formula = y~x) +
  theme_minimal()


######### arquivo 8 (cor/raca)
arquivo8 <- read_delim("microdados2018_arq8.txt", 
                       delim = ";", escape_double = FALSE, trim_ws = TRUE)

arq8 <- arquivo8 %>% 
  mutate(negros_dummy = case_when(QE_I02 == "A" ~ 0,
                                  QE_I02 == "B" ~ 1,
                                  QE_I02 == "D" ~ 1,
                                  QE_I02 == "E" ~ 1)) %>% 
  group_by(CO_CURSO) %>% 
  mutate(media_negros = mean(negros_dummy, na.rm = T)) %>% 
  # removendo duplicatas
  distinct(CO_CURSO, .keep_all = TRUE) %>% 
  ungroup()

# join no dataset principal
df <- inner_join(df, arq8, by = "CO_CURSO") %>% 
  distinct(CO_CURSO, .keep_all = TRUE) 

df <- df %>% 
  select(-c("NU_ANO", "QE_I02", "negros_dummy"))

# grafico
ggplot(df) +
  aes(x = media_negros, y = nota_media) +
  geom_point(shape = "circle",
             size = 1.5,
             colour = "#112446",
             alpha = 0.8) +
  labs(x = "Média de negros na turma", y = "Nota média") +
  geom_smooth(method = "lm", formula = y~x) +
  theme_minimal()

df %>% 
  filter(media_negros < 1) %>% 
ggplot() +
  aes(x = media_negros, y = nota_media) +
  geom_point(shape = "circle",
             size = 1.5,
             colour = "#112446",
             alpha = 0.8) +
  labs(x = "Média de negros na turma", y = "Nota média") +
  geom_smooth(method = "lm", formula = y~x) +
  theme_minimal()


######### arquivo 10 (escolaridade do pai)
arquivo10 <- read_delim("microdados2018_arq10.txt", 
                       delim = ";", escape_double = FALSE, trim_ws = TRUE)

teste <- inner_join(arq3, arquivo10, by = "CO_CURSO")


teste %>%
 filter(!is.na(QE_I04),
        QE_I04 %in% c("A", "B", "C", "D", "E", "F")) %>%
 ggplot() +
 aes(x = nota_media, fill = QE_I04) +
 geom_density(adjust = 1L, alpha = 0.7) +
 scale_fill_hue(direction = 1,
                labels=c('Nenhuma', 'Fundamental (1º ao 5º)',
                         'Fundamental (6º ao 9º)', 'Ensino Médio',
                         'Graduação', 'Pós-Graduação')) +
 labs(x = "Nota média",
      y = " ",
      fill = "Escolaridade do pai") +
 theme_minimal()


######### arquivo 11 (escolaridade da mãe)
arquivo11 <- read_delim("microdados2018_arq11.txt", 
                        delim = ";", escape_double = FALSE, trim_ws = TRUE)

teste <- inner_join(arq3, arquivo11, by = "CO_CURSO")


teste %>%
  filter(!is.na(QE_I05),
         QE_I05 %in% c("A", "B", "C", "D", "E", "F")) %>%
  ggplot() +
  aes(x = nota_media, fill = QE_I05) +
  geom_density(adjust = 1L, alpha = 0.7) +
  scale_fill_hue(direction = 1,
                 labels=c('Nenhuma', 'Fundamental (1º ao 5º)',
                          'Fundamental (6º ao 9º)', 'Ensino Médio',
                          'Graduação', 'Pós-Graduação')) +
  labs(x = "Nota média",
       y = " ",
       fill = "Escolaridade da mãe") +
  theme_minimal()

######### arquivo 14 (renda total da familia)
arquivo14 <- read_delim("microdados2018_arq14.txt", 
                        delim = ";", escape_double = FALSE, trim_ws = TRUE)

teste <- inner_join(arq3, arquivo14, by = "CO_CURSO")


teste %>%
  filter(!is.na(QE_I08),
         QE_I08 %in% c("A", "B", "C", "D", "E", "F", "G")) %>%
  ggplot() +
  aes(x = nota_media, fill = QE_I08) +
  geom_density(adjust = 1L, alpha = 0.7) +
  scale_fill_hue(direction = 1, 
                 labels = c('Até 1,5 salário mínimo',
                            'De 1,5 a 3 salários mínimos',
                            'De 3 a 4,5 salários mínimos',
                            'De 4,5 a 6 salários mínimos',
                            'De 6 a 10 salários mínimos',
                            'De 10 a 30 salários mínimos',
                            'Acima de 30 salários mínimos')) +
  labs(x = "Nota média",
       y = " ",
       fill = "Renda total da família") +
  theme_minimal()


######### arquivo 21 (entrou na graduacao por cota?)
arquivo21 <- read_delim("microdados2018_arq21.txt", 
                        delim = ";", escape_double = FALSE, trim_ws = TRUE)

teste <- inner_join(arq3, arquivo21, by = "CO_CURSO")

teste <- teste %>% 
  mutate(cota = ifelse(QE_I15 == "A", "nao", "sim"))

teste %>%
  filter(!is.na(cota)) %>% 
  ggplot() +
  aes(x = nota_media, fill = cota) +
  geom_density(adjust = 1L, alpha = 0.3) +
  scale_fill_hue(direction = 1) +
  labs(x = "Nota média",
       y = " ",
       fill = "Cotista?") +
  theme_minimal()
