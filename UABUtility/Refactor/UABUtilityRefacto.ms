sysinfo.currentdir = getFilenamePath (getSourceFileName())

Include "globals.ms"

utility UABUtility "UAB export Utility" width:152 height:404
(
	button btnSetPath "Set Path" tooltip:"Set path to export objects" pos:[8,8] width:136 height:28
	label PathLabel "" pos:[8,40] width:136 height:76 readOnly:true
	checkbox ExportMeshCheck "Export Mesh" tooltip:"Export mesh"pos:[8,124] width:136 height:16
	checkbox CopyTexturesCheck "Copy Textures" tooltip:"Copy textures to destination" pos:[8,148] width:136 height:16
	GroupBox grp1 "Export" pos:[8,196] width:136 height:144
	button ExportLightsButton "Lights" tooltip:"Export only lights" pos:[16,220] width:56 height:16
	button ExportMeshButton "Mesh" tooltip:"Export only selected mesh" pos:[80,220] width:56 height:16
	button ExportCameraButton "Camera" tooltip:"Export cameras" pos:[16,244] width:56 height:16
	button ExportSceneButton "Scene" tooltip:"Export all the scene" pos:[16,292] width:120 height:16
	button ExportStaticMeshButton "Static Meshes" tooltip:"Export only static meshes" pos:[16,268] width:120 height:16
	button ExportCinematicButton "Cinematic" tooltip:"Export cinematics" pos:[16,316] width:120 height:16
	checkbox DebugValue "D" tooltip:"Debug value" pos:[80,244] width:30 height:16
	checkbox OverrideValue "O" tooltip:"Override Always" pos:[110,244] width:30 height:16
	groupBox grp2 "Tools" pos:[8,348] width:136 height:48
	button btnSetProperties "Set Properties" tooltip:"Open Property menu" pos:[16,372] width:120 height:16
	dropdownList LevelList "" tooltip:"Level on save the files" pos:[8,172] width:136 height:21

	Include "setProperties.ms"

	Include "Utilities.ms"

	Include "ExportMesh.ms"

	Include "ExportStaticMesh.ms"

	on LevelList selected lvl do
	(
		PathToCopy = realPath + DataDirectory + LevelList.items[LevelList.selection] + "\\"
	) 

	on UABUtility open do
	(
		LevelList.items = levels
		DebugValue.checked = debug
		CopyTexturesCheck.checked = CopyTextures
		OverrideValue.checked = Override
		ExportMeshCheck.checked = ExportMeshes
	)

	on DebugValue changed newValue do
	(
		debug = DebugValue.checked
	)

	on ExportMeshCheck changed newValue do
	(
		ExportMeshes = ExportMeshCheck.checked
	)

	on CopyTexturesCheck changed newValue do
	(
		CopyTextures = newValue
	)

	on btnSetPath pressed do
	(
		Include "PathReductor.ms"
		PathToCopy = realPath + DataDirectory + LevelList.items[LevelList.selection] + "\\"
	)

	on ExportMeshButton pressed do
	(
		if $ != undefined then
		(
			if classof $ == ObjectSet then
			(
				messageBox "No més un objecte a l'hora (Utilitzar scene per mes objectes)" title:"ONLY ONE OBJECT"
			) 
			else
			(
				MeshPath = PathToCopy + MeshDirectory
				TexturePath = PathToCopy + TextureDirectory
				ExportMeshes = true
				if debug then
					format "name is %\n" (MeshPath + $.name + FileExtension)
				ExportMesh $ ($.name + FileExtension)
				ExportMeshes = false
				format "==============================\n"
				format "Mesh exported correctly\n"
				format "==============================\n"
			)
		) 
		else
		(
			messageBox "No hi ha res seleccionat, no es pot exportar." title:"NO SELECTION"
		)

	)

	on btnSetProperties pressed do
	(
		createDialog UABSetProperties
	)

	on ExportStaticMeshButton pressed do
	(			
		MeshPath = PathToCopy + MeshDirectory
		TexturePath = PathToCopy + TextureDirectory
		if debug then
			format "Exporting static mesh of scene\n"
		ExportStaticMesh()
		format "==============================\n"
		format "Static meshes exported correctly\n"
		format "==============================\n"
	)


)