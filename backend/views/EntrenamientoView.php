<?php
require_once __DIR__ . '/Layout.php';

class EntrenamientoView
{
    public function render(array $entrenamientos): void
    {
        $bloques = '';
        foreach ($entrenamientos as $item) {
            $a = $item['asignacion'];
            $r = $item['rutina'];

            $filasEjercicios = '';
            foreach ($item['ejercicios'] as $ej) {
                $imagen = !empty($ej['imagen_url']) ? '<img src="' . esc($ej['imagen_url']) . '" class="h-20 rounded-lg border border-slate-200">' : '';
                $video = !empty($ej['video_url']) ? '<video src="' . esc($ej['video_url']) . '" class="h-20 rounded-lg border border-slate-200 bg-black" muted controls></video>' : '';
                $media = ($imagen === '' && $video === '')
                    ? '<span class="text-slate-400 text-xs">Sin imagen ni video</span>'
                    : '<div class="flex items-center gap-2">' . $imagen . $video . '</div>';

                $filasEjercicios .= '
          <div class="flex items-center justify-between gap-4 py-3 border-b border-slate-100 last:border-0">
            <div>
              <div class="font-medium text-slate-800">' . esc($ej['ejercicio_nombre']) . '</div>
              <div class="text-sm text-slate-500">' . (int)$ej['series'] . ' series x ' . esc($ej['repeticiones']) . (!empty($ej['peso_sugerido']) ? ' — ' . esc($ej['peso_sugerido']) : '') . '</div>
            </div>
            ' . $media . '
          </div>';
            }
            if ($filasEjercicios === '') {
                $filasEjercicios = '<p class="text-sm text-slate-400 py-3">Esta rutina todavía no tiene ejercicios cargados.</p>';
            }

            $bloques .= '
      <div class="bg-white rounded-2xl shadow-sm border border-slate-200 p-6">
        <div class="flex items-center justify-between mb-1">
          <h2 class="text-lg font-semibold text-slate-800">' . esc($a['rutina_nombre']) . '</h2>
          <span class="px-2 py-1 rounded-full text-xs font-medium bg-slate-100 text-slate-600">' . esc($a['estado']) . '</span>
        </div>
        <p class="text-sm text-slate-500 mb-1">Desde ' . esc($a['fecha_inicio']) . (!empty($a['fecha_fin']) ? ' hasta ' . esc($a['fecha_fin']) : '') . (!empty($r['duracion_semanas']) ? ' · ' . (int)$r['duracion_semanas'] . ' semanas' : '') . '</p>
        ' . (!empty($r['descripcion']) ? '<p class="text-sm text-slate-500 mb-4">' . esc($r['descripcion']) . '</p>' : '<div class="mb-4"></div>') . '
        ' . $filasEjercicios . '
      </div>';
        }

        if ($bloques === '') {
            $bloques = '<div class="bg-white rounded-2xl shadow-sm border border-slate-200 p-6 text-slate-500">Todavía no tenés rutinas asignadas.</div>';
        }

        $contenido = '
      <h1 class="text-xl font-bold text-slate-800 mb-6">Mis Entrenamientos</h1>
      <div class="space-y-6 max-w-3xl">' . $bloques . '</div>';

        echo layoutCliente('Mis Entrenamientos', $contenido);
    }
}
