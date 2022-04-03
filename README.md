<div align = "center">
 <h1>Desafio FortBrasil</h>
 </div>

Neste projeto, sintetizei meus conhecimentos de análise de dados, realizando um trabalho em cima do banco de dados de clientes da empresa FortBrasil, como parte do processo seletivo para estagiário de data science. 

Apesar de estar familiarizado com a maioria das ferramentas utilizadas, o projeto foi muito desafiador e me fez dar o meu melhor e me comprometer a entregar o melhor resultado possível. Além disso, foi meu primeiro contato real com o Power BI e com versionamento utilizando Git, tecnologias muito importantes para minha carreira.

Fico muito orgulhoso do projeto que realizei e de ter tido a oportunidade de mostrar do que sou capaz, além de ficar muito feliz por conta do aprendizado que tive nesse processo!

<div align="center">
<sub> 
 
 Made with 💖 by [Gabriel Alvaro](https://www.linkedin.com/in/gabriel-alvaro/).
 
 </sub>
</div>
<div>
<h2>Estrutura do projeto</h>
</div>

Utilizei [este template](https://github.com/andreashandel/dataanalysis-template) para organizar as pastas:
- **code**: temos os códigos utilizados para resolução do case e para criação dos arquivos PDF.
- **data**: aqui estão todas as bases de dados utilizadas no projeto, incluindo a base criada para teste das queries. O arquivo 'data.zip' contém as bases de dados fornecidas inicialmente para o case.
- **output**: onde encontram-se as saídas do projeto - as imagens e gráficos, o relatório e a base de dados resposta.
- **root**: no diretório princiapl, estão as respostas em PDF e o arquivo .Rproj, que estrutura todo o projeto dentro do RStudio e facilita sua navegação.

<div>
<h2>Instruções</h>
</div>

Para executar o projeto, basta clonar o repositório e executar o arquivo "desafio-fortbrasil.Rproj", no RStudio:

```
git clone https://github.com/gabriel-alvaro/desafio-fortbrasil.git
```

Uma alternativa a clonar o repositório é baixá-lo como um arquivo .zip e então extrair no seu computador.

Atenção! São necessários os seguintes pacotes do R para que todos os scripts funcionem:
- Tidyverse
  - readr
  - dplyr
  - ggplot2
  - tidyr
- Lubridate
- RSQLite
