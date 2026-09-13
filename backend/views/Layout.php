<?php
// =====================================================
// LAYOUT GENERAL - shell HTML + sidebar. Lo usan todas las vistas.
// =====================================================
function esc($v): string
{
    return htmlspecialchars((string)($v ?? ''), ENT_QUOTES, 'UTF-8');
}

function layout(string $titulo, string $activo, string $contenido): string
{
    $items = [
        ['key' => 'usuario', 'label' => 'Usuarios', 'href' => '/usuario'],
        ['key' => 'categoria', 'label' => 'Categorías', 'href' => '/categoria'],
        ['key' => 'ejercicio', 'label' => 'Ejercicios', 'href' => '/ejercicio'],
        ['key' => 'rutina', 'label' => 'Rutinas', 'href' => '/rutina'],
        ['key' => 'asignar', 'label' => 'Asignar Ejercicios', 'href' => '/asignar'],
        ['key' => 'asignar-rutina', 'label' => 'Asignar Rutina', 'href' => '/asignar-rutina'],
    ];

    $nav = '';
    foreach ($items as $i) {
        $clase = $i['key'] === $activo
            ? 'bg-indigo-600 text-white'
            : 'text-slate-300 hover:bg-slate-800 hover:text-white';
        $nav .= '<a href="' . $i['href'] . '" class="block px-3 py-2.5 rounded-lg text-sm font-medium ' . $clase . '">' . $i['label'] . '</a>';
    }

    return <<<HTML
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{$titulo}</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-100">
  <div class="flex min-h-screen">
    <aside class="w-64 bg-slate-900 shrink-0">
      <div class="px-5 py-6 border-b border-slate-800">
        <div class="text-white font-bold text-lg">Gym MVC</div>
        <p class="text-slate-400 text-xs mt-1">Panel de gestión</p>
      </div>
      <nav class="p-3 space-y-1">{$nav}</nav>
    </aside>
    <main class="flex-1 p-8">{$contenido}</main>
  </div>
</body>
</html>
HTML;
}
