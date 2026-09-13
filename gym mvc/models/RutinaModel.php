<?php
require_once __DIR__ . '/../Conexion.php';

class RutinaModel
{
    private PDO $conexion;

    public function __construct()
    {
        $this->conexion = Conexion::getConexion();
    }

    public function obtenerTodos(): array
    {
        return $this->conexion->query('SELECT id, nombre, descripcion, duracion_semanas FROM rutina ORDER BY id')->fetchAll();
    }

    public function buscarPorId(int $id): ?array
    {
        $stmt = $this->conexion->prepare('SELECT id, nombre, descripcion, duracion_semanas FROM rutina WHERE id = :id');
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public function registrar(array $d): array
    {
        $stmt = $this->conexion->prepare(
            'INSERT INTO rutina (nombre, descripcion, duracion_semanas) VALUES (:nombre, :descripcion, :duracion) RETURNING id'
        );
        $stmt->execute([
            'nombre' => $d['nombre'],
            'descripcion' => $d['descripcion'] ?? null,
            'duracion' => (int)$d['duracion_semanas'],
        ]);
        return $stmt->fetch();
    }

    public function actualizar(int $id, array $d): void
    {
        $stmt = $this->conexion->prepare(
            'UPDATE rutina SET nombre=:nombre, descripcion=:descripcion, duracion_semanas=:duracion WHERE id=:id'
        );
        $stmt->execute([
            'nombre' => $d['nombre'],
            'descripcion' => $d['descripcion'] ?? null,
            'duracion' => (int)$d['duracion_semanas'],
            'id' => $id,
        ]);
    }

    public function eliminar(int $id): void
    {
        $stmt = $this->conexion->prepare('DELETE FROM rutina WHERE id = :id');
        $stmt->execute(['id' => $id]);
    }
}
