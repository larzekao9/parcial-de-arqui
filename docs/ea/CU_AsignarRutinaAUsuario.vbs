Option Explicit

!INC Local Scripts.EAConstants-VBScript

'
' Script Name: CU_AsignarRutinaAUsuario
' Author:
' Purpose: Genera el diagrama de clases (Modelo/Vista/Controlador/Dato)
'          del caso de uso "Asignar Rutina a Usuario", reflejando el
'          código PHP real de:
'            - backend/models/AsignacionModel.php
'            - backend/models/UsuarioModel.php (dependencia)
'            - backend/models/RutinaModel.php (dependencia)
'            - backend/views/AsignacionView.php
'            - backend/controllers/AsignacionController.php
'            - backend/Conexion.php
'          MAsignacion no tiene "id" propio: la tabla "asignacion" usa
'          clave compuesta (usuario_id, rutina_id, fecha_inicio), por
'          eso no se le agrega ese atributo. El controlador tiene
'          instancia de MUsuario, MRutina, MAsignacion y VAsignacion
'          (constructor con 4 parámetros).
' Date:
'

sub main

	Dim oParent
	Set oParent = GetParentPackage()

	Dim oCasoUso
	Set oCasoUso = GetOrCreatePackage(oParent, "CU5 Asignar Rutina a Usuario - Detalle Procedimental")

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
	' Sin atributo "id": la tabla usa clave compuesta
	' (usuario_id, rutina_id, fecha_inicio).
	Dim oMAsignacion
	Set oMAsignacion = GetOrCreateClass(oPkgModelo, "MAsignacion")
	AddAttribute oMAsignacion, "conexion", "PDO", "Private", False

	AddOperation0 oMAsignacion, "__construct", "void", "Public", False
	AddOperation1 oMAsignacion, "obtenerPorUsuario", "usuarioId", "int", "array", "Public"
	AddOperation1 oMAsignacion, "agregar", "d", "array", "void", "Public"
	AddOperation3Publico oMAsignacion, "eliminar", "usuarioId", "int", "rutinaId", "int", "fechaInicio", "string", "void"

	' ---- Modelo::MUsuario (models/UsuarioModel.php) ----
	' Dependencia: el controlador arma la lista de clientes con esto.
	Dim oMUsuario
	Set oMUsuario = GetOrCreateClass(oPkgModelo, "MUsuario")
	AddAttribute oMUsuario, "id", "int", "Private", False
	AddAttribute oMUsuario, "nombre", "string", "Private", False
	AddAttribute oMUsuario, "apellido", "string", "Private", False
	AddAttribute oMUsuario, "email", "string", "Private", False
	AddAttribute oMUsuario, "password", "string", "Private", False
	AddAttribute oMUsuario, "rol", "string", "Private", False
	AddAttribute oMUsuario, "conexion", "PDO", "Private", False

	AddOperation0 oMUsuario, "__construct", "void", "Public", False
	AddOperation1 oMUsuario, "crear", "datos", "array", "array", "Public"
	AddOperation0 oMUsuario, "obtenerTodos", "array", "Public", False
	AddOperation1 oMUsuario, "obtenerPorId", "id", "int", "array", "Public"
	AddOperation2 oMUsuario, "actualizar", "id", "int", "datos", "array", "void", "Public"
	AddOperation1 oMUsuario, "eliminar", "id", "int", "void", "Public"

	' ---- Modelo::MRutina (models/RutinaModel.php) ----
	' Dependencia: el controlador arma el <select> de rutinas con esto.
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

	' ---- Vista::VAsignacion (views/AsignacionView.php) ----
	' render hace echo directo: no devuelve nada.
	Dim oVAsignacion
	Set oVAsignacion = GetOrCreateClass(oPkgVista, "VAsignacion")
	AddOperation4 oVAsignacion, "render", "usuario", "array", "usuarios", "array", "rutinas", "array", "asignadas", "array", "void", "Public"

	' ---- Controlador::CAsignacion (controllers/AsignacionController.php) ----
	' Tiene instancia de MUsuario, MRutina, MAsignacion y VAsignacion.
	' Todos los métodos son void.
	Dim oCAsignacion
	Set oCAsignacion = GetOrCreateClass(oPkgControlador, "CAsignacion")
	AddAttribute oCAsignacion, "modeloUsuario", "MUsuario", "Private", False
	AddAttribute oCAsignacion, "modeloRutina", "MRutina", "Private", False
	AddAttribute oCAsignacion, "modeloAsignacion", "MAsignacion", "Private", False
	AddAttribute oCAsignacion, "vista", "VAsignacion", "Private", False

	AddOperation4 oCAsignacion, "__construct", "modeloUsuario", "MUsuario", "modeloRutina", "MRutina", "modeloAsignacion", "MAsignacion", "vista", "VAsignacion", "void", "Public"
	AddOperation0 oCAsignacion, "obtenerTodos", "void", "Public", False
	AddOperation1 oCAsignacion, "obtenerPorId", "usuarioId", "int", "void", "Public"
	AddOperation1 oCAsignacion, "agregarAsignacion", "datos", "array", "void", "Public"
	AddOperation3Publico oCAsignacion, "eliminarAsignacion", "usuarioId", "int", "rutinaId", "int", "fechaInicio", "string", "void"

	' ---- Relaciones ----
	ConectarDependencia oCAsignacion, oMUsuario, "modeloUsuario"
	ConectarDependencia oCAsignacion, oMRutina, "modeloRutina"
	ConectarDependencia oCAsignacion, oMAsignacion, "modeloAsignacion"
	ConectarDependencia oCAsignacion, oVAsignacion, "vista"
	ConectarDependencia oMAsignacion, oConexion, "conexion"
	ConectarDependencia oMUsuario, oConexion, "conexion"
	ConectarDependencia oMRutina, oConexion, "conexion"

	' ---- Diagrama de clases ----
	Dim oDiagrama
	Set oDiagrama = GetOrCreateDiagram(oCasoUso, "CU5 Asignar Rutina a Usuario - Detalle Procedimental")

	AgregarAlDiagrama oDiagrama, oVAsignacion,     0,   0,  280, 150
	AgregarAlDiagrama oDiagrama, oMAsignacion,   350,   0,  650, 180
	AgregarAlDiagrama oDiagrama, oMUsuario,      720,   0, 1050, 320
	AgregarAlDiagrama oDiagrama, oMRutina,      1100,   0, 1400, 260
	AgregarAlDiagrama oDiagrama, oCAsignacion,     0, 250,  400, 500
	AgregarAlDiagrama oDiagrama, oConexion,      450, 250,  720, 370

	oDiagrama.Update()
	Repository.ReloadDiagram(oDiagrama.DiagramID)
	Repository.OpenDiagram(oDiagrama.DiagramID)

	MsgBox "Diagrama 'CU5 Asignar Rutina a Usuario' actualizado correctamente."

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

' Operación pública con 3 parámetros (ej. eliminar(usuarioId, rutinaId, fechaInicio))
sub AddOperation3Publico(oElement, sNombre, sParam1, sTipo1, sParam2, sTipo2, sParam3, sTipo3, sRetorno)
	Dim oMet
	Set oMet = ObtenerOCrearMetodo(oElement, sNombre)
	oMet.ReturnType = sRetorno
	oMet.Visibility = "Public"
	oMet.Update()

	LimpiarParametros oMet
	AgregarParametro oMet, sParam1, sTipo1
	AgregarParametro oMet, sParam2, sTipo2
	AgregarParametro oMet, sParam3, sTipo3
end sub

' Operación con 4 parámetros (ej. constructor con 4 dependencias, o render)
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
' tipo y orden que en el código PHP real) sin arrastrar basura de
' versiones anteriores (ej. la época Node.js).
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
