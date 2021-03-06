fileIn "BBoxBSphere.ms"
fileIn "Common.ms"

VERTEX_XYZ = 0x1
VERTEX_NORMAL = 0x2
VERTEX_TANGENT = 0x4
VERTEX_BINORMAL = 0x8
VERTEX_TEXTURE1 = 0x10
VERTEX_TEXTURE2 = 0x20
VERTEX_DIFFUSE = 0x40
VERTEX_CUBEMAP = 0x200
VERTEX_RNM = 0x400


function ExportMesh Obj filepath _filename _file copy_textures=
(
	if UABUtility.debug then
		format "[ExportMesh] exporting %\n" _filename
	
	if doesFileExist (filepath + "meshes//") == false then (
		makeDir (filepath + "meshes//") all:true
		if UABUtility.debug then
			format "[ExportMesh] directorio % creado \n" filepath	
	)
	local filename = filepath + "meshes//" + _filename
	local l_NumMaterials 
	local l_Vtxs = #()
	local l_Idxs = #()
	local file=fopen filename "wb"
	local l_MaterialArray = #()
	
	WriteShort file 0x55ff #unsigned

	-- Obtener numero de materiales del objeto
	local ismult = false
	if classof(Obj.material) == Multimaterial then 
	(  
		ismult = true
		if UABUtility.debug then
			format "[ExportMesh] el objeto tiene aplicado un multimaterial\n"
		l_NumMaterials = Obj.material.numsubs
	) else 
	(  
		if classof(Obj.material) != UndefinedClass then (
			if UABUtility.debug then
				format "[ExportMesh] el objeto tiene aplicado un material standard\n"
			l_NumMaterials = 1 --Obj.material -->Si no es multimaterial solo tiene 1?
		)
	)
	
	local l_MaterialArray = CreateMaterialArray Obj
	local l_NumMaterials = l_MaterialArray.count
	
	/*if classof(Obj.material) == UndefinedClass then (
		l_MaterialArray = #(1)
		l_NumMaterials = 1
	)*/
	WriteShort file l_NumMaterials #unsigned
	if UABUtility.debug then
		format "[ExportMesh] exporting materials\n"
	local vtxmask = #()
	if ismult then (
		if UABUtility.debug then
			format "[ExportMesh] is multimaterial\n"
		for i = 1 to l_NumMaterials do
		(
			local aux = l_MaterialArray[i]
			if UABUtility.debug then
				format "[ExportMesh] material index is %\n" aux
			append vtxmask (ExportMaterial Obj.material[aux] file _file filepath copy_textures)
		)
	) else (
		if UABUtility.debug then
			format "[ExportMesh] not multimaterial\n"
		for i = 1 to l_NumMaterials do
		(
			append vtxmask (ExportMaterial Obj.material file _file filepath copy_textures)
		)
	)
	if UABUtility.debug then (
		format "[ExportMesh] vertex masks % \n" vtxmask
		format "[ExportMesh] Generating vertex\n"
	)
	GenerateVertexs Obj l_Vtxs l_Idxs vtxmask l_MaterialArray
	for idMaterial = 1 to l_NumMaterials do
	(
		if UABUtility.debug then (
			format "[ExportMesh] l_NumMaterials %\n" l_NumMaterials
			format "[ExportMesh] %\n" l_Vtxs
		)
		local numVertex = l_Vtxs[idxAccesArray[idMaterial]].count
		local numIndexes = l_Idxs[idxAccesArray[idMaterial]].count
		if UABUtility.debug then (
			format "[ExportMesh] num vertex = %\n" numVertex
			format "[ExportMesh] num index = %\n" numIndexes
		)
		if numVertex == 0 or numIndexes == 0 then (
			if UABUtility.debug then
				format "[ExportMesh] excluding face \n"
			continue
		)
		local vtxmaskpos = findItem l_MaterialArray l_MaterialArray[idMaterial]
		WriteShort file numVertex #unsigned
		ExportVertexs l_Vtxs file idxAccesArray[idMaterial] vtxmask[vtxmaskpos]    --Estos arrays en realiad son tridimensionales [][][]
		WriteShort file numIndexes #unsigned
		ExportIndexs l_Idxs file idxAccesArray[idMaterial]
	)
	
	--Exportar BoundingBox y BoundingSphere
	local BBox, BSphere
	try
	(
		BBox = BoundingBox Obj
		BSphere = BoundingSphere Obj
	)
	catch
	(
		errorStr = getCurrentException() 
		if (findString errorStr "Mesh operation on non-mesh") != undefined  then
		(
			ClonedObjects = CloneObjects Obj errorStr
			--Hacer lo que tenga que hacer
			BBox = BoundingBox ClonedObjects
			BSphere = BoundingSphere ClonedObjects
			--Eliminar clones
			DeleteClonedObjects ClonedObjects
		)	
	)
	for BBIndex = 1 to BBox.count do
	(
		WriteFloat file BBox[BBIndex] --x,y,z min, x,y,z max
	)
	
	for BSIndex = 1 to BSphere.count do
	(
		WriteFloat file BSphere[BSIndex] -- center.x, center.y, center.z, radius
	)
	
	WriteShort file 0xff55 #unsigned
	
	fflush file
	fclose file
)

