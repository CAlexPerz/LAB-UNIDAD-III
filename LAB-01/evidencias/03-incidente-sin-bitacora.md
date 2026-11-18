# Actividad 3 — El incidente sin bitácora

## 1. Comandos ejecutados

### Simulación del cambio desde `app_ventas`
```bash
psql "postgresql://app_ventas:<REDACTED>@127.0.0.1/comercial?application_name=app-ventas-web" -c "UPDATE clientes SET rfc = 'GAMA780912XXX' WHERE id = 3"
```

### Consulta de búsqueda en la bitácora
```sql
SELECT linea FROM dba.bitacora
WHERE linea ILIKE '%update%' OR linea LIKE '%app_ventas%';
```

 

## 2. Resultado obtenido

```text

```

 

## 3. Preguntas de análisis

1. **¿Puedes demostrar quién modificó el RFC?**
   >  

2. **¿Puedes demostrar que el cambio no lo hizo `soporte_ana`?**
   >  

3. **Los privilegios de la Unidad II, ¿impidieron el cambio? ¿Debían impedirlo?**
   >  

4. **¿Qué tendría que haber estado configurado antes del incidente?**
   >  