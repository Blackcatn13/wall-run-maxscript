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
		VtxMask = bit.or VtxMask VERTEX_NORMAL
	)
	if numText >= 1 then
	(
		if mat.diffuseMapEnable then
		(
			VtxMask = bit.or VtxMask VERTEX_NORMAL
			VtxMask = bit.or VtxMask VERTEX_TEXTURE1
			auxname = (openBitMap mat.diffuseMap.bitmap.filename).fileName
			auxname = substituteString auxname "\\" "/"
			append g_texturesName auxname
		)
		if mat.bumpMapEnable then
		(
			VtxMask = bit.or VtxMask VERTEX_NORMAL
			VtxMask = bit.or VtxMask VERTEX_TEXTURE1
			VtxMask = bit.or VtxMask VERTEX_TANGENT
			VtxMask = bit.or VtxMask VERTEX_BINORMAL
			if classOf(mat.bumpMap) == Normal_Bump then (
				auxname = (openBitMap mat.bumpMap.normal_map.bitmap.filename).fileName
				auxname = substituteString auxname "\\" "/"
				append g_texturesName auxname
			) else (
				auxname = (openBitMap mat.bumpMap.bitmap.filename).fileName
				auxname = substituteString auxname "\\" "/"
				append g_texturesName auxname
			)
		)
		if mat.selfIllumMapEnable then 
		(
			if classof(mat.selfIllumMap) == Multi_Sub_Map then
			(
				VtxMask = bit.or VtxMask VERTEX_NORMAL
				VtxMask = bit.or VtxMask VERTEX_TEXTURE2
				VtxMask = bit.or VtxMask VERTEX_RNM
				auxname = (openBitMap mat.selfIllumMap.id_0_color_shader.bitmap.filename).fileName
				auxname = substituteString auxname "\\" "/"
				append g_texturesName auxname
				auxname = (openBitMap mat.selfIllumMap.id_1_color_shader.bitmap.filename).fileName
				auxname = substituteString auxname "\\" "/"
				append g_texturesName auxname
				auxname = (openBitMap mat.selfIllumMap.id_2_color_shader.bitmap.filename).fileName
				auxname = substituteString auxname "\\" "/"
				append g_texturesName auxname
			) else (
				VtxMask = bit.or VtxMask VERTEX_NORMAL
				VtxMask = bit.or VtxMask VERTEX_TEXTURE2
				auxname = (openBitMap mat.selfIllumMap.bitmap.filename).fileName
				auxname = substituteString auxname "\\" "/"
				append g_texturesName auxname
			)
		)
		if mat.reflectionMapEnable then 
		(
			VtxMask = bit.or VtxMask VERTEX_NORMAL
			VtxMask = bit.or VtxMask VERTEX_TEXTURE1
			VtxMask = bit.or VtxMask VERTEX_CUBEMAP
			auxname = (openBitMap mat.reflectionMap.bitmap.filename).fileName
			auxname = substituteString auxname "\\" "/"
			append g_texturesName auxname
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
	g_texturesName = #()
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
			FileCopyPath = TexturePath + FileName
			FileCopyPath = substituteString FileCopyPath "\\" "/"
			if debug then
				format "[ExportMaterial] Copy file Name: \"%\" \n" FileCopyPath
			if doesFileExist FileCopyPath then
			(
				if (Override == false) then
				(
					if (queryBox "File already exists in destination folder. Override?" title: "[ExportMaterial] File alreay exists" true) == true then (
						deleteFile FileCopyPath
						copyFile (g_texturesName[i] as string) FileCopyPath
					)
				) else (
					copyFile (g_texturesName[i] as string) FileCopyPath
				)
			) else (
				deleteFile FileCopyPath
				copyFile (g_texturesName[i] as string) FileCopyPath
			)
		)
		if debug then (
			format "[ExportMaterial] path\"%\"\n" g_texturesName[i]
			format "[ExportMaterial] path to cut \"%\"\n" realPath
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
