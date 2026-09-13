<?php
class UsuarioController
{
    private UsuarioModel $model;
    private UsuarioView $view;

    public function __construct(UsuarioModel $model, UsuarioView $view)
    {
        $this->model = $model;
        $this->view = $view;
    }

    public function obtenerTodos(): void
    {
        $usuarios = $this->model->obtenerTodos();
        $this->view->render($usuarios, ['editando' => null]);
    }

    public function obtenerPorId(int $id): void
    {
        $usuarios = $this->model->obtenerTodos();
        $editando = $this->model->obtenerPorId($id);
        $this->view->render($usuarios, ['editando' => $editando]);
    }

    public function crear(array $datos): void
    {
        $this->model->crear($datos);
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
