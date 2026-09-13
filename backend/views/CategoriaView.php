<?php
require_once __DIR__ . '/Layout.php';

class CategoriaView
{
    public function render(array $categorias, array $opciones = []): void
    {
        $editando = $opciones['editando'] ?? null;

        // ---- formulario ----
        $c = $editando ?? ['id' => null, 'nombre' => ''];
        $titulo = $editando ? 'Editar categoría' : 'Nueva categoría';
        $idHidden = $editando ? '<input type="hidden" name="id" value="' . $c['id'] . '">' : '';
        $cancelar = $editando ? '<a href="/categoria" class="px-4 py-2 rounded-lg border border-slate-300 text-slate-600 hover:bg-slate-100">Cancelar</a>' : '';

        $formulario = '
      <div class="mb-6">
        <h1 class="text-xl font-bold text-slate-800 mb-4">' . $titulo . '</h1>
        <form method="POST" action="/categoria" class="bg-white p-6 rounded-2xl shadow-sm border border-slate-200 max-w-md space-y-4">
          ' . $idHidden . '
          <div>
            <label class="block text-sm text-slate-600 mb-1">Nombre</label>
            <input name="nombre" value="' . esc($c['nombre']) . '" class="w-full border border-slate-300 rounded-lg px-3 py-2 outline-none focus:ring-2 focus:ring-indigo-500" required>
          </div>
          <div class="flex gap-2 pt-2">
            <button class="bg-indigo-600 text-white px-4 py-2 rounded-lg hover:bg-indigo-500">Guardar</button>
            ' . $cancelar . '
          </div>
        </form>
      </div>';

        // ---- tabla ----
        $filas = '';
        foreach ($categorias as $cat) {
            $filas .= '
      <tr class="hover:bg-slate-50">
        <td class="px-6 py-3 text-slate-400">#' . $cat['id'] . '</td>
        <td class="px-6 py-3 font-medium text-slate-800">' . esc($cat['nombre']) . '</td>
        <td class="px-6 py-3 text-right space-x-3 whitespace-nowrap">
          <a href="/categoria?editar=' . $cat['id'] . '" class="text-indigo-600 hover:underline">Editar</a>
          <form method="POST" action="/categoria?eliminar=' . $cat['id'] . '" class="inline" onsubmit="return confirm(\'¿Eliminar esta categoría?\')">
            <button class="text-rose-600 hover:underline">Eliminar</button>
          </form>
        </td>
      </tr>';
        }
        if ($filas === '') {
            $filas = '<tr><td colspan="3" class="px-6 py-8 text-center text-slate-400">Sin categorías</td></tr>';
        }

        $tabla = '
      <div class="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden">
        <table class="w-full text-sm">
          <thead class="bg-slate-50 text-slate-500 text-left">
            <tr>
              <th class="px-6 py-3 font-medium w-20">ID</th>
              <th class="px-6 py-3 font-medium">Nombre</th>
              <th class="px-6 py-3 font-medium text-right">Acciones</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-slate-100">' . $filas . '</tbody>
        </table>
      </div>';

        echo layout('Categorías', 'categoria', $formulario . $tabla);
    }
}
