# BaseDatosGym — App MVC (Node.js, sin dependencias)

CRUD de **Usuarios, Categorías, Ejercicios y Rutinas** con arquitectura **MVC**.
Todo con Node puro (módulo `http`), la **Vista genera el HTML** (Tailwind por CDN) y hay
un **layout general** con sidebar. Los datos se guardan en memoria.

## Patrón (por cada recurso)
- **Model** (`*Model.js`): guarda/procesa los datos (repositorio en memoria).
- **View** (`*View.js`): genera el HTML usando el layout general.
- **Controller** (`*Controller.js`): recibe `model` y `view` por constructor y maneja
  la ruta con `manejarRuta(req, res)` (listar / crear / editar / eliminar).
- **`app.js`**: crea el servidor HTTP, inyecta modelo y vista a cada controlador y
  deriva la petición según la ruta.
- **`layout.js`**: shell HTML + sidebar (Usuarios, Categorías, Ejercicios, Rutinas).

## Atributos (tomados de la BD)
- **usuario**: nombre, apellido, email, password, rol
- **categoria_ejercicio**: nombre
- **ejercicio**: nombre, descripcion, grupo_muscular, imagen_url, video_url, categoria_id
- **rutina**: nombre, descripcion, duracion_semanas

> El esquema original está en `db/init.sql` (referencia; la app corre en memoria).

## Estructura
```
backend/
  app.js
  layout.js
  usuarioModel.js    usuarioView.js    usuarioController.js
  categoriaModel.js  categoriaView.js  categoriaController.js
  ejercicioModel.js  ejercicioView.js  ejercicioController.js
  rutinaModel.js     rutinaView.js     rutinaController.js
  package.json
db/init.sql
```

## Cómo correrlo
Requisito: **Node.js**. Sin `npm install` (no usa dependencias).

```bash
cd backend
node app.js
```

Abrir **http://localhost:3000** (entra a Usuarios).

## Rutas (por recurso: usuario / categoria / ejercicio / rutina)
| Acción | Ruta |
|---|---|
| Listar | `GET /usuario` |
| Form nuevo | `GET /usuario/crear` |
| Crear | `POST /usuario/crear` |
| Form editar | `GET /usuario/editar/:id` |
| Actualizar | `POST /usuario/editar/:id` |
| Eliminar | `POST /usuario/eliminar/:id` |
