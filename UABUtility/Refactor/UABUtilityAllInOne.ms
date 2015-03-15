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
global CopyTextures = true
global ExportMeshes = false
global Override = true
global PathToCopy
global XMLVersion = "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n"
global XMLCloseTag = "/>\n"
global XMLSpace = " "

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

	global scene_geometry=#()
	global scene_cores=#()

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
		scene_cores = GetObjectCores scene_geometry
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

	global g_file
	global g_NumMaterials
	global g_Idxs
	global g_Vtxs
	global g_MaterialArray
	global g_IsMultimaterial = false
	global g_idxAccesArray
	global g_VertexMsks
	global UABVtxsNormals=#()

	-- Global functions 
	global ExportMaterial
	global GenerateVertexs
	global UABClearNormalsArray
	global IsSmoothingGroupEnabled
	global UABGetVertexNormal
	global UABCalcVertexsNormals
	global BoundingBox
	global BoundingSphere
	global CreateMaterialArray
	global ExportMaterials
	global GetNumberOfTextures
	global getMask
	global TryCloneObjects
	global CloneObjects
	global DeleteClonedObjects
	global CreateFullVertex
	global ExportVertexs
	global ExportIndexs
	global ConvertVtx
	global dotNetAddVertex
	global AddIndex

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
				FilePathName = TexturePath + filenameFromPath
				if debug then
					format "[ExportMaterial] Copy file Name: \"%\" \n" FilePathName
				if doesFileExist FilePathNamem and false then
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
			local relPath 
			if CopyTextures then (
				relPath = pathConfig.convertPathToRelativeTo FilePathName realPath
			) else (
				FileNameAux = filenameFromPath g_texturesName[i]
				FilePathNameAux = TexturePath + FileNameAux
				relPath = pathConfig.convertPathToRelativeTo FilePathNameAux realPath
			)
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
global sm_filename 			= "filename="
global sm_name 				= "name="

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
		meshFileAux = MeshPath + scene_cores[i].name + FileExtension
		format (sm_init_tag + XMLSpace + sm_name + "\"%\"" + XMLSpace+ sm_filename + "\"%\"" + XMLCloseTag) scene_cores[i].name meshFileAux to:sm_file
		ExportMesh scene_cores[i] (scene_cores[i].name + FileExtension)
	)
	format (sm_close_file_tag) to:sm_file
	close sm_file
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

	on LevelList selected lvl do
	(
		PathToCopy = realPath + DataDirectory + LevelList.items[LevelList.selection] + "\\"
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