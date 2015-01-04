fileIn "setProperties.ms"
fileIn "UABFunctions.ms"
fileIn "ExportMesh.ms"
fileIn "BBoxBSphere.ms"
fileIn "ExportCamera.ms"
fileIn "ExportCinematic.ms"

global realPath

utility UABUtility "UAB Utility" width:152 height:404
(
	local debug = true
	-- Contenido de la utility
	button btnSetPath "Set Path" pos:[8,8] width:136 height:28
	label PathLabel "" pos:[8,40] width:136 height:76 readOnly:true
	checkbox ExportMeshCheck "Export Mesh" pos:[8,124] width:136 height:16
	checkbox CopyTexturesCheck "Copy Textures" pos:[8,148] width:136 height:16
	GroupBox grp1 "Export" pos:[8,196] width:136 height:144
	button ExportLightsButton "Lights" pos:[16,220] width:56 height:16
	button ExportMeshButton "Mesh" pos:[80,220] width:56 height:16
	button ExportCameraButton "Camera" pos:[16,244] width:56 height:16
	button ExportSceneButton "Scene" pos:[16,292] width:120 height:16
	button ExportStaticMeshManagerButton "Static Mesh Manager" pos:[16,268] width:120 height:16
	button ExportCinematicButton "Cinematic" pos:[16,316] width:120 height:16
	checkbox DebugValue "Debug" pos:[80,244] width:56 height:16
	groupBox grp2 "Tools" pos:[8,348] width:136 height:48
	button btnSetProperties "Set Properties" pos:[16,372] width:120 height:16
	dropdownList LevelList "" pos:[8,172] width:136 height:21
	
	--Eventos de la utility
	
	--Esta función se llama al pulsarse sobre el btón ExportMeshButton
	
	
	on UABUtility open do
	(
		
		--PathLabel.text = "C:/Users/IBM_ADMIN/this_works?/Desktop/uabEngines/UABEngine_2_12/bin/Videogame/Data/auxi/testing/the_size_of_this_labels"--"Path: D://UABEngine/Data"
		--global ExportPath = PathLabel.text
		local levels=#("","level1","level2", "level3","level4", "level5", "main menu", "select player")
		LevelList.items=levels
		DebugValue.checked = true
		debug = DebugValue.checked
	)
	
	on DebugValue changed newValue do (
		debug = DebugValue.checked
	)
	
	on btnSetPath pressed do
	(
		-- TODO, si el filtered[idx].count > 22 peta
		local data_path = getSavePath caption:"Exe path" initialDir:"C:\\" 
		if data_path != undefined then (
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
			format "==============================\n"
			format "Path set correctly\n"
			format "==============================\n"
		)
	)
	on ExportMeshButton pressed do
	(
	
		local pathToCopy = realPath + "\\Data\\" + LevelList.items[LevelList.selection] + "\\"
		if $ != undefined then (
			if UABUtility.debug then
				format "name is %\n" (pathToCopy + "meshes\\" + $.name + ".mesh")
			ExportMesh $  pathToCopy ($.name + ".mesh") realPath true
			format "==============================\n"
			format "Mesh exported correctly\n"
			format "==============================\n"
		) else (
			messageBox "No hi ha res seleccionat, no es pot exportar." title:"NO SELECTION"
		)

	)
	on ExportSceneButton pressed do
	(
		local pathToCopy = realPath + "\\Data\\" + LevelList.items[LevelList.selection] + "\\"
		ExportStaticMesh pathToCopy realPath
		exportCameras pathToCopy realPath undefined
		format "==============================\n"
		format "Full scene exported correctly\n"
		format "==============================\n"
	)
	on ExportStaticMeshManagerButton pressed do
	(
		local pathToCopy = realPath + "\\Data\\" + LevelList.items[LevelList.selection] + "\\"
		if UABUtility.debug then
			format "pathToCopy %\n" pathToCopy
		ExportStaticMeshManager $ pathToCopy realPath CopyTexturesCheck.checked ExportMeshCheck.checked
		format "==============================\n"
		format "Static meshes exported correctly\n"
		format "==============================\n"
	)
	
	on ExportCameraButton pressed do
	(
		local pathToCopy = realPath + "\\Data\\" + LevelList.items[LevelList.selection] + "\\"
		exportCameras pathToCopy realPath $
		format "==============================\n"
		format "camera exported correctly\n"
		format "==============================\n"
	)
	
	on btnSetProperties pressed do
	(
		createDialog UABSetProperties
	)
	
	on ExportCinematicButton pressed do
	(
		local _name = filterString maxFileName ".max"
		local dialog = dotNetObject "MaxCustomControls.RenameInstanceDialog" _name[1]
		dialog.text = "What's the cinematic name?"
		local dialogResult = dialog.Showmodal()
		if dotnet.compareenums dialog.DialogResult ((dotnetclass "System.Windows.Forms.DialogResult").OK) then (
			local cinematicName = dialog.InstanceName
			local pathToCopy = realPath + "\\Data\\" + LevelList.items[LevelList.selection] + "\\"
			ExportCinematics pathToCopy realPath cinematicName
			format "==============================\n"
			format "cinematic exported correctly\n"
			format "==============================\n"
		)
	)

		/*on ExportAnimatedMeshManagerButton pressed do
	(
		local pathToCopy = realPath + "\\Data\\" + LevelList.items[LevelList.selection] + "\\"
		local arrayObjs = #()
		
		if $ != undefined then (
			if (classof $) == ObjectSet then (
				for i = 1 to $.count do	(
					if (getUserProp $[i] "export_type") != "animated_mesh" then (
						format "L'objecte % no és de tipus Animated Mesh \n" i
					) else (
						append arrayObjs $[i]
					)
				)
				format "pathToCopy %\n" pathToCopy
				ExportAnimMeshManager arrayObjs pathToCopy realPath CopyTexturesCheck.checked ExportMeshCheck.checked
				format "Animated Mesh Manager Exportado \n"
			) else (
				if (getUserProp $ "export_type") == "animated_mesh" then (
					append arrayObjs $
					format "pathToCopy %\n" pathToCopy
					ExportAnimMeshManager arrayObjs pathToCopy realPath CopyTexturesCheck.checked ExportMeshCheck.checked
					format "Animated Mesh Manager Exportado \n"
				) else (
					messageBox "La selecció no és de tipus Animated Mesh." title:"WRONG TYPE"
				)
			)
		) else (
			messageBox "No hi ha res seleccionat, no es pot exportar." title:"NO SELECTION"
		)
	)*/
)
