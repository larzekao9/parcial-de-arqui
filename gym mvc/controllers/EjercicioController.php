<?php
class EjercicioController
{
    private EjercicioModel $model;
    private EjercicioView $view;
    private CategoriaModel $categoriaModel;

    public function __construct(EjercicioModel $model, EjercicioView $view, CategoriaModel $categoriaModel)
    {
        $this->model = $model;
        $this->view = $view;
        $this->categoriaModel = $categoriaModel;
    }

    public function obtenerTodos(): void
    {
        $ejercicios = $this->model->obtenerTodos();
        $categorias = $this->categoriaModel->obtenerTodos();
        $this->view->render($ejercicios, ['editando' => null, 'categorias' => $categorias]);
    }

    public function obtenerPorId(int $id): void
    {
        $ejercicios = $this->model->obtenerTodos();
        $categorias = $this->categoriaModel->obtenerTodos();
        $editando = $this->model->buscarPorId($id);
        $this->view->render($ejercicios, ['editando' => $editando, 'categorias' => $categorias]);
    }

    public function crear(array $datos): void
    {
        try {
            $datos['imagen_url'] = $this->subirArchivo('imagen', $datos['imagen_actual'] ?? '', !empty($datos['quitar_imagen']));
            $datos['video_url'] = $this->subirArchivo('video', $datos['video_actual'] ?? '', !empty($datos['quitar_video']));
        } catch (RuntimeException $e) {
            $this->renderConError($e->getMessage(), $datos);
            return;
        }
        $this->model->registrar($datos);
        $ejercicios = $this->model->obtenerTodos();
        $categorias = $this->categoriaModel->obtenerTodos();
        $this->view->render($ejercicios, ['editando' => null, 'categorias' => $categorias]);
    }

    public function actualizar(int $id, array $datos): void
    {
        $imagenAnterior = $datos['imagen_actual'] ?? '';
        $videoAnterior = $datos['video_actual'] ?? '';
        try {
            $datos['imagen_url'] = $this->subirArchivo('imagen', $imagenAnterior, !empty($datos['quitar_imagen']));
            $datos['video_url'] = $this->subirArchivo('video', $videoAnterior, !empty($datos['quitar_video']));
        } catch (RuntimeException $e) {
            $datos['id'] = $id;
            $this->renderConError($e->getMessage(), $datos);
            return;
        }
        $this->model->actualizar($id, $datos);
        $this->borrarSiCambio($imagenAnterior, $datos['imagen_url']);
        $this->borrarSiCambio($videoAnterior, $datos['video_url']);
        $ejercicios = $this->model->obtenerTodos();
        $categorias = $this->categoriaModel->obtenerTodos();
        $this->view->render($ejercicios, ['editando' => null, 'categorias' => $categorias]);
    }

    private function renderConError(string $mensaje, array $datos): void
    {
        $ejercicios = $this->model->obtenerTodos();
        $categorias = $this->categoriaModel->obtenerTodos();
        $this->view->render($ejercicios, ['editando' => $datos, 'categorias' => $categorias, 'error' => $mensaje]);
    }

    private function borrarSiCambio(string $anterior, string $nuevo): void
    {
        if ($anterior === '' || $anterior === $nuevo || strpos($anterior, '/uploads/') !== 0) {
            return;
        }
        $ruta = __DIR__ . '/../uploads/' . basename($anterior);
        if (is_file($ruta)) {
            unlink($ruta);
        }
    }

    public function eliminar(int $id): void
    {
        $this->model->eliminar($id);
        $ejercicios = $this->model->obtenerTodos();
        $categorias = $this->categoriaModel->obtenerTodos();
        $this->view->render($ejercicios, ['editando' => null, 'categorias' => $categorias]);
    }

    private function subirArchivo(string $campo, string $actual, bool $quitar = false): string
    {
        if (
            empty($_FILES[$campo]) ||
            $_FILES[$campo]['error'] === UPLOAD_ERR_NO_FILE ||
            $_FILES[$campo]['size'] <= 0
        ) {
            return $quitar ? '' : $actual;
        }

        if ($_FILES[$campo]['error'] !== UPLOAD_ERR_OK) {
            throw new RuntimeException(
                "El archivo de \"$campo\" no se pudo subir (código de error {$_FILES[$campo]['error']}). " .
                'Puede que supere el tamaño máximo permitido.'
            );
        }

        $dir = __DIR__ . '/../uploads';

        if (!is_dir($dir)) {
            mkdir($dir, 0777, true);
        }

        $original = preg_replace(
            '/[^A-Za-z0-9._-]/',
            '_',
            $_FILES[$campo]['name']
        );

        $nombre = time() . '_' . $original;

        move_uploaded_file(
            $_FILES[$campo]['tmp_name'],
            $dir . '/' . $nombre
        );

        return '/uploads/' . $nombre;
    }
}
