# Informe

## 1. Despliegue y situación inicial

## 2. Configuración aplicada

## 3. Eventos observados

## 4. Auditoría del dato

## 5. Limitaciones

## 6. Riesgos de la bitácora y conservación

### Actividad 16

1. **Un resumen SHA-256 ¿impide que alguien modifique la bitácora? ¿Qué permite demostrar?**
   >  

2. **¿Dónde debería guardarse el hash para que sea útil como control de integridad?**
   >  

3. **La guía NIST SP 800-92 trata la conservación y protección de bitácoras (REF-U3-03). ¿Qué riesgos tiene conservar la bitácora solo en el servidor que la produce?**
   >  

4. **Propón durante cuánto tiempo conservarías esta bitácora y justifica tu criterio. No existe una cifra única correcta.**
   >  

## 7. Cronología y conclusión

1. **¿Con esta configuración puede demostrarse quién cambió un dato sensible y qué valor tenía antes?**
   >  

 

## 8. Preguntas de reflexión

1. **¿Por qué la auditoría no puede configurarse después de un incidente para investigarlo?**
   >  

2. **¿Por qué conviene que la bitácora la administre el propio servidor y no el mecanismo de despliegue?**
   >  

3. **¿Por qué el prefijo de línea es tan importante como el nivel de `log_statement`?**
   >  

4. **¿Qué diferencia práctica hay entre registrar la sentencia y registrar el cambio en el dato?**
   >  

5. **¿Qué evidencia ofrece `pg_stat_activity` que no ofrece la bitácora, y viceversa?**
   >  

6. **Si el administrador puede cambiar `log_statement` a `none` y desactivar el disparador, ¿quién audita al administrador?**
   >  