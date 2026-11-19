# Actividad 3 — El incidente sin bitácora

## Evidencias de querys
![](../recursos/01_act3.png)

## Preguntas de análisis

1. **¿Puedes demostrar quién modificó el RFC?**
   No, porque no quedó registro en la bitácora de la conexión ni de la sentencia `UPDATE` ejecutada. 

2. **¿Puedes demostrar que el cambio no lo hizo `soporte_ana`?**
   Tampoco porque la falta de evidencia en bitácora impide descartar técnicamente qué sesión realizó la modificación. 

3. **Los privilegios de la Unidad II, ¿impidieron el cambio? ¿Debían impedirlo?**
   No lo impidieron ni debían hacerlo, ya que `app_ventas` necesita el privilegio `UPDATE` sobre `clientes` para operar normalmente.

4. **¿Qué tendría que haber estado configurado antes del incidente?**
   `logging_collector = on`, `log_connections = on`, `log_line_prefix`, `log_statement = 'mod'` y un trigger.