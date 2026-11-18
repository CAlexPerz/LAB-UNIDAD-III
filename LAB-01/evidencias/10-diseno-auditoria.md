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

 

## 2. Sentencias ejecutadas

```sql
CREATE SCHEMA auditoria;
REVOKE ALL ON SCHEMA auditoria FROM PUBLIC;

CREATE TABLE auditoria.cambios_clientes (
    id_evento        BIGSERIAL PRIMARY KEY,
    momento          TIMESTAMPTZ NOT NULL DEFAULT now(),
    usuario_sesion   TEXT        NOT NULL DEFAULT session_user,
    usuario_efectivo TEXT        NOT NULL DEFAULT current_user,
    aplicacion       TEXT        DEFAULT current_setting('application_name'),
    ip_cliente       INET        DEFAULT inet_client_addr(),
    operacion        TEXT        NOT NULL,
    id_cliente       BIGINT,
    valores_antes    JSONB,
    valores_despues  JSONB
);
```

 

## 3. Preguntas de análisis

1. **¿Por qué `momento` usa `TIMESTAMPTZ` y no `TIMESTAMP`?**
   >  

2. **¿Por qué se guarda el registro completo en `JSONB` y no solo la columna que cambió?**
   >  

3. **La tabla de auditoría también contendrá RFC. ¿Qué implica eso para su clasificación y su control de acceso?**
   >  