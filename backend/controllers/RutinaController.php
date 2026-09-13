<?php
class RutinaController
{
    private RutinaModel $model;
    private RutinaView $view;

    public function __construct(RutinaModel $model, RutinaView $view)
    {
        $this->model = $model;
        $this->view = $view;
    }

    public function obtenerTodos(): void
    {
        $rutinas = $this->model->obtenerTodos();
        $this->view->render($rutinas, ['editando' => null]);
    }

    public function obtenerPorId(int $id): void
    {
        $rutinas = $this->model->obtenerTodos();
        $editando = $this->model->buscarPorId($id);
        $this->view->render($rutinas, ['editando' => $editando]);
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
