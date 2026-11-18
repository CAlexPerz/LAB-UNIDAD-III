# Actividad 7 — Modificaciones de datos: `ddl` frente a `mod`

## 1. Comandos ejecutados

### Prueba con `log_statement = 'ddl'`
```bash
psql "postgresql://app_ventas:<REDACTED>@127.0.0.1/comercial?application_name=app-ventas-web" -c "UPDATE clientes SET rfc = 'GAMA780912XYZ' WHERE id = 3"
```

### Cambio de nivel a `mod` y prueba con `UPDATE` + `SELECT`
```sql
ALTER SYSTEM SET log_statement = 'mod';
SELECT pg_reload_conf();
```

```bash
psql "postgresql://app_ventas:<REDACTED>@127.0.0.1/comercial?application_name=app-ventas-web" -c "UPDATE clientes SET telefono = '6679990000' WHERE id = 3" -c "SELECT nombre, rfc FROM clientes WHERE id = 3"
```

```sql
SELECT linea FROM dba.bitacora
WHERE linea LIKE '%log_statement%' OR linea LIKE '%user=app_ventas%statement:%'
ORDER BY num;
```

 

## 2. Resultado obtenido

```text
  
```

 

## 3. Preguntas de análisis

1. **¿Qué nivel habría registrado la lectura del RFC? ¿Qué costo tendría en un servidor con miles de consultas por minuto?**
   >  

2. **¿Qué le falta a esta bitácora para revertir el cambio con certeza? (Lo resolverás en la Parte B.)**
   >  