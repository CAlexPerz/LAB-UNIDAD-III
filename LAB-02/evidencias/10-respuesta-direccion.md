# Actividad 10 — Responder a Dirección

1. **¿Quién cambió el RFC de María García en la Actividad 2? ¿Y en la Actividad 3?**  
   * **Actividad 2:** **No hay evidencia con esta edición.** El perfilador estaba en nivel `0` y la bitácora de MongoDB Community no registra operaciones CRUD (aunque confirma conexión de `app_ventas@comercial` a las `2026-11-24T04:35:44.976Z`).  
   * **Actividad 3:** **Sí hay evidencia.** Con el perfilador en nivel 2, `system.profile` registró que **`app_ventas@comercial`** actualizó `{ _id: 3 }` con `rfc: "GAMA780912XYZ"`.

2. **¿Cuándo y desde qué aplicación?**  
   * **Actividad 2:** **No hay evidencia con esta edición** sobre la hora exacta de escritura ni la aplicación ejecutora.  
   * **Actividad 3:** El **`2026-10-25T22:52:45.909Z`** (en la prueba local, el `2026-11-24` entre `04:40:44Z` y `04:42:44Z`) desde **`127.0.0.1`** mediante la aplicación **`app-ventas-web`**.

3. **¿Qué valor tenía antes?**  
   **No hay evidencia con esta edición.** `system.profile` solo conserva el comando enviado (`$set`), nunca el estado anterior del documento.

4. **¿Cambió alguien los privilegios de `app_ventas` recientemente?**  
   **No hay evidencia con esta edición** en los registros nativos del motor (`system.profile` ni bitácora), ya que Community no audita `grantRolesToUser`. El control compensatorio (`auditoria.instantaneas_privilegios`) detecta si los roles cambian entre dos tomas, pero sin identificar autor ni hora exacta.