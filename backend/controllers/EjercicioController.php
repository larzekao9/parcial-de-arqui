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
        $datos['imagen_url'] = $this->subirArchivo('imagen', $datos['imagen_actual'] ?? '');
        $datos['video_url'] = $this->subirArchivo('video', $datos['video_actual'] ?? '');
        $this->model->registrar($datos);
        $this->obtenerTodos();
    }

    public function actualizar(int $id, array $datos): void
    {
        $datos['imagen_url'] = $this->subirArchivo('imagen', $datos['imagen_actual'] ?? '');
        $datos['video_url'] = $this->subirArchivo('video', $datos['video_actual'] ?? '');
        $this->model->actualizar($id, $datos);
        $this->obtenerTodos();
    }

    public function eliminar(int $id): void
    {
        $this->model->eliminar($id);
        $this->obtenerTodos();
    }

    private function subirArchivo(string $campo, string $actual): string
    {
        if (
            empty($_FILES[$campo]) ||
            $_FILES[$campo]['error'] !== UPLOAD_ERR_OK ||
            $_FILES[$campo]['size'] <= 0
        ) {
            return $actual;
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
