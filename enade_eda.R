library(readr)
library(tidyverse)

setwd("C:\\Users\\gusta\\OneDrive\\FEARP\\2º semestre\\Didática\\trabalho\\microdados_enade_2018_LGPD\\microdados_Enade_2018_LGPD\\2.DADOS")


# arquivo 1
arquivo1 <- read_delim("microdados2018_arq1.txt", 
                       delim = ";", escape_double = FALSE, trim_ws = TRUE) 

arq1 <- arquivo1 %>% 
  select(CO_CURSO, CO_CATEGAD, CO_GRUPO, CO_MODALIDADE, CO_UF_CURSO) %>% 
  # filtrando para cursos de economia
  filter(CO_GRUPO == 13) %>% 
  select(-CO_GRUPO)


# arquivo 3
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


# arquivo 5 (sexo)
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
  geom_point(shape = "circle", size = 1.5, colour = "#112446") +
  labs(x = "Média de mulheres na turma", y = "Nota média") +
  geom_smooth(method = "lm", formula = y~x)
  theme_classic()




