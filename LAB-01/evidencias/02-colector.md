# Actividad 2 — Que el servidor administre su propia bitácora

## 1. Comandos ejecutados

```sql
ALTER SYSTEM SET logging_collector = on;
SELECT name, setting, pending_restart FROM pg_settings WHERE name = 'logging_collector';
-- [Reinicio del servicio]
SELECT name, setting, source FROM pg_settings WHERE name = 'logging_collector';
SELECT pg_current_logfile();

CREATE SCHEMA dba;
REVOKE ALL ON SCHEMA dba FROM PUBLIC;
CREATE VIEW dba.bitacora AS
SELECT t.n AS num, t.linea
FROM regexp_split_to_table(pg_read_file(pg_current_logfile()), E'\n')
     WITH ORDINALITY AS t(linea, n)
WHERE t.linea <> '';
```

 

## 2. Resultado obtenido

### Estado del colector y archivo vigente

| Parámetro / Función | Valor obtenido | Origen (`source`) |
| :--- | :--- | :--- |
| `logging_collector` | | |
| `pg_current_logfile()` | |  |

### Extracto de lectura inicial desde `dba.bitacora`

```text

```

 

## 3. Preguntas de análisis

1. **¿Por qué `logging_collector` requiere reinicio y `log_statement` solo recarga?**
   >  

2. **¿Qué ventaja tiene que la bitácora se lea con SQL y no con una herramienta del sistema operativo o del contenedor? ¿Qué riesgo introduce?**
   >  

3. **¿Quién debería poder consultar `dba.bitacora`?**
   >  