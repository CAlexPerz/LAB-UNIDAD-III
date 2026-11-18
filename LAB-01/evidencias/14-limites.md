# Actividad 15 — Límites: lecturas y volumen

## 1. Comandos ejecutados

```bash
psql "postgresql://soporte_ana:<REDACTED>@127.0.0.1/comercial" -c "SELECT nombre, rfc, telefono FROM clientes WHERE id = 3"
```

```sql
UPDATE clientes SET segmento = 'regular';

SELECT count(*) AS lineas_bitacora FROM dba.bitacora
WHERE linea LIKE '%statement: UPDATE clientes SET segmento%';

SELECT operacion, count(*) FROM auditoria.cambios_clientes GROUP BY operacion ORDER BY operacion;

SELECT count(*) AS lecturas_soporte FROM dba.bitacora
WHERE linea LIKE '%user=soporte_ana%SELECT nombre, rfc%';
```

 

## 2. Resultado obtenido

| Métrica consultada | Valor obtenido |
| :--- | :--- |
| `lineas_bitacora` | |
| `DELETE` (en `auditoria.cambios_clientes`) | |
| `INSERT` (en `auditoria.cambios_clientes`) | |
| `UPDATE` (en `auditoria.cambios_clientes`) | |
| `lecturas_soporte` | |

 

## 3. Preguntas de análisis

1. **Si `clientes` tuviera un millón de registros, ¿qué ocurriría con la auditoría tras un `UPDATE` sin `WHERE`?**
   >  

2. **Propón quién podría autorizar la depuración de `auditoria.cambios_clientes`.**
   >  

3. **¿Por qué `log_statement = 'all'` puede convertir la bitácora en un nuevo depósito de datos sensibles?**
   >  