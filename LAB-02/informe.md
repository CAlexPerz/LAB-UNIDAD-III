# Informe Técnico

## 1. Despliegue, edición y limitación
El servidor se desplegó en Docker (`mongo:7`) con `--auth` (`security.authorization: "enabled"`). Mediante `db.version()` y `db.adminCommand({ buildInfo: 1 }).modules` (`[]`) se verificó que corresponde a **MongoDB 7 Community Edition**.

**Limitación crítica:** Community **no incluye auditoría nativa** (función exclusiva de MongoDB Enterprise y Atlas M10+, `REF-U3-04`). Solo ofrece el perfilador (`system.profile`) y la bitácora de `mongod`, ninguno de los cuales equivale a un sistema de auditoría de seguridad.

## 2. Perfilador (`Database Profiler`)
* **Configuración:** Se activó en nivel 2 (`db.setProfilingLevel(2)`) en `comercial`, logrando atribuir consultas y escrituras a `app_ventas@comercial`, `127.0.0.1` y `app-ventas-web`. Luego se filtró a escrituras (`op: { $in: ["insert", "update", "remove"] }`), capturando únicamente modificaciones como el cambio de teléfono sobre `_id: 1` (`2026-11-24T04:54:41.900Z`).
* **Alcance y costo:** No guarda valores anteriores del documento (*before-image*). En nivel 2 penaliza el rendimiento, llena rápidamente su límite de 1 MB (*capped collection*), expone criterios de búsqueda (PII) en texto claro y vuelve a nivel `0` tras reiniciar si no se configura en `mongod.conf`.

## 3. Bitácora de `mongod`
Sin `systemLog.destination: file`, `mongod` escribe eventos JSON en `stdout` y mantiene los últimos **1,024 eventos** en RAM (`getLog: "global"`).
* **Accesos:** Distingue éxitos (`id: 5286306`, `result: 0`) de fallos (`id: 5286307`), diferenciando internamente clave errónea (`result: 18`) de usuario inexistente (`result: 11`), mientras muestra un error genérico al cliente.
* **Correlación (`ctx`):** Al cruzar `ctx: "conn292"` entre `Successfully authenticated` (`04:51:49.338Z`) y `Profiler settings changed` (`04:51:49.386Z`), se comprobó que **`admin@admin`** cambió el filtro del perfilador. Esta correlación solo es válida dentro de un mismo arranque del servicio.

## 4. Privilegios: evidencia, control compensatorio y límite
MongoDB Community **no registra cambios de privilegios** (`grantRolesToUser` devolvió `0` coincidencias en `system.profile` y bitácora). Como **control compensatorio**, se implementaron instantáneas periódicas en `auditoria.instantaneas_privilegios`: detectan qué rol cambió entre dos tomas, pero **no sustituyen a la auditoría nativa** porque no revelan quién ejecutó el cambio ni el momento exacto.

## 5. Conservación de evidencias
Para evitar pérdidas por sobrescritura del límite de 1 MB o vaciado de `getLog` al reiniciar, se exportaron las evidencias antes del reinicio y se calcularon sus hashes en `evidencias/hashes.sha256`

## 6. Comparación (resumen Actividad 9)
* **PostgreSQL (bitácora + disparador):** cobertura completa observada de accesos, privilegios (`GRANT`/`REVOKE`), DDL, DML y valor anterior (`OLD`).
* **MongoDB Community (perfilador + bitácora):** cubre accesos, cambios de configuración del perfilador y comandos CRUD (mientras no rote el 1 MB), pero **no registra** cambios de privilegios ni valores anteriores.
* **MongoDB Enterprise / Atlas:** cubre de forma nativa accesos, privilegios, DDL, CRUD autorizado y configuración en destinos externos inmutables (documentado, no practicado), aunque tampoco guarda imágenes `before/after` del documento.

## 7. Recomendación
Para auditar cambios de privilegios con validez normativa, **se recomienda migrar a MongoDB Enterprise o Atlas (M10+)** con auditoría nativa enviada a un SIEM externo. Como medida transitoria en Community, automatizar instantáneas de roles cada 15 minutos con alertas de cambios y acceso restringido.
* **Hechos verificados:** Community (`modules: []`) omite eventos DCL (`grantRolesToUser`); `system.profile` es circular de 1 MB y no guarda valores previos; `getLog` retiene 1,024 eventos volátiles.
* **Supuestos:** Comercializadora Norte S.A. de C.V. requiere cumplimiento de protección de datos personales y retención forense superior a la ventana que ofrece 1 MB en producción.

---

## Preguntas de reflexión

1. **¿Por qué el perfilador no debe presentarse como un mecanismo de auditoría de seguridad?**  
   Porque está diseñado para diagnóstico de desempeño, carece de inmutabilidad, sobrescribe evidencia al llenar 1 MB, se apaga al reiniciar si no se persiste y omite cambios de privilegios.

2. **¿Por qué el perfilador sí aporta trazabilidad aunque no sea auditoría?**  
   Porque registra metadatos operativos clave (`user`, `client`, `appName`, `ts`, `ns`, `command`) que permiten reconstruir quién ejecutó consultas o modificaciones recientes.

3. **¿Qué riesgo introduce el nivel 2 al registrar filtros de consultas que pueden contener datos personales?**  
   Persiste en texto claro dentro de `system.profile` los criterios de búsqueda (RFC, correos, teléfonos), ampliando la exposición de datos personales (PII).

4. **¿Qué diferencia hay entre detectar un cambio y atribuirlo a alguien?**  
   **Detectar** es comprobar que un estado cambió (ej. ver un nuevo rol en una instantánea); **atribuir** es vincular ese cambio de forma fehaciente con un usuario, origen y hora exacta.

5. **¿Por qué reconocer una limitación técnica es parte del trabajo profesional del DBA?**  
   Porque evita falsas garantías de cumplimiento y permite a la Dirección gestionar el riesgo residual mediante controles compensatorios o actualizaciones de arquitectura.