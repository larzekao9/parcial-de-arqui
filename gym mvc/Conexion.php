<?php
// =====================================================
// Conexion - acceso a PostgreSQL (singleton)
// Los modelos piden la conexión con Conexion::getConexion().
// =====================================================
class Conexion
{
    private static ?PDO $instancia = null;

    public static function getConexion(): PDO
    {
        if (self::$instancia === null) {
            $host = getenv('DB_HOST') ?: 'localhost';
            $port = getenv('DB_PORT') ?: '5432';
            $dbname = getenv('DB_NAME') ?: 'BaseDatosGym';
            $user = getenv('DB_USER') ?: 'gym';
            $pass = getenv('DB_PASS') ?: 'gym123';

            $dsn = "pgsql:host=$host;port=$port;dbname=$dbname";
            self::$instancia = new PDO($dsn, $user, $pass, [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            ]);
        }
        return self::$instancia;
    }
}
