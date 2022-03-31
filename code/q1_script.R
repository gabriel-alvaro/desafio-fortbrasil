## setup
library(tidyverse)
library(lubridate)

## importacao dos dados
q1_data = read_table(unz("./data/data.zip", "Q1_Base.txt"))

## questao 1.1
percentual = q1_data %>%
  mutate(MES = month(DT_VENCIMENTO, label = TRUE, locale = "Portuguese")) %>%
  select(-ID_CONTA, -VL_FATURA, -DT_VENCIMENTO) %>%
  group_by(MES) %>%
  summarise(PERCENTUAL_PGTO = sum(DS_ROLAGEM == "FX1")/n())

# grafico
percentual_plot = percentual %>%
  ggplot(aes(x = MES, y = PERCENTUAL_PGTO, fill = MES)) +
  geom_bar(stat = "identity", colour ="black") +
  scale_fill_brewer(palette = "Greens") +
  theme_minimal() +
  scale_y_continuous(labels = scales::percent, 
                     limits = c(0, 0.12),
                     breaks = c(0, 0.02, 0.04, 0.06, 0.08, 0.10, 0.12)) +
  labs(x = "Mês", y = "Percentual",
       title = "Percentual de clientes com faturas não pagas no mês anterior") +
  theme(legend.position = "none")

# exportando grafico como arquivo jpg
ggsave(filename = "./outputs/Q1_Grafico.jpg",
       plot = percentual_plot,
       height = 3,
       width = 6)

## questao 1.2
# criacao de dataframe auxiliar
clientes_setembro = q1_data %>%
  mutate(MES = month(DT_VENCIMENTO, label = TRUE, locale = "Portuguese")) %>%
  filter(MES == "set")

# condicionamento dos dados e criacao da base resposta
q1_resposta = merge(clientes_setembro, 
                         q1_data %>%
                           mutate(MES = month(DT_VENCIMENTO, label = TRUE, locale = "Portuguese")) %>%
                           filter(ID_CONTA %in% clientes_setembro$ID_CONTA) %>%
                           filter(MES %in% c("mar", "abr", "mai", "jun", "jul", "ago")) %>%
                           group_by(ID_CONTA) %>%
                           summarise(QTD_FATURAS_ULT_6M = n(),
                                     VL_MEDIO_FATURA = mean(VL_FATURA),
                                     QTD_FATURAS_ULT_6M_FX1 = sum(DS_ROLAGEM == 'FX1')),
                         by = "ID_CONTA") %>%
  select(-MES, -VL_FATURA)

# exportando o dataframe como arquivo txt
write_tsv(q1_resposta, "./outputs/Q1_Resposta.txt")
