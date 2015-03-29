global g_file
global g_NumMaterials
global g_Idxs
global g_Vtxs
global g_MaterialArray
global g_IsMultimaterial = false
global g_idxAccesArray
global g_VertexMsks
global UABVtxsNormals=#()

Include "ExportMaterial.ms"

Include "Vertex.ms"

Include "Bounding.ms"

Include "CloneObjects.ms"

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

function ExportVertexs idMaterial vtxmask _file PhysxExport=
(
	if debug then
		format "[ExportVertexs] Exporting vertex with idMaterial %\n" idMaterial
	for  j=1 to g_Vtxs[idMaterial].count do
	(   
		if PhysxExport then (
			local k = 1
			if (bit.and vtxmask VERTEX_XYZ) == VERTEX_XYZ then (
				if debug then
					format "[ExportVertexs] position: % % %\n" g_Vtxs[idMaterial][j][k] g_Vtxs[idMaterial][j][k+1] g_Vtxs[idMaterial][j][k+2]
				writeFloat _file g_Vtxs[idMaterial][j][k]
				writeFloat _file g_Vtxs[idMaterial][j][k+1]
				writeFloat _file g_Vtxs[idMaterial][j][k+2]
				k = k + 3
			)
			if (bit.and vtxmask VERTEX_NORMAL) == VERTEX_NORMAL then (
				k = k + 3
			)
			if (bit.and vtxmask VERTEX_TANGENT) == VERTEX_TANGENT then (
				k = k + 5
			)
			if (bit.and vtxmask VERTEX_BINORMAL) == VERTEX_BINORMAL then (
				k = k + 4
			)
			if (bit.and vtxmask VERTEX_DIFFUSE) == VERTEX_DIFFUSE then (
				k = k + 1
			)
			if (bit.and vtxmask VERTEX_TEXTURE1) == VERTEX_TEXTURE1 then (
				k = k + 2
			)
			if(bit.and vtxmask VERTEX_TEXTURE2) == VERTEX_TEXTURE2 then (
				k = k + 2
			)
		) else (
			local k = 1
			if (bit.and vtxmask VERTEX_XYZ) == VERTEX_XYZ then (
				if debug then
					format "[ExportVertexs] position: % % %\n" g_Vtxs[idMaterial][j][k] g_Vtxs[idMaterial][j][k+1] g_Vtxs[idMaterial][j][k+2]
				writeFloat _file g_Vtxs[idMaterial][j][k]
				writeFloat _file g_Vtxs[idMaterial][j][k+1]
				writeFloat _file g_Vtxs[idMaterial][j][k+2]
				k = k + 3
			)
			if (bit.and vtxmask VERTEX_NORMAL) == VERTEX_NORMAL then (
				if debug then
					format "[ExportVertexs] normal: % % %\n" g_Vtxs[idMaterial][j][k] g_Vtxs[idMaterial][j][k+1] g_Vtxs[idMaterial][j][k+2]
				writeFloat _file g_Vtxs[idMaterial][j][k]
				writeFloat _file g_Vtxs[idMaterial][j][k+1]
				writeFloat _file g_Vtxs[idMaterial][j][k+2]
				k = k + 3
			)
			if (bit.and vtxmask VERTEX_TANGENT) == VERTEX_TANGENT then (
				if debug then
						format "[ExportVertexs] normal w: %\n" g_Vtxs[idMaterial][j][k]
				writeFloat _file g_Vtxs[idMaterial][j][k]
				if debug then
					format "[ExportVertexs] tangent: % % % %\n" g_Vtxs[idMaterial][j][k+1] g_Vtxs[idMaterial][j][k+2] g_Vtxs[idMaterial][j][k+3] g_Vtxs[idMaterial][j][k+4]
				writeFloat _file g_Vtxs[idMaterial][j][k+1]
				writeFloat _file g_Vtxs[idMaterial][j][k+2]
				writeFloat _file g_Vtxs[idMaterial][j][k+3]
				writeFloat _file g_Vtxs[idMaterial][j][k+4]
				k = k + 5
			)
			if (bit.and vtxmask VERTEX_BINORMAL) == VERTEX_BINORMAL then (
				if debug then
					format "[ExportVertexs] binormal: % % % %\n" g_Vtxs[idMaterial][j][k] g_Vtxs[idMaterial][j][k+1] g_Vtxs[idMaterial][j][k+2] g_Vtxs[idMaterial][j][k+3]
				writeFloat _file g_Vtxs[idMaterial][j][k]
				writeFloat _file g_Vtxs[idMaterial][j][k+1]
				writeFloat _file g_Vtxs[idMaterial][j][k+2]
				writeFloat _file g_Vtxs[idMaterial][j][k+3]
				k = k + 4
			)
			if (bit.and vtxmask VERTEX_DIFFUSE) == VERTEX_DIFFUSE then (
				if debug then
					format "[ExportVertexs] color: %\n" g_Vtxs[idMaterial][j][k]
				writeLong _file g_Vtxs[idMaterial][j][k] #unsigned
				k = k + 1
			)
			if (bit.and vtxmask VERTEX_TEXTURE1) == VERTEX_TEXTURE1 then (
				if debug then
					format "[ExportVertexs] uv: % %\n" g_Vtxs[idMaterial][j][k] g_Vtxs[idMaterial][j][k+1]
				writeFloat _file g_Vtxs[idMaterial][j][k]
				writeFloat _file g_Vtxs[idMaterial][j][k+1]
				k = k + 2
			)
			if(bit.and vtxmask VERTEX_TEXTURE2) == VERTEX_TEXTURE2 then (
				if debug then
					format "[ExportVertexs] uv2: % %\n" g_Vtxs[idMaterial][j][k] g_Vtxs[idMaterial][j][k+1]
				writeFloat _file g_Vtxs[idMaterial][j][k]
				writeFloat _file g_Vtxs[idMaterial][j][k+1]
				k = k + 2
			)
		)
	)
)

