<?php
require_once __DIR__ . '/Layout.php';

class EjercicioView
{
    public function render(array $ejercicios, array $opciones = []): void
    {
        $editando = $opciones['editando'] ?? null;
        $categorias = $opciones['categorias'] ?? [];

        // ---- formulario ----
        $e = $editando ?? ['id' => null, 'nombre' => '', 'descripcion' => '', 'grupo_muscular' => '', 'imagen_url' => '', 'video_url' => '', 'categoria_id' => null];
        $titulo = $editando ? 'Editar ejercicio' : 'Nuevo ejercicio';

        $opcionesCat = '';
        foreach ($categorias as $c) {
            $sel = (string)$e['categoria_id'] === (string)$c['id'] ? 'selected' : '';
            $opcionesCat .= '<option value="' . $c['id'] . '" ' . $sel . '>' . esc($c['nombre']) . '</option>';
        }

        $idHidden = $editando ? '<input type="hidden" name="id" value="' . $e['id'] . '">' : '';
        $cancelar = $editando ? '<a href="/ejercicio" class="px-4 py-2 rounded-lg border border-slate-300 text-slate-600 hover:bg-slate-100">Cancelar</a>' : '';
        $previewImg = !empty($e['imagen_url']) ? '<img src="' . esc($e['imagen_url']) . '" class="h-16 mt-2 rounded-lg border border-slate-200">' : '';
        $previewVid = !empty($e['video_url']) ? '<video src="' . esc($e['video_url']) . '" class="h-16 mt-2 rounded-lg border border-slate-200 bg-black" muted controls></video>' : '';

        $formulario = '
      <div class="mb-6">
        <h1 class="text-xl font-bold text-slate-800 mb-4">' . $titulo . '</h1>
        <form method="POST" action="/ejercicio" enctype="multipart/form-data" class="bg-white p-6 rounded-2xl shadow-sm border border-slate-200 max-w-lg space-y-4">
          ' . $idHidden . '
          <input type="hidden" name="imagen_actual" value="' . esc($e['imagen_url']) . '">
          <input type="hidden" name="video_actual" value="' . esc($e['video_url']) . '">
          <div class="grid grid-cols-3 gap-3">
            <div class="col-span-2">
              <label class="block text-sm text-slate-600 mb-1">Nombre</label>
              <input name="nombre" value="' . esc($e['nombre']) . '" class="w-full border border-slate-300 rounded-lg px-3 py-2 outline-none focus:ring-2 focus:ring-indigo-500" required>
            </div>
            <div>
              <label class="block text-sm text-slate-600 mb-1">Categoría</label>
              <select name="categoria_id" class="w-full border border-slate-300 rounded-lg px-3 py-2 outline-none focus:ring-2 focus:ring-indigo-500">' . $opcionesCat . '</select>
            </div>
          </div>
          <div>
            <label class="block text-sm text-slate-600 mb-1">Grupo muscular</label>
            <input name="grupo_muscular" value="' . esc($e['grupo_muscular']) . '" class="w-full border border-slate-300 rounded-lg px-3 py-2 outline-none focus:ring-2 focus:ring-indigo-500">
          </div>
          <div>
            <label class="block text-sm text-slate-600 mb-1">Descripción</label>
            <textarea name="descripcion" rows="2" class="w-full border border-slate-300 rounded-lg px-3 py-2 outline-none focus:ring-2 focus:ring-indigo-500">' . esc($e['descripcion']) . '</textarea>
          </div>
          <div class="grid grid-cols-2 gap-3">
            <div>
              <label class="block text-sm text-slate-600 mb-1">Imagen</label>
              <input type="file" name="imagen" accept="image/*" class="w-full text-sm text-slate-600 file:mr-3 file:py-2 file:px-3 file:rounded-lg file:border-0 file:bg-indigo-50 file:text-indigo-600">
              ' . $previewImg . '
            </div>
            <div>
              <label class="block text-sm text-slate-600 mb-1">Video</label>
              <input type="file" name="video" accept="video/*" class="w-full text-sm text-slate-600 file:mr-3 file:py-2 file:px-3 file:rounded-lg file:border-0 file:bg-indigo-50 file:text-indigo-600">
              ' . $previewVid . '
            </div>
          </div>
          <div class="flex gap-2 pt-2">
            <button class="bg-indigo-600 text-white px-4 py-2 rounded-lg hover:bg-indigo-500">Guardar</button>
            ' . $cancelar . '
          </div>
        </form>
      </div>';

        // ---- tabla ----
        $nombreCategoria = function ($id) use ($categorias) {
            foreach ($categorias as $c) {
                if ($c['id'] == $id) return $c['nombre'];
            }
            return '—';
        };

        $filas = '';
        foreach ($ejercicios as $ej) {
            $imagen = !empty($ej['imagen_url']) ? '<img src="' . esc($ej['imagen_url']) . '" class="h-24 rounded-lg border border-slate-200">' : '';
            $video = !empty($ej['video_url']) ? '<video src="' . esc($ej['video_url']) . '" class="h-24 rounded-lg border border-slate-200 bg-black" muted controls></video>' : '';
            $media = ($imagen === '' && $video === '')
                ? '<span class="text-slate-400 text-xs">Sin imagen ni video</span>'
                : '<div class="flex items-center gap-2">' . $imagen . $video . '</div>';

            $filas .= '
      <tr class="hover:bg-slate-50">
        <td class="px-6 py-3 text-slate-400">#' . $ej['id'] . '</td>
        <td class="px-6 py-3 font-medium text-slate-800">' . esc($ej['nombre']) . '</td>
        <td class="px-6 py-3 text-slate-600">' . esc($ej['grupo_muscular'] ?: '—') . '</td>
        <td class="px-6 py-3"><span class="px-2 py-1 rounded-full text-xs font-medium bg-emerald-100 text-emerald-700">' . esc($nombreCategoria($ej['categoria_id'])) . '</span></td>
        <td class="px-6 py-3 text-right whitespace-nowrap">
          <details class="inline-block text-left align-middle">
            <summary class="inline text-emerald-600 hover:underline cursor-pointer list-none [&::-webkit-details-marker]:hidden [&::marker]:hidden">Ver</summary>
            <div class="mt-2">' . $media . '</div>
          </details>
          <a href="/ejercicio?editar=' . $ej['id'] . '" class="text-indigo-600 hover:underline ml-3">Editar</a>
          <form method="POST" action="/ejercicio?eliminar=' . $ej['id'] . '" class="inline ml-3" onsubmit="return confirm(\'¿Eliminar este ejercicio?\')">
            <button class="text-rose-600 hover:underline">Eliminar</button>
          </form>
        </td>
      </tr>';
        }
        if ($filas === '') {
            $filas = '<tr><td colspan="5" class="px-6 py-8 text-center text-slate-400">Sin ejercicios</td></tr>';
        }

        $tabla = '
      <div class="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-x-auto">
        <table class="w-full text-sm">
          <thead class="bg-slate-50 text-slate-500 text-left">
            <tr>
              <th class="px-6 py-3 font-medium w-16">ID</th>
              <th class="px-6 py-3 font-medium">Nombre</th>
              <th class="px-6 py-3 font-medium">Grupo muscular</th>
              <th class="px-6 py-3 font-medium">Categoría</th>
              <th class="px-6 py-3 font-medium text-right">Acciones</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-slate-100">' . $filas . '</tbody>
        </table>
      </div>';

        echo layout('Ejercicios', 'ejercicio', $formulario . $tabla);
    }
}
