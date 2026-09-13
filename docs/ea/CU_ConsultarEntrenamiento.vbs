Option Explicit

!INC Local Scripts.EAConstants-VBScript

'
' Script Name: CU_ConsultarEntrenamiento
' Author:
' Purpose: Genera el diagrama de clases (Modelo/Vista/Controlador/Dato)
'          del caso de uso "Consultar Entrenamiento" (pantalla "Mis
'          Entrenamientos" del rol cliente), reflejando el código PHP
'          real de:
'            - backend/controllers/EntrenamientoController.php
'            - backend/views/EntrenamientoView.php
'            - backend/models/AsignacionModel.php
'            - backend/models/RutinaModel.php
'            - backend/models/RutinaEjercicioModel.php
'            - backend/Conexion.php
'          El controlador tiene instancia de MAsignacion, MRutina,
'          MRutinaEjercicio y VEntrenamiento (constructor con 4
'          parámetros). MAsignacion y MRutinaEjercicio no tienen "id"
'          propio (claves primarias compuestas). id va primero en el
'          resto, sin anotaciones; conexion va al final.
' Date:
'

sub main

	Dim oParent
	Set oParent = GetParentPackage()

	Dim oCasoUso
	Set oCasoUso = GetOrCreatePackage(oParent, "CU7 Consultar Entrenamiento - Detalle Procedimental")

	Dim oPkgModelo, oPkgVista, oPkgControlador, oPkgDato
	Set oPkgModelo      = GetOrCreatePackage(oCasoUso, "Modelo")
	Set oPkgVista       = GetOrCreatePackage(oCasoUso, "Vista")
	Set oPkgControlador = GetOrCreatePackage(oCasoUso, "Controlador")
	Set oPkgDato        = GetOrCreatePackage(oCasoUso, "Dato")

	' ---- Dato::Conexion (Conexion.php) ----
	Dim oConexion
	Set oConexion = GetOrCreateClass(oPkgDato, "Conexion")
	AddAttribute oConexion, "instancia", "PDO", "Private", True
	AddOperation0 oConexion, "getConexion", "PDO", "Public", True

	' ---- Modelo::MAsignacion (models/AsignacionModel.php) ----
	' Sin "id": clave primaria compuesta (usuario_id, rutina_id, fecha_inicio).
	Dim oMAsignacion
	Set oMAsignacion = GetOrCreateClass(oPkgModelo, "MAsignacion")
	AddAttribute oMAsignacion, "usuario_id", "int", "Private", False
	AddAttribute oMAsignacion, "rutina_id", "int", "Private", False
	AddAttribute oMAsignacion, "fecha_inicio", "string", "Private", False
	AddAttribute oMAsignacion, "fecha_fin", "string", "Private", False
	AddAttribute oMAsignacion, "semana_numero", "int", "Private", False
	AddAttribute oMAsignacion, "estado", "string", "Private", False
	AddAttribute oMAsignacion, "notas", "string", "Private", False
	AddAttribute oMAsignacion, "created_at", "string", "Private", False
	AddAttribute oMAsignacion, "conexion", "PDO", "Private", False

	AddOperation0 oMAsignacion, "__construct", "void", "Public", False
	AddOperation1 oMAsignacion, "obtenerPorUsuario", "usuarioId", "int", "array", "Public"
	AddOperation1 oMAsignacion, "agregar", "d", "array", "void", "Public"
	AddOperation3 oMAsignacion, "eliminar", "usuarioId", "int", "rutinaId", "int", "fechaInicio", "string", "void", "Public"

	' ---- Modelo::MRutina (models/RutinaModel.php) ----
	Dim oMRutina
	Set oMRutina = GetOrCreateClass(oPkgModelo, "MRutina")
	AddAttribute oMRutina, "id", "int", "Private", False
	AddAttribute oMRutina, "nombre", "string", "Private", False
	AddAttribute oMRutina, "descripcion", "string", "Private", False
	AddAttribute oMRutina, "duracion_semanas", "int", "Private", False
	AddAttribute oMRutina, "conexion", "PDO", "Private", False

	AddOperation0 oMRutina, "__construct", "void", "Public", False
	AddOperation0 oMRutina, "obtenerTodos", "array", "Public", False
	AddOperation1 oMRutina, "buscarPorId", "id", "int", "array", "Public"
	AddOperation1 oMRutina, "registrar", "d", "array", "array", "Public"
	AddOperation2 oMRutina, "actualizar", "id", "int", "d", "array", "void", "Public"
	AddOperation1 oMRutina, "eliminar", "id", "int", "void", "Public"

	' ---- Modelo::MRutinaEjercicio (models/RutinaEjercicioModel.php) ----
	' Sin "id": clave primaria compuesta (rutina_id, ejercicio_id).
	Dim oMRutinaEjercicio
	Set oMRutinaEjercicio = GetOrCreateClass(oPkgModelo, "MRutinaEjercicio")
	AddAttribute oMRutinaEjercicio, "rutina_id", "int", "Private", False
	AddAttribute oMRutinaEjercicio, "ejercicio_id", "int", "Private", False
	AddAttribute oMRutinaEjercicio, "series", "int", "Private", False
	AddAttribute oMRutinaEjercicio, "repeticiones", "string", "Private", False
	AddAttribute oMRutinaEjercicio, "peso_sugerido", "string", "Private", False
	AddAttribute oMRutinaEjercicio, "orden", "int", "Private", False
	AddAttribute oMRutinaEjercicio, "notas", "string", "Private", False
	AddAttribute oMRutinaEjercicio, "conexion", "PDO", "Private", False

	AddOperation0 oMRutinaEjercicio, "__construct", "void", "Public", False
	AddOperation1 oMRutinaEjercicio, "obtenerPorRutina", "rutinaId", "int", "array", "Public"
	AddOperation1 oMRutinaEjercicio, "agregar", "d", "array", "void", "Public"
	AddOperation2 oMRutinaEjercicio, "eliminar", "rutinaId", "int", "ejercicioId", "int", "void", "Public"

	' ---- Vista::VEntrenamiento (views/EntrenamientoView.php) ----
	' render hace echo directo: no devuelve nada.
	Dim oVEntrenamiento
	Set oVEntrenamiento = GetOrCreateClass(oPkgVista, "VEntrenamiento")
	AddOperation1 oVEntrenamiento, "render", "entrenamientos", "array", "void", "Public"

	' ---- Controlador::CEntrenamiento (controllers/EntrenamientoController.php) ----
	' Tiene instancia de MAsignacion, MRutina, MRutinaEjercicio y
	' VEntrenamiento. Único método público real: misEntrenamientos(id).
	Dim oCEntrenamiento
	Set oCEntrenamiento = GetOrCreateClass(oPkgControlador, "CEntrenamiento")
	AddAttribute oCEntrenamiento, "modeloAsignacion", "MAsignacion", "Private", False
	AddAttribute oCEntrenamiento, "modeloRutina", "MRutina", "Private", False
	AddAttribute oCEntrenamiento, "modeloRutinaEj", "MRutinaEjercicio", "Private", False
	AddAttribute oCEntrenamiento, "vista", "VEntrenamiento", "Private", False

	AddOperation4 oCEntrenamiento, "__construct", "modeloAsignacion", "MAsignacion", "modeloRutina", "MRutina", "modeloRutinaEj", "MRutinaEjercicio", "vista", "VEntrenamiento", "void", "Public"
	AddOperation1 oCEntrenamiento, "misEntrenamientos", "usuarioId", "int", "void", "Public"

	' ---- Relaciones ----
	ConectarDependencia oCEntrenamiento, oMAsignacion, "modeloAsignacion"
	ConectarDependencia oCEntrenamiento, oMRutina, "modeloRutina"
	ConectarDependencia oCEntrenamiento, oMRutinaEjercicio, "modeloRutinaEj"
	ConectarDependencia oCEntrenamiento, oVEntrenamiento, "vista"
	ConectarDependencia oMAsignacion, oConexion, "conexion"
	ConectarDependencia oMRutina, oConexion, "conexion"
	ConectarDependencia oMRutinaEjercicio, oConexion, "conexion"

	' ---- Diagrama de clases ----
	Dim oDiagrama
	Set oDiagrama = GetOrCreateDiagram(oCasoUso, "CU7 Consultar Entrenamiento - Detalle Procedimental")

	AgregarAlDiagrama oDiagrama, oVEntrenamiento,      0,   0,  280, 150
	AgregarAlDiagrama oDiagrama, oMAsignacion,       350,   0,  680, 360
	AgregarAlDiagrama oDiagrama, oMRutina,           750,   0, 1050, 260
	AgregarAlDiagrama oDiagrama, oMRutinaEjercicio, 1100,   0, 1400, 320
	AgregarAlDiagrama oDiagrama, oCEntrenamiento,      0, 420,  400, 620
	AgregarAlDiagrama oDiagrama, oConexion,          450, 420,  720, 540

	oDiagrama.Update()
	Repository.ReloadDiagram(oDiagrama.DiagramID)
	Repository.OpenDiagram(oDiagrama.DiagramID)

	MsgBox "Diagrama 'CU7 Consultar Entrenamiento' generado correctamente."

