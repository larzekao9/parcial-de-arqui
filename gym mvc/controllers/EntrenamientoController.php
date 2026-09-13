<?php
class EntrenamientoController
{
    private AsignacionModel $modeloAsignacion;
    private RutinaModel $modeloRutina;
    private RutinaEjercicioModel $modeloRutinaEj;
    private EntrenamientoView $vista;

    public function __construct(
        AsignacionModel $modeloAsignacion,
        RutinaModel $modeloRutina,
        RutinaEjercicioModel $modeloRutinaEj,
        EntrenamientoView $vista
    ) {
        $this->modeloAsignacion = $modeloAsignacion;
        $this->modeloRutina = $modeloRutina;
        $this->modeloRutinaEj = $modeloRutinaEj;
        $this->vista = $vista;
    }

    public function misEntrenamientos(int $usuarioId): void
    {
        $asignaciones = $this->modeloAsignacion->obtenerPorUsuario($usuarioId);

        $entrenamientos = [];
        foreach ($asignaciones as $asignacion) {
            $rutinaId = (int)$asignacion['rutina_id'];
            $entrenamientos[] = [
                'asignacion' => $asignacion,
                'rutina' => $this->modeloRutina->buscarPorId($rutinaId),
                'ejercicios' => $this->modeloRutinaEj->obtenerPorRutina($rutinaId),
            ];
        }

        $this->vista->render($entrenamientos);
    }
}
