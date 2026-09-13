Option Explicit

!INC Local Scripts.EAConstants-VBScript

'
' Script Name: CU_GestionarCategoria_Secuencia
' Author:
' Purpose: Diagrama de SECUENCIA de "Gestionar Categoria", mismo
'          patrón que CU_GestionarUsuario_Secuencia.vbs:
'            - Clasificadores propios de este diagrama (no comparte
'              clases con el diagrama de clases CU2, para que sus
'              conectores no interfieran).
'            - Connector.SequenceNo correlativo en cada mensaje (sin
'              esto EA no respeta el orden y los mezcla).
'            - Lifeline "BD" con mensajes "Query..." genéricos.
'            - El actor dispara con clicks ("click en Ver categorías",
'              "click en Crear", etc.), no con nombres de método crudos.
'          Basado en backend/controllers/CategoriaController.php +
'          backend/models/CategoriaModel.php reales.
' Date:
'

sub main

	Dim oParent
	Set oParent = GetParentPackage()

	Dim oCasoUso
	Set oCasoUso = GetOrCreatePackage(oParent, "CU2 Gestionar Categoria - Detalle Procedimental")

	Dim oPkgSecuencia
	Set oPkgSecuencia = GetOrCreatePackage(oCasoUso, "Diagrama de Secuencia")

	Dim oAdmin, oCCategoria, oVCategoria, oMCategoria, oConexion
	Set oAdmin      = GetOrCreateActor(oPkgSecuencia, "Administrador")
	Set oCCategoria = GetOrCreateClass(oPkgSecuencia, "CCategoria")
	Set oVCategoria = GetOrCreateClass(oPkgSecuencia, "VCategoria")
	Set oMCategoria = GetOrCreateClass(oPkgSecuencia, "MCategoria")
	Set oConexion   = GetOrCreateClass(oPkgSecuencia, "BD")

	Dim oDiagrama
	Set oDiagrama = GetOrCreateSequenceDiagram(oPkgSecuencia, "SEC CU2 - Gestionar Categorias")

	AgregarAlDiagrama oDiagrama, oAdmin,      0,   0,  100, 60
	AgregarAlDiagrama oDiagrama, oCCategoria, 180,   0,  420, 60
	AgregarAlDiagrama oDiagrama, oVCategoria, 500,   0,  740, 60
	AgregarAlDiagrama oDiagrama, oMCategoria, 820,   0, 1060, 60
	AgregarAlDiagrama oDiagrama, oConexion,  1140,   0, 1320, 60

	Dim colorAzulClaro
	colorAzulClaro = RGB(187, 214, 251)
	PintarElemento oDiagrama, oCCategoria, colorAzulClaro
	PintarElemento oDiagrama, oVCategoria, colorAzulClaro
	PintarElemento oDiagrama, oMCategoria, colorAzulClaro
	PintarElemento oDiagrama, oConexion, colorAzulClaro

	LimpiarMensajes oCCategoria
	LimpiarMensajes oVCategoria
	LimpiarMensajes oMCategoria
	LimpiarMensajes oConexion
	LimpiarMensajes oAdmin

	' ================================================================
	' 0) Construcción (Vista inicializándose, no es acción del usuario)
	' ================================================================
	AgregarMensaje oCCategoria, oCCategoria, "__construct()"
	AgregarMensaje oCCategoria, oMCategoria, "__construct()  [new CategoriaModel()]"
	AgregarMensaje oMCategoria, oConexion, "conectar()..."
	AgregarMensaje oConexion, oMCategoria, "PDO"
	AgregarMensaje oMCategoria, oCCategoria, "ok"
	AgregarMensaje oCCategoria, oVCategoria, "new VCategoria()"

	' ================================================================
	' 1) click en Ver categorías  ->  obtenerTodos()
	' ================================================================
	AgregarMensaje oAdmin, oCCategoria, "click en Ver categorías"
	AgregarMensaje oCCategoria, oMCategoria, "obtenerTodos()"
	AgregarMensaje oMCategoria, oConexion, "Query..."
	AgregarMensaje oConexion, oMCategoria, "filas"
	AgregarMensaje oMCategoria, oCCategoria, "categorias"
	AgregarMensaje oCCategoria, oVCategoria, "render(categorias, [editando=>null])"

	' ================================================================
	' 2) click en Crear  ->  crear(datos)  [registrar en el modelo]
	' ================================================================
	AgregarMensaje oAdmin, oCCategoria, "click en Crear"
	AgregarMensaje oCCategoria, oMCategoria, "registrar(datos: array)"
	AgregarMensaje oMCategoria, oConexion, "Query..."
	AgregarMensaje oConexion, oMCategoria, "id"
	AgregarMensaje oMCategoria, oCCategoria, "id"
	AgregarMensaje oCCategoria, oMCategoria, "obtenerTodos()"
	AgregarMensaje oMCategoria, oConexion, "Query..."
	AgregarMensaje oConexion, oMCategoria, "filas"
	AgregarMensaje oMCategoria, oCCategoria, "categorias"
	AgregarMensaje oCCategoria, oVCategoria, "render(categorias, [editando=>null])"

	' ================================================================
	' 3) click en Editar  ->  actualizar(id, datos)
	' ================================================================
	AgregarMensaje oAdmin, oCCategoria, "click en Editar"
	AgregarMensaje oCCategoria, oMCategoria, "actualizar(id: int, datos: array)"
	AgregarMensaje oMCategoria, oConexion, "Query..."
	AgregarMensaje oConexion, oMCategoria, "ok"
	AgregarMensaje oMCategoria, oCCategoria, "ok"
	AgregarMensaje oCCategoria, oMCategoria, "obtenerTodos()"
	AgregarMensaje oMCategoria, oConexion, "Query..."
	AgregarMensaje oConexion, oMCategoria, "filas"
	AgregarMensaje oMCategoria, oCCategoria, "categorias"
	AgregarMensaje oCCategoria, oVCategoria, "render(categorias, [editando=>null])"

	' ================================================================
	' 4) click en Eliminar  ->  eliminar(id)
	' ================================================================
	AgregarMensaje oAdmin, oCCategoria, "click en Eliminar"
	AgregarMensaje oCCategoria, oMCategoria, "eliminar(id: int)"
	AgregarMensaje oMCategoria, oConexion, "Query..."
	AgregarMensaje oConexion, oMCategoria, "ok"
	AgregarMensaje oMCategoria, oCCategoria, "ok"
	AgregarMensaje oCCategoria, oMCategoria, "obtenerTodos()"
	AgregarMensaje oMCategoria, oConexion, "Query..."
	AgregarMensaje oConexion, oMCategoria, "filas"
	AgregarMensaje oMCategoria, oCCategoria, "categorias"
	AgregarMensaje oCCategoria, oVCategoria, "render(categorias, [editando=>null])"

	oDiagrama.Update()
	Repository.ReloadDiagram(oDiagrama.DiagramID)
	Repository.OpenDiagram(oDiagrama.DiagramID)

	MsgBox "Diagrama 'SEC CU2 - Gestionar Categorias' regenerado."

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
