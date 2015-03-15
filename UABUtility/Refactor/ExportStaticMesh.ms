global sm_open_file_tag 	= "<static_meshes>\n"
global sm_close_file_tag 	= "</static_meshes>\n"
global sm_init_tag 			= "\t<static_mesh"
global sm_filename 			= "filename="
global sm_name 				= "name="

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
		if (GetUserProp scene_cores[i] "export") == true then
		(
			meshFileAux = MeshPath + scene_cores[i].name + FileExtension
			format (sm_init_tag + XMLSpace + sm_name + "\"%\"" + XMLSpace+ sm_filename + "\"%\"" + XMLCloseTag) scene_cores[i].name meshFileAux to:sm_file
			ExportMesh scene_cores[i] (scene_cores[i].name + FileExtension)
		)
	)
	format (sm_close_file_tag) to:sm_file
	close sm_file
)