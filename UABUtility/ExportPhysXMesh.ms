global pm_open_file_tag 	= "<Physx_meshes>\n"
global pm_close_file_tag 	= "</Physx_meshes>\n"
global pm_init_tag 			= "\t<Physx_mesh"

global pm_file

function ExportPhysXMesh _XMLFileName propName=
(
	scene_geometry = geometry as Array
	CreatePath PathToCopy

	pm_file = createfile (PathToCopy + _XMLFileName)

	format (XMLVersion) to:pm_file
	format (pm_open_file_tag) to:pm_file
	local oldExportMesh = ExportMeshes
	ExportMeshes = false
	PhysxExport = true
	for i = 1 to scene_geometry.count do
	(
		if (GetUserProp scene_geometry[i] propName) == true then
		(
			meshFileAux = RelativeMeshPath + scene_geometry[i].name + PhysXExtension
			format (pm_init_tag + XMLName + XML1Value + XMLFilename + XML1Value + XMLCloseTag) scene_geometry[i].name meshFileAux to:pm_file
			--local physxProp = GetUserProp scene_geometry[i] "physics"
			ExportMesh scene_geometry[i] (scene_geometry[i].name + PhysXExtension)
		)
	)
	ExportMeshes = oldExportMesh
	PhysxExport = false
	format (pm_close_file_tag) to:pm_file
	close pm_file
)

