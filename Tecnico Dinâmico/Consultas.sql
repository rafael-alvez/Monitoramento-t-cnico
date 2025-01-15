/*Algumas das consultas usadas na tabela.*/

SELECT 
    count(atendimento_os.id) AS qtd
FROM atendimento_os
INNER JOIN atendimento_ocorrencia ON (atendimento_os.ocorrencia_id = atendimento_ocorrencia.id)
INNER JOIN auth_user ON (atendimento_os.responsavel_id = auth_user.id)
INNER JOIN atendimento_motivoos ON (atendimento_motivoos.id = atendimento_os.motivoos_id)
INNER JOIN admcore_clientecontrato  ON (admcore_clientecontrato.id = atendimento_ocorrencia.clientecontrato_id)
INNER JOIN admcore_cliente ON (admcore_clientecontrato.cliente_id = admcore_cliente.id)
INNER JOIN admcore_pessoa ON (admcore_cliente.pessoa_id = admcore_pessoa.id)
where atendimento_os.data_cadastro >= current_date - interval '30 day'and auth_user.username = '$tecnico'\r\n and atendimento_os.status = 0

--------------------------------------------------------------------------------------

SELECT 
    count(atendimento_os.id) AS qtd
FROM atendimento_os
INNER JOIN atendimento_ocorrencia ON (atendimento_os.ocorrencia_id = atendimento_ocorrencia.id)
INNER JOIN auth_user ON (atendimento_os.responsavel_id = auth_user.id)
INNER JOIN atendimento_motivoos ON (atendimento_motivoos.id = atendimento_os.motivoos_id)
INNER JOIN admcore_clientecontrato  ON (admcore_clientecontrato.id = atendimento_ocorrencia.clientecontrato_id)
INNER JOIN admcore_cliente ON (admcore_clientecontrato.cliente_id = admcore_cliente.id)
INNER JOIN admcore_pessoa ON (admcore_cliente.pessoa_id = admcore_pessoa.id)
where atendimento_os.data_cadastro >= current_date - interval '30 day' and auth_user.username = '$tecnico'\r\n and atendimento_os.status = 1