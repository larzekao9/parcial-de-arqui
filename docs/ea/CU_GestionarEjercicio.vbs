Option Explicit

!INC Local Scripts.EAConstants-VBScript

'
' Script Name: CU_GestionarEjercicio
' Author:
' Purpose: Genera el diagrama de clases (Modelo/Vista/Controlador/Dato)
'          del caso de uso "Gestionar Ejercicio", reflejando el código
'          PHP real de:
'            - backend/models/EjercicioModel.php
'            - backend/models/CategoriaModel.php (el controlador también
'              depende de MCategoria para poblar el <select> de categorías)
'            - backend/views/EjercicioView.php
'            - backend/controllers/EjercicioController.php
'            - backend/Conexion.php
'          Los atributos son las columnas reales de "ejercicio" y
'          "categoria_ejercicio". id va primero, sin anotaciones;
'          conexion va al final. subirArchivo es el único método
'          privado real del controlador (subida nativa vía $_FILES).
' Date:
'

sub main

	Dim oParent
	Set oParent = GetParentPackage()

	Dim oCasoUso
	Set oCasoUso = GetOrCreatePackage(oParent, "CU4 Gestionar Ejercicio - Detalle Procedimental")

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

	' ---- Modelo::MEjercicio (models/EjercicioModel.php) ----
	' Atributos = columnas reales de la tabla "ejercicio". id primero,
	' sin anotaciones; conexion al final.
	Dim oMEjercicio
	Set oMEjercicio = GetOrCreateClass(oPkgModelo, "MEjercicio")
	AddAttribute oMEjercicio, "id", "int", "Private", False
	AddAttribute oMEjercicio, "nombre", "string", "Private", False
	AddAttribute oMEjercicio, "descripcion", "string", "Private", False
	AddAttribute oMEjercicio, "grupo_muscular", "string", "Private", False
	AddAttribute oMEjercicio, "imagen_url", "string", "Private", False
	AddAttribute oMEjercicio, "video_url", "string", "Private", False
	AddAttribute oMEjercicio, "categoria_id", "int", "Private", False
	AddAttribute oMEjercicio, "conexion", "PDO", "Private", False

	AddOperation0 oMEjercicio, "__construct", "void", "Public", False
	AddOperation0 oMEjercicio, "obtenerTodos", "array", "Public", False
	AddOperation1 oMEjercicio, "buscarPorId", "id", "int", "array", "Public"
	AddOperation1 oMEjercicio, "registrar", "d", "array", "array", "Public"
	AddOperation2 oMEjercicio, "actualizar", "id", "int", "d", "array", "void", "Public"
	AddOperation1 oMEjercicio, "eliminar", "id", "int", "void", "Public"

	' ---- Modelo::MCategoria (models/CategoriaModel.php) ----
	' El controlador de ejercicio también usa este modelo para el <select>.
	Dim oMCategoria
	Set oMCategoria = GetOrCreateClass(oPkgModelo, "MCategoria")
	AddAttribute oMCategoria, "id", "int", "Private", False
	AddAttribute oMCategoria, "nombre", "string", "Private", False
	AddAttribute oMCategoria, "conexion", "PDO", "Private", False

	AddOperation0 oMCategoria, "__construct", "void", "Public", False
	AddOperation1 oMCategoria, "registrar", "datos", "array", "array", "Public"
	AddOperation0 oMCategoria, "obtenerTodos", "array", "Public", False
	AddOperation1 oMCategoria, "buscarPorId", "id", "int", "array", "Public"
	AddOperation2 oMCategoria, "actualizar", "id", "int", "datos", "array", "void", "Public"
	AddOperation1 oMCategoria, "eliminar", "id", "int", "void", "Public"

	' ---- Vista::VEjercicio (views/EjercicioView.php) ----
	' render hace echo directo: no devuelve nada.
	Dim oVEjercicio
	Set oVEjercicio = GetOrCreateClass(oPkgVista, "VEjercicio")
	AddOperation2 oVEjercicio, "render", "ejercicios", "array", "opciones", "array", "void", "Public"

	' ---- Controlador::CEjercicio (controllers/EjercicioController.php) ----
	' Todos los métodos públicos son void; subirArchivo es privado y
	' devuelve string (la url final del archivo subido o la actual).
	Dim oCEjercicio
	Set oCEjercicio = GetOrCreateClass(oPkgControlador, "CEjercicio")
	AddAttribute oCEjercicio, "model", "MEjercicio", "Private", False
	AddAttribute oCEjercicio, "view", "VEjercicio", "Private", False
	AddAttribute oCEjercicio, "categoriaModel", "MCategoria", "Private", False

	AddOperation3 oCEjercicio, "__construct", "model", "MEjercicio", "view", "VEjercicio", "categoriaModel", "MCategoria", "void", "Public"
	AddOperation0 oCEjercicio, "obtenerTodos", "void", "Public", False
	AddOperation1 oCEjercicio, "obtenerPorId", "id", "int", "void", "Public"
	AddOperation1 oCEjercicio, "crear", "datos", "array", "void", "Public"
	AddOperation2 oCEjercicio, "actualizar", "id", "int", "datos", "array", "void", "Public"
	AddOperation1 oCEjercicio, "eliminar", "id", "int", "void", "Public"
	AddOperation2Privado oCEjercicio, "subirArchivo", "campo", "string", "actual", "string", "string"

	' ---- Relaciones ----
	ConectarDependencia oCEjercicio, oMEjercicio, "model"
	ConectarDependencia oCEjercicio, oVEjercicio, "view"
	ConectarDependencia oCEjercicio, oMCategoria, "categoriaModel"
	ConectarDependencia oMEjercicio, oConexion, "conexion"
	ConectarDependencia oMCategoria, oConexion, "conexion"

	' ---- Diagrama de clases ----
	Dim oDiagrama
	Set oDiagrama = GetOrCreateDiagram(oCasoUso, "CU4 Gestionar Ejercicio - Detalle Procedimental")

	AgregarAlDiagrama oDiagrama, oVEjercicio,    0,   0,  250, 150
	AgregarAlDiagrama oDiagrama, oMEjercicio,  400,   0,  780, 360
	AgregarAlDiagrama oDiagrama, oMCategoria,  850,   0, 1130, 220
	AgregarAlDiagrama oDiagrama, oCEjercicio,    0, 250,  350, 520
	AgregarAlDiagrama oDiagrama, oConexion,   550, 420,  820, 540

	oDiagrama.Update()
	Repository.ReloadDiagram(oDiagrama.DiagramID)
	Repository.OpenDiagram(oDiagrama.DiagramID)

	MsgBox "Diagrama 'CU4 Gestionar Ejercicio' actualizado correctamente."

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

' Operación pública con 3 parámetros (ej. constructor con 3 dependencias)
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

' Operación PRIVADA con 2 parámetros (ej. subirArchivo del controlador)
sub AddOperation2Privado(oElement, sNombre, sParam1, sTipo1, sParam2, sTipo2, sRetorno)
	Dim oMet
	Set oMet = ObtenerOCrearMetodo(oElement, sNombre)
	oMet.ReturnType = sRetorno
	oMet.Visibility = "Private"
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
