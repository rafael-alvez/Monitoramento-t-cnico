--Algumas consultas usadas na dash

WITH PlanosAntigosNovos AS (
      SELECT    
        admcore_aditivo.id,    
        (admcore_aditivo.dado_antigo::json->>'plano_id')::INT AS id_plano_antigo,   
        (admcore_aditivo.dado_novo::json->>'plano_id')::INT AS id_plano_novo  
FROM admcore_aditivo     
LEFT JOIN admcore_clientecontrato ON (admcore_clientecontrato.id = admcore_aditivo.clientecontrato_id)   
LEFT JOIN admcore_pop ON (admcore_clientecontrato.pop_id = admcore_pop.id)  

WHERE admcore_aditivo.dado_antigo LIKE '%plano%' 
AND admcore_aditivo.dado_novo LIKE '%plano%' 
AND admcore_aditivo.data_baixa AT TIME ZONE 'UTC' AT TIME ZONE 'America/Recife' IS NOT NULL  
AND admcore_aditivo.data_baixa AT TIME ZONE 'UTC' AT TIME ZONE 'America/Recife' >= $__timeFrom()  
AND admcore_aditivo.data_baixa AT TIME ZONE 'UTC' AT TIME ZONE 'America/Recife' <= $__timeTo()
)

SELECT  
    COUNT(p.id) AS total_upgrades
FROM PlanosAntigosNovos 
INNER JOIN admcore_plano AS p ON p.id = pan.id_plano_novo
INNER JOIN admcore_plano AS pa ON pa.id = pan.id_plano_antigo
WHERE p.preco > pa.preco;

----------------------------------------------------------------------------------------------------------------

SELECT   
    ((SELECT 
        COUNT(admcore_clientecontratostatus.id) AS novos_contratos       
    FROM admcore_clientecontrato        
    INNER JOIN admcore_clientecontratostatus ON admcore_clientecontratostatus.id = admcore_clientecontrato.status_id      
    INNER JOIN admcore_servicointernet ON admcore_clientecontrato.id = admcore_servicointernet.clientecontrato_id       
    LEFT JOIN admcore_pop ON admcore_clientecontrato.pop_id = admcore_pop.id   

    WHERE admcore_clientecontratostatus.status IN (1,2) 
    AND $__timeFilter(admcore_clientecontrato.data_cadastro)      
    AND admcore_pop.cidade IN ($pop)  )
    - 
    (SELECT 
        COUNT(admcore_clientecontratostatus.id) AS cancelamentos        
    FROM admcore_clientecontrato        
    INNER JOIN admcore_clientecontratostatus ON admcore_clientecontratostatus.id = admcore_clientecontrato.status_id        
    INNER JOIN admcore_servicointernet ON admcore_clientecontrato.id = admcore_servicointernet.clientecontrato_id        
    LEFT JOIN admcore_pop ON admcore_clientecontrato.pop_id = admcore_pop.id  

    WHERE admcore_clientecontratostatus.status = 3       
    AND admcore_clientecontratostatus.data_cadastro AT TIME ZONE 'UTC' AT TIME ZONE 'America/Recife' IS NOT NULL         
    AND admcore_clientecontratostatus.data_cadastro AT TIME ZONE 'UTC' AT TIME ZONE 'America/Recife' >= $__timeFrom()      
    AND admcore_clientecontratostatus.data_cadastro AT TIME ZONE 'UTC' AT TIME ZONE 'America/Recife' <= $__timeTo()\r\n        
    AND admcore_pop.cidade in ($pop)       )    ) as crescimento_liquido

-------------------------------------------------------------------------------------------------------------------

SELECT 
    TO_CHAR((sum(plano_novo.preco)-sum(plano_antigo.preco)), 'FM999G999G999D00') as upgrade
FROM admcore_aditivo 
INNER JOIN admcore_plano AS plano_antigo ON plano_antigo.id = (admcore_aditivo.dado_antigo::json->>'plano_id')::INT
INNER JOIN admcore_plano AS plano_novo ON plano_novo.id = (admcore_aditivo.dado_novo::json->>'plano_id')::INT    
LEFT JOIN admcore_clientecontrato ON (admcore_clientecontrato.id = admcore_aditivo.clientecontrato_id)  
LEFT JOIN admcore_pop ON (admcore_clientecontrato.pop_id = admcore_pop.id)

WHERE admcore_aditivo.dado_antigo LIKE '%plano%' 
AND admcore_aditivo.dado_novo LIKE '%plano%' 
AND admcore_aditivo.data_baixa AT TIME ZONE 'UTC' AT TIME ZONE 'America/Recife' IS NOT NULL 
AND admcore_aditivo.data_baixa AT TIME ZONE 'UTC' AT TIME ZONE 'America/Recife' >= $__timeFrom()  
AND admcore_aditivo.data_baixa AT TIME ZONE 'UTC' AT TIME ZONE 'America/Recife' <= $__timeTo()     
AND admcore_pop.cidade IN ($pop)\r\nand plano_novo.preco > plano_antigo.preco