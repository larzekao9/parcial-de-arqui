Option Explicit

!INC Local Scripts.EAConstants-VBScript

'
' Script Name: CU_AsignarRutinaAUsuario_Secuencia
' Author:
' Purpose: Diagrama de SECUENCIA de "Asignar Rutina a Usuario".
'          El controlador tiene instancia de MUsuario, MRutina,
'          MAsignacion y VAsignacion (los 4 recién construidos en el
'          constructor, según router.php: "new AsignacionController(
'          new UsuarioModel(), new RutinaModel(), new AsignacionModel(),
'          new AsignacionView())" — instancias propias, no compartidas
'          con UsuarioController/RutinaController).
'
'          Simplificación: se muestra el camino con un cliente ya
'          elegido (agregarAsignacion/eliminarAsignacion), sin el
'          combined fragment de "lista vacía sin cliente seleccionado".
' Date:
'

sub main

	Dim oParent
	Set oParent = GetParentPackage()

	Dim oCasoUso
	Set oCasoUso = GetOrCreatePackage(oParent, "CU5 Asignar Rutina a Usuario - Detalle Procedimental")

	Dim oPkgSecuencia
	Set oPkgSecuencia = GetOrCreatePackage(oCasoUso, "Diagrama de Secuencia")

	Dim oAdmin, oCAsignacion, oVAsignacion, oMUsuario, oMRutina, oMAsignacion, oConexion
	Set oAdmin       = GetOrCreateActor(oPkgSecuencia, "Administrador")
	Set oCAsignacion = GetOrCreateClass(oPkgSecuencia, "CAsignacion")
	Set oVAsignacion = GetOrCreateClass(oPkgSecuencia, "VAsignacion")
	Set oMUsuario    = GetOrCreateClass(oPkgSecuencia, "MUsuario")
	Set oMRutina     = GetOrCreateClass(oPkgSecuencia, "MRutina")
	Set oMAsignacion = GetOrCreateClass(oPkgSecuencia, "MAsignacion")
	Set oConexion    = GetOrCreateClass(oPkgSecuencia, "BD")

	Dim oDiagrama
	Set oDiagrama = GetOrCreateSequenceDiagram(oPkgSecuencia, "SEC CU5 - Asignar Rutina a Usuario")

	AgregarAlDiagrama oDiagrama, oAdmin,       0,   0,  100, 60
	AgregarAlDiagrama oDiagrama, oCAsignacion,180,   0,  460, 60
	AgregarAlDiagrama oDiagrama, oVAsignacion,540,   0,  820, 60
	AgregarAlDiagrama oDiagrama, oMUsuario,   900,   0, 1140, 60
	AgregarAlDiagrama oDiagrama, oMRutina,   1220,   0, 1460, 60
	AgregarAlDiagrama oDiagrama, oMAsignacion,1540,   0, 1820, 60
	AgregarAlDiagrama oDiagrama, oConexion,  1900,   0, 2080, 60

	Dim colorAzulClaro
	colorAzulClaro = RGB(187, 214, 251)
	PintarElemento oDiagrama, oCAsignacion, colorAzulClaro
	PintarElemento oDiagrama, oVAsignacion, colorAzulClaro
	PintarElemento oDiagrama, oMUsuario, colorAzulClaro
	PintarElemento oDiagrama, oMRutina, colorAzulClaro
	PintarElemento oDiagrama, oMAsignacion, colorAzulClaro
	PintarElemento oDiagrama, oConexion, colorAzulClaro

	LimpiarMensajes oCAsignacion
	LimpiarMensajes oVAsignacion
	LimpiarMensajes oMUsuario
	LimpiarMensajes oMRutina
	LimpiarMensajes oMAsignacion
	LimpiarMensajes oConexion
	LimpiarMensajes oAdmin

	' ================================================================
	' 0) Construcción: los 3 modelos se crean nuevos acá (no se
	'    comparten con otros controladores).
	' ================================================================
	AgregarMensaje oCAsignacion, oCAsignacion, "__construct()"
	AgregarMensaje oCAsignacion, oMUsuario, "__construct()  [new UsuarioModel()]"
	AgregarMensaje oMUsuario, oConexion, "conectar()..."
	AgregarMensaje oConexion, oMUsuario, "PDO"
	AgregarMensaje oMUsuario, oCAsignacion, "ok"
	AgregarMensaje oCAsignacion, oMRutina, "__construct()  [new RutinaModel()]"
	AgregarMensaje oMRutina, oConexion, "conectar()..."
	AgregarMensaje oConexion, oMRutina, "PDO"
	AgregarMensaje oMRutina, oCAsignacion, "ok"
	AgregarMensaje oCAsignacion, oMAsignacion, "__construct()  [new AsignacionModel()]"
	AgregarMensaje oMAsignacion, oConexion, "conectar()..."
	AgregarMensaje oConexion, oMAsignacion, "PDO"
	AgregarMensaje oMAsignacion, oCAsignacion, "ok"
	AgregarMensaje oCAsignacion, oVAsignacion, "new AsignacionView()"

	' ================================================================
	' 1) click en Ver cliente (elige uno)  ->  obtenerPorId(usuarioId)
	' ================================================================
	AgregarMensaje oAdmin, oCAsignacion, "click en Ver cliente"
	AgregarMensaje oCAsignacion, oMUsuario, "obtenerTodos()"
	AgregarMensaje oMUsuario, oConexion, "Query..."
	AgregarMensaje oConexion, oMUsuario, "filas"
	AgregarMensaje oMUsuario, oCAsignacion, "usuarios"
	AgregarMensaje oCAsignacion, oMUsuario, "obtenerPorId(usuarioId: int)"
	AgregarMensaje oMUsuario, oConexion, "Query..."
	AgregarMensaje oConexion, oMUsuario, "fila"
	AgregarMensaje oMUsuario, oCAsignacion, "usuario"
	AgregarMensaje oCAsignacion, oMRutina, "obtenerTodos()"
	AgregarMensaje oMRutina, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutina, "filas"
	AgregarMensaje oMRutina, oCAsignacion, "rutinas"
	AgregarMensaje oCAsignacion, oMAsignacion, "obtenerPorUsuario(usuarioId: int)"
	AgregarMensaje oMAsignacion, oConexion, "Query..."
	AgregarMensaje oConexion, oMAsignacion, "filas"
	AgregarMensaje oMAsignacion, oCAsignacion, "asignadas"
	AgregarMensaje oCAsignacion, oVAsignacion, "render(usuario, usuarios, rutinas, asignadas)"

	' ================================================================
	' 2) click en Asignar rutina  ->  agregarAsignacion(datos)
	' ================================================================
	AgregarMensaje oAdmin, oCAsignacion, "click en Asignar rutina"
	AgregarMensaje oCAsignacion, oMAsignacion, "agregar(d: array)"
	AgregarMensaje oMAsignacion, oConexion, "Query..."
	AgregarMensaje oConexion, oMAsignacion, "ok"
	AgregarMensaje oMAsignacion, oCAsignacion, "ok"
	AgregarMensaje oCAsignacion, oMUsuario, "obtenerTodos()"
	AgregarMensaje oMUsuario, oConexion, "Query..."
	AgregarMensaje oConexion, oMUsuario, "filas"
	AgregarMensaje oMUsuario, oCAsignacion, "usuarios"
	AgregarMensaje oCAsignacion, oMUsuario, "obtenerPorId(usuarioId: int)"
	AgregarMensaje oMUsuario, oConexion, "Query..."
	AgregarMensaje oConexion, oMUsuario, "fila"
	AgregarMensaje oMUsuario, oCAsignacion, "usuario"
	AgregarMensaje oCAsignacion, oMRutina, "obtenerTodos()"
	AgregarMensaje oMRutina, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutina, "filas"
	AgregarMensaje oMRutina, oCAsignacion, "rutinas"
	AgregarMensaje oCAsignacion, oMAsignacion, "obtenerPorUsuario(usuarioId: int)"
	AgregarMensaje oMAsignacion, oConexion, "Query..."
	AgregarMensaje oConexion, oMAsignacion, "filas"
	AgregarMensaje oMAsignacion, oCAsignacion, "asignadas"
	AgregarMensaje oCAsignacion, oVAsignacion, "render(usuario, usuarios, rutinas, asignadas)"

	' ================================================================
	' 3) click en Quitar rutina  ->  eliminarAsignacion(usuarioId, rutinaId, fechaInicio)
	' ================================================================
	AgregarMensaje oAdmin, oCAsignacion, "click en Quitar rutina"
	AgregarMensaje oCAsignacion, oMAsignacion, "eliminar(usuarioId: int, rutinaId: int, fechaInicio: string)"
	AgregarMensaje oMAsignacion, oConexion, "Query..."
	AgregarMensaje oConexion, oMAsignacion, "ok"
	AgregarMensaje oMAsignacion, oCAsignacion, "ok"
	AgregarMensaje oCAsignacion, oMUsuario, "obtenerTodos()"
	AgregarMensaje oMUsuario, oConexion, "Query..."
	AgregarMensaje oConexion, oMUsuario, "filas"
	AgregarMensaje oMUsuario, oCAsignacion, "usuarios"
	AgregarMensaje oCAsignacion, oMUsuario, "obtenerPorId(usuarioId: int)"
	AgregarMensaje oMUsuario, oConexion, "Query..."
	AgregarMensaje oConexion, oMUsuario, "fila"
	AgregarMensaje oMUsuario, oCAsignacion, "usuario"
	AgregarMensaje oCAsignacion, oMRutina, "obtenerTodos()"
	AgregarMensaje oMRutina, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutina, "filas"
	AgregarMensaje oMRutina, oCAsignacion, "rutinas"
	AgregarMensaje oCAsignacion, oMAsignacion, "obtenerPorUsuario(usuarioId: int)"
	AgregarMensaje oMAsignacion, oConexion, "Query..."
	AgregarMensaje oConexion, oMAsignacion, "filas"
	AgregarMensaje oMAsignacion, oCAsignacion, "asignadas"
	AgregarMensaje oCAsignacion, oVAsignacion, "render(usuario, usuarios, rutinas, asignadas)"

	oDiagrama.Update()
	Repository.ReloadDiagram(oDiagrama.DiagramID)
	Repository.OpenDiagram(oDiagrama.DiagramID)

	MsgBox "Diagrama 'SEC CU5 - Asignar Rutina a Usuario' regenerado."

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
