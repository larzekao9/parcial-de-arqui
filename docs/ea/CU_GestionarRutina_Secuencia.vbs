Option Explicit

!INC Local Scripts.EAConstants-VBScript

'
' Script Name: CU_GestionarRutina_Secuencia
' Author:
' Purpose: Diagrama de SECUENCIA de "Gestionar Rutina", mismo patrón
'          que CU_GestionarCategoria_Secuencia.vbs (CRUD simple, un
'          solo modelo). Basado en backend/controllers/RutinaController.php
'          + backend/models/RutinaModel.php reales.
' Date:
'

sub main

	Dim oParent
	Set oParent = GetParentPackage()

	Dim oCasoUso
	Set oCasoUso = GetOrCreatePackage(oParent, "CU3 Gestionar Rutina - Detalle Procedimental")

	Dim oPkgSecuencia
	Set oPkgSecuencia = GetOrCreatePackage(oCasoUso, "Diagrama de Secuencia")

	Dim oAdmin, oCRutina, oVRutina, oMRutina, oConexion
	Set oAdmin   = GetOrCreateActor(oPkgSecuencia, "Administrador")
	Set oCRutina = GetOrCreateClass(oPkgSecuencia, "CRutina")
	Set oVRutina = GetOrCreateClass(oPkgSecuencia, "VRutina")
	Set oMRutina = GetOrCreateClass(oPkgSecuencia, "MRutina")
	Set oConexion = GetOrCreateClass(oPkgSecuencia, "BD")

	Dim oDiagrama
	Set oDiagrama = GetOrCreateSequenceDiagram(oPkgSecuencia, "SEC CU3 - Gestionar Rutinas")

	AgregarAlDiagrama oDiagrama, oAdmin,     0,   0,  100, 60
	AgregarAlDiagrama oDiagrama, oCRutina, 180,   0,  420, 60
	AgregarAlDiagrama oDiagrama, oVRutina, 500,   0,  740, 60
	AgregarAlDiagrama oDiagrama, oMRutina, 820,   0, 1060, 60
	AgregarAlDiagrama oDiagrama, oConexion,1140,   0, 1320, 60

	Dim colorAzulClaro
	colorAzulClaro = RGB(187, 214, 251)
	PintarElemento oDiagrama, oCRutina, colorAzulClaro
	PintarElemento oDiagrama, oVRutina, colorAzulClaro
	PintarElemento oDiagrama, oMRutina, colorAzulClaro
	PintarElemento oDiagrama, oConexion, colorAzulClaro

	LimpiarMensajes oCRutina
	LimpiarMensajes oVRutina
	LimpiarMensajes oMRutina
	LimpiarMensajes oConexion
	LimpiarMensajes oAdmin

	' ================================================================
	' 0) Construcción
	' ================================================================
	AgregarMensaje oCRutina, oCRutina, "__construct()"
	AgregarMensaje oCRutina, oMRutina, "__construct()  [new RutinaModel()]"
	AgregarMensaje oMRutina, oConexion, "conectar()..."
	AgregarMensaje oConexion, oMRutina, "PDO"
	AgregarMensaje oMRutina, oCRutina, "ok"
	AgregarMensaje oCRutina, oVRutina, "new VRutina()"

	' ================================================================
	' 1) click en Ver rutinas  ->  obtenerTodos()
	' ================================================================
	AgregarMensaje oAdmin, oCRutina, "click en Ver rutinas"
	AgregarMensaje oCRutina, oMRutina, "obtenerTodos()"
	AgregarMensaje oMRutina, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutina, "filas"
	AgregarMensaje oMRutina, oCRutina, "rutinas"
	AgregarMensaje oCRutina, oVRutina, "render(rutinas, [editando=>null])"

	' ================================================================
	' 2) click en Crear  ->  crear(datos)  [registrar en el modelo]
	' ================================================================
	AgregarMensaje oAdmin, oCRutina, "click en Crear"
	AgregarMensaje oCRutina, oMRutina, "registrar(d: array)"
	AgregarMensaje oMRutina, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutina, "id"
	AgregarMensaje oMRutina, oCRutina, "id"
	AgregarMensaje oCRutina, oMRutina, "obtenerTodos()"
	AgregarMensaje oMRutina, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutina, "filas"
	AgregarMensaje oMRutina, oCRutina, "rutinas"
	AgregarMensaje oCRutina, oVRutina, "render(rutinas, [editando=>null])"

	' ================================================================
	' 3) click en Editar  ->  actualizar(id, datos)
	' ================================================================
	AgregarMensaje oAdmin, oCRutina, "click en Editar"
	AgregarMensaje oCRutina, oMRutina, "actualizar(id: int, d: array)"
	AgregarMensaje oMRutina, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutina, "ok"
	AgregarMensaje oMRutina, oCRutina, "ok"
	AgregarMensaje oCRutina, oMRutina, "obtenerTodos()"
	AgregarMensaje oMRutina, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutina, "filas"
	AgregarMensaje oMRutina, oCRutina, "rutinas"
	AgregarMensaje oCRutina, oVRutina, "render(rutinas, [editando=>null])"

	' ================================================================
	' 4) click en Eliminar  ->  eliminar(id)
	' ================================================================
	AgregarMensaje oAdmin, oCRutina, "click en Eliminar"
	AgregarMensaje oCRutina, oMRutina, "eliminar(id: int)"
	AgregarMensaje oMRutina, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutina, "ok"
	AgregarMensaje oMRutina, oCRutina, "ok"
	AgregarMensaje oCRutina, oMRutina, "obtenerTodos()"
	AgregarMensaje oMRutina, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutina, "filas"
	AgregarMensaje oMRutina, oCRutina, "rutinas"
	AgregarMensaje oCRutina, oVRutina, "render(rutinas, [editando=>null])"

	oDiagrama.Update()
	Repository.ReloadDiagram(oDiagrama.DiagramID)
	Repository.OpenDiagram(oDiagrama.DiagramID)

	MsgBox "Diagrama 'SEC CU3 - Gestionar Rutinas' regenerado."

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
' Helpers de clases / actores
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

