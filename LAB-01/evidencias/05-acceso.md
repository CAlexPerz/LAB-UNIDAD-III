# Actividad 5 — Accesos exitosos y fallidos

### Desglose de una línea de acceso fallido (Sección 11.1)

| Campo | Valor observado | Significado |
| :--- | :--- | :--- |
| Fecha y hora | | |
| PID | | |
| Usuario | | |
| Base de datos | | |
| Aplicación | | |
| Cliente | | |
| Severidad | | |
| Mensaje | | |
| Regla aplicada | | |

## Evidencias de querys
![](../recursos/act5_01.png)

## 3. Preguntas de análisis

1. **La bitácora registra el usuario `app_ventas` en el intento fallido. ¿Eso prueba que la aplicación de ventas intentó entrar? ¿Qué prueba realmente?**
   >  

2. **¿Qué información adicional registra PostgreSQL cuando el rol no existe? ¿Por qué aparece en la bitácora y no en el mensaje que recibe el cliente?**
   >  

3. **¿Por qué `app=[unknown]` en el intento fallido, pero `app=app-ventas-web` en la desconexión?**
   >  

4. **¿Qué patrón de varias líneas te haría sospechar de un ataque de fuerza bruta? Escribe la consulta que contaría los intentos fallidos por usuario.**
   >  