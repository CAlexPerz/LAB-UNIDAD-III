# Actividad 1 — Revisar la configuración de registro por defecto

## 1. Comando ejecutado

```sql
SELECT name, setting, source FROM pg_settings
WHERE name IN ('log_destination', 'logging_collector', 'log_directory', 'log_filename',
               'log_connections', 'log_disconnections', 'log_line_prefix',
               'log_statement', 'log_min_error_statement', 'log_timezone')
ORDER BY name;
```

 

## 2. Resultado obtenido

| `name` | `setting` | `source` |
| :--- | :--- | :--- |
| `log_connections` | | |
| `log_destination` | | |
| `log_directory` | | |
| `log_disconnections` | | |
| `log_filename` | | |
| `logging_collector` | | |
| `log_line_prefix` | | |
| `log_min_error_statement` | | |
| `log_statement` | | |
| `log_timezone` | | |

 

## 3. Preguntas de análisis

1. **Con esta configuración, ¿se registra quién se conecta?**
   > 

2. **¿Se registran las sentencias `UPDATE`?**
   > 

3. **¿La línea de bitácora incluye el usuario o la dirección IP del cliente?**
   > 

4. **¿En qué zona horaria se registran los eventos? ¿Por qué importa al reconstruir una cronología?**
   > 

5. **Con `logging_collector = off`, ¿quién decide dónde termina la bitácora: PostgreSQL o el mecanismo con que se desplegó el servidor?**
   > 