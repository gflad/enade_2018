library(readr)
library(tidyverse)

setwd("C:\\Users\\gusta\\OneDrive\\FEARP\\2º semestre\\Didática\\trabalho\\microdados_enade_2018_LGPD\\microdados_Enade_2018_LGPD\\2.DADOS")


# arquivo 1
arquivo1 <- read_delim("microdados2018_arq1.txt", 
                       delim = ";", escape_double = FALSE, trim_ws = TRUE) 

arq1 <- arquivo1 %>% 
  select(CO_CURSO, CO_GRUPO, CO_IES) %>% 
  filter(CO_GRUPO == 13)


# arquivo 3
arquivo3 <- read_delim("microdados2018_arq3.txt", 
                       delim = ";", escape_double = FALSE, trim_ws = TRUE)

# variaveis de interesse
arq3 <- arquivo3 %>% 
  select(CO_CURSO, TP_PR_GER, NT_GER) %>% 
  filter(TP_PR_GER == 555)


