Option Explicit

!INC Local Scripts.EAConstants-VBScript

'
' Script Name: ModeloDatos_BaseDatosGym
' Author:
' Purpose: Genera el diagrama de clases completo de la base de datos
'          (las 6 tablas de db/init.sql), replicando el layout de la
'          imagen de referencia pero con los atributos REALES del
'          schema. Se sacaron los campos que la imagen mostraba de más
'          y que NO existen en el proyecto:
'            - usuario: sin telefono, fecha_nacimiento, objetivo,
'              created_at (la tabla real solo tiene id, nombre,
'              apellido, email, password, rol).
'            - ejercicio: sin created_at (no existe esa columna).
'            - rutina: sin created_at (no existe esa columna).
'          created_at SÍ es real únicamente en "asignacion" (así está
'          en db/init.sql), por eso se mantiene solo ahí.
'          rutina_ejercicio y asignacion no tienen "id" propio: ambas
'          usan clave primaria compuesta.
' Date:
'

sub main

	Dim oParent
	Set oParent = GetParentPackage()

	Dim oPkg
	Set oPkg = GetOrCreatePackage(oParent, "Modelo de Datos - BaseDatosGym")

	' ---- Clases (una por tabla, atributos = columnas reales) ----
	Dim oCategoria, oEjercicio, oRutina, oRutinaEjercicio, oAsignacion, oUsuario
	Set oCategoria       = GetOrCreateElement(oPkg, "categoria_ejercicio", "Class")
	Set oEjercicio       = GetOrCreateElement(oPkg, "ejercicio", "Class")
	Set oRutina          = GetOrCreateElement(oPkg, "rutina", "Class")
	Set oRutinaEjercicio = GetOrCreateElement(oPkg, "rutina_ejercicio", "Class")
	Set oAsignacion      = GetOrCreateElement(oPkg, "asignacion", "Class")
	Set oUsuario         = GetOrCreateElement(oPkg, "usuario", "Class")

	AddAttribute oCategoria, "id", "int"
	AddAttribute oCategoria, "nombre", "string"

	AddAttribute oEjercicio, "id", "int"
	AddAttribute oEjercicio, "nombre", "string"
	AddAttribute oEjercicio, "descripcion", "string"
	AddAttribute oEjercicio, "grupo_muscular", "string"
	AddAttribute oEjercicio, "imagen_url", "string"
	AddAttribute oEjercicio, "video_url", "string"
	AddAttribute oEjercicio, "categoria_id", "int"

	AddAttribute oRutina, "id", "int"
	AddAttribute oRutina, "nombre", "string"
	AddAttribute oRutina, "descripcion", "string"
	AddAttribute oRutina, "duracion_semanas", "int"

	AddAttribute oRutinaEjercicio, "rutina_id", "int"
	AddAttribute oRutinaEjercicio, "ejercicio_id", "int"
	AddAttribute oRutinaEjercicio, "series", "int"
	AddAttribute oRutinaEjercicio, "repeticiones", "string"
	AddAttribute oRutinaEjercicio, "peso_sugerido", "string"
	AddAttribute oRutinaEjercicio, "orden", "int"
	AddAttribute oRutinaEjercicio, "notas", "string"

	AddAttribute oAsignacion, "usuario_id", "int"
	AddAttribute oAsignacion, "rutina_id", "int"
	AddAttribute oAsignacion, "fecha_inicio", "date"
	AddAttribute oAsignacion, "fecha_fin", "date"
	AddAttribute oAsignacion, "semana_numero", "int"
	AddAttribute oAsignacion, "estado", "string"
	AddAttribute oAsignacion, "notas", "string"
	AddAttribute oAsignacion, "created_at", "datetime"

	AddAttribute oUsuario, "id", "int"
	AddAttribute oUsuario, "nombre", "string"
	AddAttribute oUsuario, "apellido", "string"
	AddAttribute oUsuario, "email", "string"
	AddAttribute oUsuario, "password", "string"
	AddAttribute oUsuario, "rol", "string"

	' ---- Relaciones ----
	' categoria_ejercicio -> ejercicio: asociación normal 1 a 0..*
	AsociarConCardinalidad oCategoria, "1", oEjercicio, "0..*", "tiene"

	' ejercicio <-> rutina son muchos-a-muchos vía la tabla intermedia
	' rutina_ejercicio. NO se modela como "clase de asociación" UML
	' (Connector.AssociationClassID no existe en la Automation API de
	' EA, probado y confirmado con error). En cambio, se modelan las
	' 2 claves foráneas reales de rutina_ejercicio como 2 asociaciones
	' normales — es más preciso que la clase de asociación abstracta,
	' porque refleja el schema físico real: cada fila de
	' rutina_ejercicio pertenece a EXACTAMENTE una rutina y un
	' ejercicio (cardinalidad "1" del lado padre, "0..*" del lado hijo).
	AsociarConCardinalidad oRutina, "1", oRutinaEjercicio, "0..*", ""
	AsociarConCardinalidad oEjercicio, "1", oRutinaEjercicio, "0..*", ""

	' usuario <-> rutina vía la tabla intermedia real "asignacion".
	AsociarConCardinalidad oUsuario, "1", oAsignacion, "0..*", ""
	AsociarConCardinalidad oRutina, "1", oAsignacion, "0..*", ""

	' ---- Diagrama ----
	Dim oDiagrama
	Set oDiagrama = GetOrCreateDiagramTipo(oPkg, "class BaseDatosGym", "Class")

	AgregarAlDiagrama oDiagrama, oCategoria,        0,  60,  260, 200
	AgregarAlDiagrama oDiagrama, oRutinaEjercicio, 340,   0,  620, 220
	AgregarAlDiagrama oDiagrama, oAsignacion,      880,   0, 1180, 220
	AgregarAlDiagrama oDiagrama, oEjercicio,        20, 280,  300, 540
	AgregarAlDiagrama oDiagrama, oRutina,          460, 300,  740, 480
	AgregarAlDiagrama oDiagrama, oUsuario,         900, 260, 1180, 500

	Dim colorHueso
	colorHueso = RGB(250, 228, 216)
	PintarElemento oDiagrama, oCategoria, colorHueso
	PintarElemento oDiagrama, oEjercicio, colorHueso
	PintarElemento oDiagrama, oRutina, colorHueso
	PintarElemento oDiagrama, oRutinaEjercicio, colorHueso
	PintarElemento oDiagrama, oAsignacion, colorHueso
	PintarElemento oDiagrama, oUsuario, colorHueso

	oDiagrama.Update()
	Repository.ReloadDiagram(oDiagrama.DiagramID)
	Repository.OpenDiagram(oDiagrama.DiagramID)

	MsgBox "Diagrama 'class BaseDatosGym' generado con los atributos reales de db/init.sql."

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
' Helper genérico de elementos
' =====================================================
function GetOrCreateElement(oPkg, sNombre, sTipo)
	Dim oEl, i
	for i = 0 to oPkg.Elements.Count - 1
		Set oEl = oPkg.Elements.GetAt(i)
		if oEl.Name = sNombre and oEl.Type = sTipo then
			Set GetOrCreateElement = oEl
			exit function
		end if
	next

	Set oEl = oPkg.Elements.AddNew(sNombre, sTipo)
	oEl.Update()
	oPkg.Elements.Refresh()
	Set GetOrCreateElement = oEl
