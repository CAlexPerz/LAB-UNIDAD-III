# Actividad 17 — Reconstruir la cronología y responder a Dirección

## 1. Cronología reconstruida de eventos

| # | Fecha y hora | Usuario / Cliente | Tipo de evento | Qué ocurrió | ¿Exitoso? | Fuente (línea o `id_evento`) |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | *(Previo a bitácora)* | `app_ventas` (`127.0.0.1`) | Datos | Cambio inicial de `rfc` de María García (`id=3`) a `'GAMA780912XXX'` sin registro activo (Act. 3) | Sí | **No hay evidencia** |
| 2 | `2026-11-19 07:09:02.806 UTC` | `app_ventas` (`127.0.0.1`) | Acceso | Intento fallido de autenticación por contraseña incorrecta | No (`FATAL`) | Bitácora líneas 19-20 (PID 48) |
| 3 | `2026-11-19 07:09:10.881 UTC` | `usuario_inexistente` (`127.0.0.1`) | Acceso | Intento fallido de autenticación con rol inexistente | No (`FATAL`) | Bitácora líneas 25-26 (PID 57) |
| 4 | `2026-11-19 07:14:34.383 UTC` | `postgres` (`172.17.0.1`) | Privilegio | `REVOKE UPDATE` a `soporte_ana` y `GRANT UPDATE` a `app_ventas` | Sí | Bitácora líneas 40-41 (PID 34) |
| 5 | `2026-11-19 07:14:34.387 UTC` | `postgres` (`172.17.0.1`) | Estructura | `ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20)` | Sí | Bitácora línea 42 (PID 34) |
| 6 | `2026-11-19 08:07:04.687 UTC` | `postgres` (`172.17.0.1` / PID 1) | Configuración | Cambio de `log_statement` a `'mod'` mediante `ALTER SYSTEM` | Sí | Bitácora líneas 61-63 |
| 7 | `2026-11-19 08:14:17.195 UTC` | `app_ventas` (`127.0.0.1`) | Datos | Actualización de `telefono = '6679990000'` para `id=3` (`app-ventas-web`) | Sí | Bitácora línea 67 (PID 275) |
| 8 | `2026-11-19 08:24:09.389 UTC` | `soporte_ana` (`127.0.0.1`) | Error | Intento rechazado de `DELETE FROM clientes WHERE id = 5` | No (`ERROR`) | Bitácora líneas 74-76 (PID 312) |
| 9 | `2026-11-19 09:04:38.310 UTC` | `app_ventas` (`127.0.0.1`) | Datos | Actualización auditada de `rfc` a `'GAMA780912ZZZ'` para `id=3` | Sí | Bitácora línea 165 / `id_evento = 1` |
| 10 | `2026-11-19 09:18:20.498 UTC` | `postgres` (`172.17.0.1`) | Datos / Evasión | Desactivación de trigger, `UPDATE` de `rfc` a `'GAMA780912GHI'` (`id=3`) y reactivación | Sí | Bitácora líneas 195-197 (PID 473) |
 

## Respuestas a Dirección (basadas exclusivamente en la evidencia)

1. **¿Quién cambió el RFC la primera vez (Actividad 3)? ¿Y en las Actividades 7, 12 y 14?**
    - **Actividad 3:** **No hay evidencia** (la bitácora y el disparador aún no estaban activos).
    - **Actividad 7:** **No hay evidencia** en la bitácora porque `log_statement` estaba en `'ddl'` (solo consta la conexión de `app_ventas` en líneas 55-58).
    - **Actividad 12:** `app_ventas` desde `127.0.0.1` usando `app-ventas-web` (`id_evento = 1` y bitácora línea 165).
    - **Actividad 14:** `postgres` desde `172.17.0.1` (`vscode-pgsql`) tras desactivar temporalmente el trigger (bitácora líneas 195-197).

2. **¿Quién cambió el teléfono?**
    `app_ventas` desde `127.0.0.1` mediante `app-ventas-web` el `2026-11-19 08:14:17.195 UTC`, asignando `'6679990000'` al cliente `id = 3` (bitácora línea 67).

3. **¿Hubo intentos de acceso fallidos? ¿De qué usuarios y desde dónde?**
    Sí, todos desde `127.0.0.1`: dos intentos fallidos para `app_ventas` por contraseña incorrecta (`07:09:02.806 UTC`, líneas 19 y 22) y dos intentos fallidos para `usuario_inexistente` por rol inexistente (`07:09:10.881 UTC`, líneas 25 y 29).

4. **¿Qué valor tenía el RFC antes de cada cambio?**
    - **Actividades 3 y 7:** **No hay evidencia** registrada del valor previo.
    - **Actividad 12:** `'GAMA780912XYZ'` (registrado en `valores_antes` de `id_evento = 1`).
    - **Actividad 14:** **No hay evidencia** en la tabla de auditoría porque el trigger fue desactivado (aunque `id_evento = 1` muestra que el estado previo conocido era `'GAMA780912ZZZ'`).


| Pregunta de Dirección | Evidencia disponible |
| :--- | :--- |
| **1. ¿Quién hizo el cambio?** | En el incidente inicial (Act. 3): **No hay evidencia**. En los eventos posteriores auditados: `app_ventas` (Act. 12) y `postgres` (Act. 14). |
| **2. ¿Cuándo?** | Act. 3: **No hay evidencia** (sin hora registrada). Act. 12: `2026-11-19 09:04:38.310 UTC`. Act. 14: `2026-11-19 09:18:20.498 UTC`. |
| **3. ¿Desde qué aplicación o equipo?** | Act. 12: `app-ventas-web` desde `127.0.0.1`. Act. 14: `vscode-pgsql` desde `172.17.0.1`. |
| **4. ¿Hubo intentos de acceso fallidos antes del cambio?** | Sí, se registraron intentos fallidos de `app_ventas` y `usuario_inexistente` desde `127.0.0.1` a las `07:09:02` y `07:09:10 UTC`. |
| **5. ¿Qué valor tenía el RFC antes del cambio?** | Act. 3: **No hay evidencia**. Act. 12: `'GAMA780912XYZ'` (`id_evento = 1`). Act. 14: sin registro en tabla de auditoría por desactivación del disparador. |