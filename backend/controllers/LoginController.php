<?php
class LoginController
{
    private UsuarioModel $model;
    private LoginView $view;

    public function __construct(UsuarioModel $model, LoginView $view)
    {
        $this->model = $model;
        $this->view = $view;
    }

    public function mostrarFormulario(): void
    {
        $this->view->render();
    }

    public function iniciarSesion(array $datos): void
    {
        $usuario = $this->model->autenticar($datos['email'] ?? '', $datos['password'] ?? '');

        if (!$usuario) {
            $this->view->render('Email o contraseña incorrectos');
            return;
        }

        $_SESSION['usuario'] = $usuario;

        if ($usuario['rol'] === 'cliente') {
            header('Location: /mis-entrenamientos');
        } else {
            header('Location: /usuario');
        }
    }

    public function cerrarSesion(): void
    {
        $_SESSION = [];
        session_destroy();
        header('Location: /login');
    }
}