function GetNumberOfTextures mat =
(
	local num = 0
	if mat == undefined then
		return num
	if UABUtility.debug then
		format "[GetNumberOfTextures] number of possible textures is %\n" mat.maps.count
	for i=1 to mat.maps.count do (
		if mat.maps[i] != undefined and mat.mapEnables[i] == true then
		(
			num = num + 1
		)
	)
	if mat.selfIllumMapEnable and classof(mat.selfIllumMap) == Multi_Sub_Map then
	(
		num = num + 2;
	)
	return num
)

function getMask mat numText= 
(
	local VtxMask = VERTEX_XYZ
	if UABUtility.debug then (
		format "[getMask] number of textures %\n" numText
		if numText >= 1 then (
			format "[getMask] is diffuse enabled? % \n" mat.diffuseMapEnable
			format "[getMask] is bump enabled? % \n" mat.bumpMapEnable
			format "[getMask] is selfIllum enabled? % \n" mat.selfIllumMapEnable
		)
	)
	if numText == 0 then (
		VtxMask = bit.or VtxMask VERTEX_DIFFUSE
		VtxMask = bit.or VtxMask VERTEX_NORMAL
	)
	else if mat.diffuseMapEnable == false then (
		VtxMask = bit.or VtxMask VERTEX_DIFFUSE
		VtxMask = bit.or VtxMask VERTEX_NORMAL
	)
	if(numText >= 1 and mat.diffuseMapEnable) then (
		VtxMask = bit.or VtxMask VERTEX_NORMAL
		VtxMask = bit.or VtxMask VERTEX_TEXTURE1
		if mat.bumpMapEnable then (
			VtxMask = bit.or VtxMask VERTEX_TANGENT
			VtxMask = bit.or VtxMask VERTEX_BINORMAL
		)
		if mat.selfIllumMapEnable then (
			if classof(mat.selfIllumMap) == Multi_Sub_Map then (
				VtxMask = bit.or VtxMask VERTEX_RNM
			)
			VtxMask = bit.or VtxMask VERTEX_TEXTURE2
		)
		if mat.reflectionMapEnable then (
			VtxMask = bit.or VtxMask VERTEX_CUBEMAP
		)
	)
	else if(numText >= 1 and mat.bumpMapEnable) then (
		VtxMask = bit.or VtxMask VERTEX_NORMAL
		VtxMask = bit.or VtxMask VERTEX_TANGENT
		VtxMask = bit.or VtxMask VERTEX_BINORMAL
		VtxMask = bit.or VtxMask VERTEX_TEXTURE1
		if mat.selfIllumMapEnable then (
			VtxMask = bit.or VtxMask VERTEX_TEXTURE2
		)
	)
	else if(numText >= 1 and mat.reflectionMapEnable) then (
		VtxMask = bit.or VtxMask VERTEX_CUBEMAP
	)
	return VtxMask
)

