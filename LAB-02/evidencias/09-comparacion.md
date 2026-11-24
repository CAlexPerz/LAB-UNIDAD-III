# Actividad 9 — Comparar los tres escenarios

> **Criterio de llenado:** Usa `Sí (observado)`, `Parcial (explica)` o `No`. Para MongoDB Enterprise/Atlas escribe `Documentado, no practicado` cuando corresponda (según REF-U3-04).

| Evento auditable | PostgreSQL (bitácora + disparador) | MongoDB Community (perfilador + bitácora) | MongoDB Enterprise / Atlas (auditoría nativa) |
| :--- | :--- | :--- | :--- |
| **Acceso exitoso** | **Sí** (observado en bitácora con `log_connections`). | **Sí** (observado en bitácora: `ACCESS`, `id: 5286306`). | **Documentado, no practicado** (auditoría de autenticación). |
| **Acceso fallido** | **Sí** (observado en bitácora: `authentication failed`). | **Sí** (observado en bitácora: `ACCESS`, `id: 5286307`). | **Documentado, no practicado** (auditoría de fallos de acceso). |
| **Cambio de privilegios** | **Sí** (observado con `log_statement = 'ddl'` para `GRANT`/`REVOKE`). | **No** (no se registra en perfilador ni bitácora; requiere instantáneas). | **Documentado, no practicado** (registra cambios de usuarios y roles). |
| **Cambio de estructura** | **Sí** (observado con `log_statement = 'ddl'`). | **Parcial** (la bitácora registra creación/borrado de colecciones en `STORAGE`/`COMMAND`, pero sin DDL completo ni autor directo). | **Documentado, no practicado** (auditoría nativa completa de DDL). |
| **Modificación de datos** | **Sí** (observado con `log_statement = 'mod'` y disparador). | **Sí** (observado en `system.profile` en nivel 2 o nivel 1 con filtro). | **Documentado, no practicado** (CRUD con `auditAuthorizationSuccess: true`). |
| **Valor anterior del dato** | **Sí** (observado con `OLD` en disparador `UPDATE`/`DELETE`). | **No** (`system.profile` solo registra el comando enviado, no el valor previo). | **No** (registra metadatos del comando CRUD, no imágenes `before/after`). |
| **Lectura de datos sensibles** | **Parcial** (solo con `log_statement = 'all'`, alto volumen). | **Parcial** (solo en nivel 2 de `system.profile`, alto costo y riesgo de fuga PII). | **Documentado, no practicado** (CRUD con `auditAuthorizationSuccess: true`). |
| **Cambio de configuración del registro** | **Sí** (observado con `ALTER SYSTEM` en bitácora). | **Sí** (observado en bitácora: `id: 48742`, `Profiler settings changed`). | **Documentado, no practicado** (auditoría de cambios de configuración). |