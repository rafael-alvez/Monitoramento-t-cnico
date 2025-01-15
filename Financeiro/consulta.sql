--Alguns códigos utilizados

WITH todas_as_datas AS (  
    SELECT 
        DISTINCT TO_CHAR(DATE_TRUNC('month', financeiro_titulo.data_vencimento), 'YYYY-MM') AS mes  
    FROM financeiro_titulo  
    WHERE financeiro_titulo.data_vencimento >= TO_TIMESTAMP($__from/1000)    
    AND financeiro_titulo.data_vencimento < '2050-01-01'::date)
SELECT  
    todas_as_datas.mes,  
    COALESCE(SUM(ganhos.total), 0) AS ganhos,  
    COALESCE(SUM(perdas.total)*-1, 0) AS perdas
FROM  todas_as_datas
LEFT JOIN ( --Consulta de ganhos 
        SELECT    
            TO_CHAR(DATE_TRUNC('month', financeiro_titulo.data_vencimento), 'YYYY-MM') AS mes,    
            SUM(financeiro_titulo.valor) AS total  
        FROM    admcore_clientecontrato    
        INNER JOIN admcore_cliente ON (admcore_clientecontrato.cliente_id = admcore_cliente.id)    
        INNER JOIN financeiro_titulo       ON (financeiro_titulo.cliente_id = admcore_cliente.id       AND financeiro_titulo.data_pagamento IS NULL)    
        INNER JOIN admcore_servicointernet ON (admcore_clientecontrato.id = admcore_servicointernet.clientecontrato_id)    
        INNER JOIN financeiro_cobranca ON (financeiro_titulo.cobranca_id = financeiro_cobranca.id)    
        LEFT JOIN admcore_pop ON (admcore_clientecontrato.pop_id = admcore_pop.id)  
        WHERE     admcore_servicointernet.status IN (1, 2)     
        AND admcore_pop.cidade in ($pop)    
        AND admcore_clientecontrato.data_cadastro AT TIME ZONE 'UTC' AT TIME ZONE 'America/Recife' IS NOT NULL   
        AND admcore_clientecontrato.data_cadastro AT TIME ZONE 'UTC' AT TIME ZONE 'America/Recife' >= $__timeFrom()  
        AND admcore_clientecontrato.data_cadastro AT TIME ZONE 'UTC' AT TIME ZONE 'America/Recife' <= $__timeTo()    
        AND admcore_clientecontrato.cobranca_id = financeiro_cobranca.id
        GROUP BY mes) AS ganhos ON todas_as_datas.mes = ganhos.mes
LEFT JOIN (  --Consulta de perdas
        SELECT    
            TO_CHAR(DATE_TRUNC('month', financeiro_titulo.data_vencimento), 'YYYY-MM') AS mes,    
            SUM(financeiro_titulo.valor) AS total  
        FROM    admcore_clientecontrato    
        INNER JOIN admcore_clientecontratostatus ON (admcore_clientecontratostatus.id = admcore_clientecontrato.status_id)    
        INNER JOIN admcore_cliente ON (admcore_clientecontrato.cliente_id = admcore_cliente.id)    
        INNER JOIN financeiro_titulo ON (financeiro_titulo.cliente_id = admcore_cliente.id)    
        INNER JOIN admcore_servicointernet ON (admcore_clientecontrato.id = admcore_servicointernet.clientecontrato_id)    
        INNER JOIN financeiro_cobranca ON (financeiro_titulo.cobranca_id = financeiro_cobranca.id)        
        LEFT JOIN admcore_pop ON (admcore_clientecontrato.pop_id = admcore_pop.id)  
        WHERE    admcore_servicointernet.status = 3         
        AND admcore_pop.cidade in ($pop)    
        AND   admcore_clientecontratostatus.data_cadastro AT TIME ZONE 'UTC' AT TIME ZONE 'America/Recife' IS NOT NULL   
        AND admcore_clientecontratostatus.data_cadastro AT TIME ZONE 'UTC' AT TIME ZONE 'America/Recife' >= $__timeFrom()  
        AND admcore_clientecontratostatus.data_cadastro AT TIME ZONE 'UTC' AT TIME ZONE 'America/Recife' <= $__timeTo()  
        AND financeiro_titulo.data_vencimento >= TO_TIMESTAMP($__from/1000)
        AND financeiro_titulo.data_vencimento < '2050-01-01'::date
        AND financeiro_titulo.data_pagamento IS NULL  
        GROUP BY mes) AS perdas ON todas_as_datas.mes = perdas.mes
GROUP BY todas_as_datas.mes
HAVING COALESCE(SUM(ganhos.total), 0) <> 0 OR COALESCE(SUM(perdas.total), 0) <> 0
ORDER BY todas_as_datas.mes;


----------------------------------------------------------------------------------------------

SELECT    
    EXTRACT(MONTH FROM data_cadastro) AS mes,    
    EXTRACT(YEAR FROM data_cadastro) AS ano,    
    SUM(CASE WHEN valor > 0 THEN valor ELSE 0 END) AS valor_entrada,    
    SUM(CASE WHEN valor < 0 THEN valor ELSE 0 END) AS valor_saida    
    to_char(SUM(CASE WHEN valor > 0 THEN valor ELSE 0 END) - SUM(CASE WHEN valor < 0 THEN -valor ELSE 0 END), 'R$999G999G999D99') AS diferenca_entrada_saida
FROM public.financeiro_caixalancamento
join admcore_pop as p on financeiro_caixalancamento.pop_id = p.id
WHERE NOT EXISTS (      
        SELECT 1      
        FROM public.financeiro_caixalancamento AS fc_repasse      
        WHERE fc_repasse.observacao LIKE '%Repasse%'       
        AND fc_repasse.id = public.financeiro_caixalancamento.id)      
--and p.cidade IN ($pop)
GROUP BY mes, ano
ORDER BY ano desc, mes desc

-----------------------------------------------------------------------------------------------