function ExportMaterial _Material File _file FilePath copy_textures=
(
	if UABUtility.debug then
		format "[ExportMaterial] getting number of textures in material\n"
	local textNum = GetNumberOfTextures _Material
	if UABUtility.debug then (
		format "[ExportMaterial] number of textures in material = %\n" textNum
		format "[ExportMaterial] getting vertex mask\n"
	)
	local vtxmask = getMask _Material textNum
	local vtxmaskToWrite = (formattedprint vtxmask format:"x") as integer
	if UABUtility.debug then
		format "[ExportMaterial] vertex mask = %\n" vtxmaskToWrite
	
	WriteShort File vtxmask #unsigned --poner mascara
	WriteShort File textNum #unsigned --numero texturas
	if UABUtility.debug then
		format "[ExportMaterial] mat name %\n" _Material
	local j=1
	for  i=1 to textNum do --numero de texturas
	(
		local _filename 
		if i == 1 then (
			if _Material.diffuseMapEnable then (
				_filename = (openBitMap _Material.diffuseMap.bitmap.filename).fileName 
			)
			else if _Material.bumpMapEnable then (
				_filename = (openBitMap _Material.bumpMap.bitmap.filename).fileName
			)
			else if _Material.selfIllumMapEnable then (
				_filename = (openBitMap _Material.selfIllumMap.bitmap.filename).fileName
			)
			else if _Material.reflectionMapEnable then (
				_filename = (openBitMap _Material.reflectionMap.bitmap.filename).fileName
			)
	    ) else (
      		if i == 2 then (
				if _Material.bumpMapEnable then (
					_filename = (openBitMap _Material.bumpMap.bitmap.filename).fileName
				)
				else if _Material.selfIllumMapEnable then (
					_filename = (openBitMap _Material.selfIllumMap.bitmap.filename).fileName
				)
				else if _Material.reflectionMapEnable then (
				_filename = (openBitMap _Material.reflectionMap.bitmap.filename).fileName
				)
			) else if i >= 3 then (
				if _Material.selfIllumMapEnable then (
					if classof(_Material.selfIllumMap) == Multi_Sub_Map then (
						if (j==1) then (
							_filename = (openBitMap _Material.selfIllumMap.id_0_color_shader.bitmap.filename).filename
							j = j + 1
						) else if (j==2) then (
							_filename = (openBitMap _Material.selfIllumMap.id_1_color_shader.bitmap.filename).filename
							j = j + 1
						) else if (j==3) then (
							_filename = (openBitMap _Material.selfIllumMap.id_2_color_shader.bitmap.filename).filename
						)
					) else (
						_filename = (openBitMap _Material.selfIllumMap.bitmap.filename).fileName
					)
				)
				else if _Material.reflectionMapEnable then (
					_filename = (openBitMap _Material.reflectionMap.bitmap.filename).fileName
				)
			)
		) 
		
		---------------------------------------
		local L_Path =  FilePath+"textures/"
		if copy_textures then (
			if doesFileExist L_Path == false then (
				makeDir L_Path all:true
				if UABUtility.debug then
					format "[ExportMaterial] directorio % creado \n" L_Path
			)
			if FilePath!=undefined then (		
				--local out_name=GetSaveFileName filename:(GetMeshesPathExport L_Path/*()*/+$.name+".mesh") caption:"Select output file to export file" types:" mesh(*.mesh)|*.mesh|All Files(*.*)|*.*|"
				FileName = filenameFromPath _filename
				FilePathName = L_Path + FileName
				if UABUtility.debug then
					format "[ExportMaterial] Copy file Name: \"%\" \n" FilePathName
				if doesFileExist FilePathName and false then (
					if (queryBox "File already exists in destination folder. Override?" title: "[ExportMaterial] File alreay exists" true) == true then (
						deleteFile FilePathName
						copyFile _filename FilePathName
					)
				) else (
					copyFile _filename FilePathName
				)
			)
		)
		-----------------------------------------------
		if UABUtility.debug then (
			format "[ExportMaterial] path %\n" _filename
			format "[ExportMaterial] path to cut %\n" _file
		)
		local relPath 
		if copy_textures then (
			relPath = pathConfig.convertPathToRelativeTo FilePathName _file
		) else (
			FileName = filenameFromPath _filename
			FilePathName = L_Path + FileName
			relPath = pathConfig.convertPathToRelativeTo FilePathName _file
		)
		if UABUtility.debug then
			format "[ExportMaterial] rel path %\n" relPath
		local numChars = relPath.count
		WriteShort File numChars #unsigned
		WriteString File relPath 
		
	)
	return vtxmask
)

