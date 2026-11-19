# Actividad 15 — Límites: lecturas y volumen

### Evidencias de querys
![](../recursos/act15_01.png)
![](../recursos/act15_02.png)

##  Preguntas de análisis

1. **Si `clientes` tuviera un millón de registros, ¿qué ocurriría con la auditoría tras un `UPDATE` sin `WHERE`?**
    La bitácora registraría solo 1 línea, pero el disparador `FOR EACH ROW` generaría **un millón de filas** en `auditoria.cambios_clientes`, disparando el uso de almacenamiento, I/O y el tiempo de bloqueo.

2. **Propón quién podría autorizar la depuración de `auditoria.cambios_clientes`.**
    Un comité o responsable de auditoría interna / gobierno de datos independiente del DBA operativo, conforme a una política formal de retención y respaldo histórico.

3. **¿Por qué `log_statement = 'all'` puede convertir la bitácora en un nuevo depósito de datos sensibles?**
    Porque registraría todas las consultas `SELECT` junto con literales en sus cláusulas `WHERE` (RFC, correos, teléfonos o credenciales), exponiendo datos personales en archivos de texto.