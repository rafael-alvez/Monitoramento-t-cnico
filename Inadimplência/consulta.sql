--Alguns códigos ultilizados

SELECT    
    COUNT(p.nome) AS quantidade_clientes
FROM public.admcore_cliente AS cl
JOIN public.admcore_clientecontrato AS cc ON cl.id = cc.cliente_id
JOIN public.admcore_clientecontratostatus AS cs ON cc.status_id = cs.id
JOIN public.admcore_pessoa AS p ON cl.pessoa_id = p.id
JOIN public.admcore_endereco AS ed ON cl.endereco_id = ed.id
WHERE cs.status = 1

---------------------------------------------------------------------------------------------

SELECT    
    ed.bairro,    
    COUNT(p.nome) AS total_por_bairro,    
    (COUNT(p.nome) * 100.0 / (SELECT COUNT(*) 
    FROM public.admcore_cliente AS c 
    JOIN public.admcore_pessoa AS ps ON c.pessoa_id = ps.id 
    join public.admcore_clientecontrato as cc on c.id = cc.cliente_id 
    join public.admcore_clientecontratostatus as cs on cc.status_id = cs.id 
    WHERE cs.status = 3)) AS percentual_porcentagem_por_bairro
FROM public.admcore_cliente AS cl
JOIN public.admcore_pessoa AS p ON cl.pessoa_id = p.id
JOIN public.admcore_endereco AS ed ON cl.endereco_id = ed.id
join public.admcore_clientecontrato as cc on cl.id = cc.cliente_id
join public.admcore_clientecontratostatus as cs on cc.status_id = cs.id
WHERE cs.status = 3
GROUP BY ed.bairro
ORDER BY percentual_porcentagem_por_bairro DESC
limit 5

----------------------------------------------------------------------------------------------

SELECT \
    tp.nome,\t
    ed.bairro,\t
    ed.cidade,\t
    ed.logradouro,\t
    SPLIT_PART(map_ll, ',', 2) AS longitude,    
    SPLIT_PART(map_ll, ',', 1) AS latitude
FROM public.admcore_cliente AS cl
JOIN public.admcore_clientecontrato AS cc ON cl.id = cc.cliente_id
JOIN public.admcore_clientecontratostatus AS cs ON cc.status_id = cs.id
JOIN public.admcore_pessoa AS p ON cl.pessoa_id = p.id
JOIN public.admcore_endereco AS ed ON cl.endereco_id = ed.id
where cs.status = 3 
AND ed.map_ll IS NOT NULL     
AND ed.map_ll LIKE ANY (ARRAY['%1%', '%2%', '%3%', '%8%', '%5%', '%6%', '%0%', '%4%', '%7%', '%9%'])--GROUP BY ed.bairro, ed.map_ll, p.nome, ed.logradouro, ed.cidade,ORDER BY p.nome ASC;",

-----------------------------------------------------------------------------------------------

SELECT 
    COUNT(financeiro_titulo.cliente_id) AS total
FROM admcore_clientecontrato
INNER JOIN admcore_clientecontratostatus ON (admcore_clientecontratostatus.id = admcore_clientecontrato.status_id)
INNER JOIN admcore_cliente ON (admcore_clientecontrato.cliente_id = admcore_cliente.id)
INNER JOIN financeiro_titulo ON (financeiro_titulo.cliente_id = admcore_cliente.id)
INNER JOIN admcore_servicointernet on (admcore_clientecontrato.id = admcore_servicointernet.clientecontrato_id)
LEFT JOIN admcore_pop ON (admcore_clientecontrato.pop_id = admcore_pop.id)
WHERE admcore_clientecontratostatus.status = 3
AND admcore_clientecontratostatus.data_cadastro AT TIME ZONE 'UTC' AT TIME ZONE 'America/Recife' IS NOT NULL   
AND admcore_clientecontratostatus.data_cadastro >= current_date - interval '30 day'
AND financeiro_titulo.data_vencimento >= TO_TIMESTAMP($__from/1000)
AND financeiro_titulo.data_vencimento < '2050-01-01'::date
AND financeiro_titulo.data_pagamento IS NULL