<?php
require_once __DIR__ . '/../Conexion.php';

class CategoriaModel
{
    private PDO $conexion;

    public function __construct()
    {
        $this->conexion = Conexion::getConexion();
    }

    public function registrar(array $datos): array
    {
        $stmt = $this->conexion->prepare('INSERT INTO categoria_ejercicio (nombre) VALUES (:nombre) RETURNING id');
        $stmt->execute(['nombre' => $datos['nombre']]);
        return $stmt->fetch();
    }

    public function obtenerTodos(): array
    {
        return $this->conexion->query('SELECT id, nombre FROM categoria_ejercicio ORDER BY id')->fetchAll();
    }

    public function buscarPorId(int $id): ?array
    {
        $stmt = $this->conexion->prepare('SELECT id, nombre FROM categoria_ejercicio WHERE id = :id');
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public function actualizar(int $id, array $datos): void
    {
        $stmt = $this->conexion->prepare('UPDATE categoria_ejercicio SET nombre = :nombre WHERE id = :id');
        $stmt->execute(['nombre' => $datos['nombre'], 'id' => $id]);
    }

    public function eliminar(int $id): void
    {
        $stmt = $this->conexion->prepare('DELETE FROM categoria_ejercicio WHERE id = :id');
        $stmt->execute(['id' => $id]);
    }
}
