## setup
library(tidyverse)
library(lubridate)

# importacao da base
q2_data_1 = read.table(unz("./data/data.zip", "Q2_Base1.txt"),
                       sep = "\t", 
                       header = TRUE)

# 2.1
percentual_adesao = q2_data_1 %>%
  mutate(NU_MESES_ATRASO = as.integer(NU_DIAS_ATRASO/30)) %>%
  group_by(NU_MESES_ATRASO) %>%
  summarise(NU_ADESAO_MES = sum(RESPOSTA == 1)/n())

# grafico
percentual_adesao_plot = percentual_adesao %>%
  ggplot(aes(x = NU_MESES_ATRASO, y = NU_ADESAO_MES)) +
  geom_col(aes(fill = NU_MESES_ATRASO), colour = "black") +
  scale_fill_gradient(low = "darkorange",
                      high = "red") +
  theme_minimal() +
  scale_y_continuous(labels = scales::percent,
                     limits = c(0, 0.04)) +
  scale_x_continuous(breaks = c(6:18)) +
  labs(x = "Meses de atraso",
       y = "Taxa de adesão por mês",
       title = "Taxa de adesão ao acordo por mês de atraso") +
  theme(legend.position = "none")

# exportando grafico como arquivo jpg
ggsave(filename = "./output/Q2_Grafico.jpg",
       plot = percentual_adesao_plot,
       height = 3,
       width = 4,
       scale = 2)


# 2.4
# lendo as outras bases de dados
q2_data_2 = read.table(unz("./data/data.zip", "Q2_Base2.txt"),
                       sep = "\t", 
                       header = TRUE)

q2_data_3 = read.table(unz("./data/data.zip", "Q2_Base3.txt"),
                       sep = "\t", 
                       header = TRUE)

q2_data_4 = read.table(unz("./data/data.zip", "Q2_Base4.txt"),
                       sep = "\t", 
                       header = TRUE)
q2_data_4$DT_ACORDO = as.character(as.Date(q2_data_4$DT_ACORDO))
 
q2_data_5 = read.table(unz("./data/data.zip", "Q2_Base5.txt"),
                       sep = "\t", 
                       header = TRUE)

# juntando todos os arquivos em uma unica base
q2_data_merged = merge(q2_data_1, q2_data_2, by = c("ID_CONTA", "DT_ACORDO"), all = TRUE) %>%
  merge(q2_data_3, by = c("ID_CONTA", "DT_ACORDO"), all = TRUE) %>%
  merge(q2_data_4, by = c("ID_CONTA", "DT_ACORDO"), all = TRUE) %>%
  merge(q2_data_5, by = c("ID_CONTA", "DT_ACORDO"), all = TRUE)

q2_base = q2_data_merged %>%
  select(ID_CONTA, DIVIDA_ATUAL, 
         RESPOSTA, DT_ACORDO, 
         QTD_ACIONAMENTO_6M, QTD_CPC_6M, 
         QTD_CP_6M, NU_DIAS_ATRASO) %>%
  group_by(ID_CONTA, RESPOSTA) %>%
  summarise(DIVIDA_FINAL = max(DIVIDA_ATUAL),
            RESPOSTA = max(RESPOSTA),
            DT_ACORDO = max(DT_ACORDO),
            QTD_ACIONAMENTO = max(QTD_ACIONAMENTO_6M),
            PERC_CONTATO = max(QTD_CP_6M)/QTD_ACIONAMENTO,
            PERC_CPC = max(QTD_CPC_6M)/QTD_ACIONAMENTO,
            NU_DIAS_ATRASO = max(NU_DIAS_ATRASO))

q2_base[is.na(q2_base)] = 0

q2_acionamento_outliers = c((quantile(q2_base$QTD_ACIONAMENTO)[2])-1.5*IQR(q2_base$QTD_ACIONAMENTO),
                            (quantile(q2_base$QTD_ACIONAMENTO)[4]+1.5*IQR(q2_base$QTD_ACIONAMENTO)))


# exportando o dataframe completo como arquivo txt
output_file = "./data/Q2_BaseCompleta.txt"

if (file.exists(output_file)){
  file.remove(output_file)
}

write_tsv(q2_base, output_file)
