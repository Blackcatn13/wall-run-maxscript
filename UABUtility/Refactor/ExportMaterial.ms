global g_texturesName = #() 

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
		Include "CopyTextures.ms"
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
			VtxMask = bit.or VtxMask VERTEX_NORMAL
			VtxMask = bit.or VtxMask VERTEX_TEXTURE2
			append g_texturesName (openBitMap mat.selfIllumMap.bitmap.filename).fileName
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