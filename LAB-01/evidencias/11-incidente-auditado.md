# Actividades 11 y 12 — Función, disparador y el incidente auditado

## Parte I: Actividad 11 — Crear la función y el disparador

### 1. Verificación del disparador en `pg_trigger`

| `tgname` | `tgenabled` | `tgrelid` |
| :--- | :--- | :--- |
| | | |

### 2. Preguntas de la Actividad 11

1. **¿Por qué se ejecuta `REVOKE ALL ON FUNCTION ... FROM PUBLIC` si el disparador seguirá funcionando para `app_ventas`?**
   >  

2. **¿Qué pasaría si la función no fuera `SECURITY DEFINER`? Formula una hipótesis antes de la Actividad 12.**
   >  

3. **Consulta `dba.bitacora`. ¿Quedó registrada la creación del esquema, la tabla, la función y el disparador? ¿Por qué?**
   >  

 

## Parte II: Actividad 12 — El incidente auditado

### 1. Comandos ejecutados

```bash
psql "postgresql://app_ventas:<REDACTED>@127.0.0.1/comercial?application_name=app-ventas-web" -c "UPDATE clientes SET rfc = 'GAMA780912ZZZ' WHERE id = 3"
psql "postgresql://app_ventas:<REDACTED>@127.0.0.1/comercial" -c "SELECT * FROM auditoria.cambios_clientes"
```

```sql
SELECT id_evento, momento, usuario_sesion, usuario_efectivo, aplicacion, ip_cliente, operacion, id_cliente
FROM auditoria.cambios_clientes ORDER BY id_evento;

SELECT a.id_evento, a.momento, a.usuario_sesion, a.ip_cliente,
       d.key                 AS campo,
       a.valores_antes ->> d.key AS antes,
       d.value #>> '{}'      AS despues
FROM auditoria.cambios_clientes a
CROSS JOIN LATERAL jsonb_each(a.valores_despues) d
WHERE a.operacion = 'UPDATE' AND a.valores_antes -> d.key IS DISTINCT FROM d.value
ORDER BY a.id_evento;
```

### 2. Resultado obtenido

#### Comparación campo por campo (`valores_antes` vs `valores_despues`)

| `id_evento` | `momento` | `usuario_sesion` | `ip_cliente` | `campo` | `antes` | `despues` |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| | | | | | | |

### 3. Preguntas de la Actividad 12

1. **Compara tu hipótesis de la Actividad 11 con este resultado.**
   >  

2. **Escribe la sentencia `UPDATE` que restauraría el valor anterior.**
   >  

3. **¿Qué columna conserva más valor para una investigación: `aplicacion` o `ip_cliente`? ¿Cuál puede falsificar el cliente con más facilidad?**
   >  