<?php
// =====================================================
// router.php
// Arma cada MVC (inyecta modelo y vista), define las rutas
// y se encarga de la plomería HTTP (leer body, subir
// archivos, redirigir). El controlador sólo tiene el CRUD.
//
// Cada recurso vive en UNA sola URL (ej. /usuario): editar y
// eliminar viajan por querystring, así el path nunca cambia.
// =====================================================

require_once __DIR__ . '/Conexion.php';

require_once __DIR__ . '/models/UsuarioModel.php';
require_once __DIR__ . '/views/UsuarioView.php';
require_once __DIR__ . '/controllers/UsuarioController.php';

require_once __DIR__ . '/models/CategoriaModel.php';
require_once __DIR__ . '/views/CategoriaView.php';
require_once __DIR__ . '/controllers/CategoriaController.php';

require_once __DIR__ . '/models/EjercicioModel.php';
require_once __DIR__ . '/views/EjercicioView.php';
require_once __DIR__ . '/controllers/EjercicioController.php';

require_once __DIR__ . '/models/RutinaModel.php';
require_once __DIR__ . '/views/RutinaView.php';
require_once __DIR__ . '/controllers/RutinaController.php';

require_once __DIR__ . '/models/RutinaEjercicioModel.php';
require_once __DIR__ . '/views/RutinaEjercicioView.php';
require_once __DIR__ . '/controllers/RutinaEjercicioController.php';

require_once __DIR__ . '/models/AsignacionModel.php';
require_once __DIR__ . '/views/AsignacionView.php';
require_once __DIR__ . '/controllers/AsignacionController.php';

// ---- servir archivos estáticos subidos (imagen/video) ----
$uploadsDir = __DIR__ . '/uploads';
if (!is_dir($uploadsDir)) {
    mkdir($uploadsDir, 0777, true);
}

$pathname = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

if ($pathname === '/') {
    header('Location: /usuario');
    exit;
}

if (strpos($pathname, '/uploads/') === 0) {
    $nombre = basename($pathname); // evita path traversal
    $ruta = $uploadsDir . '/' . $nombre;
    if (!is_file($ruta)) {
        http_response_code(404);
        echo 'No encontrado';
        exit;
    }
    $tipos = [
        'jpg' => 'image/jpeg', 'jpeg' => 'image/jpeg', 'png' => 'image/png',
        'gif' => 'image/gif', 'webp' => 'image/webp',
        'mp4' => 'video/mp4', 'webm' => 'video/webm', 'mov' => 'video/quicktime', 'ogg' => 'video/ogg',
    ];
    $ext = strtolower(pathinfo($nombre, PATHINFO_EXTENSION));
    header('Content-Type: ' . ($tipos[$ext] ?? 'application/octet-stream'));
    readfile($ruta);
    exit;
}

// ---- instancias (inyección de modelo y vista) ----
$categoriaModel = new CategoriaModel();
$usuarioC = new UsuarioController(new UsuarioModel(), new UsuarioView());
$categoriaC = new CategoriaController($categoriaModel, new CategoriaView());
$ejercicioC = new EjercicioController(new EjercicioModel(), new EjercicioView(), $categoriaModel);
$rutinaC = new RutinaController(new RutinaModel(), new RutinaView());

$rutinaEjercicioC = new RutinaEjercicioController(
    new RutinaModel(), new EjercicioModel(), new RutinaEjercicioModel(), new RutinaEjercicioView()
);

$asignacionC = new AsignacionController(
    new UsuarioModel(), new RutinaModel(), new AsignacionModel(), new AsignacionView()
);

$metodo = $_SERVER['REQUEST_METHOD'];

// Un recurso, una URL: GET lista (y precarga el form si ?editar=id),
// POST crea/actualiza (según venga o no el id) o elimina (?eliminar=id)
function manejarRecurso(string $recurso, object $controller, string $pathname, string $metodo): bool
{
    if ($pathname !== '/' . $recurso) {
        return false;
    }

    if ($metodo === 'GET') {
        $idEditando = isset($_GET['editar']) ? (int)$_GET['editar'] : null;
        if ($idEditando) {
            $controller->obtenerPorId($idEditando);
        } else {
            $controller->obtenerTodos();
        }
        return true;
    }

    if ($metodo === 'POST') {
        if (isset($_GET['eliminar'])) {
            $controller->eliminar((int)$_GET['eliminar']);
            return true;
        }

        if (!empty($_POST['id'])) {
            $controller->actualizar((int)$_POST['id'], $_POST);
        } else {
            $controller->crear($_POST);
        }
        return true;
    }

    return false;
}

if (manejarRecurso('usuario', $usuarioC, $pathname, $metodo)) exit;
if (manejarRecurso('categoria', $categoriaC, $pathname, $metodo)) exit;
if (manejarRecurso('ejercicio', $ejercicioC, $pathname, $metodo)) exit;
if (manejarRecurso('rutina', $rutinaC, $pathname, $metodo)) exit;

// Asignar Ejercicios a Rutina: GET elige/muestra la rutina (?rutina=id),
// POST agrega un ejercicio o lo quita (según venga accion=eliminar)
if ($pathname === '/asignar') {
    if ($metodo === 'GET') {
        $rutinaId = isset($_GET['rutina']) ? (int)$_GET['rutina'] : null;
        if ($rutinaId) {
            $rutinaEjercicioC->obtenerPorId($rutinaId);
        } else {
            $rutinaEjercicioC->obtenerTodos();
        }
        exit;
    }
    if ($metodo === 'POST') {
        if (($_POST['accion'] ?? '') === 'eliminar') {
            $rutinaEjercicioC->eliminarEjercicio((int)$_POST['rutina_id'], (int)$_POST['ejercicio_id']);
        } else {
            $rutinaEjercicioC->agregarEjercicio($_POST);
        }
        exit;
    }
}

// Asignar Rutina a Usuario: GET elige/muestra el usuario (?usuario=id),
// POST agrega una asignación o la quita (según venga accion=eliminar)
if ($pathname === '/asignar-rutina') {
    if ($metodo === 'GET') {
        $usuarioId = isset($_GET['usuario']) ? (int)$_GET['usuario'] : null;
        if ($usuarioId) {
            $asignacionC->obtenerPorId($usuarioId);
        } else {
            $asignacionC->obtenerTodos();
        }
        exit;
    }
    if ($metodo === 'POST') {
        if (($_POST['accion'] ?? '') === 'eliminar') {
            $asignacionC->eliminarAsignacion((int)$_POST['usuario_id'], (int)$_POST['rutina_id'], $_POST['fecha_inicio']);
        } else {
            $asignacionC->agregarAsignacion($_POST);
        }
        exit;
    }
}

http_response_code(404);
echo '<h1>404 - Ruta no encontrada</h1>';