end sub

' =====================================================
' Helpers de paquetes
' =====================================================
function GetParentPackage()
	Dim oSel
	Set oSel = Repository.GetTreeSelectedPackage()
	if oSel is nothing then
		Set GetParentPackage = Repository.Models.GetAt(0)
	else
		Set GetParentPackage = oSel
	end if
end function

function GetOrCreatePackage(oParent, sNombre)
	Dim oPkg, i
	for i = 0 to oParent.Packages.Count - 1
		Set oPkg = oParent.Packages.GetAt(i)
		if oPkg.Name = sNombre then
			Set GetOrCreatePackage = oPkg
			exit function
		end if
	next

	Set oPkg = oParent.Packages.AddNew(sNombre, "")
	oPkg.Update()
	oParent.Packages.Refresh()
	Set GetOrCreatePackage = oPkg
end function

' =====================================================
' Helpers de clases
' =====================================================
function GetOrCreateClass(oPkg, sNombre)
	Dim oEl, i
	for i = 0 to oPkg.Elements.Count - 1
		Set oEl = oPkg.Elements.GetAt(i)
		if oEl.Name = sNombre and oEl.Type = "Class" then
			Set GetOrCreateClass = oEl
			exit function
		end if
	next

	Set oEl = oPkg.Elements.AddNew(sNombre, "Class")
	oEl.Update()
	oPkg.Elements.Refresh()
	Set GetOrCreateClass = oEl
