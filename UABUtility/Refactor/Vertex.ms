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