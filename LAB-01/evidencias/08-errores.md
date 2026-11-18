# Actividad 8 — Errores y operaciones rechazadas

## 1. Comandos ejecutados

```bash
psql "postgresql://soporte_ana:<REDACTED>@127.0.0.1/comercial" -c "DELETE FROM clientes WHERE id = 5"
```

```sql
DROP ROLE soporte_ana;

SELECT linea FROM dba.bitacora
WHERE linea ~ '(ERROR|STATEMENT|DETAIL): (permission|privileges|role|DELETE|DROP)'
ORDER BY num;
```

 

## 2. Resultado obtenido

```text

```

 

## 3. Preguntas de análisis

1. **¿El intento de `soporte_ana` causó algún daño? ¿Por qué debe auditarse de todos modos?**
   >  

2. **¿Qué diferencia hay entre un error de autorización (esta actividad) y uno de autenticación (Actividad 5)?**
   >  

3. **¿Qué indica el error de `DROP ROLE` sobre el orden correcto para dar de baja a un usuario?**
   >  