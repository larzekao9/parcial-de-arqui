<?php
require_once __DIR__ . '/Layout.php';

class RutinaView
{
    public function render(array $rutinas, array $opciones = []): void
    {
        $editando = $opciones['editando'] ?? null;

        // ---- formulario ----
        $r = $editando ?? ['id' => null, 'nombre' => '', 'descripcion' => '', 'duracion_semanas' => ''];
        $titulo = $editando ? 'Editar rutina' : 'Nueva rutina';
        $idHidden = $editando ? '<input type="hidden" name="id" value="' . $r['id'] . '">' : '';
        $cancelar = $editando ? '<a href="/rutina" class="px-4 py-2 rounded-lg border border-slate-300 text-slate-600 hover:bg-slate-100">Cancelar</a>' : '';

        $formulario = '
      <div class="mb-6">
        <h1 class="text-xl font-bold text-slate-800 mb-4">' . $titulo . '</h1>
        <form method="POST" action="/rutina" class="bg-white p-6 rounded-2xl shadow-sm border border-slate-200 max-w-md space-y-4">
          ' . $idHidden . '
          <div>
            <label class="block text-sm text-slate-600 mb-1">Nombre</label>
            <input name="nombre" value="' . esc($r['nombre']) . '" class="w-full border border-slate-300 rounded-lg px-3 py-2 outline-none focus:ring-2 focus:ring-indigo-500" required>
          </div>
          <div>
            <label class="block text-sm text-slate-600 mb-1">Descripción</label>
            <textarea name="descripcion" rows="2" class="w-full border border-slate-300 rounded-lg px-3 py-2 outline-none focus:ring-2 focus:ring-indigo-500">' . esc($r['descripcion']) . '</textarea>
          </div>
          <div>
            <label class="block text-sm text-slate-600 mb-1">Duración (semanas)</label>
            <input name="duracion_semanas" type="number" min="1" value="' . esc($r['duracion_semanas']) . '" class="w-full border border-slate-300 rounded-lg px-3 py-2 outline-none focus:ring-2 focus:ring-indigo-500" required>
          </div>
          <div class="flex gap-2 pt-2">
            <button class="bg-indigo-600 text-white px-4 py-2 rounded-lg hover:bg-indigo-500">Guardar</button>
            ' . $cancelar . '
          </div>
        </form>
      </div>';

        // ---- tabla ----
        $filas = '';
        foreach ($rutinas as $rt) {
            $filas .= '
      <tr class="hover:bg-slate-50">
        <td class="px-6 py-3 text-slate-400">#' . $rt['id'] . '</td>
        <td class="px-6 py-3 font-medium text-slate-800">' . esc($rt['nombre']) . '</td>
        <td class="px-6 py-3 text-slate-600">' . esc($rt['descripcion'] ?: '—') . '</td>
        <td class="px-6 py-3 text-slate-600">' . $rt['duracion_semanas'] . '</td>
        <td class="px-6 py-3 text-right space-x-3 whitespace-nowrap">
          <a href="/rutina?editar=' . $rt['id'] . '" class="text-indigo-600 hover:underline">Editar</a>
          <form method="POST" action="/rutina?eliminar=' . $rt['id'] . '" class="inline" onsubmit="return confirm(\'¿Eliminar esta rutina?\')">
            <button class="text-rose-600 hover:underline">Eliminar</button>
          </form>
        </td>
      </tr>';
        }
        if ($filas === '') {
            $filas = '<tr><td colspan="5" class="px-6 py-8 text-center text-slate-400">Sin rutinas</td></tr>';
        }

        $tabla = '
      <div class="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-x-auto">
        <table class="w-full text-sm">
          <thead class="bg-slate-50 text-slate-500 text-left">
            <tr>
              <th class="px-6 py-3 font-medium w-16">ID</th>
              <th class="px-6 py-3 font-medium">Nombre</th>
              <th class="px-6 py-3 font-medium">Descripción</th>
              <th class="px-6 py-3 font-medium">Semanas</th>
              <th class="px-6 py-3 font-medium text-right">Acciones</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-slate-100">' . $filas . '</tbody>
        </table>
      </div>';

        echo layout('Rutinas', 'rutina', $formulario . $tabla);
    }
}
