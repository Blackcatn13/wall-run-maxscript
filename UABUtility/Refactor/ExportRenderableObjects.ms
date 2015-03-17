global ro_open_file_tag		= "<renderable_objects>\n"
global ro_close_file_tag	= "</renderable_objects>\n"
global ro_mesh 				= "\t<mesh_instance"
global ro_animated			= "\t<animated_model"
global ro_platform			= "\t<platform"
global ro_platform_close	= "\t</platform>\n"
global platform_wp			= "\t\t<wp"

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
		local objaux = objaux
		if (GetUserProp objaux "export" == true) then (
			local ObjName = objaux.name
			local yawAng = DegToRad (GetYaw objaux.transform)
			local pitchAng = DegToRad (GetPitch objaux.transform)
			local rollAng = DegToRad (GetRoll objaux.transform)
			local Translation = objaux.transform.translation
			local ObjScale = (GetScale objaux.scale)
			local tranX = formattedPrint Translation.x format:"f"
			local tranY = formattedPrint Translation.y format:"f"
			local tranZ = formattedPrint Translation.z format:"f"
			local visible = GetUserProp objaux "visible"

			if (GetUserProp objaux "export_type" == "mesh_instance") then (
				format (ro_mesh + XMLName + XML1Value + XMLCore + XML1Value) ObjName (GetObjectCore objaux) to:ro_file
				format (XMLPos + XML3Value + XMLYaw + XML1Value) tranX tranY tranZ yawAng to:ro_file
				format (XMLPitch + XML1Value + XMLRoll + XML1Value + XMLScale + XML3Value + XMLVisible + XML1Value + XMLCloseTag) pitchAng rollAnf ObjScale.x ObjScale.y ObjScale.z visible to:ro_file
			)
			if (GetUserProp objaux "export_type" == "animated_model") then (
				format (ro_animated + XMLName + XML1Value + XMLCore + XML1Value) ObjName (GetUserProp objaux "anim_model") to:ro_file
				format (XMLPos + XML3Value + XMLYaw + XML1Value) tranX tranY tranZ yawAng to:ro_file
				format (XMLPitch + XML1Value + XMLRoll + XML1Value + XMLScale + XML3Value + XMLVisible + XML1Value + XMLCloseTag) pitchAng rollAnf ObjScale.x ObjScale.y ObjScale.z visible to:ro_file
			)
			if (GetUserProp objaux "export_type" == "platform_mesh") then (
				local platfType = getUserProp objaux "platform_type"
				format (ro_platform + XMLName + XML1Value + XMLCore + XML1Value + XMLType + XML1Value) ObjName (GetObjectCore objaux) platfType to:ro_file
				format (XMLPos + XML3Value + XMLYaw + XML1Value) tranX tranY tranZ yawAng to:ro_file
				format (XMLPitch + XML1Value + XMLRoll + XML1Value + XMLScale + XML3Value + XMLVisible + XML1Value) pitchAng rollAnf ObjScale.x ObjScale.y ObjScale.z visible to:ro_file
				if platfType == "breakable" then (
					format (XMLTriggerName + XML1Value + XMLCloseTag) (getUserProp objaux "trigger_name") to:ro_file
				)
				if platfType == "pinchos" then (
					format (XMLFromX + XML1Value + XMLFromZ + XML1Value) (getUserProp objaux "from_x") (getUserProp objaux "from_z") to:ro_file
					format (XMLBackPos + XML3Value) (getUserProp objaux "back_position_x") (getUserProp objaux "back_position_y") (getUserProp objaux "back_position_z") to:ro_file
					format (XMLForthPos + XML3Value + XMLCloseTag) (getUserProp objaux "forth_position_x") (getUserProp objaux "forth_position_y") (getUserProp objaux "forth_position_z") to:ro_file
				)
				if platfType == "poly" then (
					format (XMLRedAxis + XML1Value + XMLRedScale + XML1Value) (getUserProp objaux "redim_axis") (getUserProp objaux "redim_scale") to:ro_file
					format (XMLActDist + XML1Value + XMLInitCol + XML1Value + XMLCloseTag) (getUserProp objaux "activation_distance") (getUserProp objaux "initial_collision") to:ro_file
				)
				if platfType == "moving" then (
					format (XMLSpeed + XML1Value + XMLEndTag) (getUserProp objaux "speed") to:ro_file
					if (getUserProp objaux "wp1_x" != "") and (getUserProp objaux "xp1_x" != undefined) then (
						format (platform_wp + XMLPos + XML3Value + XMLCloseTag) (getUserProp objaux "wp1_x") (getUserProp objaux "wp1_y") (getUserProp objaux "wp1_z") to:ro_file
					)
					if (getUserProp objaux "wp2_x" != "") and (getUserProp objaux "xp2_x" != undefined) then (
						format (platform_wp + XMLPos + XML3Value + XMLCloseTag) (getUserProp objaux "wp2_x") (getUserProp objaux "wp2_y") (getUserProp objaux "wp2_z") to:ro_file
					)
					if (getUserProp objaux "wp3_x" != "") and (getUserProp objaux "xp3_x" != undefined) then (
						format (platform_wp + XMLPos + XML3Value + XMLCloseTag) (getUserProp objaux "wp3_x") (getUserProp objaux "wp3_y") (getUserProp objaux "wp3_z") to:ro_file
					)
					if (getUserProp objaux "wp4_x" != "") and (getUserProp objaux "xp4_x" != undefined) then (
						format (platform_wp + XMLPos + XML3Value + XMLCloseTag) (getUserProp objaux "wp4_x") (getUserProp objaux "wp4_y") (getUserProp objaux "wp4_z") to:ro_file
					)
					format (ro_platform_close) to:ro_file
				)

			)
		)
	)
	format (ro_close_file_tag) to:ro_file
	close ro_file
)