<?php
require_once __DIR__ . '/../Conexion.php';

class AsignacionModel
{
    private PDO $conexion;

    public function __construct()
    {
        $this->conexion = Conexion::getConexion();
    }

    public function obtenerPorUsuario(int $usuarioId): array
    {
        $stmt = $this->conexion->prepare(
            'SELECT a.usuario_id, a.rutina_id, r.nombre AS rutina_nombre,
                    a.fecha_inicio, a.fecha_fin, a.semana_numero, a.estado, a.notas
             FROM asignacion a
             JOIN rutina r ON r.id = a.rutina_id
             WHERE a.usuario_id = :uid
             ORDER BY a.fecha_inicio DESC'
        );
        $stmt->execute(['uid' => $usuarioId]);
        return $stmt->fetchAll();
    }

    public function agregar(array $d): void
    {
        $stmt = $this->conexion->prepare(
            'INSERT INTO asignacion (usuario_id, rutina_id, fecha_inicio, fecha_fin, semana_numero, estado, notas)
             VALUES (:usuario_id, :rutina_id, :fecha_inicio, :fecha_fin, :semana_numero, :estado, :notas)
             ON CONFLICT (usuario_id, rutina_id, fecha_inicio) DO UPDATE SET
               fecha_fin = EXCLUDED.fecha_fin, semana_numero = EXCLUDED.semana_numero,
               estado = EXCLUDED.estado, notas = EXCLUDED.notas'
        );
        $stmt->execute([
            'usuario_id' => (int)$d['usuario_id'],
            'rutina_id' => (int)$d['rutina_id'],
            'fecha_inicio' => $d['fecha_inicio'],
            'fecha_fin' => $d['fecha_fin'] !== '' ? $d['fecha_fin'] : null,
            'semana_numero' => $d['semana_numero'] !== '' ? (int)$d['semana_numero'] : null,
            'estado' => $d['estado'],
            'notas' => $d['notas'] !== '' ? $d['notas'] : null,
        ]);
    }

    public function eliminar(int $usuarioId, int $rutinaId, string $fechaInicio): void
    {
        $stmt = $this->conexion->prepare(
            'DELETE FROM asignacion WHERE usuario_id = :uid AND rutina_id = :rid AND fecha_inicio = :fi'
        );
        $stmt->execute(['uid' => $usuarioId, 'rid' => $rutinaId, 'fi' => $fechaInicio]);
    }
}
