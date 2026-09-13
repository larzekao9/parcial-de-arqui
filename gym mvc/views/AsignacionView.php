<?php
require_once __DIR__ . '/Layout.php';

class AsignacionView
{
    public function render(?array $usuario, array $usuarios, array $rutinas, array $asignadas): void
    {
        // ---- lista de clientes (columna izquierda) ----
        $filasLista = '';
        foreach ($usuarios as $u) {
            $activo = $usuario && (int)$usuario['id'] === (int)$u['id'];
            $clase = $activo
                ? 'border-indigo-600 bg-indigo-50 text-indigo-700 font-medium'
                : 'border-transparent text-slate-700 hover:bg-slate-50';
            $filasLista .= '<a href="/asignar-rutina?usuario=' . $u['id'] . '" class="block px-4 py-3 text-sm border-l-4 ' . $clase . '">' . esc($u['nombre']) . ' ' . esc($u['apellido']) . '</a>';
        }
        if ($filasLista === '') {
            $filasLista = '<div class="px-4 py-3 text-sm text-slate-400">No hay clientes</div>';
        }
        $listaClientes = '
      <div class="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden">
        <div class="px-4 py-3 border-b border-slate-100 text-sm font-semibold text-slate-600">Clientes</div>
        <nav class="divide-y divide-slate-100 max-h-[600px] overflow-y-auto">' . $filasLista . '</nav>
      </div>';

        // ---- columna derecha (form + tabla), si hay usuario elegido ----
        $derecha = '<div class="bg-white rounded-2xl shadow-sm border border-slate-200 p-6 text-slate-500">No hay clientes cargados todavía.</div>';

        if ($usuario) {
            $opcionesRut = '';
            foreach ($rutinas as $r) {
                $opcionesRut .= '<option value="' . $r['id'] . '">' . esc($r['nombre']) . '</option>';
            }
            $opcionesEstado = '';
            foreach (['activa', 'pausada', 'finalizada', 'cancelada'] as $est) {
                $opcionesEstado .= '<option value="' . $est . '">' . $est . '</option>';
            }

            $formulario = '
      <div>
        <h2 class="text-lg font-semibold text-slate-800 mb-3">Rutinas de: <span class="text-indigo-600">' . esc($usuario['nombre']) . ' ' . esc($usuario['apellido']) . '</span></h2>
        <form method="POST" action="/asignar-rutina" class="grid grid-cols-2 sm:grid-cols-6 gap-2 items-end bg-white p-4 rounded-2xl shadow-sm border border-slate-200">
          <input type="hidden" name="usuario_id" value="' . $usuario['id'] . '">
          <div class="col-span-2">
            <label class="block text-xs font-medium text-slate-500 mb-1">Rutina</label>
            <select name="rutina_id" class="w-full border border-slate-300 rounded-lg px-2 py-2 text-sm outline-none">' . $opcionesRut . '</select>
          </div>
          <div>
            <label class="block text-xs font-medium text-slate-500 mb-1">Fecha inicio</label>
            <input name="fecha_inicio" type="date" class="w-full border border-slate-300 rounded-lg px-2 py-2 text-sm outline-none" required>
          </div>
          <div>
            <label class="block text-xs font-medium text-slate-500 mb-1">Fecha fin</label>
            <input name="fecha_fin" type="date" class="w-full border border-slate-300 rounded-lg px-2 py-2 text-sm outline-none">
          </div>
          <div>
            <label class="block text-xs font-medium text-slate-500 mb-1">Semana</label>
            <input name="semana_numero" type="number" min="1" class="w-full border border-slate-300 rounded-lg px-2 py-2 text-sm outline-none">
          </div>
          <div>
            <label class="block text-xs font-medium text-slate-500 mb-1">Estado</label>
            <select name="estado" class="w-full border border-slate-300 rounded-lg px-2 py-2 text-sm outline-none">' . $opcionesEstado . '</select>
          </div>
          <div class="col-span-2 sm:col-span-6">
            <label class="block text-xs font-medium text-slate-500 mb-1">Notas</label>
            <input name="notas" type="text" placeholder="Opcional" class="w-full border border-slate-300 rounded-lg px-2 py-2 text-sm outline-none">
          </div>
          <div class="col-span-2 sm:col-span-6 text-right">
            <button class="bg-indigo-600 hover:bg-indigo-500 text-white px-4 py-2 rounded-lg text-sm">Asignar</button>
          </div>
        </form>
      </div>';

            $filasTabla = '';
            foreach ($asignadas as $a) {
                $filasTabla .= '
      <tr class="hover:bg-slate-50">
        <td class="px-3 py-2 font-medium text-slate-800">' . esc($a['rutina_nombre']) . '</td>
        <td class="px-3 py-2">' . esc($a['fecha_inicio']) . '</td>
        <td class="px-3 py-2">' . esc($a['fecha_fin'] ?: '—') . '</td>
        <td class="px-3 py-2">' . ($a['semana_numero'] ?? '—') . '</td>
        <td class="px-3 py-2"><span class="px-2 py-1 rounded-full text-xs font-medium bg-slate-100 text-slate-600">' . esc($a['estado']) . '</span></td>
        <td class="px-3 py-2">' . esc($a['notas'] ?: '—') . '</td>
        <td class="px-3 py-2 text-right">
          <form method="POST" action="/asignar-rutina" class="inline" onsubmit="return confirm(\'¿Quitar esta rutina del usuario?\')">
            <input type="hidden" name="accion" value="eliminar">
            <input type="hidden" name="usuario_id" value="' . $usuario['id'] . '">
            <input type="hidden" name="rutina_id" value="' . $a['rutina_id'] . '">
            <input type="hidden" name="fecha_inicio" value="' . $a['fecha_inicio'] . '">
            <button class="text-rose-600 hover:underline">Quitar</button>
          </form>
        </td>
      </tr>';
            }
            if ($filasTabla === '') {
                $filasTabla = '<tr><td colspan="7" class="px-3 py-6 text-center text-slate-400">Este usuario no tiene rutinas asignadas</td></tr>';
            }

            $tabla = '
      <div class="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-x-auto">
        <table class="w-full text-sm">
          <thead class="bg-slate-50 text-slate-500 text-left">
            <tr>
              <th class="px-3 py-2 font-medium">Rutina</th>
              <th class="px-3 py-2 font-medium">Inicio</th>
              <th class="px-3 py-2 font-medium">Fin</th>
              <th class="px-3 py-2 font-medium">Semana</th>
              <th class="px-3 py-2 font-medium">Estado</th>
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
      <h1 class="text-xl font-bold text-slate-800 mb-6">Asignar Rutina a Usuario</h1>
      <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">
        <div class="lg:col-span-1">' . $listaClientes . '</div>
        <div class="lg:col-span-3 space-y-6">' . $derecha . '</div>
      </div>';

        echo layout('Asignar Rutina', 'asignar-rutina', $contenido);
    }
}
