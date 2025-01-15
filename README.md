# Análise de Dados para Monitoramento de redes

Este projeto consiste na criação de dashboards e análises técnicas para uma empresa de rede de internet, focando em métricas de desempenho, ocorrências e insights para a tomada de decisões estratégicas. As dashboards oferecem uma visualização clara e interativa dos dados, enquanto as análises técnicas ajudam a identificar padrões, otimizar a performance e entender os principais fatores de interrupção e manutenção de serviço.

## Objetivo do Projeto

Desenvolver e implementar dashboards interativos e análises detalhadas para monitorar e analisar dados operacionais e de desempenho da rede. O objetivo é permitir uma visão abrangente e em tempo real das principais métricas da empresa, incluindo:

- **Análise de Ocorrências**: Frequência, impacto e tempo de resolução.
- **Métricas de Desempenho da Rede**: Latência, largura de banda, uptime e outras métricas essenciais para a operação.
- **Relatórios Personalizados**: Filtragem e comparação de dados históricos e em tempo real.

## Tecnologias Utilizadas

O projeto foi desenvolvido usando as seguintes tecnologias:

- **SQL**: Linguagem principal para consultas e manipulação de dados.
  - **MySQL** e **PostgreSQL**: Bancos de dados utilizados para armazenar e consultar os dados operacionais.
- **Grafana**: Plataforma de visualização para construção de dashboards interativos.
- **JavaScript**: Utilizado no Grafana para manipulação avançada de dados e construção das interfaces dinâmicas.

## Estrutura do Projeto

1. **Scripts SQL**: Contém os scripts utilizados para extração, transformação e carregamento (ETL) dos dados, bem como as consultas necessárias para a análise.
2. **Configurações do Grafana**: Contém os templates de dashboards e configurações de visualização.
3. **Análises Técnicas**: Inclui documentos e anotações sobre as principais conclusões obtidas a partir dos dados, incluindo insights e recomendações para melhorar a infraestrutura e atendimento da rede.

## Funcionalidades Principais

- **Dashboard de Ocorrências**: Visualização das ocorrências por categoria, frequência e tempo de resolução.
- **Dashboard de Desempenho**: Monitora indicadores chave de performance (KPIs) como latência, disponibilidade da rede e consumo de largura de banda.
- **Análise de Tendências**: Projeções e comparações de métricas ao longo do tempo para identificar padrões sazonais e oportunidades de melhoria.
  
## Como Executar o Projeto

1. **Configurar Banco de Dados**:
   - Configurar um banco de dados MySQL ou PostgreSQL e importar os scripts SQL da pasta `sql_scripts`.
2. **Instalar e Configurar o Grafana**:
   - Baixar e configurar o Grafana para acessar os dados do banco e carregar os templates de dashboard disponíveis na pasta `grafana_config`.
3. **Configurar as Variáveis de Ambiente** (opcional):
   - Definir variáveis de ambiente para o banco de dados e o Grafana conforme a necessidade.

## Contribuição

Este projeto foi desenvolvido com o objetivo de fornecer uma visão abrangente dos dados de uma empresa de rede de internet. Caso queira contribuir, fique à vontade para abrir uma issue ou enviar um pull request com sugestões de melhorias ou correções.

## Licença

Este projeto é licenciado sob a [MIT License](LICENSE).

