<?php
require_once __DIR__ . '/Layout.php';

class RutinaEjercicioView
{
    public function render(?array $rutina, array $rutinas, array $ejercicios, array $asignados): void
    {
        // ---- lista de rutinas (columna izquierda) ----
        $filasLista = '';
        foreach ($rutinas as $r) {
            $activo = $rutina && (int)$rutina['id'] === (int)$r['id'];
            $clase = $activo
                ? 'border-indigo-600 bg-indigo-50 text-indigo-700 font-medium'
                : 'border-transparent text-slate-700 hover:bg-slate-50';
            $filasLista .= '<a href="/asignar?rutina=' . $r['id'] . '" class="block px-4 py-3 text-sm border-l-4 ' . $clase . '">' . esc($r['nombre']) . '</a>';
        }
        if ($filasLista === '') {
            $filasLista = '<div class="px-4 py-3 text-sm text-slate-400">No hay rutinas</div>';
        }
        $listaRutinas = '
      <div class="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden">
        <div class="px-4 py-3 border-b border-slate-100 text-sm font-semibold text-slate-600">Rutinas</div>
        <nav class="divide-y divide-slate-100 max-h-[600px] overflow-y-auto">' . $filasLista . '</nav>
      </div>';

        // ---- columna derecha (form + tabla), si hay rutina elegida ----
        $derecha = '<div class="bg-white rounded-2xl shadow-sm border border-slate-200 p-6 text-slate-500">No hay rutinas cargadas todavía.</div>';

        if ($rutina) {
            $opcionesEj = '';
            foreach ($ejercicios as $e) {
                $opcionesEj .= '<option value="' . $e['id'] . '">' . esc($e['nombre']) . '</option>';
            }

            $formulario = '
      <div>
        <h2 class="text-lg font-semibold text-slate-800 mb-3">Ejercicios de: <span class="text-indigo-600">' . esc($rutina['nombre']) . '</span></h2>
        <form method="POST" action="/asignar" class="grid grid-cols-2 sm:grid-cols-6 gap-2 items-end bg-white p-4 rounded-2xl shadow-sm border border-slate-200">
          <input type="hidden" name="rutina_id" value="' . $rutina['id'] . '">
          <div class="col-span-2">
            <label class="block text-xs font-medium text-slate-500 mb-1">Ejercicio</label>
            <select name="ejercicio_id" class="w-full border border-slate-300 rounded-lg px-2 py-2 text-sm outline-none">' . $opcionesEj . '</select>
          </div>
          <div>
            <label class="block text-xs font-medium text-slate-500 mb-1">Series</label>
            <input name="series" type="number" min="1" class="w-full border border-slate-300 rounded-lg px-2 py-2 text-sm outline-none" required>
          </div>
          <div>
            <label class="block text-xs font-medium text-slate-500 mb-1">Reps</label>
            <input name="repeticiones" type="text" placeholder="8-10" class="w-full border border-slate-300 rounded-lg px-2 py-2 text-sm outline-none" required>
          </div>
          <div>
            <label class="block text-xs font-medium text-slate-500 mb-1">Peso</label>
            <input name="peso_sugerido" type="text" placeholder="40kg" class="w-full border border-slate-300 rounded-lg px-2 py-2 text-sm outline-none">
          </div>
          <div>
            <label class="block text-xs font-medium text-slate-500 mb-1">Orden</label>
            <input name="orden" type="number" min="1" value="1" class="w-full border border-slate-300 rounded-lg px-2 py-2 text-sm outline-none" required>
          </div>
          <div class="col-span-2 sm:col-span-6">
            <label class="block text-xs font-medium text-slate-500 mb-1">Notas</label>
            <input name="notas" type="text" placeholder="Opcional" class="w-full border border-slate-300 rounded-lg px-2 py-2 text-sm outline-none">
          </div>
          <div class="col-span-2 sm:col-span-6 text-right">
            <button class="bg-indigo-600 hover:bg-indigo-500 text-white px-4 py-2 rounded-lg text-sm">Agregar</button>
          </div>
        </form>
      </div>';

            $filasTabla = '';
            foreach ($asignados as $a) {
                $filasTabla .= '
      <tr class="hover:bg-slate-50">
        <td class="px-3 py-2 text-slate-400">' . $a['orden'] . '</td>
        <td class="px-3 py-2 font-medium text-slate-800">' . esc($a['ejercicio_nombre']) . '</td>
        <td class="px-3 py-2">' . $a['series'] . '</td>
        <td class="px-3 py-2">' . esc($a['repeticiones']) . '</td>
        <td class="px-3 py-2">' . esc($a['peso_sugerido'] ?: '—') . '</td>
        <td class="px-3 py-2">' . esc($a['notas'] ?: '—') . '</td>
        <td class="px-3 py-2 text-right">
          <form method="POST" action="/asignar" class="inline" onsubmit="return confirm(\'¿Quitar este ejercicio de la rutina?\')">
            <input type="hidden" name="accion" value="eliminar">
            <input type="hidden" name="rutina_id" value="' . $rutina['id'] . '">
            <input type="hidden" name="ejercicio_id" value="' . $a['ejercicio_id'] . '">
            <button class="text-rose-600 hover:underline">Quitar</button>
          </form>
        </td>
      </tr>';
            }
            if ($filasTabla === '') {
                $filasTabla = '<tr><td colspan="7" class="px-3 py-6 text-center text-slate-400">Esta rutina no tiene ejercicios</td></tr>';
            }

            $tabla = '
      <div class="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-x-auto">
        <table class="w-full text-sm">
          <thead class="bg-slate-50 text-slate-500 text-left">
            <tr>
              <th class="px-3 py-2 font-medium">#</th>
              <th class="px-3 py-2 font-medium">Ejercicio</th>
              <th class="px-3 py-2 font-medium">Series</th>
              <th class="px-3 py-2 font-medium">Reps</th>
              <th class="px-3 py-2 font-medium">Peso</th>
              <th class="px-3 py-2 font-medium">Notas</th>
              <th class="px-3 py-2 font-medium text-right">Quitar</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-slate-100">' . $filasTabla . '</tbody>
        </table>
      </div>';

            $derecha = $formulario . $tabla;
        }

        $contenido = '
      <h1 class="text-xl font-bold text-slate-800 mb-6">Asignar Ejercicios a Rutina</h1>
      <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">
        <div class="lg:col-span-1">' . $listaRutinas . '</div>
        <div class="lg:col-span-3 space-y-6">' . $derecha . '</div>
      </div>';

        echo layout('Asignar Ejercicios', 'asignar', $contenido);
    }
}
