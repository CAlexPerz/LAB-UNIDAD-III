# Incidente auditado

## Actividad 11 — Crear la función y el disparador

## Evidencias de querys
![](../recursos/act11_01.png)

### 2. Preguntas de la Actividad 11

1. **¿Por qué se ejecuta `REVOKE ALL ON FUNCTION ... FROM PUBLIC` si el disparador seguirá funcionando para `app_ventas`?**
   >  

2. **¿Qué pasaría si la función no fuera `SECURITY DEFINER`? Formula una hipótesis antes de la Actividad 12.**
   >  

3. **Consulta `dba.bitacora`. ¿Quedó registrada la creación del esquema, la tabla, la función y el disparador? ¿Por qué?**
   >  

 

## Actividad 12 — El incidente auditado

### Evidencias de querys
![](../recursos/act12_01.png)
![](../recursos/act12_02.png)

### Preguntas de la Actividad 12

1. **Compara tu hipótesis de la Actividad 11 con este resultado.**
    Se confirma la hipótesis: gracias a `SECURITY DEFINER`, el disparador escribió la auditoría usando los privilegios de `postgres` (`usuario_efectivo`), permitiendo a `app_ventas` actualizar `clientes` sin darle permisos de lectura ni escritura sobre `auditoria.cambios_clientes`.

2. **Escribe la sentencia `UPDATE` que restauraría el valor anterior.**
    `UPDATE clientes SET rfc = 'GAMA780912XYZ' WHERE id = 3;`

3. **¿Qué columna conserva más valor para una investigación: `aplicacion` o `ip_cliente`? ¿Cuál puede falsificar el cliente con más facilidad?**
    `ip_cliente` tiene mayor valor probatorio porque la obtiene el servidor desde la conexión de red; `aplicacion` (`application_name`) la declara el propio cliente y puede falsificarse fácilmente.