function ExportVertexs arrayVertex File idMaterial vtxmask=
(
	if UABUtility.debug then
		format "[ExportVertexs] Exporting vertex with idMaterial %\n" idMaterial
	for  j=1 to arrayVertex[idMaterial].count do
	(            
		local k = 1
		if (bit.and vtxmask VERTEX_XYZ) == VERTEX_XYZ then (
			if UABUtility.debug then
				format "[ExportVertexs] position: % % %\n" arrayVertex[idMaterial][j][k] arrayVertex[idMaterial][j][k+1] arrayVertex[idMaterial][j][k+2]
			writeFloat File arrayVertex[idMaterial][j][k]
			writeFloat File arrayVertex[idMaterial][j][k+1]
			writeFloat File arrayVertex[idMaterial][j][k+2]
			k = k + 3
		)
		if (bit.and vtxmask VERTEX_NORMAL) == VERTEX_NORMAL then (
			if UABUtility.debug then
				format "[ExportVertexs] normal: % % %\n" arrayVertex[idMaterial][j][k] arrayVertex[idMaterial][j][k+1] arrayVertex[idMaterial][j][k+2]
			writeFloat File arrayVertex[idMaterial][j][k]
			writeFloat File arrayVertex[idMaterial][j][k+1]
			writeFloat File arrayVertex[idMaterial][j][k+2]
			k = k + 3
			if (bit.and vtxmask VERTEX_TANGENT) == VERTEX_TANGENT then (
				if UABUtility.debug then
					format "[ExportVertexs] normal w: %\n" arrayVertex[idMaterial][j][k]
				writeFloat File arrayVertex[idMaterial][j][k]
				k = k + 1
			)
		)
		if (bit.and vtxmask VERTEX_TANGENT) == VERTEX_TANGENT then (
			if UABUtility.debug then
				format "[ExportVertexs] tangent: % % % %\n" arrayVertex[idMaterial][j][k] arrayVertex[idMaterial][j][k+1] arrayVertex[idMaterial][j][k+2] arrayVertex[idMaterial][j][k+3]
			writeFloat File arrayVertex[idMaterial][j][k]
			writeFloat File arrayVertex[idMaterial][j][k+1]
			writeFloat File arrayVertex[idMaterial][j][k+2]
			writeFloat File arrayVertex[idMaterial][j][k+3]
			k = k + 4
		)
		if (bit.and vtxmask VERTEX_BINORMAL) == VERTEX_BINORMAL then (
			if UABUtility.debug then
				format "[ExportVertexs] binormal: % % % %\n" arrayVertex[idMaterial][j][k] arrayVertex[idMaterial][j][k+1] arrayVertex[idMaterial][j][k+2] arrayVertex[idMaterial][j][k+3]
			writeFloat File arrayVertex[idMaterial][j][k]
			writeFloat File arrayVertex[idMaterial][j][k+1]
			writeFloat File arrayVertex[idMaterial][j][k+2]
			writeFloat File arrayVertex[idMaterial][j][k+3]
			k = k + 4
		)
		if (bit.and vtxmask VERTEX_DIFFUSE) == VERTEX_DIFFUSE then (
			if UABUtility.debug then
				format "[ExportVertexs] color: %\n" arrayVertex[idMaterial][j][k]
			writeLong File arrayVertex[idMaterial][j][k] #unsigned
			k = k + 1
		)
		if (bit.and vtxmask VERTEX_TEXTURE1) == VERTEX_TEXTURE1 then (
			if UABUtility.debug then
				format "[ExportVertexs] uv: % %\n" arrayVertex[idMaterial][j][k] arrayVertex[idMaterial][j][k+1]
			writeFloat File arrayVertex[idMaterial][j][k]
			writeFloat File arrayVertex[idMaterial][j][k+1]
			k = k + 2
		)
		if(bit.and vtxmask VERTEX_TEXTURE2) == VERTEX_TEXTURE2 then (
			if UABUtility.debug then
				format "[ExportVertexs] uv2: % %\n" arrayVertex[idMaterial][j][k] arrayVertex[idMaterial][j][k+1]
			writeFloat File arrayVertex[idMaterial][j][k]
			writeFloat File arrayVertex[idMaterial][j][k+1]
			k = k + 2
		)
	)
)

function ExportIndexs arrayIndex File idMaterial =
(
	for  j=1 to arrayIndex[idMaterial].count do
	(   
		WriteShort File arrayIndex[idMaterial][j] #unsigned
	)
)

/*----------------------------------------------*/

function AreVertexsEqual Vtx1 Vtx2 =
(
	if Vtx1.count!=Vtx2.count then
	(
		--format "[AreVertexEquals] false\n"
		return false
	)
	else
	(
		for i=1 to Vtx1.count do
		(
			if Vtx1[i]!=Vtx2[i] then
			(
				--format "[AreVertexEquals] false\n"
				return false
			)
		)
		--format "[AreVertexEquals] true\n"
		return true
	)
)

