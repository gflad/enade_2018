# Enade 2018

The objective of this project is to make a quick exploratory data analysis on economics course performance on Enade's 2018 exam. I aim to take a closer look at the factors that may be affecting students grades on the exam, like parents education, household per capita income, sex, race and so on.

In 14 august 2018 was instituted the Lei Geral de Proteção dos Dados (General Data Protection Law), which aims to protect indivuals private data. Considering that Enade's microdata involve personal data, a new data structure was proposed, in which it became mmore difficult to identify each student. Therefore, we cannot group informations at the student's level, but only make analysis in relation to the profile of the courses and their results, grouping differente files by the course code variable (CO_CURSO).

Another approach is to group by institution, looking if the institutions where students in general have higher parents education or higher household per capita income haver better grades.

Relevant variables to be selected are:
 • CO_IES (institution code), from microdados2018_arq1
 • CO_GRUPO == 13 (identifies economics students), from from microdados2018_arq1
 • CO_CURSO (course code), from microdados2018_arq3
 • TP_PR_GER == 555 (identify if the student went to do the exam), from microdados2018_arq3
 • NT_GER (exam scores), from microdados2018_arq3
 • TP_SEXO (identifies students sex), from microdados2018_arq5
 
