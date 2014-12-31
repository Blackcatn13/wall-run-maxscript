/*Funciones de transformada*/
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
	format "[GetMeshesPathExport] test %\n" newPath
	return newPath
)
