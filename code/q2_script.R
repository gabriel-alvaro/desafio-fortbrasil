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
