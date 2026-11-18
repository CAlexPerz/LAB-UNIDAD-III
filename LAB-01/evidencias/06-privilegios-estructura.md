# Actividad 6 — Cambios de privilegios y de estructura

- **Estudiante:** [Nombre del estudiante]
- **Actividad:** Parte A — Actividad 6: Cambios de privilegios y de estructura
- **Script relacionado:** `sql/03-privilegios-estructura.sql`

 

## 1. Comandos ejecutados

```sql
REVOKE UPDATE ON clientes FROM soporte_ana;
GRANT UPDATE ON clientes TO app_ventas;
ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20);

CREATE ROLE rol_temporal LOGIN PASSWORD '<REDACTED>';
DROP ROLE rol_temporal;

SELECT linea FROM dba.bitacora WHERE linea LIKE '%statement:%' ORDER BY num;
```

 

## 2. Resultado obtenido

```text

```

 

## 3. Preguntas de análisis

1. **¿Qué tipo de evento es cada una de las tres primeras sentencias (privilegio o estructura)?**
   >  

2. **¿Por qué `GRANT` y `REVOKE` quedan registrados con `log_statement = 'ddl'`?**
   >  

3. **Si la bitácora contiene contraseñas, ¿quién debería poder leerla? Relaciónalo con la gestión de secretos de la Unidad II.**
   >  