# Actividad 10 — Diseñar y crear el registro de auditoría

## 1. Diseño del registro de auditoría (`auditoria.cambios_clientes`)

| Campo propuesto | Tipo | ¿Qué pregunta responde? | ¿Puede ser nulo? ¿Por qué? |
| :--- | :--- | :--- | :--- |
| `id_evento` | `BIGSERIAL` | | |
| `momento` | `TIMESTAMPTZ` | | |
| `usuario_sesion` | `TEXT` | | |
| `usuario_efectivo` | `TEXT` | | |
| `aplicacion` | `TEXT` | | |
| `ip_cliente` | `INET` | | |
| `operacion` | `TEXT` | | |
| `id_cliente` | `BIGINT` | | |
| `valores_antes` | `JSONB` | | |
| `valores_despues` | `JSONB` | | |

## Evidencias de querys
![](../recursos/act10_01.png)

## Preguntas de análisis

1. **¿Por qué `momento` usa `TIMESTAMPTZ` y no `TIMESTAMP`?**
   >  

2. **¿Por qué se guarda el registro completo en `JSONB` y no solo la columna que cambió?**
   >  

3. **La tabla de auditoría también contendrá RFC. ¿Qué implica eso para su clasificación y su control de acceso?**
   >  