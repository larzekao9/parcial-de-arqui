<?php
require_once __DIR__ . '/Layout.php';

class UsuarioView
{
    public function render(array $usuarios, array $opciones = []): void
    {
        $editando = $opciones['editando'] ?? null;

        // ---- formulario ----
        $u = $editando ?? ['id' => null, 'nombre' => '', 'apellido' => '', 'email' => '', 'rol' => 'cliente'];
        $titulo = $editando ? 'Editar usuario' : 'Nuevo usuario';

        $roles = '';
        foreach (['admin', 'entrenador', 'cliente'] as $r) {
            $sel = $u['rol'] === $r ? 'selected' : '';
            $roles .= "<option value=\"$r\" $sel>$r</option>";
        }

        $idHidden = $editando ? '<input type="hidden" name="id" value="' . $u['id'] . '">' : '';
        $cancelar = $editando ? '<a href="/usuario" class="px-4 py-2 rounded-lg border border-slate-300 text-slate-600 hover:bg-slate-100">Cancelar</a>' : '';

        $formulario = '
      <div class="mb-6">
        <h1 class="text-xl font-bold text-slate-800 mb-4">' . $titulo . '</h1>
        <form method="POST" action="/usuario" class="bg-white p-6 rounded-2xl shadow-sm border border-slate-200 max-w-md space-y-4">
          ' . $idHidden . '
          <div class="grid grid-cols-2 gap-3">
            <div>
              <label class="block text-sm text-slate-600 mb-1">Nombre</label>
              <input name="nombre" value="' . esc($u['nombre']) . '" class="w-full border border-slate-300 rounded-lg px-3 py-2 outline-none focus:ring-2 focus:ring-indigo-500" required>
            </div>
            <div>
              <label class="block text-sm text-slate-600 mb-1">Apellido</label>
              <input name="apellido" value="' . esc($u['apellido']) . '" class="w-full border border-slate-300 rounded-lg px-3 py-2 outline-none focus:ring-2 focus:ring-indigo-500" required>
            </div>
          </div>
          <div>
            <label class="block text-sm text-slate-600 mb-1">Email</label>
            <input name="email" type="email" value="' . esc($u['email']) . '" class="w-full border border-slate-300 rounded-lg px-3 py-2 outline-none focus:ring-2 focus:ring-indigo-500" required>
          </div>
          <div>
            <label class="block text-sm text-slate-600 mb-1">Contraseña <span class="text-slate-400">(en blanco = no cambia)</span></label>
            <input name="password" type="password" class="w-full border border-slate-300 rounded-lg px-3 py-2 outline-none focus:ring-2 focus:ring-indigo-500">
          </div>
          <div>
            <label class="block text-sm text-slate-600 mb-1">Rol</label>
            <select name="rol" class="w-full border border-slate-300 rounded-lg px-3 py-2 outline-none focus:ring-2 focus:ring-indigo-500">' . $roles . '</select>
          </div>
          <div class="flex gap-2 pt-2">
            <button class="bg-indigo-600 text-white px-4 py-2 rounded-lg hover:bg-indigo-500">Guardar</button>
            ' . $cancelar . '
          </div>
        </form>
      </div>';

        // ---- tabla ----
        $filas = '';
        foreach ($usuarios as $usr) {
            $filas .= '
      <tr class="hover:bg-slate-50">
        <td class="px-6 py-3 text-slate-400">#' . $usr['id'] . '</td>
        <td class="px-6 py-3 font-medium text-slate-800">' . esc($usr['nombre']) . ' ' . esc($usr['apellido']) . '</td>
        <td class="px-6 py-3 text-slate-600">' . esc($usr['email']) . '</td>
        <td class="px-6 py-3"><span class="px-2 py-1 rounded-full text-xs font-medium bg-slate-100 text-slate-600">' . esc($usr['rol']) . '</span></td>
        <td class="px-6 py-3 text-right space-x-3 whitespace-nowrap">
          <a href="/usuario?editar=' . $usr['id'] . '" class="text-indigo-600 hover:underline">Editar</a>
          <form method="POST" action="/usuario?eliminar=' . $usr['id'] . '" class="inline" onsubmit="return confirm(\'¿Eliminar este usuario?\')">
            <button class="text-rose-600 hover:underline">Eliminar</button>
          </form>
        </td>
      </tr>';
        }
        if ($filas === '') {
            $filas = '<tr><td colspan="5" class="px-6 py-8 text-center text-slate-400">Sin usuarios</td></tr>';
        }

        $tabla = '
      <div class="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-x-auto">
        <table class="w-full text-sm">
          <thead class="bg-slate-50 text-slate-500 text-left">
            <tr>
              <th class="px-6 py-3 font-medium w-16">ID</th>
              <th class="px-6 py-3 font-medium">Nombre</th>
              <th class="px-6 py-3 font-medium">Email</th>
              <th class="px-6 py-3 font-medium">Rol</th>
              <th class="px-6 py-3 font-medium text-right">Acciones</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-slate-100">' . $filas . '</tbody>
        </table>
      </div>';

        echo layout('Usuarios', 'usuario', $formulario . $tabla);
    }
}