end function

' Atributo simple: sin notas, sin marca de PK (mismo criterio que los
' demás scripts de este proyecto).
sub AddAttribute(oElement, sNombre, sTipo)
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
	oAttr.Visibility = "Private"
	oAttr.Notes = ""
	oAttr.IsID = False
	oAttr.Pos = nPos
	oAttr.Update()
	oElement.Attributes.Refresh()
end sub

' =====================================================
' Helpers de diagrama
' =====================================================
function GetOrCreateDiagramTipo(oPkg, sNombre, sTipo)
	Dim oDiag, i
	for i = 0 to oPkg.Diagrams.Count - 1
		Set oDiag = oPkg.Diagrams.GetAt(i)
		if oDiag.Name = sNombre then
			Set GetOrCreateDiagramTipo = oDiag
			exit function
		end if
	next

	Set oDiag = oPkg.Diagrams.AddNew(sNombre, sTipo)
	oDiag.Update()
	oPkg.Diagrams.Refresh()
	Set GetOrCreateDiagramTipo = oDiag
end function

function RGB(r, g, b)
	RGB = r + (g * 256) + (b * 65536)
end function

sub PintarElemento(oDiagrama, oElemento, nColor)
	Dim oObj, i
	for i = 0 to oDiagrama.DiagramObjects.Count - 1
		Set oObj = oDiagrama.DiagramObjects.GetAt(i)
		if oObj.ElementID = oElemento.ElementID then
			oObj.BackgroundColor = nColor
			oObj.Update()
			exit for
		end if
	next
end sub

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

' =====================================================
' Asociación con cardinalidad en cada punta (ConnectorEnd.Cardinality
' es una propiedad documentada y estable de la Automation API, a
' diferencia de "Is Return"/"Return Value" de los mensajes de
' secuencia que sí investigamos y no eran seguros de scriptear).
' =====================================================
sub AsociarConCardinalidad(oCliente, sCardCliente, oProveedor, sCardProveedor, sNombre)
	Dim oConn, i, bExiste
	bExiste = False
	for i = 0 to oCliente.Connectors.Count - 1
		Set oConn = oCliente.Connectors.GetAt(i)
		if oConn.Type = "Association" and oConn.SupplierID = oProveedor.ElementID then
			bExiste = True
			exit for
		end if
	next

	if not bExiste then
		Set oConn = oCliente.Connectors.AddNew(sNombre, "Association")
		oConn.SupplierID = oProveedor.ElementID
		oConn.Update()
		oCliente.Connectors.Refresh()
	end if

	oConn.Name = sNombre
	oConn.ClientEnd.Cardinality = sCardCliente
	oConn.SupplierEnd.Cardinality = sCardProveedor
	oConn.ClientEnd.Update()
	oConn.SupplierEnd.Update()
	oConn.Update()
end sub

main
