## 1. Despliegue y versión del servidor

El servidor se desplegó mediante **contenedor Docker** (modalidad del Anexo A de la guía) con control de acceso habilitado:

* **Motor y edición:** MongoDB **7.0.48** Community Edition (`modules: []`)
* **Imagen Docker:** `mongo:7`
* **Nombre del contenedor:** `LAB-mongo`
* **Puerto publicado:** `27017:27017`
* **Autorización:** Habilitada con `--auth` (`security.authorization: "enabled"`)

### Comandos de arranque e inicialización

```bash
# Creación y arranque del contenedor con autenticación habilitada
docker run --name LAB-mongo -p 27017:27017 -d mongo:7 --auth

# Acceso inicial por excepción de localhost (mongosh 2.14.3) para crear usuarios y datos
docker exec -it LAB-mongo mongosh
```

## 2. Entorno de cliente y ejecución

* **IDE y extensión:** Las consultas, configuración del perfilador, revisión de bitácoras e instantáneas de privilegios se ejecutaron desde **Visual Studio Code** mediante la extensión oficial **MongoDB for VS Code** usando **MongoDB Playgrounds** conectados a `127.0.0.1:27017`.
* **Cliente CLI (`mongosh`):** Utilizado para simular sesiones de la aplicación (`app_ventas` con `appName=app-ventas-web`), intentos de autenticación fallidos y exportación de evidencias.
* **Nota sobre origen de red en bitácora:** Conforme al Anexo A, las conexiones originadas desde VS Code en el equipo anfitrión hacia el puerto publicado del contenedor aparecen en `mongod` con la IP de la red interna de Docker (`172.17.0.1`), mientras que las sesiones ejecutadas dentro del contenedor registran `127.0.0.1`.