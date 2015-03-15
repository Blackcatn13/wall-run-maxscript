sysinfo.currentdir = getFilenamePath (getSourceFileName())

-- UABUtility Variables
global debug = true
global levels=#("","level1","level2", "level3","level4", "level5", "main menu", "select player")
global realPath
global FileExtension = ".mesh"
global DataDirectory = "\\Data\\"
global MeshDirectory = "meshes\\"
global TextureDirectory = "textures\\"
global staticMeshFileName = "static_meshes.xml"
global renderableObjectsFileName = "renderable_objects.xml"
global CamerasFileName = "cameras.xml"
global AnimatedCamerasPath = "cameras\\"
global CopyTextures = true
global ExportMeshes = false
global Override = true
global PathToCopy
global RelativePathToCopy

-- XMLStrings

global XMLVersion		= "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n"
global XMLCloseTag		= "/>\n"
global XMLName			= " name="
global XMLFilename		= " filename="
global XMLCore			= " core="
global XMLPos			= " pos="
global XMLYaw			= " yaw="
global XMLPitch			= " pitch="
global XMLRoll			= " roll="
global XMLScale			= " scale="
global XMLVisible		= " visible="
global XMLLookAt		= " lookat="
global XMLFov			= " fov="
global XMLNear_plane	= " near_plane="
global XMLFar_plane		= " far_plane="
global XMLFile			= " file="
global XMLTime			= " time="
global XMLOnce 			= " once="
global XMLCycle 		= " cycle="
global XMLReverse		= " reverse="
global XML1Value      	= "\"%\""
global XML3Value		= "\"% % %\""


-- Properties values
global RenderLayers = #("solid", "skybox", "alpha_objects", "alpha_blend_objects", "particles")
global MeshType = #("mesh_instance", "animated_model")
global PhysicsType = #("triangle_mesh", "convex_shape", "box_shape", "plane_shape", "capsule_shape")
global PhysicsLayer = #("logic")
global logicGenerate = #("box_event", "sphere_event")
global EventList = #("event1")

-- Vertex declaration
global VERTEX_XYZ 		= 0x1
global VERTEX_NORMAL 	= 0x2
global VERTEX_TANGENT 	= 0x4
global VERTEX_BINORMAL 	= 0x8
global VERTEX_TEXTURE1 	= 0x10
global VERTEX_TEXTURE2 	= 0x20
global VERTEX_DIFFUSE 	= 0x40
global VERTEX_CUBEMAP 	= 0x200
global VERTEX_RNM 		= 0x400

-- ExportMesh Variables
global MeshPath
global TexturePath
global RelativeMeshPath
global RelativeTexturePath

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

	fn GetUserProperty Obj GUIObj StrProperty = 
(
	--local message = (classof GUIObj)
	--messagebox message
	if (getUserProp $ StrProperty)!=undefined then
	(
		--format "gui element type % and gui name %\n" (classof GUIObj) GUIObj.name
		--Aquí uno por cada tipo de elemento de GUI
		if (classof GUIObj) == ComboBoxControl then (
			local items = GUIObj.items
			local position = findItem items (getUserProp Obj StrProperty)
			GUIObj.selection = position
		)
		
		if (classof GUIObj) == CheckBoxControl then (
			if (getUserProp Obj StrProperty) == true then
				GUIObj.checked = true
			else
				GUIObj.checked = false
		)
		
		if (classof GUIObj) == EditTextControl then (
			GUIObj.text = (getUserProp Obj StrProperty as string)
			GUIObj.bold = true
		)
		
	)
	else
	(
		--messageBox ("Undefined property: \"" + StrProperty +"\".") title:"Undefined Property"
		false
	)
)

fn SetUserProperty Obj StrProperty StrValue =
(
	setUserProp Obj StrProperty StrValue
)

