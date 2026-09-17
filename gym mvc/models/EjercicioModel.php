<?php
require_once __DIR__ . '/../Conexion.php';

class EjercicioModel
{
    private PDO $conexion;
    
    public function __construct()
    {
        $this->conexion = Conexion::getConexion();
    }

    public function obtenerTodos(): array
    {
        return $this->conexion->query(
            'SELECT id, nombre, descripcion, grupo_muscular, imagen_url, video_url, categoria_id
             FROM ejercicio ORDER BY id'
        )->fetchAll();
    }

    public function buscarPorId(int $id): ?array
    {
        $stmt = $this->conexion->prepare(
            'SELECT id, nombre, descripcion, grupo_muscular, imagen_url, video_url, categoria_id
             FROM ejercicio WHERE id = :id'
        );
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public function registrar(array $d): void
    {
        $stmt = $this->conexion->prepare(
            'INSERT INTO ejercicio (nombre, descripcion, grupo_muscular, imagen_url, video_url, categoria_id)
             VALUES (:nombre, :descripcion, :grupo_muscular, :imagen_url, :video_url, :categoria_id)'
        );
        $stmt->execute([
            'nombre' => $d['nombre'],
            'descripcion' => $d['descripcion'] ?? null,
            'grupo_muscular' => $d['grupo_muscular'] ?? null,
            'imagen_url' => $d['imagen_url'] ?? null,
            'video_url' => $d['video_url'] ?? null,
            'categoria_id' => (int)$d['categoria_id'],
        ]);
    }

    public function actualizar(int $id, array $d): void
    {
        $stmt = $this->conexion->prepare(
            'UPDATE ejercicio SET nombre=:nombre, descripcion=:descripcion, grupo_muscular=:grupo_muscular,
             imagen_url=:imagen_url, video_url=:video_url, categoria_id=:categoria_id WHERE id=:id'
        );
        $stmt->execute([
            'nombre' => $d['nombre'],
            'descripcion' => $d['descripcion'] ?? null,
            'grupo_muscular' => $d['grupo_muscular'] ?? null,
            'imagen_url' => $d['imagen_url'] ?? null,
            'video_url' => $d['video_url'] ?? null,
            'categoria_id' => (int)$d['categoria_id'],
            'id' => $id,
        ]);
    }

    public function eliminar(int $id): void
    {
        $stmt = $this->conexion->prepare('DELETE FROM ejercicio WHERE id = :id');
        $stmt->execute(['id' => $id]);
    }
}
