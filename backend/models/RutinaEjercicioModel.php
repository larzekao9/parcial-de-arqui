<?php
require_once __DIR__ . '/../Conexion.php';

class RutinaEjercicioModel
{
    private PDO $conexion;

    public function __construct()
    {
        $this->conexion = Conexion::getConexion();
    }

    public function obtenerPorRutina(int $rutinaId): array
    {
        $stmt = $this->conexion->prepare(
            'SELECT re.rutina_id, re.ejercicio_id, e.nombre AS ejercicio_nombre,
                    re.series, re.repeticiones, re.peso_sugerido, re.orden, re.notas
             FROM rutina_ejercicio re
             JOIN ejercicio e ON e.id = re.ejercicio_id
             WHERE re.rutina_id = :rid
             ORDER BY re.orden'
        );
        $stmt->execute(['rid' => $rutinaId]);
        return $stmt->fetchAll();
    }

    public function agregar(array $d): void
    {
        $stmt = $this->conexion->prepare(
            'INSERT INTO rutina_ejercicio (rutina_id, ejercicio_id, series, repeticiones, peso_sugerido, orden, notas)
             VALUES (:rutina_id, :ejercicio_id, :series, :repeticiones, :peso_sugerido, :orden, :notas)
             ON CONFLICT (rutina_id, ejercicio_id) DO UPDATE SET
               series = EXCLUDED.series, repeticiones = EXCLUDED.repeticiones,
               peso_sugerido = EXCLUDED.peso_sugerido, orden = EXCLUDED.orden, notas = EXCLUDED.notas'
        );
        $stmt->execute([
            'rutina_id' => (int)$d['rutina_id'],
            'ejercicio_id' => (int)$d['ejercicio_id'],
            'series' => (int)$d['series'],
            'repeticiones' => $d['repeticiones'],
            'peso_sugerido' => $d['peso_sugerido'] !== '' ? $d['peso_sugerido'] : null,
            'orden' => (int)($d['orden'] ?: 1),
            'notas' => $d['notas'] !== '' ? $d['notas'] : null,
        ]);
    }

    public function eliminar(int $rutinaId, int $ejercicioId): void
    {
        $stmt = $this->conexion->prepare('DELETE FROM rutina_ejercicio WHERE rutina_id = :rid AND ejercicio_id = :eid');
        $stmt->execute(['rid' => $rutinaId, 'eid' => $ejercicioId]);
    }
}