rollout UABSetProperties "UAB Set Properties" width:544 height:456
(
	groupBox RenderGp "Render" pos:[8,8] width:528 height:200
	groupBox PhysicsGp "Physics" pos:[8,216] width:256 height:88
	groupBox EventsGp "Events" pos:[272,216] width:264 height:56
	checkBox RenderExportCheckBox "Export" pos:[16,32] width:56 height:16
	checkBox RenderVisibleCheckBox "Visible" pos:[16,64] width:56 height:16
	checkBox LayerCheckBox "Layer" pos:[16,96] width:56 height:16
	dropDownList RenderExportList "" pos:[88,32] width:168 height:21
	dropDownList RenderLayerList "" pos:[88,96] width:168 height:21
	label AnimModelLabel "Anim. model" pos:[16,128] width:64 height:16
	editText AnimModelText "" pos:[88,128] width:168 height:16
	label TechniqueLabel "Technique" pos:[16,160] width:64 height:16
	editText TechniqueText "" pos:[88,160] width:168 height:16
	checkBox PhysicsGenerateCheckBox "Generate" pos:[16,240] width:64 height:16
	dropDownList PhysicsGenerateList "" pos:[88,240] width:168 height:21
	checkBox PhysicsLayerCheckBox "Layer" pos:[16,272] width:56 height:16
	dropDownList PhysicsLayerList "" pos:[88,272] width:168 height:21
	groupBox LogicGp "Logic" pos:[8,312] width:256 height:88
	checkBox LogicGenerateCheckBox "Generate" pos:[16,336] width:64 height:16
	dropDownList LogicGenerateList "" pos:[88,336] width:168 height:21
	checkBox ShowNormal "Show normal" pos:[96,368] width:88 height:16
	checkBox CameraVisibility "Don't test camera visibility" pos:[264,32] width:216 height:16
	checkBox WorldTransform "Don't export world transform" pos:[264,64] width:216 height:16
	editText LinkedBoneText "" pos:[368,96] width:152 height:16
	checkBox LinkedBoneCheck "Linked to bone" pos:[264,96] width:96 height:16
	checkBox Cinematics "Export to cinematics" pos:[264,128] width:216 height:16
	checkBox EventGenerateCheck "Generate" pos:[280,240] width:64 height:16
	dropDownList EventGenerateList "" pos:[352,240] width:176 height:21
	groupBox TracksGp "Tracks" pos:[272,280] width:128 height:56
	checkBox GenerateTracks "Generate" pos:[304,304] width:64 height:16
	groupBox CamerasGp "Cameras" pos:[272,344] width:264 height:56
	checkBox CycleCam "Cycle" pos:[280,368] width:56 height:16
	groupBox LightsGp "Lights" pos:[408,280] width:128 height:56
	checkBox GenerateLights "Generate" pos:[440,304] width:64 height:16
	checkBox ReverseCam "Reverse" pos:[368,368] width:64 height:16
	checkBox OnceCam "Once" pos:[456,368] width:56 height:16
	button GetButton "Get" pos:[160,416] width:104 height:32
	button SetButton "Set" pos:[272,416] width:104 height:32
	
	on UABSetProperties open do
	(	
		RenderExportList.items = MeshType
		RenderLayerList.items = RenderLayers
		PhysicsGenerateList.items = PhysicsType
		PhysicsLayerList.items=PhysicsLayer
		LogicGenerateList.items = logicGenerate
		EventGenerateList.items = EventList
	)
	
	on GetButton pressed  do
	(
		local obj
		if ((classof $) == ObjectSet) then (
			obj = $[1]
		) else ( 
			obj = $
		)
		
		GetUserProperty obj RenderExportCheckBox "export"
		GetUserProperty obj RenderExportList "export_type"
		GetUserProperty obj RenderVisibleCheckBox "visible"
		GetUserProperty obj LayerCheckBox "render_to_layer"
		GetUserProperty obj RenderLayerList "render_layer"
		GetUserProperty obj AnimModelText "anim_model"
		GetUserProperty obj TechniqueText "technique"
		GetUserProperty obj CameraVisibility "test_camera"
		GetUserProperty obj WorldTransform "export_world"
		GetUserProperty obj LinkedBoneCheck "linked"
		GetUserProperty obj LinkedBoneText "bone_linked"
		GetUserProperty obj Cinematics "cinematics"
		GetUserProperty obj PhysicsGenerateCheckBox "physics"
		GetUserProperty obj PhysicsGenerateList "physics_type"
		GetUserProperty obj PhysicsLayerCheckBox "physics_to_layer"
		GetUserProperty obj PhysicsLayerList "physics_layer"
		GetUserProperty obj LogicGenerateCheckBox "logic"
		GetUserProperty obj LogicGenerateList "logic_type"
		GetUserProperty obj ShowNormal "normal"
		GetUserProperty obj EventGenerateCheck "event"
		GetUserProperty obj EventGenerateList "event_type"
		GetUserProperty obj GenerateTracks "track"
		GetUserProperty obj CycleCam "cam_cycle"
		GetUserProperty obj ReverseCam "cam_reverse"
		GetUserProperty obj OnceCam "cam_once"
		GetUserProperty obj GenerateLights "lights"
	)
	
	on SetButton pressed  do
	(
		if ((classof $) == ObjectSet) then
		(
			for i = 1 to $.count do
			(
				SetUserProperty $[i] "export" RenderExportCheckBox.checked
				if RenderExportCheckBox.checked then
				(	
					SetUserProperty $[i] "export_type" RenderExportList.items[RenderExportList.selection]
				)
				SetUserProperty $[i] "visible" RenderVisibleCheckBox.checked
				SetUserProperty $[i] "render_to_layer" LayerCheckBox.checked
				if LayerCheckBox.checked then
				(	
					SetUserProperty $[i] "render_layer" RenderLayerList.items[RenderLayerList.selection]
				)
				if AnimModelText.text != "" or (getUserProp $[i] "anim_model")!=undefined then
				(
					SetUserProperty $[i] "anim_model" AnimModelText.text
				)
				if TechniqueText.text != "" or (getUserProp $[i] "technique")!=undefined then
				(
					SetUserProperty $[i] "technique" TechniqueText.text
				)
				SetUserProperty $[i] "test_camera" CameraVisibility.checked
				SetUserProperty $[i] "export_world" WorldTransform.checked
				SetUserProperty $[i] "linked" LinkedBoneCheck.checked
				if LinkedBoneText.text != "" or (getUserProp $[i] "bone_linked")!=undefined then
				(
					SetUserProperty $[i] "bone_linked" LinkedBoneText.text
				)
				SetUserProperty $[i] "cinematics" Cinematics.checked
				SetUserProperty $[i] "physics" PhysicsGenerateCheckBox.checked
				if PhysicsGenerateCheckBox.checked then (
					SetUserProperty $[i] "physics_type" PhysicsGenerateList.items[PhysicsGenerateList.selection]
				)
				SetUserProperty $[i] "physics_to_layer" PhysicsLayerCheckBox.checked
				if PhysicsLayerCheckBox.checked then (
					SetUserProperty $[i] "physics_layer" PhysicsLayerList.items[PhysicsLayerList.selection] 
				)
				SetUserProperty $[i] "logic" LogicGenerateCheckBox.checked
				if LogicGenerateCheckBox.checked then (
					SetUserProperty $[i] "logic_type" LogicGenerateList.items[LogicGenerateList.selection]
				)
				SetUserProperty $[i] "normal" ShowNormal.checked
				SetUserProperty $[i] "event" EventGenerateCheck.checked
				if EventGenerateCheck.checked then (
					SetUserProperty $[i] "event_type" EventGenerateList.items[EventGenerateList.selection]
				)
				SetUserProperty $[i] "track" GenerateTracks.checked
				SetUserProperty $[i] "cam_cycle" CycleCam.checked
				SetUserProperty $[i] "cam_reverse" ReverseCam.checked
				SetUserProperty $[i] "cam_once" OnceCam.checked
				SetUserProperty $[i] "lights" GenerateLights.checked
			)
		)
		else
		(
			SetUserProperty $ "export" RenderExportCheckBox.checked
			if RenderExportCheckBox.checked then
			(	
				SetUserProperty $ "export_type" RenderExportList.items[RenderExportList.selection]
			)
			SetUserProperty $ "visible" RenderVisibleCheckBox.checked
			SetUserProperty $ "render_to_layer" LayerCheckBox.checked
			if LayerCheckBox.checked then
			(	
				SetUserProperty $ "render_layer" RenderLayerList.items[RenderLayerList.selection]
			)
			if AnimModelText.text != "" or (getUserProp $ "anim_model")!=undefined then
			(
				SetUserProperty $ "anim_model" AnimModelText.text
			)
			if TechniqueText.text != "" or (getUserProp $ "technique")!=undefined then
			(
				SetUserProperty $ "technique" TechniqueText.text
			)
			SetUserProperty $ "test_camera" CameraVisibility.checked
			SetUserProperty $ "export_world" WorldTransform.checked
			SetUserProperty $ "linked" LinkedBoneCheck.checked
			if LinkedBoneText.text != "" or (getUserProp $ "bone_linked")!=undefined then
			(
				SetUserProperty $ "bone_linked" LinkedBoneText.text
			)
			SetUserProperty $ "cinematics" Cinematics.checked
			SetUserProperty $ "physics" PhysicsGenerateCheckBox.checked
			if PhysicsGenerateCheckBox.checked then (
				SetUserProperty $ "physics_type" PhysicsGenerateList.items[PhysicsGenerateList.selection]
			)
			SetUserProperty $ "physics_to_layer" PhysicsLayerCheckBox.checked
			if PhysicsLayerCheckBox.checked then (
				SetUserProperty $ "physics_layer" PhysicsLayerList.items[PhysicsLayerList.selection] 
			)
			SetUserProperty $ "logic" LogicGenerateCheckBox.checked
			if LogicGenerateCheckBox.checked then (
				SetUserProperty $ "logic_type" LogicGenerateList.items[LogicGenerateList.selection]
			)
			SetUserProperty $ "normal" ShowNormal.checked
			SetUserProperty $ "event" EventGenerateCheck.checked
			if EventGenerateCheck.checked then (
				SetUserProperty $ "event_type" EventGenerateList.items[EventGenerateList.selection]
			)
			SetUserProperty $ "track" GenerateTracks.checked
			SetUserProperty $ "cam_cycle" CycleCam.checked
			SetUserProperty $ "cam_reverse" ReverseCam.checked
			SetUserProperty $ "cam_once" OnceCam.checked
			SetUserProperty $ "lights" GenerateLights.checked
		)
	)
	
	on AnimModelText entered key do (
			AnimModelText.bold = false
	)
		
	on TechniqueText entered key do (
		TechniqueText.bold = false
	)
	
	on LinkedBoneText entered key do (
		LinkedBoneText.bold = false
	)
)

	global scene_geometry
