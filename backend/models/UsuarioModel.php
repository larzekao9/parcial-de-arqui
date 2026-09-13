<?php
require_once __DIR__ . '/../Conexion.php';

class UsuarioModel
{
    private PDO $conexion;

    public function __construct()
    {
        $this->conexion = Conexion::getConexion();
    }

    public function crear(array $datos): array
    {
        $stmt = $this->conexion->prepare(
            "INSERT INTO usuario (nombre, apellido, email, password, rol)
             VALUES (:nombre, :apellido, :email, :password, :rol) RETURNING id"
        );
        $stmt->execute([
            'nombre' => $datos['nombre'],
            'apellido' => $datos['apellido'],
            'email' => $datos['email'],
            'password' => password_hash($datos['password'], PASSWORD_BCRYPT),
            'rol' => $datos['rol'],
        ]);
        return $stmt->fetch();
    }

    public function autenticar(string $email, string $password): ?array
    {
        $stmt = $this->conexion->prepare('SELECT id, nombre, apellido, email, password, rol FROM usuario WHERE email = :email');
        $stmt->execute(['email' => $email]);
        $usuario = $stmt->fetch();

        if (!$usuario || !password_verify($password, $usuario['password'])) {
            return null;
        }

        unset($usuario['password']);
        return $usuario;
    }

    public function obtenerTodos(): array
    {
        $stmt = $this->conexion->query('SELECT id, nombre, apellido, email, rol FROM usuario ORDER BY id');
        return $stmt->fetchAll();
    }

    public function obtenerPorId(int $id): ?array
    {
        $stmt = $this->conexion->prepare('SELECT id, nombre, apellido, email, rol FROM usuario WHERE id = :id');
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public function actualizar(int $id, array $datos): void
    {
        if (!empty($datos['password'])) {
            $stmt = $this->conexion->prepare(
                'UPDATE usuario SET nombre=:nombre, apellido=:apellido, email=:email, password=:password, rol=:rol WHERE id=:id'
            );
            $stmt->execute([
                'nombre' => $datos['nombre'], 'apellido' => $datos['apellido'],
                'email' => $datos['email'], 'password' => password_hash($datos['password'], PASSWORD_BCRYPT),
                'rol' => $datos['rol'], 'id' => $id,
            ]);
            return;
        }

        $stmt = $this->conexion->prepare(
            'UPDATE usuario SET nombre=:nombre, apellido=:apellido, email=:email, rol=:rol WHERE id=:id'
        );
        $stmt->execute([
            'nombre' => $datos['nombre'], 'apellido' => $datos['apellido'],
            'email' => $datos['email'], 'rol' => $datos['rol'], 'id' => $id,
        ]);
    }

    public function eliminar(int $id): void
    {
        $stmt = $this->conexion->prepare('DELETE FROM usuario WHERE id = :id');
        $stmt->execute(['id' => $id]);
    }
}
