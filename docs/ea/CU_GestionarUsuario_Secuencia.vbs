Option Explicit

!INC Local Scripts.EAConstants-VBScript

'
' Script Name: CU_GestionarUsuario_Secuencia
' Author:
' Purpose: Genera el diagrama de SECUENCIA de "Gestionar Usuario", para
'          obtenerTodos (ver lista) / crear / actualizar / eliminar
'          (el constructor no cuenta como acción del Administrador: es
'          la Vista inicializándose, no algo que el usuario dispare).
'
'          Fixes acumulados sobre versiones anteriores (probadas y
'          rotas en EA):
'          1) Clasificadores propios de este diagrama (no se reusan
'             CUsuario/VUsuario/MUsuario/Conexion del diagrama de
'             clases), para que sus conectores no interfieran.
'          2) Connector.SequenceNo (10, 20, 30...) en cada mensaje:
'             sin esto EA no respeta el orden y los mezcla. Confirmado
'             contra el código real de gobravedave/Enterprise-Architect.
'          3) La lifeline "Conexion" ahora se llama "BD" y sus mensajes
'             muestran la consulta SQL real de cada operación (INSERT/
'             SELECT/UPDATE/DELETE, acortada con "..."), en vez de
'             mostrar siempre getConexion(). El conectar() inicial
'             (obtener el PDO) sigue pasando una sola vez, en la
'             construcción (Conexion es singleton).
'          4) Los mensajes de retorno llevan texto corto directo en el
'             Name (ej. "id", "filas", "ok") en vez de quedar vacíos.
'             OJO: no están marcados con el checkbox "Is Return" de EA
'             ni cargados en el campo "Return Value" — EA no expone
'             eso por Automation de forma segura (el único ejemplo real
'             que existe usa SQL crudo contra tablas internas no
'             documentadas). Si además querés que EA los reconozca
'             formalmente como "return", hay que tildarlos a mano en
'             el inspector una vez generado el diagrama.
' Date:
'

