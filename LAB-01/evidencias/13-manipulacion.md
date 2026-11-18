# Actividad 14 — Intentar manipular la auditoría

## 1. Comandos ejecutados

### Intento de manipulación desde `app_ventas`
```bash
psql "postgresql://app_ventas:<REDACTED>@127.0.0.1/comercial?application_name=app-ventas-web" -c "DELETE FROM auditoria.cambios_clientes" -c "ALTER TABLE clientes DISABLE TRIGGER trg_auditoria_clientes"
```

### Desactivación temporal desde administrador (`postgres`)
```sql
ALTER TABLE clientes DISABLE TRIGGER trg_auditoria_clientes;
UPDATE clientes SET rfc = 'GAMA780912GHI' WHERE id = 3;
ALTER TABLE clientes ENABLE TRIGGER trg_auditoria_clientes;

SELECT count(*) FROM auditoria.cambios_clientes;

SELECT linea FROM dba.bitacora
WHERE linea ~ 'statement: (ALTER TABLE clientes (DIS|EN)ABLE|UPDATE clientes SET rfc = .GAMA780912GHI)'
ORDER BY num;
```

 

## 2. Resultado obtenido

```text
```

 

## 3. Preguntas de análisis

1. **¿Qué evidencia permite detectar que hubo un cambio sin auditar?**
   >  

2. **¿Qué control administrativo (no técnico) reduciría este riesgo?**
   >  

3. **Relaciona esta actividad con el principio de separación de funciones de la Unidad II.**
   >  