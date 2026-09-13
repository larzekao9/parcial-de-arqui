<?php
class LoginView
{
    public function render(?string $error = null): void
    {
        $errorHtml = $error ? '<div class="mb-4 text-sm text-rose-600 bg-rose-50 border border-rose-200 rounded-lg px-3 py-2">' . esc($error) . '</div>' : '';

        echo <<<HTML
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Iniciar sesión</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-100 min-h-screen flex items-center justify-center">
  <div class="w-full max-w-sm bg-white p-8 rounded-2xl shadow-sm border border-slate-200">
    <h1 class="text-xl font-bold text-slate-800 mb-6 text-center">Gym MVC</h1>
    {$errorHtml}
    <form method="POST" action="/login" class="space-y-4">
      <div>
        <label class="block text-sm text-slate-600 mb-1">Email</label>
        <input name="email" type="email" class="w-full border border-slate-300 rounded-lg px-3 py-2 outline-none focus:ring-2 focus:ring-indigo-500" required>
      </div>
      <div>
        <label class="block text-sm text-slate-600 mb-1">Contraseña</label>
        <input name="password" type="password" class="w-full border border-slate-300 rounded-lg px-3 py-2 outline-none focus:ring-2 focus:ring-indigo-500" required>
      </div>
      <button class="w-full bg-indigo-600 text-white px-4 py-2 rounded-lg hover:bg-indigo-500">Ingresar</button>
    </form>
  </div>
</body>
</html>
HTML;
    }
}
