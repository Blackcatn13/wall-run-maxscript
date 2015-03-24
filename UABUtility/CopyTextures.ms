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