# Actividad 4 — Configurar la bitácora

## 1. Comandos ejecutados

```sql
ALTER SYSTEM SET log_connections = on;
ALTER SYSTEM SET log_disconnections = on;
ALTER SYSTEM SET log_line_prefix = '%m [%p] user=%u db=%d app=%a client=%h ';
ALTER SYSTEM SET log_statement = 'ddl';
SELECT pg_reload_conf();

SELECT name, setting, source, sourcefile
FROM pg_settings
WHERE name IN ('log_connections', 'log_line_prefix', 'log_statement');

SELECT num, linea FROM dba.bitacora ORDER BY num DESC LIMIT 6;
```

 

## 2. Resultado obtenido

### Verificación en `pg_settings`

| `name` | `setting` | `source` | `sourcefile` |
| :--- | :--- | :--- | :--- |
| `log_connections` | | | |
| `log_line_prefix` | | | |
| `log_statement` | | | |

### Últimas líneas de `dba.bitacora`

```text
  
```

 

## 3. Preguntas de análisis

1. **¿Por qué el proceso que registra el cambio es el principal y no tu sesión?**
   >  

2. **¿Qué pasaría si alguien ejecutara `ALTER SYSTEM SET log_statement = 'none'`? ¿Quedaría rastro?**
   >  

3. **¿Por qué no se recomienda editar `postgresql.auto.conf` a mano?**
   >  