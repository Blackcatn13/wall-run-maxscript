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


function ExportMesh Obj filename=
(
	if debug then
		format "[ExportMesh] exporting %\n" filename

	if debug then
		format "[ExportMesh] Cloning object\n"

	ClonedObj = CloneObjects Obj

	if doesFileExist (MeshPath) == false then 
	(
		makeDir (MeshPath) all:true
		if debug then
		(
			format "[ExportMesh] directorio % creado \n" MeshPath
		)
	)

	g_Vtxs = #()
	g_Idxs = #()
	g_file = fopen filename "wb"
	--g_MaterialArray = #()

	-- Starting export of mesh
	-- First write header of file 0x55FF
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
	GenerateVertex ClonedObj
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

Include "ExportMaterial.ms"

Include "Vertex.ms"

Include "Bounding.ms"

Inlcude "CloneObjects.ms"

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