global scene_geometry_toExport
global scene_cores

function GetObjectCores Obj =
(
	local start = timeStamp()
	local list = dotnetobject "System.Collections.Generic.List`1[System.String]"
	local cores=#()
	ss = Obj as array
	for i = 1 to ss.count do (
		InstanceMgr.GetInstances ss[i] &instances
		local isCore = true
		for j = 1 to instances.count do (
			if list.Contains instances[j].name then (
				isCore = false
			)
		)
		if isCore then (
			list.Add ss[i].name
			appendifUnique cores ss[i]
		)
	)
	local end = timeStamp()
	if debug then
		format "[GetObjectCores] time to calculate cores is %\n" (end - start)
	return cores
)

function getGeometryandCores =
(
	scene_geometry = geometry as Array
	scene_geometry_toExport = #()
	for i = 1 to scene_geometry.count do
	(
		if (GetUserProp scene_geometry[i] "export") == true then (
			appendifUnique scene_geometry_toExport scene_geometry[i]
		)
	)
	scene_cores = GetObjectCores scene_geometry_toExport
)

function GetObjectCore obj =
(
	pos = findItem scene_cores obj 
	if pos != 0 then (
		return (obj.name)
	) else (
		InstanceMgr.GetInstances obj &instances
		for i = 1 to instances.count do (
			pos = findItem scene_cores instances[i]
			if pos != 0	then (
				return (scene_cores[pos].name)
			)
		)
	)
)

function CreatePath path =
(
	if doesFileExist (path) == false then 
	(
		makeDir (path) all:true
		if debug then
			format "[ExportMesh] directorio % creado \n" path
	)
)

function GetYaw transform =
(
	return (transform as eulerangles).z
)

function GetPitch transform =
(
	return (transform as eulerangles).x
)

function GetRoll transform =
(
	return (transform as eulerangles).y
)

function RHTranslationToLH translation =
(
	return point3 translation.x translation.z translation.y
)

function GetScale _scale =
(
	return point3 _scale.x _scale.z _scale.y
)

function GetMeshesPathExport FilePath AbsPath =
(
	local newPath= pathConfig.convertPathToRelativeTo FilePath AbsPath
	if debug then
		format "[GetMeshesPathExport] test %\n" newPath
	return newPath
)

	global g_file
global g_NumMaterials
global g_Idxs
global g_Vtxs
global g_MaterialArray
global g_IsMultimaterial = false
global g_idxAccesArray
global g_VertexMsks
global UABVtxsNormals=#()

global g_texturesName = #() 

function GetNumberOfTextures mat =
(
	local num = 0
	if mat == undefined then
		return num
	if debug then
		format "[GetNumberOfTextures] number of possible textures is %\n" mat.maps.count
	for i=1 to mat.maps.count do (
		if mat.maps[i] != undefined and mat.mapEnables[i] == true then
		(
			num = num + 1
		)
	)
	if mat.selfIllumMapEnable and classOf(mat.selfIllumMap) == Multi_Sub_Map then
	(
		num = num + 2
	)
	return num
)

function getMask mat numText= 
(
	local VtxMask = VERTEX_XYZ
	if debug then 
	(
		format "[getMask] number of textures %\n" numText
		if numText >= 1 then 
		(
			format "[getMask] is diffuse enabled? % \n" mat.diffuseMapEnable
			format "[getMask] is bump enabled? % \n" mat.bumpMapEnable
			format "[getMask] is selfIllum enabled? % \n" mat.selfIllumMapEnable
			format "[getMask] is reflection enabled? % \n" mat.reflectionMapEnable
		)
	)
	if numText == 0  or mat.diffuseMapEnable == false then 
	(
		VtxMask = bit.or VtxMask VERTEX_DIFFUSE
	)
	if numText >= 1 then
	(
		if mat.diffuseMapEnable then
		(
			VtxMask = bit.or VtxMask VERTEX_NORMAL
			VtxMask = bit.or VtxMask VERTEX_TEXTURE1
			append g_texturesName (openBitMap mat.diffuseMap.bitmap.filename).fileName
		)
		if mat.bumpMapEnable then
		(
			VtxMask = bit.or VtxMask VERTEX_NORMAL
			VtxMask = bit.or VtxMask VERTEX_TEXTURE1
			VtxMask = bit.or VtxMask VERTEX_TANGENT
			VtxMask = bit.or VtxMask VERTEX_BINORMAL
			append g_texturesName (openBitMap mat.bumpMap.bitmap.filename).fileName 
		)
		if mat.selfIllumMapEnable then 
		(
			if classof(mat.selfIllumMap) == Multi_Sub_Map then
			(
				VtxMask = bit.or VtxMask VERTEX_NORMAL
				VtxMask = bit.or VtxMask VERTEX_TEXTURE2
				VtxMask = bit.or VtxMask VERTEX_RNM
				append g_texturesName (openBitMap mat.selfIllumMap.id_0_color_shader.bitmap.filename).fileName
				append g_texturesName (openBitMap mat.selfIllumMap.id_1_color_shader.bitmap.filename).fileName
				append g_texturesName (openBitMap mat.selfIllumMap.id_2_color_shader.bitmap.filename).fileName
			) else (
				VtxMask = bit.or VtxMask VERTEX_NORMAL
				VtxMask = bit.or VtxMask VERTEX_TEXTURE2
				append g_texturesName (openBitMap mat.selfIllumMap.bitmap.filename).fileName
			)
		)
		if mat.reflectionMapEnable then 
		(
			VtxMask = bit.or VtxMask VERTEX_NORMAL
			VtxMask = bit.or VtxMask VERTEX_TEXTURE1
			VtxMask = bit.or VtxMask VERTEX_CUBEMAP
			append g_texturesName (openBitMap mat.reflectionMap.bitmap.filename).fileName
		)
	)

	return VtxMask
)

