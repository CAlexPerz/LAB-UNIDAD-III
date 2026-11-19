-- 18. Actividad 12 — El incidente auditado
--  En la sesión de administrador (\x activa la presentación vertical de psql; repítelo para desactivarla):
SELECT id_evento, momento, usuario_sesion, usuario_efectivo, aplicacion, ip_cliente, operacion, id_cliente
FROM auditoria.cambios_clientes ORDER BY id_evento;

-- ¿Qué campo cambió? Compara valores_antes con valores_despues campo por campo:
SELECT a.id_evento, a.momento, a.usuario_sesion, a.ip_cliente,
       d.key             AS campo,
       a.valores_antes ->> d.key AS antes,
       d.value #>> '{}'  AS despues
FROM auditoria.cambios_clientes a
CROSS JOIN LATERAL jsonb_each(a.valores_despues) d
WHERE a.operacion = 'UPDATE' AND a.valores_antes -> d.key IS DISTINCT FROM d.value
ORDER BY a.id_evento;

-- 19. Actividad 13 — Altas y bajas
-- Como administrador:
INSERT INTO clientes (nombre, correo, rfc, edad, ciudad, codigo_postal)
VALUES ('Pedro Ruiz', 'pedro.ruiz@example.test', 'RUPE950101AAA', 30, 'Guasave', '81000');
DELETE FROM clientes WHERE nombre = 'Pedro Ruiz';

SELECT id_evento, usuario_sesion, aplicacion, ip_cliente, operacion, id_cliente,
       valores_antes ->> 'rfc' AS rfc_antes, valores_despues ->> 'rfc' AS rfc_despues
FROM auditoria.cambios_clientes ORDER BY id_evento;

-- 20. Actividad 14 — Intentar manipular la auditoría
-- Desde la cuenta de administrador, desactiva el disparador, modifica un dato y vuelve a activarlo:
ALTER TABLE clientes DISABLE TRIGGER trg_auditoria_clientes;
UPDATE clientes SET rfc = 'GAMA780912GHI' WHERE id = 3;
ALTER TABLE clientes ENABLE TRIGGER trg_auditoria_clientes;
SELECT count(*) FROM auditoria.cambios_clientes;

-- El conteo sigue en 3: el cambio no quedó en la tabla de auditoría. Revisa la bitácora:
SELECT linea FROM dba.bitacora
WHERE linea ~ 'statement: (ALTER TABLE clientes (DIS|EN)ABLE|UPDATE clientes SET rfc = .GAMA780912GHI)'
ORDER BY num;

-- 21. Actividad 15 — Límites: lecturas y volumen
-- Ejecuta una lectura de datos sensibles y un cambio masivo:

UPDATE clientes SET segmento = 'regular';
SELECT count(*) AS lineas_bitacora FROM dba.bitacora
WHERE linea LIKE '%statement: UPDATE clientes SET segmento%';
SELECT operacion, count(*) FROM auditoria.cambios_clientes GROUP BY operacion ORDER BY operacion;
SELECT count(*) AS lecturas_soporte FROM dba.bitacora
WHERE linea LIKE '%user=soporte_ana%SELECT nombre, rfc%';



-- PARTE C — pgaudit (opcional, práctica avanzada)
-- 24. Actividad 18 — Instalar y cargar pgaudit
-- 24.1 Instalar el paquete
SELECT name, default_version FROM pg_available_extensions WHERE name = 'pgaudit';
CREATE EXTENSION pgaudit;

-- 24.2 Cargar la biblioteca al arrancar
ALTER SYSTEM SET shared_preload_libraries = 'pgaudit';
SELECT pg_reload_conf();
SELECT name, setting, pending_restart FROM pg_settings WHERE name = 'shared_preload_libraries';

-- pending_restart = t: el valor está guardado, pero solo entra en vigor al reiniciar. Reinicia el servicio (Anexo A, tabla A.1) y en una sesión nueva:
SHOW shared_preload_libraries;
CREATE EXTENSION pgaudit;
SELECT extname, extversion FROM pg_extension WHERE extname = 'pgaudit';

-- 25. Actividad 19 — Auditoría de objeto sobre columnas sensibles
-- Crea un rol auditor sin acceso de conexión y otórgale privilegios solo sobre las columnas sensibles. Sus privilegios funcionan como un filtro:
CREATE ROLE auditor_datos NOLOGIN;
GRANT SELECT (rfc, telefono), UPDATE (rfc, telefono) ON clientes TO auditor_datos;
ALTER SYSTEM SET pgaudit.log = 'role, ddl';
ALTER SYSTEM SET pgaudit.role = 'auditor_datos';
ALTER SYSTEM SET pgaudit.log_relation = on;
SELECT pg_reload_conf();

-- Y, como administrador, un cambio de privilegios:
GRANT SELECT ON clientes TO soporte_ana;
SELECT linea FROM dba.bitacora WHERE linea LIKE '%AUDIT:%';
