# Actividades 18 y 19 — Auditoría de objeto sobre columnas sensibles con `pgaudit` (Parte C)

## 1. Comandos ejecutados

### Carga de extensión (Actividad 18)
```sql
ALTER SYSTEM SET shared_preload_libraries = 'pgaudit';
-- [Reinicio del servicio]
SHOW shared_preload_libraries;
CREATE EXTENSION pgaudit;
SELECT extname, extversion FROM pg_extension WHERE extname = 'pgaudit';
```

### Configuración del rol auditor y pruebas (Actividad 19)
```sql
CREATE ROLE auditor_datos NOLOGIN;
GRANT SELECT (rfc, telefono), UPDATE (rfc, telefono) ON clientes TO auditor_datos;

ALTER SYSTEM SET pgaudit.log = 'role, ddl';
ALTER SYSTEM SET pgaudit.role = 'auditor_datos';
ALTER SYSTEM SET pgaudit.log_relation = on;
SELECT pg_reload_conf();
```

```bash
psql "postgresql://app_ventas:<REDACTED>@127.0.0.1/comercial?application_name=app-ventas-web" \
  -c "SELECT nombre, ciudad FROM clientes WHERE id = 2" \
  -c "SELECT nombre, rfc FROM clientes WHERE id = 3" \
  -c "SELECT * FROM clientes WHERE id = 4" \
  -c "UPDATE clientes SET rfc = 'LOAA850315XXX' WHERE id = 1" \
  -c "UPDATE clientes SET ciudad = 'Navolato' WHERE id = 2"
```

```sql
GRANT SELECT ON clientes TO soporte_ana;
SELECT linea FROM dba.bitacora WHERE linea LIKE '%AUDIT:%';
```

 

## 2. Resultado obtenido

```text

```

 

## 3. Preguntas de análisis

1. **¿Por qué no apareció `SELECT nombre, ciudad ...`? ¿Por qué sí apareció `SELECT * ...`?**
   >  

2. **¿Por qué no apareció `UPDATE ... ciudad ...`?**
   >  

3. **¿Qué diferencia de volumen esperarías frente a `log_statement = 'all'`?**
   >  

4. **El README oficial advierte que `pgaudit` no puede auditar de forma confiable a los superusuarios (REF-U3-09). ¿Qué implica para la separación de funciones?**
   >  