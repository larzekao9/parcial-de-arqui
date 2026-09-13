Option Explicit

!INC Local Scripts.EAConstants-VBScript

'
' Script Name: CU_GestionarEjercicio_Secuencia
' Author:
' Purpose: Diagrama de SECUENCIA de "Gestionar Ejercicio", mismo
'          patrón que CU_GestionarUsuario_Secuencia.vbs, con la
'          diferencia de que el controlador usa DOS modelos:
'          MEjercicio (CRUD principal) y MCategoria (solo para poblar
'          el <select> de categorías, ya recibido construido desde
'          router.php, no se instancia de nuevo acá).
'
'          También incluye subirArchivo(campo, actual): string, el
'          único método PRIVADO real de EjercicioController.php, que
'          se llama a sí mismo (self-call) antes de registrar/actualizar
'          cuando hay imagen/video en el form.
'
'          Fixes de las corridas anteriores del CU1 ya aplicados acá:
'          clasificadores propios de este diagrama, Connector.SequenceNo
'          correlativo, lifeline "BD" con "Query...", clicks como
'          disparador del actor.
' Date:
'

sub main

	Dim oParent
	Set oParent = GetParentPackage()

	Dim oCasoUso
	Set oCasoUso = GetOrCreatePackage(oParent, "CU4 Gestionar Ejercicio - Detalle Procedimental")

	Dim oPkgSecuencia
	Set oPkgSecuencia = GetOrCreatePackage(oCasoUso, "Diagrama de Secuencia")

	Dim oAdmin, oCEjercicio, oVEjercicio, oMEjercicio, oMCategoria, oConexion
	Set oAdmin      = GetOrCreateActor(oPkgSecuencia, "Administrador")
	Set oCEjercicio = GetOrCreateClass(oPkgSecuencia, "CEjercicio")
	Set oVEjercicio = GetOrCreateClass(oPkgSecuencia, "VEjercicio")
	Set oMEjercicio = GetOrCreateClass(oPkgSecuencia, "MEjercicio")
	Set oMCategoria = GetOrCreateClass(oPkgSecuencia, "MCategoria")
	Set oConexion   = GetOrCreateClass(oPkgSecuencia, "BD")

	Dim oDiagrama
	Set oDiagrama = GetOrCreateSequenceDiagram(oPkgSecuencia, "SEC CU4 - Gestionar Ejercicios")

	AgregarAlDiagrama oDiagrama, oAdmin,      0,   0,  100, 60
	AgregarAlDiagrama oDiagrama, oCEjercicio, 180,   0,  420, 60
	AgregarAlDiagrama oDiagrama, oVEjercicio, 500,   0,  740, 60
	AgregarAlDiagrama oDiagrama, oMEjercicio, 820,   0, 1060, 60
	AgregarAlDiagrama oDiagrama, oMCategoria,1140,   0, 1380, 60
	AgregarAlDiagrama oDiagrama, oConexion,  1460,   0, 1640, 60

	Dim colorAzulClaro
	colorAzulClaro = RGB(187, 214, 251)
	PintarElemento oDiagrama, oCEjercicio, colorAzulClaro
	PintarElemento oDiagrama, oVEjercicio, colorAzulClaro
	PintarElemento oDiagrama, oMEjercicio, colorAzulClaro
	PintarElemento oDiagrama, oMCategoria, colorAzulClaro
	PintarElemento oDiagrama, oConexion, colorAzulClaro

	LimpiarMensajes oCEjercicio
	LimpiarMensajes oVEjercicio
	LimpiarMensajes oMEjercicio
	LimpiarMensajes oMCategoria
	LimpiarMensajes oConexion
	LimpiarMensajes oAdmin

	' ================================================================
	' 0) Construcción. categoriaModel llega YA CONSTRUIDO como parámetro
	'    (router.php lo comparte con CategoriaController), por eso acá
	'    no hay "new MCategoria()".
	' ================================================================
	AgregarMensaje oCEjercicio, oCEjercicio, "__construct()"
	AgregarMensaje oCEjercicio, oMEjercicio, "__construct()  [new EjercicioModel()]"
	AgregarMensaje oMEjercicio, oConexion, "conectar()..."
	AgregarMensaje oConexion, oMEjercicio, "PDO"
	AgregarMensaje oMEjercicio, oCEjercicio, "ok"
	AgregarMensaje oCEjercicio, oVEjercicio, "new VEjercicio()"

	' ================================================================
	' 1) click en Ver ejercicios  ->  obtenerTodos()
	'    (consulta MEjercicio y también MCategoria, para el <select>)
	' ================================================================
	AgregarMensaje oAdmin, oCEjercicio, "click en Ver ejercicios"
	AgregarMensaje oCEjercicio, oMEjercicio, "obtenerTodos()"
	AgregarMensaje oMEjercicio, oConexion, "Query..."
	AgregarMensaje oConexion, oMEjercicio, "filas"
	AgregarMensaje oMEjercicio, oCEjercicio, "ejercicios"
	AgregarMensaje oCEjercicio, oMCategoria, "obtenerTodos()"
	AgregarMensaje oMCategoria, oConexion, "Query..."
	AgregarMensaje oConexion, oMCategoria, "filas"
	AgregarMensaje oMCategoria, oCEjercicio, "categorias"
	AgregarMensaje oCEjercicio, oVEjercicio, "render(ejercicios, [editando=>null, categorias=>categorias])"

	' ================================================================
	' 2) click en Crear  ->  crear(datos)  [subirArchivo + registrar]
	' ================================================================
	AgregarMensaje oAdmin, oCEjercicio, "click en Crear"
	AgregarMensaje oCEjercicio, oCEjercicio, "subirArchivo(""imagen"", actual): string"
	AgregarMensaje oCEjercicio, oCEjercicio, "subirArchivo(""video"", actual): string"
	AgregarMensaje oCEjercicio, oMEjercicio, "registrar(d: array)"
	AgregarMensaje oMEjercicio, oConexion, "Query..."
	AgregarMensaje oConexion, oMEjercicio, "id"
	AgregarMensaje oMEjercicio, oCEjercicio, "id"
	AgregarMensaje oCEjercicio, oMEjercicio, "obtenerTodos()"
	AgregarMensaje oMEjercicio, oConexion, "Query..."
	AgregarMensaje oConexion, oMEjercicio, "filas"
	AgregarMensaje oMEjercicio, oCEjercicio, "ejercicios"
	AgregarMensaje oCEjercicio, oMCategoria, "obtenerTodos()"
	AgregarMensaje oMCategoria, oConexion, "Query..."
	AgregarMensaje oConexion, oMCategoria, "filas"
	AgregarMensaje oMCategoria, oCEjercicio, "categorias"
	AgregarMensaje oCEjercicio, oVEjercicio, "render(ejercicios, [editando=>null, categorias=>categorias])"

	' ================================================================
	' 3) click en Editar  ->  actualizar(id, datos)  [subirArchivo + actualizar]
	' ================================================================
	AgregarMensaje oAdmin, oCEjercicio, "click en Editar"
	AgregarMensaje oCEjercicio, oCEjercicio, "subirArchivo(""imagen"", actual): string"
	AgregarMensaje oCEjercicio, oCEjercicio, "subirArchivo(""video"", actual): string"
	AgregarMensaje oCEjercicio, oMEjercicio, "actualizar(id: int, d: array)"
	AgregarMensaje oMEjercicio, oConexion, "Query..."
	AgregarMensaje oConexion, oMEjercicio, "ok"
	AgregarMensaje oMEjercicio, oCEjercicio, "ok"
	AgregarMensaje oCEjercicio, oMEjercicio, "obtenerTodos()"
	AgregarMensaje oMEjercicio, oConexion, "Query..."
	AgregarMensaje oConexion, oMEjercicio, "filas"
	AgregarMensaje oMEjercicio, oCEjercicio, "ejercicios"
	AgregarMensaje oCEjercicio, oMCategoria, "obtenerTodos()"
	AgregarMensaje oMCategoria, oConexion, "Query..."
	AgregarMensaje oConexion, oMCategoria, "filas"
	AgregarMensaje oMCategoria, oCEjercicio, "categorias"
	AgregarMensaje oCEjercicio, oVEjercicio, "render(ejercicios, [editando=>null, categorias=>categorias])"

	' ================================================================
	' 4) click en Eliminar  ->  eliminar(id)
	' ================================================================
	AgregarMensaje oAdmin, oCEjercicio, "click en Eliminar"
	AgregarMensaje oCEjercicio, oMEjercicio, "eliminar(id: int)"
	AgregarMensaje oMEjercicio, oConexion, "Query..."
	AgregarMensaje oConexion, oMEjercicio, "ok"
	AgregarMensaje oMEjercicio, oCEjercicio, "ok"
	AgregarMensaje oCEjercicio, oMEjercicio, "obtenerTodos()"
	AgregarMensaje oMEjercicio, oConexion, "Query..."
	AgregarMensaje oConexion, oMEjercicio, "filas"
	AgregarMensaje oMEjercicio, oCEjercicio, "ejercicios"
	AgregarMensaje oCEjercicio, oMCategoria, "obtenerTodos()"
	AgregarMensaje oMCategoria, oConexion, "Query..."
	AgregarMensaje oConexion, oMCategoria, "filas"
	AgregarMensaje oMCategoria, oCEjercicio, "categorias"
	AgregarMensaje oCEjercicio, oVEjercicio, "render(ejercicios, [editando=>null, categorias=>categorias])"

	oDiagrama.Update()
	Repository.ReloadDiagram(oDiagrama.DiagramID)
	Repository.OpenDiagram(oDiagrama.DiagramID)

	MsgBox "Diagrama 'SEC CU4 - Gestionar Ejercicios' regenerado."

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