function ExportMaterial _Material=
(
	if debug then
		format "[ExportMaterial] getting number of textures in material\n"
	local textNum = GetNumberOfTextures _Material
	if debug then (
		format "[ExportMaterial] number of textures in material = %\n" textNum
		format "[ExportMaterial] getting vertex mask\n"
	)
	local vtxmask = getMask _Material textNum
	local vtxmaskToWrite = (formattedprint vtxmask format:"x") as integer
	if debug then
		format "[ExportMaterial] vertex mask = %\n" vtxmaskToWrite
	
	WriteShort g_file vtxmask #unsigned --poner mascara
	WriteShort g_file textNum #unsigned --numero texturas
	if debug then
		format "[ExportMaterial] mat name %\n" _Material
	for i=1 to textNum do
	(
		if CopyTextures then 
		(
			if doesFileExist TexturePath == false then
			(
				makeDir TexturePath all:true
				if debug then
					format "[ExportMaterial] directorio % creado \n" TexturePath
			)
			FileName = filenameFromPath g_texturesName[i]
			FilePathName = RelativeTexturePath + FileName
			if debug then
				format "[ExportMaterial] Copy file Name: \"%\" \n" FilePathName
			if doesFileExist FilePathName and false then
			(
				if (Override == false) then
				(
					if (queryBox "File already exists in destination folder. Override?" title: "[ExportMaterial] File alreay exists" true) == true then (
						deleteFile FilePathName
						copyFile g_texturesName[i] FilePathName
					)
					else
					(
						copyFile g_texturesName[i] FilePathName
					)
				)
				else
				(
					deleteFile FilePathName
					copyFile g_texturesName[i] FilePathName
				)
			)
		)
		if debug then (
			format "[ExportMaterial] path %\n" g_texturesName[i]
			format "[ExportMaterial] path to cut %\n" realPath
		)
		local relPath = FilePathName 
		--if CopyTextures then (
		--	relPath = pathConfig.convertPathToRelativeTo FilePathName realPath
		--) else (
		--	FileNameAux = filenameFromPath g_texturesName[i]
		--	FilePathNameAux = TexturePath + FileNameAux
		--	relPath = pathConfig.convertPathToRelativeTo FilePathNameAux realPath
		--)
		if debug then
			format "[ExportMaterial] rel path %\n" relPath
		local numChars = relPath.count
		WriteShort g_file numChars #unsigned
		WriteString g_file relPath 
	)
	return vtxmask
)

function ExportMaterials Obj =
(
	if g_IsMultimaterial then (
		if debug then
			format "[ExportMaterials] is multimaterial\n"
		for i = 1 to g_NumMaterials do
		(
			local aux = g_MaterialArray[i]
			if debug then
				format "[ExportMaterials] material index is %\n" aux
			append g_VertexMsks (ExportMaterial (Obj.material[aux]))
		)
	) else (
		if debug then
			format "[ExportMaterials] not multimaterial\n"
		for i = 1 to g_NumMaterials do
		(
			append g_VertexMsks (ExportMaterial (Obj.material))
		)
	)
)


function UABClearNormalsArray =
(
	while UABVtxsNormals.count>0 do (
		deleteItem UABVtxsNormals 1
	)
)

function IsSmoothingGroupEnabled IdGroup Value =
(
	local ValueMask=2^(IdGroup-1)	
	return (bit.and Value ValueMask)==ValueMask
)

function UABCalcVertexsNormals obj =
(
	UABClearNormalsArray()
	local NumVtxs=getNumVerts obj
	for b=1 to NumVtxs do (
		UABVtxsNormals[b]=#()
		for t=1 to 32 do (
			UABVtxsNormals[b][t]=point3 0 0 0
		)
	)
	local NumFaces=getNumFaces obj
	local InvTransform=inverse obj.transform
	for IdFace=1 to NumFaces do (
		local IdxsFace=getFace obj IdFace
		local Vtx1=(getVert obj IdxsFace.x)*InvTransform
		local Vtx3=(getVert obj IdxsFace.z)*InvTransform
		local FaceNormal=getFaceNormal obj IdFace
		local SmoothValue=getFaceSmoothGroup obj IdFace
		for b=1 to 32 do (
			if((IsSmoothingGroupEnabled b SmoothValue)==true) then (
				UABVtxsNormals[IdxsFace.x][b]=UABVtxsNormals[IdxsFace.x][b] + FaceNormal
				UABVtxsNormals[IdxsFace.y][b]=UABVtxsNormals[IdxsFace.y][b] + FaceNormal
				UABVtxsNormals[IdxsFace.z][b]=UABVtxsNormals[IdxsFace.z][b] + FaceNormal
			)
		)
	)
)

function UABGetVertexNormal obj IdVertex SmoothValue FaceNormal =
(
	local HasNormal=false
	local Normal=point3 0 0 0
	for b=1 to 32 do (
		if((IsSmoothingGroupEnabled b SmoothValue)==true) then (
			Normal=Normal+UABVtxsNormals[IdVertex][b]
			HasNormal=true
		)
	)
	if HasNormal==false then (
		Normal=FaceNormal
	)
	return Normal
)


function CreateFullVertex vtx n tu1 tu2 col tn bn mater=
(
	local vertex=#()
	if (bit.and mater VERTEX_XYZ) == VERTEX_XYZ then (
		append vertex vtx.x
		append vertex vtx.z
		append vertex vtx.y	
	)
	if (bit.and mater VERTEX_NORMAL) == VERTEX_NORMAL then (
		n = normalize(n)
		append vertex n.x
		append vertex n.z
		append vertex n.y
	)
	if(bit.and mater VERTEX_TANGENT) == VERTEX_TANGENT then (
		append vertex 1.0
		append vertex 0.0
		append vertex 0.0
		append vertex 0.0
		append vertex 0.0
	)
	if(bit.and mater VERTEX_BINORMAL) == VERTEX_BINORMAL then (
		append vertex 0.0
		append vertex 0.0
		append vertex 0.0
		append vertex 0.0
	)
	if (bit.and mater VERTEX_DIFFUSE) == VERTEX_DIFFUSE then (
		local alphaValue = bit.and col.a 0xff
		local redValue = bit.and col.r 0xff	
		local greenValue = bit.and col.g 0xff
		local blueValue = bit.and col.b 0xff
		local finalColor = bit.shift alphaValue 24
		finalColor = finalColor + (bit.shift redValue 16)
		finalColor = finalColor + (bit.shift greenValue 8)
		finalColor = finalColor + blueValue
		if debug then
			format "[CreateFullVertex] finalColor is %\n" (formattedprint finalColor format:"x")
		append vertex finalColor
	)
	if (bit.and mater VERTEX_TEXTURE1) == VERTEX_TEXTURE1 then (
		append vertex tu1.x
		local v =  (0.0f - (tu1.y - 1.0f))
		append vertex v
	)
	if (bit.and mater VERTEX_TEXTURE2) == VERTEX_TEXTURE2 then (
		append vertex tu2.x
		local v =  (0.0f - (tu2.y - 1.0f))
		append vertex v
	)
	
	return vertex
)

