<?php
class CategoriaController
{
    private CategoriaModel $model;
    private CategoriaView $view;

    public function __construct(CategoriaModel $model, CategoriaView $view)
    {
        $this->model = $model;
        $this->view = $view;
    }

    public function obtenerTodos(): void
    {
        $categorias = $this->model->obtenerTodos();
        $this->view->render($categorias, ['editando' => null]);
    }

    public function obtenerPorId(int $id): void
    {
        $categorias = $this->model->obtenerTodos();
        $editando = $this->model->buscarPorId($id);
        $this->view->render($categorias, ['editando' => $editando]);
    }

    public function crear(array $datos): void
    {
        $this->model->registrar($datos);
        $this->obtenerTodos();
    }

    public function actualizar(int $id, array $datos): void
    {
        $this->model->actualizar($id, $datos);
        $this->obtenerTodos();
    }

    public function eliminar(int $id): void
    {
        $this->model->eliminar($id);
        $this->obtenerTodos();
    }
}