end function

' Sin notas ni marca de PK: atributos simples, tipo y visibilidad nomás.
sub AddAttribute(oElement, sNombre, sTipo, sScope, bEstatico)
	Dim oAttr, i, bExiste, nPos
	bExiste = False
	nPos = oElement.Attributes.Count
	for i = 0 to oElement.Attributes.Count - 1
		Set oAttr = oElement.Attributes.GetAt(i)
		if oAttr.Name = sNombre then
			bExiste = True
			nPos = oAttr.Pos
			exit for
		end if
	next

	if not bExiste then
		Set oAttr = oElement.Attributes.AddNew(sNombre, sTipo)
	end if

	oAttr.Type = sTipo
	oAttr.Visibility = sScope
	oAttr.IsStatic = bEstatico
	oAttr.Notes = ""
	oAttr.IsID = False
	oAttr.Pos = nPos
	oAttr.Update()
	oElement.Attributes.Refresh()
end sub

' Operación sin parámetros
sub AddOperation0(oElement, sNombre, sRetorno, sScope, bEstatico)
	Dim oMet
	Set oMet = ObtenerOCrearMetodo(oElement, sNombre)
	oMet.ReturnType = sRetorno
	oMet.Visibility = sScope
	oMet.IsStatic = bEstatico
	oMet.Update()

	LimpiarParametros oMet
end sub

' Operación con 1 parámetro
sub AddOperation1(oElement, sNombre, sParam1, sTipo1, sRetorno, sScope)
	Dim oMet
	Set oMet = ObtenerOCrearMetodo(oElement, sNombre)
	oMet.ReturnType = sRetorno
	oMet.Visibility = sScope
	oMet.Update()

	LimpiarParametros oMet
	AgregarParametro oMet, sParam1, sTipo1
end sub

' Operación con 2 parámetros
sub AddOperation2(oElement, sNombre, sParam1, sTipo1, sParam2, sTipo2, sRetorno, sScope)
	Dim oMet
	Set oMet = ObtenerOCrearMetodo(oElement, sNombre)
	oMet.ReturnType = sRetorno
	oMet.Visibility = sScope
	oMet.Update()

	LimpiarParametros oMet
	AgregarParametro oMet, sParam1, sTipo1
	AgregarParametro oMet, sParam2, sTipo2
end sub

