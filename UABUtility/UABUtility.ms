fileIn "setProperties.ms"
fileIn "UABFunctions.ms"

utility UABUtility "UAB Utility" width:200 height:352
(
	-- Contenido de la utility
	button btnSetPath "Set Path" pos:[56,8] width:85 height:23
	label PathLabel "Path" pos:[12,37] width:180 height:16
	checkbox ExportMeshCheck "Export Mesh" pos:[8,69] width:112 height:16
	checkbox CopyTexturesCheck "Copy Textures" pos:[8,88] width:96 height:16
	GroupBox grp1 "Export" pos:[8,176] width:184 height:144
	button ExportLightsButton "Lights" pos:[16,192] width:72 height:24
	button ExportMeshButton "Mesh" pos:[104,192] width:80 height:24
	button ExportCameraButton "Camera" pos:[16,224] width:72 height:24
	button ExportSceneButton "Scene" pos:[16,288] width:168 height:24
	button ExportStaticMeshManagerButton "Static Mesh Manager" pos:[16,256] width:168 height:24
	button btnSetProperties "Set Properties" pos:[56,328] width:72 height:16
	combobox LevelList "" pos:[8,116] width:184 height:3
	
	--Eventos de la utility
	
	--Esta función se llama al pulsarse sobre el btón ExportMeshButton
	on UABUtility open do
	(
		PathLabel.text = "C:/Users/IBM_ADMIN/Desktop/uabEngines/UABEngine_2_12/bin/Videogame/Data/"--"Path: D://UABEngine/Data"
		global ExportPath = PathLabel.text
		local levels=#("","level_1","level_2", "level_3","level_4", "main menu", "select player")
		LevelList.items=levels
	)
	on btnSetPath pressed do
	(
		PathLabel.text = ExportPath +LevelList.items[LevelList.selection] +"/"
	)
	on ExportMeshButton pressed do
	(
	--Implementad aquí el código de pulsado de este botón
	
		--Si CopyTextures checked copia las texturas
		if CopyTexturesCheck.checked == true then
		(
			format "Copiamos \n"
			CopyTextures PathLabel.text $
		)
		--Si ExportMesh checked exportar el mesh
		if ExportMeshCheck.checked == true then
		(
			ExportStaticMesh true PathLabel.text $
		)
		else 
		(
			-- Exportar solo transformación y posicion
			ExportStaticMesh false PathLabel.text $
		)
	)
	on ExportStaticMeshManagerButton pressed do
	(
		ExportStaticMeshManager PathLabel.text
		format "Static Mesh Manager Exportado \n"
	)
	on btnSetProperties pressed do
	(
		createDialog UABSetProperties
	)
)

