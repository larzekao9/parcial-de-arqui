Option Explicit

!INC Local Scripts.EAConstants-VBScript

'
' Script Name: CU_GestionarUsuario
' Author:
' Purpose: Genera el diagrama de clases (Modelo/Vista/Controlador/Dato)
'          del caso de uso "Gestionar Usuario", reflejando el código
'          PHP real de:
'            - backend/models/UsuarioModel.php
'            - backend/views/UsuarioView.php
'            - backend/controllers/UsuarioController.php
'            - backend/Conexion.php
'          Los atributos de MUsuario son las columnas reales de la
'          tabla "usuario" (id, nombre, apellido, email, password, rol).
'          id va primero, sin anotaciones; conexion va al final.
'          Todos los métodos de CUsuario son void: la Vista hace
'          echo directo, no hay ningún return.
' Date:
'

sub main

	Dim oParent
	Set oParent = GetParentPackage()

	Dim oCasoUso
	Set oCasoUso = GetOrCreatePackage(oParent, "CU1 Gestionar Usuario - Detalle Procedimental")

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

	' ---- Modelo::MUsuario (models/UsuarioModel.php) ----
	' Atributos = columnas reales de la tabla "usuario". id primero,
	' sin anotaciones; conexion al final (no es columna de la tabla).
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

	' ---- Vista::VUsuario (views/UsuarioView.php) ----
	' render hace echo directo: no devuelve nada.
	Dim oVUsuario
	Set oVUsuario = GetOrCreateClass(oPkgVista, "VUsuario")
	AddOperation2 oVUsuario, "render", "usuarios", "array", "opciones", "array", "void", "Public"

	' ---- Controlador::CUsuario (controllers/UsuarioController.php) ----
	' Todos los métodos son void: piden datos al Modelo y le dicen
	' a la Vista que se muestre (echo), sin devolver nada.
	Dim oCUsuario
	Set oCUsuario = GetOrCreateClass(oPkgControlador, "CUsuario")
	AddAttribute oCUsuario, "model", "MUsuario", "Private", False
	AddAttribute oCUsuario, "view", "VUsuario", "Private", False

	AddOperation2 oCUsuario, "__construct", "model", "MUsuario", "view", "VUsuario", "void", "Public"
	AddOperation0 oCUsuario, "obtenerTodos", "void", "Public", False
	AddOperation1 oCUsuario, "obtenerPorId", "id", "int", "void", "Public"
	AddOperation1 oCUsuario, "crear", "datos", "array", "void", "Public"
	AddOperation2 oCUsuario, "actualizar", "id", "int", "datos", "array", "void", "Public"
	AddOperation1 oCUsuario, "eliminar", "id", "int", "void", "Public"

	' ---- Relaciones ----
	ConectarDependencia oCUsuario, oMUsuario, "model"
	ConectarDependencia oCUsuario, oVUsuario, "view"
	ConectarDependencia oMUsuario, oConexion, "conexion"

	' ---- Diagrama de clases ----
	Dim oDiagrama
	Set oDiagrama = GetOrCreateDiagram(oCasoUso, "CU1 Gestionar Usuario - Detalle Procedimental")

	AgregarAlDiagrama oDiagrama, oVUsuario,   0,   0,  250, 150
	AgregarAlDiagrama oDiagrama, oMUsuario,  400,   0,  780, 360
	AgregarAlDiagrama oDiagrama, oCUsuario,    0, 250,  350, 470
	AgregarAlDiagrama oDiagrama, oConexion,  550, 420,  820, 540

	oDiagrama.Update()
	Repository.ReloadDiagram(oDiagrama.DiagramID)
	Repository.OpenDiagram(oDiagrama.DiagramID)

	MsgBox "Diagrama 'CU1 Gestionar Usuario' actualizado correctamente."

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
' El parámetro Pos respeta el orden real de llamada (0,1,2,...), así
' "conexion" (agregado al final) queda visualmente abajo.
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
