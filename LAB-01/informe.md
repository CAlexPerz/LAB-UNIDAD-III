# Informe

## 1. Despliegue y situación inicial

El servidor se desplegó mediante el contenedor Docker `LABORATORIO` basado en la imagen `postgres:16`, conectado a Visual Studio Code a través de la red puente (`172.17.0.1`) y administrado localmente con `psql` (`127.0.0.1`). Por defecto, el motor mantenía `logging_collector = off`, `log_connections = off`, `log_statement = 'none'` y reglas `trust` en `pg_hba.conf`, por lo que las conexiones y modificaciones exitosas no dejaban evidencia alguna para responder a Dirección.

## 2. Configuración aplicada

### Tabla de verificación final (Sección 26)

| Parámetro | Valor configurado | Valor esperado | Origen (`source`) | ¿Requirió recarga o reinicio? | Justificación |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `logging_collector` | `on` | `on` | `configuration file` | Reinicio (`docker restart`) | Captura `stderr` en archivos propios dentro de `/var/lib/postgresql/data/log/`. |
| `log_connections` | `on` | `on` | `configuration file` | Recarga (`pg_reload_conf()`) | Registra cada intento de conexión exitosa o fallida. |
| `log_disconnections` | `on` | `on` | `configuration file` | Recarga (`pg_reload_conf()`) | Registra el cierre de sesión y su duración total. |
| `log_statement` | `mod` | `mod` | `configuration file` | Recarga (`pg_reload_conf()`) | Registra sentencias DDL, permisos y modificaciones de datos (`INSERT`, `UPDATE`, `DELETE`). |
| `log_line_prefix` | `%m [%p] user=%u db=%d app=%a client=%h ` | `%m [%p] user=%u db=%d app=%a client=%h ` | `configuration file` | Recarga (`pg_reload_conf()`) | Identifica marca temporal, PID, usuario, base de datos, aplicación e IP en cada línea. |

 

## 3. Eventos observados

### Resumen de los 6 tipos de eventos auditables

| Tipo de evento | Ejemplo observado en bitácora | Interpretación |
| :--- | :--- | :--- |
| **Acceso** (exitoso y fallido) | `2026-11-19 07:09:02.806 UTC [48] user=app_ventas ... FATAL: password authentication failed` (línea 19) | Rechazo de conexión por contraseña inválida tras cambiar `pg_hba.conf` a `scram-sha-256`. |
| **Privilegio** (`GRANT` / `REVOKE`) | `2026-11-19 07:14:34.383 UTC [34] user=postgres ... statement: REVOKE UPDATE ON clientes FROM soporte_ana;` (línea 40) | Auditoría de administración de permisos ejecutada por el administrador. |
| **Estructura** (`ALTER TABLE`) | `2026-11-19 07:14:34.387 UTC [34] user=postgres ... statement: ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20);` (línea 42) | Registro de cambios sobre el esquema de la tabla `clientes`. |
| **Datos** (`UPDATE`) | `2026-11-19 09:04:38.310 UTC [461] user=app_ventas ... statement: UPDATE clientes SET rfc = 'GAMA780912ZZZ' WHERE id = 3` (línea 165) | Trazabilidad de qué rol, aplicación e IP modificaron un registro. |
| **Error** (operación rechazada) | `2026-11-19 08:24:09.389 UTC [312] user=soporte_ana ... ERROR: permission denied for table clientes` (línea 75) | Detección de intentos de borrado no autorizados bloqueados por el control de acceso. |
| **Configuración** (`parameter ... changed to ...`) | `2026-11-19 08:07:04.687 UTC [1] ... LOG: parameter "log_statement" changed to "mod"` (línea 63) | Evidencia emitida por el proceso maestro (`PID 1`) al recargar parámetros del servidor. |

 

## 4. Auditoría del dato

Se creó el esquema privado `auditoria` (sin permisos para `PUBLIC`) y la tabla `auditoria.cambios_clientes` alimentada por el disparador `trg_auditoria_clientes` (`AFTER INSERT OR UPDATE OR DELETE FOR EACH ROW`). La función `auditoria.registrar_cambio_cliente()` utiliza `SECURITY DEFINER` con `SET search_path = pg_catalog, public` para permitir que `app_ventas` registre cambios sin tener acceso directo al esquema `auditoria`, y emplea `session_user` (en lugar de `current_user`) para conservar el usuario real (`app_ventas`) frente al propietario de la función (`postgres`). En el incidente auditado (Actividad 12), se demostró el cambio de `rfc` de `'GAMA780912XYZ'` a `'GAMA780912ZZZ'` en `id_evento = 1`.

 

## 5. Limitaciones

