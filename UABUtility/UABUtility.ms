fileIn "setProperties.ms"
fileIn "UABFunctions.ms"
fileIn "ExportMesh.ms"
fileIn "BBoxBSphere.ms"

global realPath

utility UABUtility "UAB Utility" width:152 height:411
(
	-- Contenido de la utility
	button btnSetPath "Set Path" pos:[8,8] width:136 height:28
	label PathLabel "" pos:[8,40] width:136 height:76 readOnly:true
	checkbox ExportMeshCheck "Export Mesh" pos:[8,124] width:136 height:16
	checkbox CopyTexturesCheck "Copy Textures" pos:[8,148] width:136 height:16
	GroupBox grp1 "Export" pos:[8,196] width:136 height:142
	button ExportLightsButton "Lights" pos:[16,220] width:56 height:16
	button ExportMeshButton "Mesh" pos:[80,220] width:56 height:16
	button ExportCameraButton "Camera" pos:[16,244] width:56 height:16
	button ExportSceneButton "Scene" pos:[16,316] width:120 height:16
	button ExportStaticMeshManagerButton "Static Mesh Manager" pos:[16,268] width:120 height:16
	button ExportAnimatedMeshManagerButton "Anim Mesh Manager" pos:[16,292] width:120 height:16
	GroupBox grp2 "Tools" pos:[8,351] width:136 height:48
	button btnSetProperties "Set Properties" pos:[15,371] width:120 height:16
	dropdownList LevelList "" pos:[8,172] width:136 height:21
	
	--Eventos de la utility
	
	--Esta función se llama al pulsarse sobre el btón ExportMeshButton
	
	
	on UABUtility open do
	(
		
		--PathLabel.text = "C:/Users/IBM_ADMIN/this_works?/Desktop/uabEngines/UABEngine_2_12/bin/Videogame/Data/auxi/testing/the_size_of_this_labels"--"Path: D://UABEngine/Data"
		--global ExportPath = PathLabel.text
		local levels=#("","level1","level2", "level3","level4", "main menu", "select player")
		LevelList.items=levels
	)
	on btnSetPath pressed do
	(
		-- TODO, si el filtered[idx].count > 22 peta
		local data_path = getSavePath caption:"Exe path" initialDir:"C:\\" 
		PathLabel.text = data_path
		realPath = data_path
		local filtered = filterString data_path "\\"
		local idx = 1
		local auxstring = ""
		PathLabel.text = auxstring
		while idx <= filtered.count do (
			
			if (filtered[idx].count + auxstring.count) <  22 then (
				auxstring = auxstring + filtered[idx] + "\\"
				idx = idx + 1
			) else (
				if filtered[idx].count > 22 then (
					auxstring = auxstring + filtered[idx] + "\\"
					idx = idx + 1
				)
				auxstring = auxstring + "\n"
				PathLabel.text = PathLabel.text + auxstring
				auxstring = ""
			)
		) 
		if auxstring != "" then (
			PathLabel.text = PathLabel.text + auxstring
		)
	)
	on ExportMeshButton pressed do
	(
	
		local pathToCopy = realPath + "\\Data\\" + LevelList.items[LevelList.selection] + "\\"
		if $ != undefined then (
			format "name is %\n" (pathToCopy + "meshes\\" + $.name + ".mesh")
			ExportMesh $  pathToCopy ($.name + ".mesh") realPath true
		) else (
			messageBox "No hi ha res seleccionat, no es pot exportar." title:"NO SELECTION"
		)
	)
	on ExportSceneButton pressed do
	(
		local pathToCopy = realPath + "\\Data\\" + LevelList.items[LevelList.selection] + "\\"
		ExportStaticMesh pathToCopy realPath 
	)
	on ExportStaticMeshManagerButton pressed do
	(
		local pathToCopy = realPath + "\\Data\\" + LevelList.items[LevelList.selection] + "\\"
	
		format "pathToCopy %\n" pathToCopy
		ExportStaticMeshManager $ pathToCopy realPath CopyTexturesCheck.checked ExportMeshCheck.checked
		format "Static Mesh Manager Exportado \n"
	)
	on ExportAnimatedMeshManagerButton pressed do
	(
		local pathToCopy = realPath + "\\Data\\" + LevelList.items[LevelList.selection] + "\\"
		
		
			if (getUserProp $ "export_type") == "animated_mesh" then (	
				if $ != undefined then (
					format "pathToCopy %\n" pathToCopy
					ExportAnimMeshManager $ pathToCopy realPath CopyTexturesCheck.checked ExportMeshCheck.checked
					format "Animated Mesh Manager Exportado \n"
				) else (
					messageBox "No hi ha res seleccionat, no es pot exportar." title:"NO SELECTION"
				)
			) else (
					messageBox "La selecció no és de tipus Animated Mesh." title:"WRONG TYPE"
			)
	)
	
	on btnSetProperties pressed do
	(
		createDialog UABSetProperties
	)
)
