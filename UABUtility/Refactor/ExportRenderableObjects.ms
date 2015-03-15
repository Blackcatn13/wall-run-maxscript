global ro_open_file_tag		= "<renderable_objects>\n"
global ro_close_file_tag	= "</renderable_objects>\n"
global ro_mesh 				= "\t<mesh_instance"
global ro_animated			= "\t<animated_model"

global ro_file

function ExportRenderableObjects =
(
	getGeometryandCores()
	CreatePath PathToCopy

	ro_file = createfile (PathToCopy + renderableObjectsFileName)

	format (XMLVersion) to:ro_file
	format (ro_open_file_tag) to:ro_file

	for i = 1 to scene_geometry_toExport.count do
	(
		if (GetUserProp scene_geometry_toExport[i] "export" == true) then (
			local ObjName = scene_geometry_toExport[i].name
			local yawAng = DegToRad (GetYaw scene_geometry_toExport[i].transform)
			local pitchAng = DegToRad (GetPitch scene_geometry_toExport[i].transform)
			local rollAng = DegToRad (GetRoll scene_geometry_toExport[i].transform)
			local Translation = scene_geometry_toExport[i].transform.translation
			local ObjScale = (GetScale scene_geometry_toExport[i].scale)
			local tranX = formattedPrint Translation.x format:"f"
			local tranY = formattedPrint Translation.y format:"f"
			local tranZ = formattedPrint Translation.z format:"f"
			local visible = GetUserProp scene_geometry_toExport[i] "visible"

			if (GetUserProp scene_geometry_toExport[i] "export_type" == "mesh_instance") then
				format (ro_mesh + XMLName + "\"%\"" + XMLCore + "\"%\"") ObjName (GetObjectCore scene_geometry_toExport[i]) to:ro_file
			if (GetUserProp scene_geometry_toExport[i] "export_type" == "animated_model") then
				format (ro_animated + XMLName + "\"%\"" + XMLCore + "\"%\"") ObjName (GetUserProp scene_geometry_toExport[i] "anim_model") to:ro_file
			format (XMLPos + "\"% % %\"" + XMLYaw + "\"%\"") tranX tranY tranZ yawAng to:ro_file
			format (XMLPitch + "\"%\"" + XMLRoll + "\"%\"" + XMLScale + "\"% % %\"" + XMLVisible + "\"%\"" + XMLCloseTag) pitchAng rollAnf ObjScale.x ObjScale.y ObjScale.z visible to:ro_file
		)
	)
	format (ro_close_file_tag) to:ro_file
	close ro_file
)