function GetOrCreateActor(oPkg, sNombre)
	Dim oEl, i
	for i = 0 to oPkg.Elements.Count - 1
		Set oEl = oPkg.Elements.GetAt(i)
		if oEl.Name = sNombre and oEl.Type = "Actor" then
			Set GetOrCreateActor = oEl
			exit function
		end if
	next

	Set oEl = oPkg.Elements.AddNew(sNombre, "Actor")
	oEl.Update()
	oPkg.Elements.Refresh()
	Set GetOrCreateActor = oEl
end function

' =====================================================
' Helpers de diagrama de secuencia
' =====================================================
function GetOrCreateSequenceDiagram(oPkg, sNombre)
	Dim oDiag, i
	for i = 0 to oPkg.Diagrams.Count - 1
		Set oDiag = oPkg.Diagrams.GetAt(i)
		if oDiag.Name = sNombre then
			Set GetOrCreateSequenceDiagram = oDiag
			exit function
		end if
	next

	Set oDiag = oPkg.Diagrams.AddNew(sNombre, "Sequence")
	oDiag.Update()
	oPkg.Diagrams.Refresh()
	Set GetOrCreateSequenceDiagram = oDiag
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

sub LimpiarMensajes(oElemento)
	Dim i
	for i = oElemento.Connectors.Count - 1 to 0 step -1
		if oElemento.Connectors.GetAt(i).Type = "Sequence" and oElemento.Connectors.GetAt(i).ClientID = oElemento.ElementID then
			oElemento.Connectors.Delete(i)
		end if
	next
	oElemento.Connectors.Refresh()
end sub

Dim gSeqNo
gSeqNo = 0

sub AgregarMensaje(oOrigen, oDestino, sTexto)
	Dim oMsg
	gSeqNo = gSeqNo + 10
	Set oMsg = oOrigen.Connectors.AddNew(sTexto, "Sequence")
	oMsg.ClientID = oOrigen.ElementID
	oMsg.SupplierID = oDestino.ElementID
	oMsg.SequenceNo = gSeqNo
	oMsg.Update()
	oOrigen.Connectors.Refresh()
end sub

main
