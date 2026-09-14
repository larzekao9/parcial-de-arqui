# BaseDatosGym — App MVC (PHP + PostgreSQL)

CRUD de **Usuarios, Categorías, Ejercicios y Rutinas** con arquitectura **MVC** en PHP puro,
login con sesiones y una vista de "Mis Entrenamientos" para clientes.

## Requisitos

- PHP 8+ con extensión `pdo_pgsql`
- PostgreSQL corriendo en local

## Cómo levantar el sistema

Un solo script crea el rol y la base de datos (si no existen), carga el esquema
y los datos de ejemplo (solo la primera vez) y levanta el servidor PHP:

```bash
./levantar.sh
```

Luego abrir **http://localhost:8000**

Variables opcionales (sobreescriben los valores por defecto): `DB_HOST`, `DB_PORT`,
`DB_NAME`, `DB_USER`, `DB_PASS`, `APP_PORT`.

## Configuración de conexión

Por defecto (`gym mvc/Conexion.php`) usa:

| Variable  | Valor por defecto |
|-----------|--------------------|
| DB_HOST   | localhost |
| DB_PORT   | 5432 |
| DB_NAME   | BaseDatosGym |
| DB_USER   | gym |
| DB_PASS   | gym123 |

Se pueden sobreescribir con variables de entorno si tu PostgreSQL usa otras credenciales.

## Estructura

```
gym mvc/
  index.php        punto de entrada
  router.php       ruteo y cableado de dependencias
  Conexion.php      conexión PDO a PostgreSQL
  controllers/
  models/
  views/
  uploads/          imágenes y videos subidos por ejercicios
db/
  init.sql          esquema + datos de ejemplo
levantar.sh         crea/puebla la base de datos y levanta el servidor PHP
```
