global sm_open_file_tag 	= "<static_meshes>\n"
global sm_close_file_tag 	= "</static_meshes>\n"
global sm_init_tag 			= "\t<static_mesh"

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
		if (GetUserProp scene_cores[i] "export") == true and ((GetUserProp scene_cores[i] "export_type") == "mesh_instance" or (GetUserProp scene_cores[i] "export_type") == "door" or (GetUserProp scene_cores[i] "export_type") == "platform_mesh" or (GetUserProp scene_cores[i] "export_type") == "switch_instance" or (GetUserProp scene_cores[i] "export_type") == "wall_trap_mesh")  then
		(
			meshFileAux = RelativeMeshPath + scene_cores[i].name + FileExtension
			format (sm_init_tag + XMLName + XML1Value + XMLFilename + XML1Value + XMLCloseTag) scene_cores[i].name meshFileAux to:sm_file
			local physxProp = GetUserProp scene_cores[i] "physics"
			ExportMesh scene_cores[i] (scene_cores[i].name + FileExtension)
		)
	)
	format (sm_close_file_tag) to:sm_file
	close sm_file
)