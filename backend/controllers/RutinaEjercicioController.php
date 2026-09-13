<?php
// =====================================================
// CONTROLADOR - RutinaEjercicio
// Caso de uso: Asignar Ejercicios a Rutina.
// Tiene instancia de MRutina, MEjercicio, MRutinaEjercicio y VRutinaEjercicio.
// =====================================================
class RutinaEjercicioController
{
    private RutinaModel $modeloRutina;
    private EjercicioModel $modeloEjercicio;
    private RutinaEjercicioModel $modeloRutinaEj;
    private RutinaEjercicioView $vista;

    public function __construct(
        RutinaModel $modeloRutina,
        EjercicioModel $modeloEjercicio,
        RutinaEjercicioModel $modeloRutinaEj,
        RutinaEjercicioView $vista
    ) {
        $this->modeloRutina = $modeloRutina;
        $this->modeloEjercicio = $modeloEjercicio;
        $this->modeloRutinaEj = $modeloRutinaEj;
        $this->vista = $vista;
    }

    public function obtenerTodos(): void
    {
        $rutinas = $this->modeloRutina->obtenerTodos();

        // Sin rutina elegida: se autoselecciona la primera (nunca entra vacío)
        $idFinal = $rutinas[0]['id'] ?? null;
        if (!$idFinal) {
            $this->vista->render(null, $rutinas, [], []);
            return;
        }

        $this->obtenerPorId((int)$idFinal);
    }

    public function obtenerPorId(int $rutinaId): void
    {
        $rutinas = $this->modeloRutina->obtenerTodos();
        $rutina = $this->modeloRutina->buscarPorId($rutinaId);
        $ejercicios = $this->modeloEjercicio->obtenerTodos();
        $asignados = $this->modeloRutinaEj->obtenerPorRutina($rutinaId);

        $this->vista->render($rutina, $rutinas, $ejercicios, $asignados);
    }

    public function agregarEjercicio(array $datos): void
    {
        $this->modeloRutinaEj->agregar($datos);
        $this->obtenerPorId((int)$datos['rutina_id']);
    }

    public function eliminarEjercicio(int $rutinaId, int $ejercicioId): void
    {
        $this->modeloRutinaEj->eliminar($rutinaId, $ejercicioId);
        $this->obtenerPorId($rutinaId);
    }
}
