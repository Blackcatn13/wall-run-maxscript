sysinfo.currentdir = getFilenamePath (getSourceFileName())

Include "globals.ms"

utility UABUtility "UAB export Utility" width:152 height:404
(
	button btnSetPath "Set Path" pos:[8,8] width:136 height:28 toolTip:"Set path to export objects"
	label PathLabel "" pos:[8,40] width:136 height:76 readOnly:true
	checkbox ExportMeshCheck "Export Mesh" pos:[8,124] width:136 height:16 toolTip:"Export mesh"
	checkbox CopyTexturesCheck "Copy Textures" pos:[8,148] width:136 height:16 toolTip:"Copy textures to destination"
	GroupBox grp1 "Export" pos:[8,196] width:136 height:220
	button ExportLightsButton "Lights" pos:[16,220] width:56 height:16 toolTip:"Export only lights"
	button ExportMeshButton "Mesh" pos:[80,220] width:56 height:16 toolTip:"Export only selected mesh"
	button ExportCameraButton "Camera" pos:[16,244] width:56 height:16 toolTip:"Export cameras"
	button ExportSceneButton "Scene" pos:[16,368] width:120 height:16 toolTip:"Export all the scene"
	button ExportStaticMeshButton "Static Meshes" pos:[16,344] width:120 height:16 toolTip:"Export only static meshes"
	button ExportCinematicButton "Cinematic" pos:[16,392] width:120 height:16 toolTip:"Export cinematics"
	checkbox DebugValue "Debug Messages" pos:[24,272] width:104 height:16 toolTip:"Debug value"
	checkbox OverrideValue "Always Override" pos:[24,296] width:104 height:16 toolTip:"Override Always"
	GroupBox grp2 "Tools" pos:[8,424] width:136 height:48
	button btnSetProperties "Set Properties" pos:[16,448] width:120 height:16 toolTip:"Open Property menu"
	dropdownList LevelList "" pos:[8,172] width:136 height:21 toolTip:"Level on save the files"
	button PhysxMeshCheck "ExportPhysXMesh" pos:[16,320] width:120 height:16 toolTip:"Export Only PhysX"

	Include "setProperties.ms"

	Include "Utilities.ms"

	Include "ExportMesh.ms"

	Include "ExportStaticMesh.ms"

	Include "ExportRenderableObjects.ms"

	Include "ExportCameras.ms"

	Include "ExportLigths.ms"

	Include "ExportPhysXMesh.ms"

	on LevelList selected lvl do
	(
		PathToCopy = realPath + DataDirectory + LevelList.items[LevelList.selection] + "\\"
		RelativePathToCopy = DataDirectory + LevelList.items[LevelList.selection] + "\\"
		MeshPath = PathToCopy + MeshDirectory
		TexturePath = PathToCopy + TextureDirectory
		RelativeMeshPath = RelativePathToCopy + MeshDirectory
		RelativeTexturePath = RelativePathToCopy + TextureDirectory
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
		CopyTextures = CopyTexturesCheck.checked
	)

	on OverrideValue changed newValue do
	(
		Override = OverrideValue.checked
	)
	

	on btnSetPath pressed do
	(
		Include "PathReductor.ms"
		PathToCopy = realPath + DataDirectory + LevelList.items[LevelList.selection] + "\\"
		RelativePathToCopy = DataDirectory + LevelList.items[LevelList.selection] + "\\"
		MeshPath = PathToCopy + MeshDirectory
		TexturePath = PathToCopy + TextureDirectory
		RelativeMeshPath = RelativePathToCopy + MeshDirectory
		RelativeTexturePath = RelativePathToCopy + TextureDirectory
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
				ExportMesh $ ($.name + FileExtension) false
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
		if debug then
			format "Exporting static mesh of scene\n"
		ExportStaticMesh()
		format "==============================\n"
		format "Static meshes exported correctly\n"
		format "==============================\n"
	)

	on ExportSceneButton pressed do
	(
		if debug then
			format "Exporting Renderable Objects\n"
		ExportRenderableObjects()
		if debug then
			format "Exporting Camera(s)\n"
		exportCameras undefined
		if debug then
			format "Exporting light(s)\n"
		exportLights undefined
		format "==============================\n"
		format "Full scene exported correctly\n"
		format "==============================\n"
	)

	on PhysxMeshCheck pressed do
	(
		if debug then
			format "Exporting Physx meshes\n"
		ExportPhysXMesh()
		format "==============================\n"
		format "PhysX exported correctly\n"
		format "==============================\n"
	)

	on ExportCameraButton pressed do
	(
		if debug then
			format "Exporting Camera(s)\n"
		exportCameras $
		format "==============================\n"
		format "camera exported correctly\n"
		format "==============================\n"
	)

	on ExportLightsButton pressed do
	(
		if debug then
			format "Exporting light(s)\n"
		exportLights $
		format "==============================\n"
		format "ligths exported correctly\n"
		format "==============================\n"
	)

	on ExportCinematicButton pressed do
	(
		local _name = filterString maxFileName ".max"
		local dialog = dotNetObject "MaxCustomControls.RenameInstanceDialog" _name[1]
		dialog.text = "What's the cinematic name?"
		local dialogResult = dialog.Showmodal()
		if dotnet.compareenums dialog.DialogResult ((dotnetclass "System.Windows.Forms.DialogResult").OK) then (
			local cinematicName = dialog.InstanceName
			ExportCinematics cinematicName
			format "==============================\n"
			format "cinematic exported correctly\n"
			format "==============================\n"
		)
	)

)