' Operación con 3 parámetros
sub AddOperation3(oElement, sNombre, sParam1, sTipo1, sParam2, sTipo2, sParam3, sTipo3, sRetorno, sScope)
	Dim oMet
	Set oMet = ObtenerOCrearMetodo(oElement, sNombre)
	oMet.ReturnType = sRetorno
	oMet.Visibility = sScope
	oMet.Update()

	LimpiarParametros oMet
	AgregarParametro oMet, sParam1, sTipo1
	AgregarParametro oMet, sParam2, sTipo2
	AgregarParametro oMet, sParam3, sTipo3
end sub

' Operación con 4 parámetros (ej. constructor con 4 dependencias)
sub AddOperation4(oElement, sNombre, sParam1, sTipo1, sParam2, sTipo2, sParam3, sTipo3, sParam4, sTipo4, sRetorno, sScope)
	Dim oMet
	Set oMet = ObtenerOCrearMetodo(oElement, sNombre)
	oMet.ReturnType = sRetorno
	oMet.Visibility = sScope
	oMet.Update()

	LimpiarParametros oMet
	AgregarParametro oMet, sParam1, sTipo1
	AgregarParametro oMet, sParam2, sTipo2
	AgregarParametro oMet, sParam3, sTipo3
	AgregarParametro oMet, sParam4, sTipo4
end sub

' Borra todos los parámetros existentes del método para que, en cada
' corrida, queden exactamente los que se pasan ahora (mismo nombre,
' tipo y orden que en el código PHP real).
sub LimpiarParametros(oMet)
	Dim i
	for i = oMet.Parameters.Count - 1 to 0 step -1
		oMet.Parameters.Delete(i)
	next
	oMet.Parameters.Refresh()
end sub

function ObtenerOCrearMetodo(oElement, sNombre)
	Dim oMet, i
	for i = 0 to oElement.Methods.Count - 1
		Set oMet = oElement.Methods.GetAt(i)
		if oMet.Name = sNombre then
			Set ObtenerOCrearMetodo = oMet
			exit function
		end if
	next

	Set oMet = oElement.Methods.AddNew(sNombre, "void")
	oMet.Update()
	oElement.Methods.Refresh()
	Set ObtenerOCrearMetodo = oMet
end function

sub AgregarParametro(oMet, sNombre, sTipo)
	Dim oParam
	Set oParam = oMet.Parameters.AddNew(sNombre, sTipo)
	oParam.Update()
	oMet.Parameters.Refresh()
end sub

' =====================================================
' Helpers de relaciones (dependencia con nombre de rol)
' =====================================================
sub ConectarDependencia(oCliente, oProveedor, sRol)
	Dim oConn, i, bExiste
	bExiste = False
	for i = 0 to oCliente.Connectors.Count - 1
		Set oConn = oCliente.Connectors.GetAt(i)
		if oConn.Type = "Dependency" and oConn.SupplierID = oProveedor.ElementID then
			bExiste = True
			exit for
		end if
	next

	if not bExiste then
		Set oConn = oCliente.Connectors.AddNew("", "Dependency")
		oConn.SupplierID = oProveedor.ElementID
		oConn.Update()
		oCliente.Connectors.Refresh()

		oConn.SupplierEnd.Role = sRol
		oConn.SupplierEnd.Update()
		oConn.Update()
	end if
end sub

' =====================================================
' Helpers de diagrama
' =====================================================
function GetOrCreateDiagram(oPkg, sNombre)
	Dim oDiag, i
	for i = 0 to oPkg.Diagrams.Count - 1
		Set oDiag = oPkg.Diagrams.GetAt(i)
		if oDiag.Name = sNombre then
			Set GetOrCreateDiagram = oDiag
			exit function
		end if
	next

	Set oDiag = oPkg.Diagrams.AddNew(sNombre, "Class")
	oDiag.Update()
	oPkg.Diagrams.Refresh()
	Set GetOrCreateDiagram = oDiag
end function

sub AgregarAlDiagrama(oDiagrama, oElemento, l, t, r, b)
	Dim oObj, i, bExiste
	bExiste = False
	for i = 0 to oDiagrama.DiagramObjects.Count - 1
		Set oObj = oDiagrama.DiagramObjects.GetAt(i)
		if oObj.ElementID = oElemento.ElementID then
			bExiste = True
			exit for
		end if
	next

	if not bExiste then
		Set oObj = oDiagrama.DiagramObjects.AddNew("l=" & l & ";r=" & r & ";t=" & t & ";b=" & b & ";", "")
		oObj.ElementID = oElemento.ElementID
		oObj.Update()
		oDiagrama.DiagramObjects.Refresh()
	end if
end sub

main
