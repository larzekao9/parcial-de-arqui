Option Explicit

!INC Local Scripts.EAConstants-VBScript

'
' Script Name: CU_AsignarEjerciciosARutina_Secuencia
' Author:
' Purpose: Diagrama de SECUENCIA de "Asignar Ejercicios a Rutina".
'          El controlador tiene instancia de MRutina, MEjercicio,
'          MRutinaEjercicio y VRutinaEjercicio (los 4 recién
'          construidos en el constructor, según router.php:
'          "new RutinaEjercicioController(new RutinaModel(), new
'          EjercicioModel(), new RutinaEjercicioModel(), new
'          RutinaEjercicioView())" — a diferencia de Ejercicio/Categoria,
'          acá NO se comparte ninguna instancia con otro controlador).
'
'          Simplificación: se omite la rama de "no hay ninguna rutina
'          todavía" de obtenerTodos() (early return con lista vacía);
'          se muestra el camino feliz (agregarEjercicio/eliminarEjercicio
'          ya con una rutina elegida), igual criterio que los demás
'          diagramas de este set (sin combined fragments "alt").
' Date:
'

sub main

	Dim oParent
	Set oParent = GetParentPackage()

	Dim oCasoUso
	Set oCasoUso = GetOrCreatePackage(oParent, "CU6 Asignar Ejercicios a Rutina - Detalle Procedimental")

	Dim oPkgSecuencia
	Set oPkgSecuencia = GetOrCreatePackage(oCasoUso, "Diagrama de Secuencia")

	Dim oAdmin, oCRutinaEj, oVRutinaEj, oMRutina, oMEjercicio, oMRutinaEj, oConexion
	Set oAdmin      = GetOrCreateActor(oPkgSecuencia, "Administrador")
	Set oCRutinaEj  = GetOrCreateClass(oPkgSecuencia, "CRutinaEjercicio")
	Set oVRutinaEj  = GetOrCreateClass(oPkgSecuencia, "VRutinaEjercicio")
	Set oMRutina    = GetOrCreateClass(oPkgSecuencia, "MRutina")
	Set oMEjercicio = GetOrCreateClass(oPkgSecuencia, "MEjercicio")
	Set oMRutinaEj  = GetOrCreateClass(oPkgSecuencia, "MRutinaEjercicio")
	Set oConexion   = GetOrCreateClass(oPkgSecuencia, "BD")

	Dim oDiagrama
	Set oDiagrama = GetOrCreateSequenceDiagram(oPkgSecuencia, "SEC CU6 - Asignar Ejercicios a Rutina")

	AgregarAlDiagrama oDiagrama, oAdmin,      0,   0,  100, 60
	AgregarAlDiagrama oDiagrama, oCRutinaEj, 180,   0,  460, 60
	AgregarAlDiagrama oDiagrama, oVRutinaEj, 540,   0,  820, 60
	AgregarAlDiagrama oDiagrama, oMRutina,   900,   0, 1140, 60
	AgregarAlDiagrama oDiagrama, oMEjercicio,1220,   0, 1460, 60
	AgregarAlDiagrama oDiagrama, oMRutinaEj, 1540,   0, 1820, 60
	AgregarAlDiagrama oDiagrama, oConexion,  1900,   0, 2080, 60

	Dim colorAzulClaro
	colorAzulClaro = RGB(187, 214, 251)
	PintarElemento oDiagrama, oCRutinaEj, colorAzulClaro
	PintarElemento oDiagrama, oVRutinaEj, colorAzulClaro
	PintarElemento oDiagrama, oMRutina, colorAzulClaro
	PintarElemento oDiagrama, oMEjercicio, colorAzulClaro
	PintarElemento oDiagrama, oMRutinaEj, colorAzulClaro
	PintarElemento oDiagrama, oConexion, colorAzulClaro

	LimpiarMensajes oCRutinaEj
	LimpiarMensajes oVRutinaEj
	LimpiarMensajes oMRutina
	LimpiarMensajes oMEjercicio
	LimpiarMensajes oMRutinaEj
	LimpiarMensajes oConexion
	LimpiarMensajes oAdmin

	' ================================================================
	' 0) Construcción: los 3 modelos se crean nuevos acá (no se
	'    comparten con otros controladores).
	' ================================================================
	AgregarMensaje oCRutinaEj, oCRutinaEj, "__construct()"
	AgregarMensaje oCRutinaEj, oMRutina, "__construct()  [new RutinaModel()]"
	AgregarMensaje oMRutina, oConexion, "conectar()..."
	AgregarMensaje oConexion, oMRutina, "PDO"
	AgregarMensaje oMRutina, oCRutinaEj, "ok"
	AgregarMensaje oCRutinaEj, oMEjercicio, "__construct()  [new EjercicioModel()]"
	AgregarMensaje oMEjercicio, oConexion, "conectar()..."
	AgregarMensaje oConexion, oMEjercicio, "PDO"
	AgregarMensaje oMEjercicio, oCRutinaEj, "ok"
	AgregarMensaje oCRutinaEj, oMRutinaEj, "__construct()  [new RutinaEjercicioModel()]"
	AgregarMensaje oMRutinaEj, oConexion, "conectar()..."
	AgregarMensaje oConexion, oMRutinaEj, "PDO"
	AgregarMensaje oMRutinaEj, oCRutinaEj, "ok"
	AgregarMensaje oCRutinaEj, oVRutinaEj, "new VRutinaEjercicioView()"

	' ================================================================
	' 1) click en Ver rutina (elige una)  ->  obtenerPorId(rutinaId)
	' ================================================================
	AgregarMensaje oAdmin, oCRutinaEj, "click en Ver rutina"
	AgregarMensaje oCRutinaEj, oMRutina, "obtenerTodos()"
	AgregarMensaje oMRutina, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutina, "filas"
	AgregarMensaje oMRutina, oCRutinaEj, "rutinas"
	AgregarMensaje oCRutinaEj, oMRutina, "buscarPorId(rutinaId: int)"
	AgregarMensaje oMRutina, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutina, "fila"
	AgregarMensaje oMRutina, oCRutinaEj, "rutina"
	AgregarMensaje oCRutinaEj, oMEjercicio, "obtenerTodos()"
	AgregarMensaje oMEjercicio, oConexion, "Query..."
	AgregarMensaje oConexion, oMEjercicio, "filas"
	AgregarMensaje oMEjercicio, oCRutinaEj, "ejercicios"
	AgregarMensaje oCRutinaEj, oMRutinaEj, "obtenerPorRutina(rutinaId: int)"
	AgregarMensaje oMRutinaEj, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutinaEj, "filas"
	AgregarMensaje oMRutinaEj, oCRutinaEj, "asignados"
	AgregarMensaje oCRutinaEj, oVRutinaEj, "render(rutina, rutinas, ejercicios, asignados)"

	' ================================================================
	' 2) click en Agregar ejercicio  ->  agregarEjercicio(datos)
	' ================================================================
	AgregarMensaje oAdmin, oCRutinaEj, "click en Agregar ejercicio"
	AgregarMensaje oCRutinaEj, oMRutinaEj, "agregar(d: array)"
	AgregarMensaje oMRutinaEj, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutinaEj, "ok"
	AgregarMensaje oMRutinaEj, oCRutinaEj, "ok"
	AgregarMensaje oCRutinaEj, oMRutina, "obtenerTodos()"
	AgregarMensaje oMRutina, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutina, "filas"
	AgregarMensaje oMRutina, oCRutinaEj, "rutinas"
	AgregarMensaje oCRutinaEj, oMRutina, "buscarPorId(rutinaId: int)"
	AgregarMensaje oMRutina, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutina, "fila"
	AgregarMensaje oMRutina, oCRutinaEj, "rutina"
	AgregarMensaje oCRutinaEj, oMEjercicio, "obtenerTodos()"
	AgregarMensaje oMEjercicio, oConexion, "Query..."
	AgregarMensaje oConexion, oMEjercicio, "filas"
	AgregarMensaje oMEjercicio, oCRutinaEj, "ejercicios"
	AgregarMensaje oCRutinaEj, oMRutinaEj, "obtenerPorRutina(rutinaId: int)"
	AgregarMensaje oMRutinaEj, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutinaEj, "filas"
	AgregarMensaje oMRutinaEj, oCRutinaEj, "asignados"
	AgregarMensaje oCRutinaEj, oVRutinaEj, "render(rutina, rutinas, ejercicios, asignados)"

	' ================================================================
	' 3) click en Quitar ejercicio  ->  eliminarEjercicio(rutinaId, ejercicioId)
	' ================================================================
	AgregarMensaje oAdmin, oCRutinaEj, "click en Quitar ejercicio"
	AgregarMensaje oCRutinaEj, oMRutinaEj, "eliminar(rutinaId: int, ejercicioId: int)"
	AgregarMensaje oMRutinaEj, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutinaEj, "ok"
	AgregarMensaje oMRutinaEj, oCRutinaEj, "ok"
	AgregarMensaje oCRutinaEj, oMRutina, "obtenerTodos()"
	AgregarMensaje oMRutina, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutina, "filas"
	AgregarMensaje oMRutina, oCRutinaEj, "rutinas"
	AgregarMensaje oCRutinaEj, oMRutina, "buscarPorId(rutinaId: int)"
	AgregarMensaje oMRutina, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutina, "fila"
	AgregarMensaje oMRutina, oCRutinaEj, "rutina"
	AgregarMensaje oCRutinaEj, oMEjercicio, "obtenerTodos()"
	AgregarMensaje oMEjercicio, oConexion, "Query..."
	AgregarMensaje oConexion, oMEjercicio, "filas"
	AgregarMensaje oMEjercicio, oCRutinaEj, "ejercicios"
	AgregarMensaje oCRutinaEj, oMRutinaEj, "obtenerPorRutina(rutinaId: int)"
	AgregarMensaje oMRutinaEj, oConexion, "Query..."
	AgregarMensaje oConexion, oMRutinaEj, "filas"
	AgregarMensaje oMRutinaEj, oCRutinaEj, "asignados"
	AgregarMensaje oCRutinaEj, oVRutinaEj, "render(rutina, rutinas, ejercicios, asignados)"

	oDiagrama.Update()
	Repository.ReloadDiagram(oDiagrama.DiagramID)
	Repository.OpenDiagram(oDiagrama.DiagramID)

	MsgBox "Diagrama 'SEC CU6 - Asignar Ejercicios a Rutina' regenerado."

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
