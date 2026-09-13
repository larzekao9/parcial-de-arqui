Option Explicit

!INC Local Scripts.EAConstants-VBScript

'
' Script Name: VistaModulos_Usuarios
' Author:
' Purpose: Genera el diagrama "2.2 Vista De Los Módulos" para el
'          paquete Usuarios: un elemento Package "Usuarios" con
'          dependencias «trace» hacia los casos de uso donde participa:
'            CU1. Gestionar Usuarios
'            CU5. Asignar Ejercicio
'            CU6. Asignar Rutina
'            CU7. Consultar Entrenamiento
'          Replica exactamente la imagen de referencia (mismos textos,
'          mismo tipo de relación «trace», mismo layout paquete-a-la-
'          izquierda / casos de uso a la derecha).
' Date:
'

sub main

	Dim oParent
	Set oParent = GetParentPackage()

	Dim oPkgVista
	Set oPkgVista = GetOrCreatePackage(oParent, "2.2 Vista de los Modulos")

	' ---- Elemento Package "Usuarios" ----
	Dim oUsuarios
	Set oUsuarios = GetOrCreateElement(oPkgVista, "Usuarios", "Package")

	' ---- Casos de uso (elipses) ----
	Dim oCU1, oCU5, oCU6, oCU7
	Set oCU1 = GetOrCreateElement(oPkgVista, "CU1. Gestionar Usuarios", "UseCase")
	Set oCU5 = GetOrCreateElement(oPkgVista, "CU5. Asignar Ejercicio", "UseCase")
	Set oCU6 = GetOrCreateElement(oPkgVista, "CU6. Asignar Rutina", "UseCase")
	Set oCU7 = GetOrCreateElement(oPkgVista, "CU7. Consultar Entrenamiento", "UseCase")

	' ---- Diagrama ----
	Dim oDiagrama
	Set oDiagrama = GetOrCreateDiagramTipo(oPkgVista, "class pkg Usuarios", "Package")

	AgregarAlDiagrama oDiagrama, oUsuarios,   0, 150,  260, 330
	AgregarAlDiagrama oDiagrama, oCU1,      480,   0,  760, 140
	AgregarAlDiagrama oDiagrama, oCU5,      480, 180,  760, 320
	AgregarAlDiagrama oDiagrama, oCU6,      480, 360,  760, 500
	AgregarAlDiagrama oDiagrama, oCU7,      480, 540,  760, 680

	' ---- Colores (paquete color hueso/salmón, casos de uso azul) ----
	PintarElemento oDiagrama, oUsuarios, RGB(250, 228, 216)
	PintarElemento oDiagrama, oCU1, RGB(187, 214, 251)
	PintarElemento oDiagrama, oCU5, RGB(187, 214, 251)
	PintarElemento oDiagrama, oCU6, RGB(187, 214, 251)
	PintarElemento oDiagrama, oCU7, RGB(187, 214, 251)

	' ---- Relaciones «trace» ----
	ConectarTrace oUsuarios, oCU1
	ConectarTrace oUsuarios, oCU5
	ConectarTrace oUsuarios, oCU6
	ConectarTrace oUsuarios, oCU7

	oDiagrama.Update()
	Repository.ReloadDiagram(oDiagrama.DiagramID)
	Repository.OpenDiagram(oDiagrama.DiagramID)

	MsgBox "Diagrama 'Vista de los Modulos - Usuarios' generado."

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
' Helper genérico de elementos (Package, UseCase, etc.)
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
' Relación de dependencia con estereotipo «trace»
' =====================================================
sub ConectarTrace(oCliente, oProveedor)
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
	end if

	oConn.Stereotype = "trace"
	oConn.Update()
end sub

main