- **Lecturas (`SELECT`):** Con `log_statement = 'mod'` y disparadores DML no se registran consultas de lectura; para auditar columnas sensibles sin saturar el sistema se requiere `pgaudit` en modo objeto (Parte C).
- **Volumen:** Un `UPDATE` masivo sin `WHERE` genera una sola línea en la bitácora del servidor pero una fila por cada registro afectado en `auditoria.cambios_clientes`.
- **Administrador con control total:** Un superusuario (`postgres`) puede desactivar disparadores (`DISABLE TRIGGER`) o alterar parámetros de bitácora; aunque queda rastro en el log local, también podría borrar los archivos del contenedor si no se exportan externamente.

 

## 6. Riesgos de la bitácora y conservación (Actividad 16)

### Documentación de exportación y control de integridad

- **Archivo exportado:** `evidencias/bitacora-lab01.log` (exportado desde el contenedor `LABORATORIO` mediante `pg_read_file(pg_current_logfile())` sustituyendo la contraseña `Temporal_Practica_2026` por `<REDACTED>`).
- **Resumen criptográfico (`evidencias/bitacora-lab01.sha256`):** Calculado con `Get-FileHash evidencias/bitacora-lab01.log -Algorithm SHA256` en PowerShell.

### Preguntas de la Actividad 16 (Exportar y conservar la bitácora)

1. **Un resumen SHA-256 ¿impide que alguien modifique la bitácora? ¿Qué permite demostrar?**
    No impide su modificación, pero permite demostrar de forma matemática si el archivo fue alterado o se mantiene íntegro respecto al momento en que se generó el hash.

2. **¿Dónde debería guardarse el hash para que sea útil como control de integridad?**
    En un repositorio externo de solo lectura o sistema independiente al servidor de base de datos, administrado por un área distinta al DBA operativo.

3. **La guía NIST SP 800-92 trata la conservación y protección de bitácoras (REF-U3-03). ¿Qué riesgos tiene conservar la bitácora solo en el servidor que la produce?**
    Pérdida total de evidencia ante fallos de disco, eliminación del contenedor, rotación automática de archivos o manipulación intencional por parte de un administrador comprometido.

4. **Propón durante cuánto tiempo conservarías esta bitácora y justifica tu criterio. No existe una cifra única correcta.**
    Al menos **12 meses** en almacenamiento activo y **5 años** en archivo histórico respaldado, cubriendo ciclos completos de auditoría fiscal y contable aplicables a datos de facturación y RFC.

 

## 7. Cronología y conclusión

1. **¿Con esta configuración puede demostrarse quién cambió un dato sensible y qué valor tenía antes?**
    Sí. La combinación de la bitácora del servidor (`log_statement = 'mod'`, `log_connections = on` y prefijo completo) junto con el disparador de auditoría en `auditoria.cambios_clientes` permite demostrar qué usuario, aplicación e IP realizaron el cambio, cuándo ocurrió y qué valor exacto tenía el dato antes y después, además de detectar si el disparador fue desactivado.

 

## 8. Preguntas de reflexión

1. **¿Por qué la auditoría no puede configurarse después de un incidente para investigarlo?**
    Porque los registros de auditoría capturan eventos en tiempo real conforme ocurren; lo que no se registró en su momento no puede reconstruirse retroactivamente.

2. **¿Por qué conviene que la bitácora la administre el propio servidor y no el mecanismo de despliegue?**
    Porque garantiza una ruta, formato y acceso consistentes mediante funciones SQL (`pg_current_logfile()`, `pg_read_file()`) sin depender de la plataforma, el sistema operativo o la salida del contenedor.

3. **¿Por qué el prefijo de línea es tan importante como el nivel de `log_statement`?**
    Porque sin marcadores como `%u`, `%d`, `%a` y `%h` en `log_line_prefix`, la bitácora mostraría qué sentencia se ejecutó pero no quién la lanzó ni desde qué cliente.

4. **¿Qué diferencia práctica hay entre registrar la sentencia y registrar el cambio en el dato?**
    Registrar la sentencia muestra la instrucción SQL ejecutada, mientras que registrar el cambio en el dato conserva el estado exacto anterior y posterior de cada fila afectada (permitiendo restaurar valores).

5. **¿Qué evidencia ofrece `pg_stat_activity` que no ofrece la bitácora, y viceversa?**
    `pg_stat_activity` ofrece una fotografía en tiempo real de las sesiones activas y consultas en curso; la bitácora conserva el historial cronológico persistente de conexiones, errores y sentencias ya finalizadas.

6. **Si el administrador puede cambiar `log_statement` a `none` y desactivar el disparador, ¿quién audita al administrador?**
    Un sistema externo de recolección centralizada de bitácoras (SIEM/Syslog remoto) custodiado por un equipo de seguridad o auditoría independiente bajo separación de funciones.