--Alguns códigos utilizados

WITH ranked_os AS (   
    SELECT        
        atendimento_os.id AS OS,        
        CONCAT(           
            TRIM(SUBSTRING(admcore_pessoa.nome FROM 1 FOR POSITION(' ' IN admcore_pessoa.nome))), ' ', TRIM(SUBSTRING(admcore_pessoa.nome FROM POSITION(' ' IN admcore_pessoa.nome) + 1 FOR POSITION(' ' IN SUBSTRING(admcore_pessoa.nome FROM POSITION(' ' IN admcore_pessoa.nome) + 1))))       
            ) AS cliente,        
        auth_user.username AS tecnico,        
        ed.logradouro AS rua,       
        atendimento_motivoos.descricao AS descricao,        
        EXTRACT(EPOCH FROM (atendimento_os.data_finalizacao - atendimento_os.data_checkin)) AS media_tempo_gasto_horas    
    FROM atendimento_os       
    INNER JOIN atendimento_ocorrencia ON (atendimento_os.ocorrencia_id = atendimento_ocorrencia.id)       
    INNER JOIN auth_user ON (atendimento_os.responsavel_id = auth_user.id)         
    INNER JOIN atendimento_motivoos ON (atendimento_motivoos.id = atendimento_os.motivoos_id)       
    INNER JOIN admcore_clientecontrato ON (admcore_clientecontrato.id = atendimento_ocorrencia.clientecontrato_id)        
    INNER JOIN admcore_cliente ON (admcore_clientecontrato.cliente_id = admcore_cliente.id)       
    INNER JOIN admcore_pessoa ON (admcore_cliente.pessoa_id = admcore_pessoa.id)       
    JOIN public.admcore_endereco AS ed ON admcore_cliente.endereco_id = ed.id  

    WHERE atendimento_os.status = 2)
    
SELECT   
    COUNT(*) AS total_os_em_execucao
FROM  ranked_os

-----------------------------------------------------------------------------------------------------------------------------------------

SELECT 
    atendimento_os.id AS OS, 
    CONCAT(split_part(admcore_pessoa.nome, ' ', 1), ' ', split_part(admcore_pessoa.nome, ' ', 3)) as CLIENTE, 
    split_part(upper(auth_user.username), '_', 1) AS TECNICO, 
    atendimento_os.latitude, 
    atendimento_os.longitude, 
    ed.cidade, 
    ed.bairro, 
    ed.logradouro, 
    ed.numero, 
    atendimento_motivoos.descricao 
FROM atendimento_os 
INNER JOIN atendimento_ocorrencia ON (atendimento_os.ocorrencia_id = atendimento_ocorrencia.id) 
INNER JOIN auth_user ON (atendimento_os.responsavel_id = auth_user.id)
INNER JOIN atendimento_motivoos ON (atendimento_motivoos.id = atendimento_os.motivoos_id) 
INNER JOIN admcore_clientecontrato  ON (admcore_clientecontrato.id = atendimento_ocorrencia.clientecontrato_id) 
INNER JOIN admcore_cliente ON (admcore_clientecontrato.cliente_id = admcore_cliente.id) 
INNER JOIN admcore_pessoa ON (admcore_cliente.pessoa_id = admcore_pessoa.id) 
JOIN public.admcore_endereco AS ed ON admcore_cliente.endereco_id = ed.id 

where auth_user.username like '%jerlan%' and atendimento_os.status = 2 
limit 1