function ExportIndexs idMaterial _file=
(
	for  j=1 to g_Idxs[idMaterial].count do
	(   
		WriteShort _file g_Idxs[idMaterial][j] #unsigned
	)
)

function ExportMesh Obj filename PhysxVersion=
(
	if ExportMeshes or CopyTextures or PhysxVersion then 
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
		if PhysxVersion then
			local phxs_file = fopen (MeshPath + filename) "wb"
		--g_MaterialArray = #()

		-- Starting export of mesh
		-- First write header of file 0x55FF
		if ExportMeshes then
			WriteShort g_file 0x55FF #unsigned
		if PhysxVersion then
			WriteShort phxs_file 0x55FF #unsigned

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
		if PhysxVersion then (
			-- Leave only one material, to get all the vertex and indexs in an only array
			for i = 1 to getNumFaces(ClonedObj) do (
				setFaceMatID ClonedObj i 1
			)
		)

		-- We get the real materials applied to the object
		g_MaterialArray = CreateMaterialArray ClonedObj
		g_NumMaterials = g_MaterialArray.count

		-- Write to the file the number of Materials
		if ExportMeshes then 
			WriteShort g_file g_NumMaterials #unsigned
		if PhysxVersion then
			WriteShort phxs_file g_NumMaterials #unsigned

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
				local numVertex = g_Vtxs[idMaterial].count
				local numIndexes = g_Idxs[idMaterial].count
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
				ExportVertexs idMaterial g_VertexMsks[vtxmaskpos] g_file false --Estos arrays en realiad son tridimensionales [][][]
				WriteShort g_file numIndexes #unsigned
				ExportIndexs idMaterial g_file
				
			)
			-- Calculate BB and BS
			local BBox, BSphere
			BBox = BoundingBox ClonedObj
			BSphere = BoundingSphere ClonedObj
			for BBIndex = 1 to BBox.count do
			(
				WriteFloat g_file BBox[BBindex]
			)
			for BSIndex = 1 to BSphere.count do
			(
				WriteFloat g_file BSphere[BSindex]
			)
			-- Export footer
			WriteShort g_file 0xFF55 #unsigned
			fflush g_file
			fclose g_file
		)
		if PhysxVersion then (
			GenerateVertexs ClonedObj
			for idMaterial = 1 to g_NumMaterials do
			(
				local numVertex = g_Vtxs[g_idxAccesArray[idMaterial]].count
				local numIndexes = g_Idxs[g_idxAccesArray[idMaterial]].count
				if numVertex == 0 or numIndexes == 0 then (
					if debug then
						format "[ExportMesh] excluding face \n"
					continue
				)
				local vtxmaskpos = findItem g_MaterialArray g_MaterialArray[idMaterial]
				WriteShort phxs_file numVertex #unsigned
				ExportVertexs g_idxAccesArray[idMaterial] g_VertexMsks[vtxmaskpos] phxs_file true
				WriteShort phxs_file numIndexes #unsigned
				ExportIndexs g_idxAccesArray[idMaterial] phxs_file
			)
			WriteShort phxs_file 0xFF55 #unsigned
			fflush phxs_file
			fclose phxs_file
		)
		DeleteClonedObjects ClonedObj_A
	)
)
