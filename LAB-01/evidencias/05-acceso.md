# Actividad 5 — Accesos exitosos y fallidos

## 1. Comandos ejecutados

### Intentos de conexión por red
```bash
psql "postgresql://app_ventas:<REDACTED>@127.0.0.1/comercial" -c "SELECT 1"
psql "postgresql://usuario_inexistente:<REDACTED>@127.0.0.1/comercial" -c "SELECT 1"
psql "postgresql://app_ventas:<REDACTED>@127.0.0.1/comercial?application_name=app-ventas-web" -c "SELECT count(*) FROM clientes"
```

### Consulta de filtrado en `dba.bitacora`
```sql
SELECT linea FROM dba.bitacora WHERE linea LIKE '%client=127.0.0.1%' ORDER BY num;
```

 

## 2. Resultado obtenido

```text
  
```

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

 

## 3. Preguntas de análisis

1. **La bitácora registra el usuario `app_ventas` en el intento fallido. ¿Eso prueba que la aplicación de ventas intentó entrar? ¿Qué prueba realmente?**
   >  

2. **¿Qué información adicional registra PostgreSQL cuando el rol no existe? ¿Por qué aparece en la bitácora y no en el mensaje que recibe el cliente?**
   >  

3. **¿Por qué `app=[unknown]` en el intento fallido, pero `app=app-ventas-web` en la desconexión?**
   >  

4. **¿Qué patrón de varias líneas te haría sospechar de un ataque de fuerza bruta? Escribe la consulta que contaría los intentos fallidos por usuario.**
   >  