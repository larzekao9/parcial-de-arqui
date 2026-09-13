<?php
// =====================================================
// CONTROLADOR - Asignacion
// Caso de uso: Asignar Rutina a Usuario.
// Tiene instancia de MUsuario, MRutina, MAsignacion y VAsignacion.
// =====================================================
class AsignacionController
{
    private UsuarioModel $modeloUsuario;
    private RutinaModel $modeloRutina;
    private AsignacionModel $modeloAsignacion;
    private AsignacionView $vista;

    public function __construct(
        UsuarioModel $modeloUsuario,
        RutinaModel $modeloRutina,
        AsignacionModel $modeloAsignacion,
        AsignacionView $vista
    ) {
        $this->modeloUsuario = $modeloUsuario;
        $this->modeloRutina = $modeloRutina;
        $this->modeloAsignacion = $modeloAsignacion;
        $this->vista = $vista;
    }

    public function obtenerTodos(): void
    {
        $usuarios = $this->modeloUsuario->obtenerTodos();

        $this->vista->render(null, $usuarios, [], []);
    }

    public function obtenerPorId(int $usuarioId): void
    {
        $usuarios = $this->modeloUsuario->obtenerTodos();
        $usuario = $this->modeloUsuario->obtenerPorId($usuarioId);
        $rutinas = $this->modeloRutina->obtenerTodos();
        $asignadas = $this->modeloAsignacion->obtenerPorUsuario($usuarioId);

        $this->vista->render($usuario, $usuarios, $rutinas, $asignadas);
    }

    public function agregarAsignacion(array $datos): void
    {
        $this->modeloAsignacion->agregar($datos);

        $usuarioId = (int)$datos['usuario_id'];
        $usuarios = $this->modeloUsuario->obtenerTodos();
        $usuario = $this->modeloUsuario->obtenerPorId($usuarioId);
        $rutinas = $this->modeloRutina->obtenerTodos();
        $asignadas = $this->modeloAsignacion->obtenerPorUsuario($usuarioId);

        $this->vista->render($usuario, $usuarios, $rutinas, $asignadas);
    }

    public function eliminarAsignacion(int $usuarioId, int $rutinaId, string $fechaInicio): void
    {
        $this->modeloAsignacion->eliminar($usuarioId, $rutinaId, $fechaInicio);

        $usuarios = $this->modeloUsuario->obtenerTodos();
        $usuario = $this->modeloUsuario->obtenerPorId($usuarioId);
        $rutinas = $this->modeloRutina->obtenerTodos();
        $asignadas = $this->modeloAsignacion->obtenerPorUsuario($usuarioId);

        $this->vista->render($usuario, $usuarios, $rutinas, $asignadas);
    }
}
