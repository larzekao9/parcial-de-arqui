Option Explicit

!INC Local Scripts.EAConstants-VBScript

'
' Script Name: CU_ConsultarEntrenamiento_Secuencia
' Author:
' Purpose: Diagrama de SECUENCIA de "Consultar Entrenamiento" (pantalla
'          "Mis Entrenamientos" del rol cliente). Actor "Cliente" (no
'          "Administrador": esta pantalla la usa el usuario final).
'
'          El controlador tiene instancia de MAsignacion, MRutina,
'          MRutinaEjercicio y VEntrenamiento, los 4 recién construidos
'          en su constructor según router.php: "new EntrenamientoController(
'          new AsignacionModel(), new RutinaModel(), new RutinaEjercicioModel(),
'          new EntrenamientoView())" — instancias propias, no compartidas
'          con otros controladores.
'
'          Único método público real: misEntrenamientos(usuarioId), que
'          por cada asignación del usuario busca la rutina completa y
'          sus ejercicios (se muestra una sola iteración representativa,
'          no el loop completo).
'
'          Mismos fixes que el resto de los diagramas de secuencia de
'          este proyecto: clasificadores propios de este diagrama,
'          Connector.SequenceNo correlativo, lifeline "BD" con "Query...".
' Date:
'

sub main

	Dim oParent
	Set oParent = GetParentPackage()

	Dim oCasoUso
	Set oCasoUso = GetOrCreatePackage(oParent, "CU7 Consultar Entrenamiento - Detalle Procedimental")

	Dim oPkgSecuencia
	Set oPkgSecuencia = GetOrCreatePackage(oCasoUso, "Diagrama de Secuencia")

	Dim oCliente, oCEntrenamiento, oVEntrenamiento, oMAsignacion, oMRutina, oMRutinaEj, oConexion
	Set oCliente        = GetOrCreateActor(oPkgSecuencia, "Cliente")
	Set oCEntrenamiento = GetOrCreateClass(oPkgSecuencia, "CEntrenamiento")
	Set oVEntrenamiento = GetOrCreateClass(oPkgSecuencia, "VEntrenamiento")
	Set oMAsignacion    = GetOrCreateClass(oPkgSecuencia, "MAsignacion")
	Set oMRutina        = GetOrCreateClass(oPkgSecuencia, "MRutina")
	Set oMRutinaEj      = GetOrCreateClass(oPkgSecuencia, "MRutinaEjercicio")
	Set oConexion       = GetOrCreateClass(oPkgSecuencia, "BD")

	Dim oDiagrama
	Set oDiagrama = GetOrCreateSequenceDiagram(oPkgSecuencia, "SEC CU7 - Consultar Entrenamiento")

	AgregarAlDiagrama oDiagrama, oCliente,          0,   0,  100, 60
	AgregarAlDiagrama oDiagrama, oCEntrenamiento, 180,   0,  460, 60
	AgregarAlDiagrama oDiagrama, oVEntrenamiento, 540,   0,  820, 60
	AgregarAlDiagrama oDiagrama, oMAsignacion,    900,   0, 1140, 60
	AgregarAlDiagrama oDiagrama, oMRutina,       1220,   0, 1460, 60
	AgregarAlDiagrama oDiagrama, oMRutinaEj,     1540,   0, 1820, 60
	AgregarAlDiagrama oDiagrama, oConexion,      1900,   0, 2080, 60

	Dim colorAzulClaro
	colorAzulClaro = RGB(187, 214, 251)
	PintarElemento oDiagrama, oCEntrenamiento, colorAzulClaro
	PintarElemento oDiagrama, oVEntrenamiento, colorAzulClaro
	PintarElemento oDiagrama, oMAsignacion, colorAzulClaro
	PintarElemento oDiagrama, oMRutina, colorAzulClaro
	PintarElemento oDiagrama, oMRutinaEj, colorAzulClaro
	PintarElemento oDiagrama, oConexion, colorAzulClaro

	LimpiarMensajes oCEntrenamiento
	LimpiarMensajes oVEntrenamiento
	LimpiarMensajes oMAsignacion
	LimpiarMensajes oMRutina
	LimpiarMensajes oMRutinaEj
	LimpiarMensajes oConexion
	LimpiarMensajes oCliente

	' ================================================================
	' 0) Construcción: los 3 modelos se crean nuevos acá (no se
	'    comparten con otros controladores).
	' ================================================================
	AgregarMensaje oCEntrenamiento, oCEntrenamiento, "__construct()"
	AgregarMensaje oCEntrenamiento, oMAsignacion, "__construct()  [new AsignacionModel()]"
	AgregarMensaje oMAsignacion, oConexion, "conectar()..."
	AgregarMensaje oConexion, oMAsignacion, "PDO"
	AgregarMensaje oMAsignacion, oCEntrenamiento, "ok"
	AgregarMensaje oCEntrenamiento, oMRutina, "__construct()  [new RutinaModel()]"
	AgregarMensaje oMRutina, oConexion, "conectar()..."
	AgregarMensaje oConexion, oMRutina, "PDO"
	AgregarMensaje oMRutina, oCEntrenamiento, "ok"
	AgregarMensaje oCEntrenamiento, oMRutinaEj, "__construct()  [new RutinaEjercicioModel()]"
	AgregarMensaje oMRutinaEj, oConexion, "conectar()..."
	AgregarMensaje oConexion, oMRutinaEj, "PDO"
	AgregarMensaje oMRutinaEj, oCEntrenamiento, "ok"
	AgregarMensaje oCEntrenamiento, oVEntrenamiento, "new EntrenamientoView()"

	' ================================================================
	' 1) click en Ver mis entrenamientos  ->  misEntrenamientos(usuarioId)
	' ================================================================
	AgregarMensaje oCliente, oCEntrenamiento, "click en Ver mis entrenamientos"
	AgregarMensaje oCEntrenamiento, oMAsignacion, "obtenerPorUsuario(usuarioId: int)"
	AgregarMensaje oMAsignacion, oConexion, "Query..."
	AgregarMensaje oConexion, oMAsignacion, "filas"
	AgregarMensaje oMAsignacion, oCEntrenamiento, "asignaciones"
	AgregarMensaje oCEntrenamiento, oMRutina, "buscarPorId(rutinaId: int)"
	AgregarMensaje oMRutina, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutina, "fila"
	AgregarMensaje oMRutina, oCEntrenamiento, "rutina"
	AgregarMensaje oCEntrenamiento, oMRutinaEj, "obtenerPorRutina(rutinaId: int)"
	AgregarMensaje oMRutinaEj, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutinaEj, "filas"
	AgregarMensaje oMRutinaEj, oCEntrenamiento, "ejercicios"
	AgregarMensaje oCEntrenamiento, oVEntrenamiento, "render(entrenamientos)"

	oDiagrama.Update()
	Repository.ReloadDiagram(oDiagrama.DiagramID)
	Repository.OpenDiagram(oDiagrama.DiagramID)

	MsgBox "Diagrama 'SEC CU7 - Consultar Entrenamiento' regenerado."

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