function FindVertex Vtxs Vtx =
(
	--format "[FindVertex] looking for %\n" Vtx
	local pos=-1
	for i=1 to Vtxs.count do
	(
		--format "[FindVertex] Compare with %\n" Vtxs[i]
		if AreVertexsEqual Vtxs[i] Vtx then
		(
			--format "[FindVertex] returning %\n" i
			pos = i
			return pos
		)
	)
	return pos
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

/*---------------------------------------*/
function AddVertex vertex vrtxs idMaterial =
(
	--format "looking for equality of %\n" vertex
	
	while vrtxs.count<idMaterial do
	(
		append vrtxs (#())
	)
	local pos=FindVertex vrtxs[idMaterial] vertex
	--format "[AddVertex] to if\n"
	if pos==-1 then
	(
		append vrtxs[idMaterial] vertex
		return vrtxs[idMaterial].count
	)
	else
	(
		--format "[AddVertex] returning %\n" pos
		return pos
	)
)

function AddIndex index idxs idMaterial =
(
	while idxs.count<idMaterial do
	(
		append idxs (#())
	)
	
	append idxs[idMaterial] (index-1)
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
		if(bit.and mater VERTEX_TANGENT) == VERTEX_TANGENT then (
			append vertex 1.0
		)
	)
	if(bit.and mater VERTEX_TANGENT) == VERTEX_TANGENT then (
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
		if UABUtility.debug then
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

global UABVtxsNormals=#()

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

function GenerateVertexs Obj vtxs idxs vtxmask l_MaterialArray =
(
	UABCalcVertexsNormals Obj
	local numFaces = getNumFaces Obj
	local l_vtxMap = array=#()
	for i = 1 to numFaces do (
		l_vtxMap[i] = dotnetobject "System.Collections.Generic.Dictionary`2[System.String,System.Int16]"
	)
	if UABUtility.debug then (
		format "[GenerateVertexs] num faces %\n" numFaces
		format "[GenerateVertexs] vertex mask size %\n" vtxmask.count
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
		
		if UABUtility.debug then (
			format "[GenerateVertexs] number of texture maps %\n" ((meshop.getNumMaps Obj) - 1)
		)
		
		local IdxsMap= meshop.getMapFace Obj 1 face
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
		if UABUtility.debug then (
			format "[GenerateVertexs] material of face is %\n" idMaterial
			format "[GenerateVertex] old idnx Array is %\n" idxAccesArray
		)
		local maskpos = findItem idxAccesArray idMaterial
		if maskpos == 0 then (
			if UABUtility.debug then
				format "[GenerateVertexs] not found material % in the materialArray %\n" idMaterial idxAccesArray
			maskpos = 1
		)
		local realpos = l_MaterialArray[maskpos]
		local Col
		if UABUtility.debug then (
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
		
		if UABUtility.debug then
			format "[GenerateVertexs] vertex mask of this material is %\n" vtxmask[realpos]
		local totalVertex1 = CreateFullVertex vtx1 Normal1 TUVMap1 TUV2Map1 Col 0 0 vtxmask[realpos]
		local totalVertex2 = CreateFullVertex vtx2 Normal2 TUVMap2 TUV2Map2 Col 0 0 vtxmask[realpos]
		local totalVertex3 = CreateFullVertex vtx3 Normal3 TUVMap3 TUV2Map3 Col 0 0 vtxmask[realpos]
		
		local index1=dotNetAddVertex totalVertex1 vtxs idMaterial l_vtxMap
		local index2=dotNetAddVertex totalVertex2 vtxs idMaterial l_vtxMap
		local index3=dotNetAddVertex totalVertex3 vtxs idMaterial l_vtxMap
	
		AddIndex index3 idxs idMaterial
		AddIndex index2 idxs idMaterial
		AddIndex index1 idxs idMaterial
	
	)
)

--Funci�n que genera un array de todos los materiales asignados a los objetos
function CreateMaterialArray Obj =
(
	if UABUtility.debug then
		format "[CreateMaterialArray] getting materials applied\n"
	local array=#()
	for i=1 to (getNumFaces Obj) do 
	(
		appendifUnique array (getFaceMatID Obj i)
	)
	if UABUtility.debug then
		format "[CreateMaterialArray]\n--------------------\narray of idexes %\n--------------------\n" array
	sort array
	global idxAccesArray = deepcopy array
	if UABUtility.debug then
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
	if UABUtility.debug then
		format "[CreateMaterialArray] ordered array is %\n" array
	return array
)

--ExportMesh $ "C:\\exported.mesh"