function ConvertVtx vtx =
(
	local l_Text=stringstream ""
	local l_value=""
	for i=1 to vtx.count do (
		format "%," vtx[i] to:l_Text
	)
	return (l_Text as string)
)

function dotNetAddVertex vtx vrtxs idMaterial vtxMap=
(
	local l_vtxString = ConvertVtx vtx
	local l_idx = 1
	if(vtxMap[idMaterial].ContainsKey(l_vtxString)) == false then (
		while vrtxs.count<idMaterial do
		(
			append vrtxs (#())
		)
		append vrtxs[idMaterial] vtx
		l_idx = vrtxs[idMaterial].count
		vtxMap[idMaterial].Add l_vtxString l_idx
	) else (
		l_idx = vtxMap[idMaterial].Item[l_vtxString]
	)
	return l_idx
)

function AddIndex index idxs idMaterial =
(
	while idxs.count<idMaterial do
	(
		append idxs (#())
	)
	
	append idxs[idMaterial] (index-1)
)

function GenerateVertexs Obj =
(
	UABCalcVertexsNormals Obj
	local numFaces = getNumFaces Obj
	local l_vtxMap = array=#()
	for i = 1 to numFaces do (
		l_vtxMap[i] = dotnetobject "System.Collections.Generic.Dictionary`2[System.String,System.Int16]"
	)
	if debug then (
		format "[GenerateVertexs] num faces %\n" numFaces
		format "[GenerateVertexs] vertex mask size %\n" g_VertexMsks.count
	)
	for face=1 to numFaces do
	(
		--format "Processing face number %\n" face
		local aFace=getFace Obj face
		local vtx1=(getVert Obj aFace.x) * inverse Obj.transform
		local vtx2=(getVert Obj aFace.y) * inverse Obj.transform
		local vtx3=(getVert Obj aFace.z) * inverse Obj.transform
		
		local sm =getFaceSmoothGroup Obj face
		--UABGetVertexNormal obj IdVertex SmoothValue FaceNormal 
		local n1 = getNormal Obj aFace.x
		local n2 = getNormal Obj aFace.y
		local n3 = getNormal Obj aFace.z
		local Normal1 = UABGetVertexNormal Obj aFace.x sm n1
		local Normal2 = UABGetVertexNormal Obj aFace.y sm n2
		local Normal3 = UABGetVertexNormal Obj aFace.z sm n3
		
		if debug then (
			format "[GenerateVertexs] number of texture maps %\n" ((meshop.getNumMaps Obj) - 1)
		)
		
		local IdxsMap =  meshop.getMapFace Obj 1 face
		local TUVMap1 =  meshop.getMapVert Obj 1 IdxsMap.x
		local TUVMap2 =  meshop.getMapVert Obj 1 IdxsMap.y
		local TUVMap3 =  meshop.getMapVert Obj 1 IdxsMap.z
		
		local TUV2Map1 = TUVMap1
		local TUV2Map2 = TUVMap2
		local TUV2Map3 = TUVMap3
		
		if ((meshop.getNumMaps Obj)  - 1) > 1 then (
			Idxs2Map = meshop.getMapFace Obj 2 face
			TUV2Map1 = meshop.getMapVert Obj 2 Idxs2Map.x
			TUV2Map2 = meshop.getMapVert Obj 2 Idxs2Map.y
			TUV2Map3 = meshop.getMapVert Obj 2 Idxs2Map.z
		)
		
		local idMaterial = getFaceMatID Obj face
		if debug then (
			format "[GenerateVertexs] material of face is %\n" idMaterial
			format "[GenerateVertex] old idnx Array is %\n" g_idxAccesArray
		)
		local maskpos = findItem g_idxAccesArray idMaterial
		if maskpos == 0 then (
			if debug then
				format "[GenerateVertexs] not found material % in the materialArray %\n" idMaterial g_idxAccesArray
			maskpos = 1
		)
		local realpos = g_MaterialArray[maskpos]
		local Col
		if debug then (
			format "[GenerateVertexs] class of material %\n" (classof(Obj.material))
			format "[GenerateVertexs] maskpos is %\n" realpos
		)
		if classof(Obj.material)==Standardmaterial then
		(
			--idMaterial=1
			Col = Obj.material.diffuse
		)
		else (
			if classof(Obj.material) == UndefinedClass then 
			(
				Col = Obj.wirecolor
				realpos = 1
			) else (
				if maskpos > Obj.material.count then (
					Col = Obj.wirecolor
				) else (
					Col = Obj.material[maskpos].diffuse
				)
			)
		)
		
		if debug then
			format "[GenerateVertexs] vertex mask of this material is %\n" g_VertexMsks[realpos]
		local totalVertex1 = CreateFullVertex vtx1 Normal1 TUVMap1 TUV2Map1 Col 0 0 g_VertexMsks[realpos]
		local totalVertex2 = CreateFullVertex vtx2 Normal2 TUVMap2 TUV2Map2 Col 0 0 g_VertexMsks[realpos]
		local totalVertex3 = CreateFullVertex vtx3 Normal3 TUVMap3 TUV2Map3 Col 0 0 g_VertexMsks[realpos]
		
		local index1=dotNetAddVertex totalVertex1 g_Vtxs idMaterial l_vtxMap
		local index2=dotNetAddVertex totalVertex2 g_Vtxs idMaterial l_vtxMap
		local index3=dotNetAddVertex totalVertex3 g_Vtxs idMaterial l_vtxMap
	
		AddIndex index3 g_Idxs idMaterial
		AddIndex index2 g_Idxs idMaterial
		AddIndex index1 g_Idxs idMaterial
	
	)
)


fn BoundingBox Obj =
(
	local Xmin, Ymin, Zmin, Xmax, Ymax,Zmax

	for i = 1 to Obj.numVerts do 
	(
		-- Init variables para comparar
		if i == 1 then
		(
			Xmin = (getVert Obj i).x
			Ymin = (getVert Obj i).y
			Zmin = (getVert Obj i).z
			Xmax = (getVert Obj i).x
			Ymax = (getVert Obj i).y
			Zmax = (getVert Obj i).z	
		)
		else(
			-- Pillar x,y,z min
			if(getVert Obj i).x <= Xmin then
				Xmin = (getVert Obj i).x
			if (getVert Obj i).y <= Ymin then
				Ymin = (getVert Obj i).y
			if (getVert Obj i).z <= Zmin then
				Zmin = (getVert Obj i).z
			-- Pillar x,y,z max
			if (getVert Obj i).x >= Xmax then
				Xmax = (getVert Obj i).x
			if (getVert Obj i).y >= Ymax then
				Ymax = (getVert Obj i).y
			if (getVert Obj i).z >= Zmax then
				Zmax = (getVert Obj i).z
		)
	)

	return #(Xmin, Ymin, Zmin, Xmax, Ymax, Zmax)
)

fn BoundingSphere Obj =
(
	local BSCenter, XCenter, YCenter, ZCenter
	local BSRadius = 0
	local BBox = BoundingBox Obj
	
	XCenter = (BBox[4] + BBox[1])/2
	YCenter = (BBox[5] + BBox[2])/2
	ZCenter = (BBox[6] + BBox[3])/2
	
	BSCenter = [XCenter,YCenter,ZCenter]
	if debug then
		format "BScenter % \n" BSCenter
	
	for i = 1 to Obj.numVerts do 
	(
		RadiusDistance = sqrt((((getVert Obj i).x - BSCenter[1])^2) + (((getVert Obj i).y - BSCenter[2])^2) + (((getVert Obj i).z - BSCenter[3])^2))
		if RadiusDistance > BSRadius then
			BSRadius = RadiusDistance
	)
	if debug then
		format "BSRadius : % \n" BSRadius
	
	return #(BSCenter[1], BSCenter[2], BSCenter[3], BSRadius)
	
)

fn TryCloneObjects Obj =
(
	local ClonedObjects
		try
		(
			if((classof Obj)==ObjectSet or (classof Obj) == PathName) then
			(
				for i = 1 to Obj.count do
					getVert Obj[i] 1
			)
			else
				getVert Obj 1
		)
		catch
		(
			--errorStr = getCurrentException() 
			ClonedObjects = CloneObjects Obj
		)
		return ClonedObjects
		
)


fn CloneObjects Objs = 
(
	if debug then
		format "[CloneObjects] Selection % \n" Objs
	if Objs != undefined then
	(
	--Clonar objeto/s como Core o instance segun sea (Si no se especifica lo contrario se copia como sea)
		maxOps.cloneNodes (Objs) newNodes:&nnl #nodialog
		for i = 1 to nnl.count do
		(
			if(classof Objs) == ObjectSet or  (classof Objs) == PathName then
				nnl[i].name = uniqueName (Objs[i].name +"_MeshCopy_") numDigits:3
			else
				nnl[i].name = uniqueName (Objs.name +"_MeshCopy_") numDigits:3
			if debug then
				format "[CloneObjects] Object % created \n" nnl[i].name
			convertToMesh nnl[i]
		)
		
		if (classof Objs) != PathName then	
			Select nnl	
		
		return nnl
	)
	else
	(
		if debug then
			format "[CloneObjects] No selected Items \n"
	)
	
)

fn DeleteClonedObjects ObjArray =
(
	for i = 1 to ObjArray.count do
	(
		if debug then
			format "[DeleteClonedObjects] Eliminando % \n" ObjArray[i]
		delete ObjArray[i]	
	)
)

function CreateMaterialArray Obj =
(
	if debug then
		format "[CreateMaterialArray] getting materials applied\n"
	local array=#()
	for i=1 to (getNumFaces Obj) do 
	(
		appendifUnique array (getFaceMatID Obj i)
	)
	if debug then
		format "[CreateMaterialArray]\n--------------------\narray of idexes %\n--------------------\n" array
	sort array
	g_idxAccesArray = deepcopy array
	if debug then
		format "[CreateMaterialArray] looking for cicle ids\n"
	for i =1 to array.count do (
		if classof(Obj.material) == Multimaterial then (
			local pos = array[i]
			if Obj.material[pos] == undefined then (
				local newIndex = mod pos Obj.material.count as integer
				if newIndex == 0 then
					newIndex = Obj.material.count
				array[i] = newIndex
			)
		)
	)
	if debug then
		format "[CreateMaterialArray] ordered array is %\n" array
	return array
)

function ExportVertexs idMaterial vtxmask =
(
	if debug then
		format "[ExportVertexs] Exporting vertex with idMaterial %\n" idMaterial
	for  j=1 to g_Vtxs[idMaterial].count do
	(            
		local k = 1
		if (bit.and vtxmask VERTEX_XYZ) == VERTEX_XYZ then (
			if debug then
				format "[ExportVertexs] position: % % %\n" g_Vtxs[idMaterial][j][k] g_Vtxs[idMaterial][j][k+1] g_Vtxs[idMaterial][j][k+2]
			writeFloat g_file g_Vtxs[idMaterial][j][k]
			writeFloat g_file g_Vtxs[idMaterial][j][k+1]
			writeFloat g_file g_Vtxs[idMaterial][j][k+2]
			k = k + 3
		)
		if (bit.and vtxmask VERTEX_NORMAL) == VERTEX_NORMAL then (
			if debug then
				format "[ExportVertexs] normal: % % %\n" g_Vtxs[idMaterial][j][k] g_Vtxs[idMaterial][j][k+1] g_Vtxs[idMaterial][j][k+2]
			writeFloat g_file g_Vtxs[idMaterial][j][k]
			writeFloat g_file g_Vtxs[idMaterial][j][k+1]
			writeFloat g_file g_Vtxs[idMaterial][j][k+2]
			k = k + 3
		)
		if (bit.and vtxmask VERTEX_TANGENT) == VERTEX_TANGENT then (
			if debug then
					format "[ExportVertexs] normal w: %\n" g_Vtxs[idMaterial][j][k]
			writeFloat g_file g_Vtxs[idMaterial][j][k]
			if debug then
				format "[ExportVertexs] tangent: % % % %\n" g_Vtxs[idMaterial][j][k+1] g_Vtxs[idMaterial][j][k+2] g_Vtxs[idMaterial][j][k+3] g_Vtxs[idMaterial][j][k+4]
			writeFloat g_file g_Vtxs[idMaterial][j][k+1]
			writeFloat g_file g_Vtxs[idMaterial][j][k+2]
			writeFloat g_file g_Vtxs[idMaterial][j][k+3]
			writeFloat g_file g_Vtxs[idMaterial][j][k+4]
			k = k + 5
		)
		if (bit.and vtxmask VERTEX_BINORMAL) == VERTEX_BINORMAL then (
			if debug then
				format "[ExportVertexs] binormal: % % % %\n" g_Vtxs[idMaterial][j][k] g_Vtxs[idMaterial][j][k+1] g_Vtxs[idMaterial][j][k+2] g_Vtxs[idMaterial][j][k+3]
			writeFloat g_file g_Vtxs[idMaterial][j][k]
			writeFloat g_file g_Vtxs[idMaterial][j][k+1]
			writeFloat g_file g_Vtxs[idMaterial][j][k+2]
			writeFloat g_file g_Vtxs[idMaterial][j][k+3]
			k = k + 4
		)
		if (bit.and vtxmask VERTEX_DIFFUSE) == VERTEX_DIFFUSE then (
			if debug then
				format "[ExportVertexs] color: %\n" g_Vtxs[idMaterial][j][k]
			writeLong g_file g_Vtxs[idMaterial][j][k] #unsigned
			k = k + 1
		)
		if (bit.and vtxmask VERTEX_TEXTURE1) == VERTEX_TEXTURE1 then (
			if debug then
				format "[ExportVertexs] uv: % %\n" g_Vtxs[idMaterial][j][k] g_Vtxs[idMaterial][j][k+1]
			writeFloat g_file g_Vtxs[idMaterial][j][k]
			writeFloat g_file g_Vtxs[idMaterial][j][k+1]
			k = k + 2
		)
		if(bit.and vtxmask VERTEX_TEXTURE2) == VERTEX_TEXTURE2 then (
			if debug then
				format "[ExportVertexs] uv2: % %\n" g_Vtxs[idMaterial][j][k] g_Vtxs[idMaterial][j][k+1]
			writeFloat g_file g_Vtxs[idMaterial][j][k]
			writeFloat g_file g_Vtxs[idMaterial][j][k+1]
			k = k + 2
		)
	)
)

function ExportIndexs idMaterial =
(
	for  j=1 to g_Idxs[idMaterial].count do
	(   
		WriteShort g_file g_Idxs[idMaterial][j] #unsigned
	)
)

function ExportMesh Obj filename=
(
	if ExportMeshes or CopyTextures then 
	(
		if debug then
			format "[ExportMesh] exporting %\n" filename

		if debug then
			format "[ExportMesh] Cloning object\n"

		ClonedObj_A = CloneObjects Obj
		ClonedObj = ClonedObj_A[1]

		CreatePath MeshPath

		g_Vtxs = #()
		g_Idxs = #()
		if ExportMeshes then
			g_file = fopen (MeshPath + filename) "wb"
		--g_MaterialArray = #()

		-- Starting export of mesh
		-- First write header of file 0x55FF
		if ExportMeshes then
			WriteShort g_file 0x55FF #unsigned

		-- Check if material assigned is Multimaterial
		if classOf (ClonedObj.material) == Multimaterial then 
		(
			g_IsMultimaterial = true
			if debug then
				format "[ExportMesh] el objeto tiene aplicado un multimaterial\n"
			--g_NumMaterials = Obj.material.numsubs
		)
		else
		(
			if classOf (ClonedObj.material) != UndefinedClass then
			(
				if debug then
					format "[ExportMesh] el objeto tiene aplicado un material standard\n"
				--g_NumMaterials = 1
			)
		)
		-- We get the real materials applied to the object
		g_MaterialArray = CreateMaterialArray ClonedObj
		g_NumMaterials = g_MaterialArray.count

		-- Write to the file the number of Materials
		if ExportMeshes then
			WriteShort g_file g_NumMaterials #unsigned
		if debug then
			format "[ExportMesh] exporting materials\n"
		g_VertexMsks = #()
		ExportMaterials ClonedObj
		if debug then
		(
			format "[ExportMesh] vertex masks % \n" g_VertexMsks
			format "[ExportMesh] Generating vertex\n"
		)
		-- Generate Vertex information
		if ExportMeshes then 
		(
			GenerateVertexs ClonedObj
		    -- Write vertex information

			for idMaterial = 1 to g_NumMaterials do
			(
				if debug then (
					format "[ExportMesh] l_NumMaterials %\n" g_NumMaterials
					format "[ExportMesh] %\n" g_Vtxs
				)
				local numVertex = g_Vtxs[g_idxAccesArray[idMaterial]].count
				local numIndexes = g_Idxs[g_idxAccesArray[idMaterial]].count
				if debug then (
					format "[ExportMesh] num vertex = %\n" numVertex
					format "[ExportMesh] num index = %\n" numIndexes
				)
				if numVertex == 0 or numIndexes == 0 then (
					if debug then
						format "[ExportMesh] excluding face \n"
					continue
				)
				local vtxmaskpos = findItem g_MaterialArray g_MaterialArray[idMaterial]
				WriteShort g_file numVertex #unsigned
				ExportVertexs g_idxAccesArray[idMaterial] g_VertexMsks[vtxmaskpos]    --Estos arrays en realiad son tridimensionales [][][]
				WriteShort g_file numIndexes #unsigned
				ExportIndexs g_idxAccesArray[idMaterial]
			)
			-- Calculate BB and BS
			local BBox, BSphere
			BBox = BoundingBox ClonedObj
			BSphere = BoundingSphere ClonedObj
			for BBIndex = 1 to BBox.count do
			(
				WriteFloat g_file BBox[BBindex]
			)
			for BBIndex = 1 to BSphere.count do
			(
				WriteFloat g_file BSphere[BBindex]
			)
			-- Export footer
			WriteShort g_file 0xFF55 #unsigned
			fflush g_file
			fclose g_file
		)
		DeleteClonedObjects ClonedObj_A
	)
)


	global sm_open_file_tag 	= "<static_meshes>\n"
global sm_close_file_tag 	= "</static_meshes>\n"
global sm_init_tag 			= "\t<static_mesh"

global sm_file

function ExportStaticMesh =
(
	getGeometryandCores()
	CreatePath PathToCopy

	sm_file = createfile (PathToCopy + staticMeshFileName)

	format (XMLVersion) to:sm_file
	format (sm_open_file_tag) to:sm_file

	for i = 1 to scene_cores.count do
	(
		if (GetUserProp scene_cores[i] "export") == true then
		(
			meshFileAux = RelativeMeshPath + scene_cores[i].name + FileExtension
			format (sm_init_tag + XMLName + XML1Value + XMLFilename + XML1Value + XMLCloseTag) scene_cores[i].name meshFileAux to:sm_file
			ExportMesh scene_cores[i] (scene_cores[i].name + FileExtension)
		)
	)
	format (sm_close_file_tag) to:sm_file
	close sm_file
)

	global ro_open_file_tag		= "<renderable_objects>\n"
global ro_close_file_tag	= "</renderable_objects>\n"
global ro_mesh 				= "\t<mesh_instance"
global ro_animated			= "\t<animated_model"

global ro_file

function ExportRenderableObjects =
(
	getGeometryandCores()
	CreatePath PathToCopy

	ro_file = createfile (PathToCopy + renderableObjectsFileName)

	format (XMLVersion) to:ro_file
	format (ro_open_file_tag) to:ro_file

	for i = 1 to scene_geometry_toExport.count do
	(
		if (GetUserProp scene_geometry_toExport[i] "export" == true) then (
			local ObjName = scene_geometry_toExport[i].name
			local yawAng = DegToRad (GetYaw scene_geometry_toExport[i].transform)
			local pitchAng = DegToRad (GetPitch scene_geometry_toExport[i].transform)
			local rollAng = DegToRad (GetRoll scene_geometry_toExport[i].transform)
			local Translation = scene_geometry_toExport[i].transform.translation
			local ObjScale = (GetScale scene_geometry_toExport[i].scale)
			local tranX = formattedPrint Translation.x format:"f"
			local tranY = formattedPrint Translation.y format:"f"
			local tranZ = formattedPrint Translation.z format:"f"
			local visible = GetUserProp scene_geometry_toExport[i] "visible"

			if (GetUserProp scene_geometry_toExport[i] "export_type" == "mesh_instance") then
				format (ro_mesh + XMLName + XML1Value + XMLCore + XML1Value) ObjName (GetObjectCore scene_geometry_toExport[i]) to:ro_file
			if (GetUserProp scene_geometry_toExport[i] "export_type" == "animated_model") then
				format (ro_animated + XMLName + XML1Value + XMLCore + XML1Value) ObjName (GetUserProp scene_geometry_toExport[i] "anim_model") to:ro_file
			format (XMLPos + XML3Value + XMLYaw + XML1Value) tranX tranY tranZ yawAng to:ro_file
			format (XMLPitch + XML1Value + XMLRoll + XML1Value + XMLScale + XML3Value + XMLVisible + XML1Value + XMLCloseTag) pitchAng rollAnf ObjScale.x ObjScale.y ObjScale.z visible to:ro_file
		)
	)
	format (ro_close_file_tag) to:ro_file
	close ro_file
)

	global camera_open_file_tag			= "<cameras>\n"
global camera_close_file_tag		= "</cameras>\n"
global camera_fixed 				= "\t<fixed_camera"
global camera_key_controller		= "\t<key_camera_controller"
global camera_key 					= "\t<key"
global camera_open_key_controller 	= "<camera_key_controller"
global camera_close_key_controller	= "</camera_key_controller>\n"

global cam_file
global cam_to_export

function exportStaticCamera cam =
(
	if debug then
		format "[exportStaticCamera] starting export of static camera\n"
	local pos = RHTranslationToLH cam.pos
	local targetDist
	if cam.type == #free then (
		targetDist = cam.baseObject.TargetDistance
	) else (
		targetDist = cam.TargetDistance
	)
	local _lookat = RHTranslationToLH (pos - cam.dir * targetDist)
	local fov = DegToRad cam.fov
	format (camera_fixed + XMLName + XML1Value) cam.name to:cam_file
	format (XMLPos + XML3Value + XMLLookAt + XML3Value) pos.x pos.y pos.z _lookat.x _lookat.y _lookat.z to:cam_file
	format (XMLFov + XML1Value + XMLNear_plane + XML1Value + XMLFar_plane + XML1Value + XMLCloseTag) fov cam.nearClip cam.farClip to:cam_file
	if debug then
		format "[exportStaticCamera] camera exported\n"
)

function exportAnimatedCamera cam= 
(
	if debug then
		format "[exportAnimatedCamera] starting export of animated camera\n"

	CreatePath (PathToCopy + AnimatedCamerasPath)
	
	local pathaux = GetMeshesPathExport (RelativePathToCopy + AnimatedCamerasPath) PathToCopy
	local camXML = pathaux + cam.name + ".xml"
	local camAbsXML = PathToCopy + AnimatedCamerasPath + cam.name + ".xml"

	format (camera_key_controller + XMLName + XML1Value + XMLFile + XML1Value + XMLCloseTag) cam.name camXML to:cam_file
	if debug then
		format "[exportAnimatedCamera] starting export of keys\n"
	exportCameraKeyFrames cam camAbsXML
	if debug then
		format "[exportAnimatedCamera] camera exported\n"
)

function exportCameraKeyFrames cam fileNameWithPath =
(
	select cam
	if debug then
		format "[exportCameraKeyFrames] starting export of animated camera\n"
	local file = createfile (fileNameWithPath)
	format (XMLVersion) to:file
	format (camera_open_key_controller + XMLName + XML1Value ) cam.name to:file
	if (getUserProp cam "cam_once") == true then
		local once = true
	else 
		local once = false
	if (getUserProp cam "cam_cycle") == true then
		local cycle = true
	else 
		local cycle = false
	if (getUserProp cam "cam_reverse") == true then
		local _reverse = true
	else 
		local _reverse = false
	format (XMLOnce + XML1Value + XMLCycle + XML1Value + XMLReverse + XML1Value + XMLCloseTag) once cycle _reverse to:file
	local animStart = animationRange.start
	local animStop = animationRange.end
	local fr = frameRate
	local key = (at time animStop trackbar.getNextKeyTime()).frame
	if debug then (
		format "[exportCameraKeyFrames] range of animation % - %\n" animStart animStop
		format "[exportCameraKeyFrames] frameRate of animation = %\n" fr
		format "[exportCameraKeyFrames] first key to export %\n" key
	)
	do (
		if debug then
			format "[exportCameraKeyFrames] exporting key %\n" key
		_time = key / fr
		pos = at time key RHTranslationToLH(cam.pos)
		dir = at time key cam.dir
		if cam.type == #free then (
			targetDist = at time key cam.baseObject.TargetDistance
			_lookat = RHTranslationToLH (pos - dir * targetDist)
		) else (
			targetDist = at time key cam.TargetDistance
			_lookat = at time key RHTranslationToLH(cam.Target.pos)
		)
		--_lookat = RHTranslationToLH (pos - dir * targetDist)
		fov = DegToRad (at time key cam.fov)
		near = at time key cam.nearClip
		far = at time key cam.farclip
		format (camera_key + XMLTime + XML1Value) _time to:file
		format (XMLPos + XML3Value + XMLLookAt + XML3Value) pos.x pos.y pos.z _lookat.x _lookat.y _lookat.z to:file
		format (XMLFov + XML1Value + XMLNear_plane + XML1Value + XMLFar_plane + XML1Value + XMLCloseTag) fov near far to:file
		key = (at time key trackbar.getNextKeyTime()).frame
    ) while key > animStart
    format (camera_close_key_controller) to:file
	close file
	if debug then
		format "[exportCameraKeyFrames] export keys ended\n"
)

function exportCameras cameraList=
(
	if debug then
		format "[exportCameras] starting export of cameras\n"
	if cameraList == undefined then (
		cam_to_export = cameras as array
	) else ( 
		if classof cameraList == ObjectSet then (
			cam_to_export = cameraList
		) else (
			cam_to_export = #(cameraList)
		)
	)
	if cam_to_export.count >= 1 then (
		if debug then
			format "[exportCameras] exporting % cameras\n" cam_to_export.count

		CreatePath PathToCopy
		
		cam_file = createfile (PathToCopy + CamerasFileName)

		format (XMLVersion) to:cam_file
		format (camera_open_file_tag) to:cam_file

		for i=1 to cam_to_export.count do (
			if (findString ((classof cam_to_export[i]) as string) "camera") != undefined then (
				if cam_to_export[i].pos.isAnimated == true then (
					if debug then
						format "[exportCameras] exporting animated camera\n"
					exportAnimatedCamera cam_to_export[i]
				) else (
					if debug then
						format "[exportCameras] exporting static camera\n"
					exportStaticCamera cam_to_export[i] 
				)
			)
		)
		format (camera_close_file_tag) to:cam_file
		close cam_file
	)
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
		format "==============================\n"
		format "Full scene exported correctly\n"
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


)