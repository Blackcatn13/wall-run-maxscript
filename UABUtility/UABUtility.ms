sysinfo.currentdir = getFilenamePath (getSourceFileName())

Include "globals.ms"

utility UABUtility "UAB export Utility" width:152 height:513
(
	button btnSetPath "Set Path" pos:[8,8] width:136 height:28 toolTip:"Set path to export objects"
	label PathLabel "" pos:[8,40] width:136 height:76 readOnly:true
	checkbox ExportMeshCheck "Export Mesh" pos:[8,124] width:136 height:16 toolTip:"Export mesh"
	checkbox CopyTexturesCheck "Copy Textures" pos:[8,148] width:136 height:16 toolTip:"Copy textures to destination"
	GroupBox grp1 "Export" pos:[8,196] width:136 height:240
	button ExportLightsButton "Lights" pos:[16,220] width:56 height:16 toolTip:"Export only lights"
	button ExportMeshButton "Mesh" pos:[80,220] width:56 height:16 toolTip:"Export only selected mesh"
	button ExportCameraPathButton "Cam Path" pos:[80,244] width:56 height:16 toolTip:"Export camera path"
	button ExportCameraButton "Camera" pos:[16,244] width:56 height:16 toolTip:"Export cameras"
	button ExportSceneButton "Scene" pos:[16,386] width:120 height:16 toolTip:"Export all the scene"
	button ExportStaticMeshButton "Static Meshes" pos:[16,362] width:120 height:16 toolTip:"Export only static meshes"
	button ExportCinematicButton "Cinematic" pos:[16,410] width:120 height:16 toolTip:"Export cinematics"
	checkbox DebugValue "Debug Messages" pos:[24,272] width:104 height:16 toolTip:"Debug value"
	checkbox OverrideValue "Always Override" pos:[24,296] width:104 height:16 toolTip:"Override Always"
	GroupBox grp2 "Tools" pos:[5,445] width:139 height:56
	button btnSetProperties "Set Properties" pos:[14,468] width:120 height:16 toolTip:"Open Property menu"
	dropdownList LevelList "" pos:[8,172] width:136 height:21 toolTip:"Level on save the files"
	button PhysxMeshCheck "ExportPhysXMesh" pos:[16,320] width:120 height:16 toolTip:"Export Only PhysX"
	button ExportSceneElementPhysxMeshButton "ElementPhysXMeshes" pos:[16,341] width:120 height:16 toolTip:"Export Only PhysX"
	
	Include "setProperties.ms"

	Include "Utilities.ms"

	Include "ExportMesh.ms"

	Include "ExportStaticMesh.ms"

	Include "ExportRenderableObjects.ms"

	Include "ExportCameras.ms"

	Include "ExportLigths.ms"

	Include "ExportPhysXMesh.ms"

	Include "ExportCameraPath.ms"

	Include "ExportSound.ms"

	Include "ExportCinematics.ms"

	on UABUtility open do
	(
		LevelList.items = levels
		DebugValue.checked = debug
		CopyTexturesCheck.checked = CopyTextures
		OverrideValue.checked = Override
		ExportMeshCheck.checked = ExportMeshes
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
	on ExportMeshCheck changed newValue do
	(
		ExportMeshes = ExportMeshCheck.checked
	)
	on CopyTexturesCheck changed newValue do
	(
		CopyTextures = CopyTexturesCheck.checked
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
	on ExportCameraPathButton pressed do
	(
		if debug then 
			format "Exporting camera path(s)\n"
		ExportCameraPath()
		format "==============================\n"
		format "camera path(s) exported correctly\n"
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
		if debug then 
			format "Exporting camera path(s)\n"
		ExportCameraPath()
		format "==============================\n"
		format "Full scene exported correctly\n"
		format "==============================\n"
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
	on DebugValue changed newValue do
	(
		debug = DebugValue.checked
	)
	on OverrideValue changed newValue do
	(
		Override = OverrideValue.checked
	)
	on btnSetProperties pressed do
	(
		createDialog UABSetProperties
	)
	on LevelList selected lvl do
	(
		PathToCopy = realPath + DataDirectory + LevelList.items[LevelList.selection] + "\\"
		RelativePathToCopy = DataDirectory + LevelList.items[LevelList.selection] + "\\"
		MeshPath = PathToCopy + MeshDirectory
		TexturePath = PathToCopy + TextureDirectory
		RelativeMeshPath = RelativePathToCopy + MeshDirectory
		RelativeTexturePath = RelativePathToCopy + TextureDirectory
	)
	on PhysxMeshCheck pressed do
	(
		if debug then
			format "Exporting Physx meshes\n"
		ExportPhysXMesh PhysXFileName "physics"
		format "==============================\n"
		format "PhysX exported correctly\n"
		format "==============================\n"
	)
	on ExportSceneElementPhysxMeshButton pressed do
	(
		if debug then
			format "Exporting Physx meshes\n"
		ExportPhysXMesh PhysXSceneElementFileName "use_phisic_mesh"
		format "==============================\n"
		format "Scene Element PhysX exported correctly\n"
		format "==============================\n"
	)
)
