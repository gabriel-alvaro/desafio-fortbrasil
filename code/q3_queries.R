# setup
library(RSQLite)

# criando banco de dados
sample_db = "./data/vendas_sample.sqlite3"
conn = dbConnect(SQLite(), sample_db)

# inserindo dados no bd para testar as queries
df_Tempo = data.frame(id_tempo = c(1, 2, 3, 4, 5, 6),
                      dt_ref = c("2020-01-01", "2020-03-02", "2020-03-01", "2020-04-01", "2020-05-01", "2020-01-16"),
                      nu_semana = c(1, 1, 1, 1, 1, 2),
                      nu_mes = c(1, 3, 3, 4, 5, 1),
                      nu_ano = c(2020, 2020, 2020, 2020, 2020, 2020))

df_Loja = data.frame(id_loja = c(5, 6, 7, 8),
                     ds_uf = c("CE", "CE", "SP", "RJ"),
                     nu_cep = c(123, 456, 789, 10123))

df_Pessoa = data.frame(id_pessoa = c(10, 11, 12, 13, 14),
                       nm_pessoa = c("João", "Maria", "Bruno", "Felipe", "José"))

df_Vendas = data.frame(id_venda = c(20, 21, 22, 23, 24, 25),
                       vl_venda = c(55, 66, 77, 88, 99, 88),
                       id_loja = c(5, 6, 7, 8, 7, 5),
                       id_tempo = c(1, 2, 3, 4, 5, 6),
                       id_pessoa = c(10, 11, 12, 13, 12, 13))

dbRemoveTable(conn, "d_Tempo")
dbWriteTable(conn, "d_Tempo", df_Tempo)
dbReadTable(conn, "d_Tempo")


dbRemoveTable(conn, "d_Loja")
dbWriteTable(conn, "d_Loja", df_Loja)
dbReadTable(conn, "d_Loja")


dbRemoveTable(conn, "d_Pessoa")
dbWriteTable(conn, "d_Pessoa", df_Pessoa)
dbReadTable(conn, "d_Pessoa")


dbRemoveTable(conn, "f_Vendas")
dbWriteTable(conn, "f_Vendas", df_Vendas)
dbReadTable(conn, "f_Vendas")

# questao 3.1
dbGetQuery(conn,
           "SELECT p.id_pessoa, p.nm_pessoa, t.dt_ref, v.vl_venda
           FROM f_Vendas AS v
           INNER JOIN d_Pessoa AS p
           ON v.id_pessoa = p.id_pessoa
           INNER JOIN d_Tempo AS t
           ON v.id_tempo = t.id_tempo
           INNER JOIN d_Loja AS l
           ON v.id_loja = l.id_loja
           WHERE t.nu_mes = 1
           AND t.nu_ano = 2020
           AND l.ds_uf = 'CE'")

# questao 3.2
dbGetQuery(conn,
           "SELECT p.id_pessoa, COUNT(v.id_venda) AS qtd_compras 
           FROM f_Vendas as v
           INNER JOIN d_pessoa AS p
           ON v.id_pessoa = p.id_pessoa
           INNER JOIN d_tempo AS t
           ON v.id_tempo = t.id_tempo
           WHERE t.nu_mes = 3
           AND t.nu_ano = 2020
           GROUP BY p.id_pessoa")

# questao 3.3
dbGetQuery(conn,
           "SELECT DISTINCT p.id_pessoa, p.nm_pessoa
           FROM d_Pessoa AS p
           LEFT JOIN f_Vendas AS v
           ON p.id_pessoa = v.id_pessoa
           LEFT JOIN d_Tempo AS t
           ON v.id_tempo = t.id_tempo
           WHERE t.nu_mes IS NOT 3
           AND p.id_pessoa NOT IN
             (SELECT p.id_pessoa
             FROM d_Pessoa AS p
             LEFT JOIN f_Vendas AS v
             ON p.id_pessoa = v.id_pessoa
             LEFT JOIN d_Tempo AS t
             ON v.id_tempo = t.id_tempo
             WHERE nu_mes = 3)")

# questao 3.4
dbGetQuery(conn,
           "SELECT p.id_pessoa, MAX(dt_ref) AS ultima_compra
           FROM f_Vendas AS v
           INNER JOIN d_Tempo as t
           ON v.id_tempo = t.id_tempo
           INNER JOIN d_Pessoa as p
           ON v.id_pessoa = p.id_pessoa
           GROUP BY p.id_pessoa")
