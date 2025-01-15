SELECT 
    hu.Rota,
    hu.Last,
    AVG.AVG_value,
    ASN.ASN_value,
    IP.IP_value,
    hu.timestamp
FROM
    (
        SELECT 
            Rota,
            Last,
            timestamp,
            ROW_NUMBER() OVER(PARTITION BY Rota ORDER BY timestamp DESC) AS rn
        FROM
            (
                SELECT 
                    SUBSTRING_INDEX(i.name, '(', 1) AS Rota,
                    hu.value AS Last,
                    CONVERT_TZ(FROM_UNIXTIME(hu.clock), '+00:00', '+03:00') AS timestamp
                    -- Adicione os outros campos necessários da sua subquery original
                FROM
                    history AS hu
                JOIN
                    items AS i ON hu.itemid = i.itemid
                JOIN
                    hosts AS h ON i.hostid = h.hostid
                WHERE
                    h.host = 'ROTA YOUTUBE' AND i.name NOT LIKE '%WRS%'
            ) AS subquery
    ) AS hu
JOIN
    (
		SELECT 
            Rota,
            ASN_value,
            timestamp,
            ROW_NUMBER() OVER(PARTITION BY Rota ORDER BY timestamp DESC) AS rn
        FROM
            (
                SELECT 
                    SUBSTRING_INDEX(i.name, '(', 1) AS Rota,
                    ht.value AS ASN_value,
                    CONVERT_TZ(FROM_UNIXTIME(ht.clock), '+00:00', '+03:00') AS timestamp
                    -- Adicione os outros campos necessários da sua subquery original
                FROM 
                    history_text ht
                JOIN 
                    items i ON ht.itemid = i.itemid
                JOIN 
                    hosts h ON i.hostid = h.hostid
                WHERE 
                    h.name = 'ROTA YOUTUBE' AND i.name LIKE '%ASN%'
            ) AS subquery
    ) AS ASN ON hu.Rota = ASN.Rota
JOIN
    (
        SELECT 
            Rota,
            IP_value,
            timestamp,
            ROW_NUMBER() OVER(PARTITION BY Rota ORDER BY timestamp DESC) AS rn
        FROM
            (
                SELECT 
                    SUBSTRING_INDEX(i.name, 'I', 1) AS Rota,
                    ht.value AS IP_value,
                    CONVERT_TZ(FROM_UNIXTIME(ht.clock), '+00:00', '+03:00') AS timestamp
                    -- Adicione os outros campos necessários da sua subquery original
                FROM 
                    history_text ht
                JOIN 
                    items i ON ht.itemid = i.itemid
                JOIN 
                    hosts h ON i.hostid = h.hostid
                WHERE 
                    h.name = 'ROTA YOUTUBE' AND i.name LIKE '%IP%'
            ) AS subquery
    ) AS IP ON hu.Rota = IP.Rota
JOIN
    (
        SELECT 
            Rota,
            AVG_value,
            timestamp,
            ROW_NUMBER() OVER(PARTITION BY Rota ORDER BY timestamp DESC) AS rn
        FROM
            (
                SELECT 
                    SUBSTRING_INDEX(i.name, '(', 1) AS Rota,
                    hu.value AS AVG_value,
                    CONVERT_TZ(FROM_UNIXTIME(hu.clock), '+00:00', '+03:00') AS timestamp
                    -- Adicione os outros campos necessários da sua subquery original
                FROM 
                    history hu
                JOIN 
                    items i ON hu.itemid = i.itemid
                JOIN 
                    hosts h ON i.hostid = h.hostid
                WHERE 
                    h.name = 'ROTA YOUTUBE' AND i.name LIKE '%AVG%'
            ) AS subquery
    ) AS AVG ON hu.Rota = AVG.Rota
WHERE hu.rn = 1 and ASN.rn = 1 and IP.rn =1 and AVG.rn = 1
LIMIT 0, 5000;