sub main

	Dim oParent
	Set oParent = GetParentPackage()

	Dim oCasoUso
	Set oCasoUso = GetOrCreatePackage(oParent, "CU1 Gestionar Usuario - Detalle Procedimental")

	Dim oPkgSecuencia
	Set oPkgSecuencia = GetOrCreatePackage(oCasoUso, "Diagrama de Secuencia")

	' ---- Clasificadores PROPIOS de este diagrama (no se comparten) ----
	' Nombres limpios directos: no hace falta el sufijo "(sec)" ni un
	' Alias, porque el problema real de las corridas anteriores era
	' compartir la MISMA clase (mismo ElementID) del diagrama de clases,
	' no el nombre. Clases nuevas con el mismo nombre en un paquete
	' distinto no chocan entre sí.
	Dim oAdmin, oCUsuario, oVUsuario, oMUsuario, oConexion
	Set oAdmin    = GetOrCreateActor(oPkgSecuencia, "Administrador")
	Set oCUsuario = GetOrCreateClass(oPkgSecuencia, "CUsuario")
	Set oVUsuario = GetOrCreateClass(oPkgSecuencia, "VUsuario")
	Set oMUsuario = GetOrCreateClass(oPkgSecuencia, "MUsuario")
	Set oConexion = GetOrCreateClass(oPkgSecuencia, "BD")

	' ---- Diagrama de secuencia ----
	Dim oDiagrama
	Set oDiagrama = GetOrCreateSequenceDiagram(oPkgSecuencia, "SEC CU1 - Gestionar Usuarios")

	' ---- Lifelines (izquierda a derecha) ----
	AgregarAlDiagrama oDiagrama, oAdmin,      0,   0,  100, 60
	AgregarAlDiagrama oDiagrama, oCUsuario, 180,   0,  420, 60
	AgregarAlDiagrama oDiagrama, oVUsuario, 500,   0,  740, 60
	AgregarAlDiagrama oDiagrama, oMUsuario, 820,   0, 1060, 60
	AgregarAlDiagrama oDiagrama, oConexion,1140,   0, 1320, 60

	' ---- Color azul en las 4 clases ----
	Dim colorAzulClaro
	colorAzulClaro = RGB(187, 214, 251)
	PintarElemento oDiagrama, oCUsuario, colorAzulClaro
	PintarElemento oDiagrama, oVUsuario, colorAzulClaro
	PintarElemento oDiagrama, oMUsuario, colorAzulClaro
	PintarElemento oDiagrama, oConexion, colorAzulClaro

	LimpiarMensajes oCUsuario
	LimpiarMensajes oVUsuario
	LimpiarMensajes oMUsuario
	LimpiarMensajes oConexion
	LimpiarMensajes oAdmin

	' ================================================================
	' 0) Construcción: la Vista se inicializa, el Administrador todavía
	'    no hizo nada (no es una acción de usuario).
	' ================================================================
	AgregarMensaje oCUsuario, oCUsuario, "__construct()"
	AgregarMensaje oCUsuario, oMUsuario, "__construct()  [new UsuarioModel()]"
	AgregarMensaje oMUsuario, oConexion, "conectar()..."
	AgregarMensaje oConexion, oMUsuario, "PDO"
	AgregarMensaje oMUsuario, oCUsuario, "ok"
	AgregarMensaje oCUsuario, oVUsuario, "new VUsuario()"

	' ================================================================
	' 1) click en Ver usuarios  ->  obtenerTodos()
	' ================================================================
	AgregarMensaje oAdmin, oCUsuario, "click en Ver usuarios"
	AgregarMensaje oCUsuario, oMUsuario, "obtenerTodos()"
	AgregarMensaje oMUsuario, oConexion, "Query..."
	AgregarMensaje oConexion, oMUsuario, "filas"
	AgregarMensaje oMUsuario, oCUsuario, "usuarios"
	AgregarMensaje oCUsuario, oVUsuario, "render(usuarios, [editando=>null])"

	' ================================================================
	' 2) click en Crear  ->  crear(datos)
	' ================================================================
	AgregarMensaje oAdmin, oCUsuario, "click en Crear"
	AgregarMensaje oCUsuario, oMUsuario, "crear(datos: array)"
	AgregarMensaje oMUsuario, oConexion, "Query..."
	AgregarMensaje oConexion, oMUsuario, "id"
	AgregarMensaje oMUsuario, oCUsuario, "id"
	AgregarMensaje oCUsuario, oMUsuario, "obtenerTodos()"
	AgregarMensaje oMUsuario, oConexion, "Query..."
	AgregarMensaje oConexion, oMUsuario, "filas"
	AgregarMensaje oMUsuario, oCUsuario, "usuarios"
	AgregarMensaje oCUsuario, oVUsuario, "render(usuarios, [editando=>null])"

	' ================================================================
	' 3) click en Editar  ->  actualizar(id, datos)
	' ================================================================
	AgregarMensaje oAdmin, oCUsuario, "click en Editar"
	AgregarMensaje oCUsuario, oMUsuario, "actualizar(id: int, datos: array)"
	AgregarMensaje oMUsuario, oConexion, "Query..."
	AgregarMensaje oConexion, oMUsuario, "ok"
	AgregarMensaje oMUsuario, oCUsuario, "ok"
	AgregarMensaje oCUsuario, oMUsuario, "obtenerTodos()"
	AgregarMensaje oMUsuario, oConexion, "Query..."
	AgregarMensaje oConexion, oMUsuario, "filas"
	AgregarMensaje oMUsuario, oCUsuario, "usuarios"
	AgregarMensaje oCUsuario, oVUsuario, "render(usuarios, [editando=>null])"

	' ================================================================
	' 4) click en Eliminar  ->  eliminar(id)
	' ================================================================
	AgregarMensaje oAdmin, oCUsuario, "click en Eliminar"
	AgregarMensaje oCUsuario, oMUsuario, "eliminar(id: int)"
	AgregarMensaje oMUsuario, oConexion, "Query..."
	AgregarMensaje oConexion, oMUsuario, "ok"
	AgregarMensaje oMUsuario, oCUsuario, "ok"
	AgregarMensaje oCUsuario, oMUsuario, "obtenerTodos()"
	AgregarMensaje oMUsuario, oConexion, "Query..."
	AgregarMensaje oConexion, oMUsuario, "filas"
	AgregarMensaje oMUsuario, oCUsuario, "usuarios"
	AgregarMensaje oCUsuario, oVUsuario, "render(usuarios, [editando=>null])"

	oDiagrama.Update()
	Repository.ReloadDiagram(oDiagrama.DiagramID)
	Repository.OpenDiagram(oDiagrama.DiagramID)

	MsgBox "Diagrama regenerado." & vbCrLf & _
	       "Pendiente manual: en cada flecha punteada de retorno, tildar 'Is Return' " & _
	       "y completar 'Return Value' según el comentario en el script."

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

' Contador global de orden: cada mensaje necesita su propio
' Connector.SequenceNo para que EA lo dibuje de arriba hacia abajo.
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
