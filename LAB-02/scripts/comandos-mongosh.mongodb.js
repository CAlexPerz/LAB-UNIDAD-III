// ACTIVIDAD 1: Lo que no existe en esta edición
db.version();
db.adminCommand({ buildInfo: 1 }).modules;
db.serverCmdLineOpts().parsed;

// ACTIVIDAD 2: El incidente sin perfilado
// Verificar estado del perfilador

use("comercial");
db.getProfilingStatus();

// Buscar evidencia del cambio

db.system.profile.countDocuments();
bitacora().filter(e => JSON.stringify(e).includes("GAMA780912XXX")).length;
bitacora().filter(e => JSON.stringify(e).includes("app-ventas-web")).map(e => ({ t: e.t, c: e.c, ctx: e.ctx, msg: e.msg }));


 
// ACTIVIDAD 3: Activar el perfilador y registrar operaciones
 
// Activar perfilador en nivel 2 en la base comercial
db.setProfilingLevel(2);
db.getProfilingStatus();

//Consultar el perfilador:
db.system.profile.find(
  { ns: "comercial.clientes" },
  { op: 1, ns: 1, command: 1, user: 1, client: 1, appName: 1, ts: 1, millis: 1, nreturned: 1, docsExamined: 1, nModified: 1, ndeleted: 1 }
).sort({ ts: 1 });
 
// ACTIVIDAD 4: Reducir el volumen con un filtro

db.setProfilingLevel(0);
db.system.profile.drop();
db.setProfilingLevel(1, { filter: { op: { $in: ["insert", "update", "remove"] } } });
db.getProfilingStatus();

// Verificar qué quedó registrado en system.profile
db.system.profile.find({}, { op: 1, ns: 1, user: 1, appName: 1, "command.q": 1, "command.u": 1, ts: 1 });


 
// ACTIVIDAD 5: Accesos en la bitácora de mongod

// Filtrar eventos de acceso fallido en la bitácora

bitacora()
  .filter(e => e.c === "ACCESS" && e.msg === "Failed to authenticate")
  .map(e => ({
    t: e.t,
    id: e.id,
    ctx: e.ctx,
    user: e.attr.user,
    client: e.attr.client,
    error: e.attr.error,
    result: e.attr.result,
    app: e.attr.doc.application.name
  }));

// Filtrar último acceso exitoso de app_ventas

bitacora()
  .filter(e => e.msg === "Successfully authenticated" && e.attr.user === "app_ventas")
  .slice(-1)
  .map(e => ({
    t: e.t,
    id: e.id,
    ctx: e.ctx,
    client: e.attr.client,
    result: e.attr.result,
    app: e.attr.doc.application.name
  }));


 
// ACTIVIDAD 6: Correlacionar un cambio de configuración con su autor (Sesión del DBA)
 
// Buscar eventos de cambio de configuración del perfilador

bitacora()
  .filter(e => e.msg === "Profiler settings changed")
  .map(e => ({ t: e.t, ctx: e.ctx, msg: e.msg, attr: e.attr }));

// Busca la autenticación de esa misma conexión (sustituye conn31 por el tuyo):
bitacora()
  .filter(e => e.ctx === "conn260" && e.msg === "Successfully authenticated")
  .map(e => ({ t: e.t, ctx: e.ctx, user: e.attr.user, db: e.attr.db, client: e.attr.client }));


 
// ACTIVIDAD 7: Cambios de privilegios: el límite más importante (Sesión del DBA)

// Activa el nivel 2 y otorga un rol adicional a la aplicación:
db.setProfilingLevel(2);
db.grantRolesToUser("app_ventas", [{ role: "dbAdmin", db: "comercial" }]);

// Busca evidencia del cambio:
db.system.profile.countDocuments({ "command.grantRolesToUser": { $exists: true } });

bitacora().filter(e => JSON.stringify(e).includes("grantRoles")).length;

// Toma una segunda instantánea
db.getSiblingDB("auditoria").instantaneas_privilegios.find({}, { _id: 0 }).sort({ momento: 1 });

// Revoca el rol y restablece el filtro de la Actividad 4:
db.revokeRolesFromUser("app_ventas", [{ role: "dbAdmin", db: "comercial" }]);
db.setProfilingLevel(1, { filter: { op: { $in: ["insert", "update", "remove"] } } });

 
// ACTIVIDAD 8: Conservación: exportar antes de perder

// Reinicia el servicio con el comando de tu despliegue (Anexo A, tabla A.1). En una nueva sesión del DBA:

db.getProfilingStatus();
db.system.profile.countDocuments();
bitacora().length;
