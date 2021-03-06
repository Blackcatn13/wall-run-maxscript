global ro_open_file_tag		= "<renderable_objects>\n"
global ro_close_file_tag	= "</renderable_objects>\n"
global ro_mesh 				= "\t<mesh_instance"
global ro_switch 				= "\t<switch_instance"
global ro_door 				= "\t<door"
global ro_animated			= "\t<animated_model"
global ro_platform			= "\t<platform"
global ro_platform_close	= "\t</platform>\n"
global platform_wp			= "\t\t<wp"
global trigger_open_file_tag 	= "<triggers>\n"
global trigger_close_file_tag 	= "</triggers>\n"
global trigger_tag 				= "<trigger"
global layer_tag				= "\t<layer"
global wp							="wp"


global ro_file
global trigg_file

function WriteMeshProps _ro_file mesh_type ObjCore ObjName tranX tranY tranZ obj yawAng pitchAng rollAng ObjScale visible =
(
	format (mesh_type + XMLName + XML1Value + XMLCore + XML1Value) ObjName ObjCore to:_ro_file
	format (XMLPos + XML3Value + XMLYaw + XML1Value) tranX tranY tranZ yawAng to:_ro_file
	format (XMLPitch + XML1Value + XMLRoll + XML1Value + XMLScale + XML3Value + XMLVisible + XML1Value) pitchAng rollAng ObjScale.x ObjScale.y ObjScale.z visible to:_ro_file
	if(CheckNotNullProperty obj "phisics_size_x" == true and CheckNotNullProperty obj "phisics_size_y" == true and CheckNotNullProperty obj "phisics_size_z" == true) then(
		format (XMLPhisicSize + XML3Value) (GetUserProp obj "phisics_size_x")  (GetUserProp obj "phisics_size_y") (GetUserProp obj "phisics_size_z")  to:_ro_file
	)	
	
	WriteCheckProp obj "use_phisic_mesh" XMLUsePhisicMesh _ro_file				
	WriteTextProperty obj "emitter" XMLEmitter _ro_file
	WriteText3Property obj "emitter_offset_x" "emitter_offset_y" "emitter_offset_z" XMLEmitterOffset _ro_file
	WriteTextProperty obj "emitter2" XMLEmitter2 _ro_file
	WriteText3Property obj "emitter2_offset_x" "emitter2_offset_y" "emitter2_offset_z" XMLEmitter2Offset _ro_file
	WriteTextProperty obj "emitter3" XMLEmitter3 _ro_file
	WriteText3Property obj "emitter3_offset_x" "emitter3_offset_y" "emitter3_offset_z" XMLEmitter3Offset _ro_file
	WriteTextProperty obj "emitter4" XMLEmitter4 _ro_file
	WriteText3Property obj "emitter4_offset_x" "emitter4_offset_y" "emitter4_offset_z" XMLEmitter4Offset _ro_file
	WriteTextProperty obj "billboard" XMLBillboard _ro_file
	WriteText3Property obj "billboard_offset_x" "billboard_offset_y" "billboard_offset_z" XMLBillboardOffset _ro_file
	WriteTextProperty obj "room" XMLRoom _ro_file
	
	if (GetUserProp obj "render_to_layer" == true) then (
		format (XMLLayer + XML1Value) (GetUserProp obj "render_layer") to:_ro_file
	)
	
	format (XMLCloseTag) to:_ro_file
)

function CheckNotNullProperty Obj propName = 
(
	if(GetUserProp Obj propName != undefined and GetUserProp Obj propName != "" and GetUserProp Obj propName != "undefined" ) then (
		return true
	)		
	return false
)

function WriteCheckProp Obj propName Tag file =
(
	if ((CheckNotNullProperty Obj propName) == true and GetUserProp Obj propName == true) then (
		format (Tag + XML1Value) (GetUserProp Obj propName) to:file
	)
)

function WriteTextProperty Obj propName Tag file = 
(
	if ((CheckNotNullProperty Obj propName) == true) then(
		format (Tag + XML1Value) (getUserProp Obj propName) to:file
	)
)

function WriteText3Property Obj propName prop2Name prop3Name Tag file = 
(
	if ((CheckNotNullProperty Obj propName) == true and (CheckNotNullProperty Obj prop2Name) == true and (CheckNotNullProperty Obj prop3Name) == true) then(
		format (Tag + XML3Value) (getUserProp Obj propName) (getUserProp Obj prop2Name) (getUserProp Obj prop3Name) to:file
	)
)

function WriteWayPoints Obj File wpName NumWPs =
(
	for i = 1 to NumWPs do
	(	
		local strNum = i as string
		local WpX = wpName+strNum+"_x"
		local WpY = wpName+strNum+"_y"
		local WpZ = wpName+strNum+"_z"
	
		if(getUserProp Obj WpX != "") and ( getUserProp Obj WpX != undefined)  then
		(
			format (platform_wp+ XMLPos+XML3Value+XMLCloseTag) (getUserProp Obj WpX)(getUserProp Obj WpY)(getUserProp Obj WpZ) to:File
		)

	)
)

function ExportRenderableObjects =
(
	getGeometryandCores()
	CreatePath PathToCopy

	ro_file = createfile (PathToCopy + renderableObjectsFileName)
	trigg_file = createfile (PathToCopy + TriggerFileName)

	format (XMLVersion) to:ro_file
	format (ro_open_file_tag) to:ro_file

	format (XMLVersion) to:trigg_file
	format (trigger_open_file_tag) to:trigg_file

	local _default = true;
	for i = 1 to RenderLayers.count do (
		format (layer_tag + XMLName + XML1Value) RenderLayers[i] to:ro_file	
		if _default == true then (
			 format (XMLDefault + XML1Value) true to:ro_file
			_default = false
		)
		format (XMLCloseTag) to:ro_file
	)

	for i = 1 to scene_geometry_toExport.count do
	(
		local objaux = scene_geometry_toExport[i]
		if (GetUserProp objaux "export" == true) then (
			local ObjName = objaux.name
			local yawAng = DegToRad (GetYaw objaux.transform)
			local pitchAng = DegToRad (GetPitch objaux.transform)
			local rollAng = DegToRad (GetRoll objaux.transform)
			local Translation = RHTranslationToLH(objaux.transform.translation)
			local ObjScale = (GetScale objaux.scale)
			local tranX = formattedPrint Translation.x format:"f"
			local tranY = formattedPrint Translation.y format:"f"
			local tranZ = formattedPrint Translation.z format:"f"
			local visible = GetUserProp objaux "visible"
			local Core =  (GetObjectCore objaux)
			
			
			if (GetUserProp objaux "export_type" == "mesh_instance") then (
				format (ro_mesh + XMLName + XML1Value + XMLCore + XML1Value) ObjName (GetObjectCore objaux) to:ro_file
				format (XMLPos + XML3Value + XMLYaw + XML1Value) tranX tranY tranZ yawAng to:ro_file
				format (XMLPitch + XML1Value + XMLRoll + XML1Value + XMLScale + XML3Value + XMLVisible + XML1Value) pitchAng rollAng ObjScale.x ObjScale.y ObjScale.z visible to:ro_file
				
				WriteCheckProp objaux "use_phisic_mesh" XMLUsePhisicMesh ro_file				
				WriteTextProperty objaux "emitter" XMLEmitter ro_file
				WriteText3Property objaux "emitter_offset_x" "emitter_offset_y" "emitter_offset_z" XMLEmitterOffset ro_file
				WriteTextProperty objaux "emitter2" XMLEmitter2 ro_file
				WriteText3Property objaux "emitter2_offset_x" "emitter2_offset_y" "emitter2_offset_z" XMLEmitter2Offset ro_file
				WriteTextProperty objaux "emitter3" XMLEmitter3 ro_file
				WriteText3Property objaux "emitter3_offset_x" "emitter3_offset_y" "emitter3_offset_z" XMLEmitter3Offset ro_file
				WriteTextProperty objaux "emitter4" XMLEmitter4 ro_file
				WriteText3Property objaux "emitter4_offset_x" "emitter4_offset_y" "emitter4_offset_z" XMLEmitter4Offset ro_file
				WriteTextProperty objaux "billboard" XMLBillboard ro_file
				WriteText3Property objaux "billboard_offset_x" "billboard_offset_y" "billboard_offset_z" XMLBillboardOffset ro_file
				WriteTextProperty objaux "room" XMLRoom ro_file
				
				if (GetUserProp objaux "render_to_layer" == true) then (
					format (XMLLayer + XML1Value) (GetUserProp objaux "render_layer") to:ro_file
				)

				if (GetUserProp objaux "use_controller" == true) then (
					format (XMLController + XML1Value) (GetUserProp objaux "controller") to:ro_file
				)
				
				format (XMLCloseTag) to:ro_file
			)
			if (GetUserProp objaux "export_type" == "animated_model") then (
				format (ro_animated + XMLName + XML1Value + XMLCore + XML1Value) ObjName (GetUserProp objaux "anim_model") to:ro_file
				format (XMLPos + XML3Value + XMLYaw + XML1Value) tranX tranY tranZ yawAng to:ro_file
				format (XMLPitch + XML1Value + XMLRoll + XML1Value + XMLScale + XML3Value + XMLVisible + XML1Value) pitchAng rollAng ObjScale.x ObjScale.y ObjScale.z visible to:ro_file
				
				WriteCheckProp objaux "use_phisic_mesh" XMLUsePhisicMesh ro_file				
				WriteTextProperty objaux "emitter" XMLEmitter ro_file
				WriteText3Property objaux "emitter_offset_x" "emitter_offset_y" "emitter_offset_z" XMLEmitterOffset ro_file
				WriteTextProperty objaux "emitter2" XMLEmitter2 ro_file
				WriteText3Property objaux "emitter2_offset_x" "emitter2_offset_y" "emitter2_offset_z" XMLEmitter2Offset ro_file
				WriteTextProperty objaux "emitter3" XMLEmitter3 ro_file
				WriteText3Property objaux "emitter3_offset_x" "emitter3_offset_y" "emitter3_offset_z" XMLEmitter3Offset ro_file
				WriteTextProperty objaux "emitter4" XMLEmitter4 ro_file
				WriteText3Property objaux "emitter4_offset_x" "emitter4_offset_y" "emitter4_offset_z" XMLEmitter4Offset ro_file
				WriteTextProperty objaux "billboard" XMLBillboard ro_file
				WriteText3Property objaux "billboard_offset_x" "billboard_offset_y" "billboard_offset_z" XMLBillboardOffset ro_file
				WriteTextProperty objaux "room" XMLRoom ro_file
				
				if (GetUserProp objaux "render_to_layer" == true) then (
					format (XMLLayer + XML1Value) (GetUserProp objaux "render_layer") to:ro_file
				)
				
				format (XMLCloseTag) to:ro_file
			)
			if (GetUserProp objaux "export_type" == "platform_mesh") then (
				local platfType = getUserProp objaux "platform_type"
				format (ro_platform + XMLName + XML1Value + XMLCore + XML1Value + XMLType + XML1Value) ObjName (GetObjectCore objaux) platfType to:ro_file
				format (XMLPos + XML3Value + XMLYaw + XML1Value) tranX tranY tranZ yawAng to:ro_file
				format (XMLPitch + XML1Value + XMLRoll + XML1Value + XMLScale + XML3Value + XMLVisible + XML1Value) pitchAng rollAng ObjScale.x ObjScale.y ObjScale.z visible to:ro_file
				-- Get Physic size as the half of the size in each axis.
				local sizeObj = (objaux.max - objaux.min) / 2
				format (XMLPhisicSize + XML3Value) sizeObj.x sizeObj.z sizeObj.y to:ro_file
				--if(CheckNotNullProperty objaux "phisics_size_x" == true and CheckNotNullProperty objaux "phisics_size_y" == true and CheckNotNullProperty objaux "phisics_size_z" == true) then(
					--format (XMLPhisicSize + XML3Value) (GetUserProp objaux "phisics_size_x")  (GetUserProp objaux "phisics_size_y") (GetUserProp objaux "phisics_size_z")  to:ro_file
				--)	
				if (GetUserProp objaux "render_to_layer" == true) then (
					format (XMLLayer + XML1Value) (GetUserProp objaux "render_layer") to:ro_file
				)
				
				WriteCheckProp objaux "use_phisic_mesh" XMLUsePhisicMesh ro_file				
				WriteTextProperty objaux "emitter" XMLEmitter ro_file
				WriteText3Property objaux "emitter_offset_x" "emitter_offset_y" "emitter_offset_z" XMLEmitterOffset ro_file
				WriteTextProperty objaux "emitter2" XMLEmitter2 ro_file
				WriteText3Property objaux "emitter2_offset_x" "emitter2_offset_y" "emitter2_offset_z" XMLEmitter2Offset ro_file
				WriteTextProperty objaux "emitter3" XMLEmitter3 ro_file
				WriteText3Property objaux "emitter3_offset_x" "emitter3_offset_y" "emitter3_offset_z" XMLEmitter3Offset ro_file
				WriteTextProperty objaux "emitter4" XMLEmitter4 ro_file
				WriteText3Property objaux "emitter4_offset_x" "emitter4_offset_y" "emitter4_offset_z" XMLEmitter4Offset ro_file
				WriteTextProperty objaux "billboard" XMLBillboard ro_file
				WriteText3Property objaux "billboard_offset_x" "billboard_offset_y" "billboard_offset_z" XMLBillboardOffset ro_file
				WriteTextProperty objaux "room" XMLRoom ro_file
				
				if platfType == "breakable" then (
					format (XMLTriggerName + XML1Value + XMLCloseTag) (getUserProp objaux "trigger_name") to:ro_file
				)
				if platfType == "pinchos" or platfType == "static" then (--remove
				--	format (XMLFromX + XML1Value + XMLFromZ + XML1Value) (getUserProp objaux "from_x") (getUserProp objaux "from_z") to:ro_file
				--	format (XMLBackPos + XML3Value) (getUserProp objaux "back_position_x") (getUserProp objaux "back_position_y") (getUserProp objaux "back_position_z") to:ro_file
				--	format (XMLForthPos + XML3Value + XMLCloseTag) (getUserProp objaux "forth_position_x") (getUserProp objaux "forth_position_y") (getUserProp objaux "forth_position_z") to:ro_file
					format (XMLCloseTag) to:ro_file
				)
				if platfType == "poly" then (
					format (XMLFinalPos + XML3Value + XMLCarryRet) (getUserProp objaux "poly_final_pos_x") (getUserProp objaux "poly_final_pos_y") (getUserProp objaux "poly_final_pos_z") to:ro_file
					format (XML2Tab+XMLDirection + XML3Value) (getUserProp objaux "poly_direction_x") (getUserProp objaux "poly_direction_y") (getUserProp objaux "poly_direction_z") to:ro_file
					format (XMLTimeOut + XML1Value) (getUserProp objaux "time_out") to:ro_file
					format (XMLSpeed + XML1Value) (getUserProp objaux "speed_poly") to:ro_file
					format (XMLLightName + XML1Value) (getUserProp objaux "light_name") to:ro_file
					format (XMLActDist + XML1Value + XMLCloseTag) (getUserProp objaux "activation_distance") to:ro_file
				)
				if platfType == "moving" then (
					format (XMLSpeed + XML1Value + XMLEndTag) (getUserProp objaux "speed") to:ro_file
					WriteWayPoints objaux ro_file wp 4
					
				--	if (getUserProp objaux "wp1_x" != "") and (getUserProp objaux "xp1_x" != undefined) then (
				--		format (platform_wp + XMLPos + XML3Value + XMLCloseTag) (getUserProp objaux "wp1_x") (getUserProp objaux "wp1_y") (getUserProp objaux "wp1_z") to:ro_file
				--	)
				--	if (getUserProp objaux "wp2_x" != "") and (getUserProp objaux "xp2_x" != undefined) then (
				--		format (platform_wp + XMLPos + XML3Value + XMLCloseTag) (getUserProp objaux "wp2_x") (getUserProp objaux "wp2_y") (getUserProp objaux "wp2_z") to:ro_file
				--	)
				--	if (getUserProp objaux "wp3_x" != "") and (getUserProp objaux "xp3_x" != undefined) then (
				--		format (platform_wp + XMLPos + XML3Value + XMLCloseTag) (getUserProp objaux "wp3_x") (getUserProp objaux "wp3_y") (getUserProp objaux "wp3_z") to:ro_file
				--	)
				--	if (getUserProp objaux "wp4_x" != "") and (getUserProp objaux "xp4_x" != undefined) then (
				--		format (platform_wp + XMLPos + XML3Value + XMLCloseTag) (getUserProp objaux "wp4_x") (getUserProp objaux "wp4_y") (getUserProp objaux "wp4_z") to:ro_file
				--	)
					format (ro_platform_close) to:ro_file
				)
			)
			if (GetUserProp objaux "export_type" == "switch_instance") then (
				WriteMeshProps ro_file ro_switch Core ObjName tranX tranY tranZ objaux yawAng pitchAng rollAng ObjScale visible
			)
			
			if (GetUserProp objaux "export_type" == "door") then (
				--WriteMeshProps ro_file ro_door Core ObjName tranX tranY tranZ objaux yawAng pitchAng rollAng ObjScale visible
				format (ro_door + XMLName + XML1Value + XMLCore + XML1Value) ObjName Core to:ro_file
				format (XMLFinalPos + XML3Value)  (GetUserProp objaux "door_final_pos_x")  (GetUserProp objaux "door_final_pos_y") (GetUserProp objaux "door_final_pos_z") to:ro_file
				WriteTextProperty objaux "speed_door" XMLSpeed ro_file
				format (XMLPos + XML3Value + XMLYaw + XML1Value) tranX tranY tranZ yawAng to:ro_file
				format (XMLPitch + XML1Value + XMLRoll + XML1Value + XMLScale + XML3Value + XMLVisible + XML1Value) pitchAng rollAng ObjScale.x ObjScale.y ObjScale.z visible to:ro_file
				if(CheckNotNullProperty objaux "phisics_size_x" == true and CheckNotNullProperty objaux "phisics_size_y" == true and CheckNotNullProperty objaux "phisics_size_z" == true) then(
					format (XMLPhisicSize + XML3Value) (GetUserProp objaux "phisics_size_x")  (GetUserProp objaux "phisics_size_y") (GetUserProp objaux "phisics_size_z")  to:ro_file
				)	
				
				WriteCheckProp objaux "use_phisic_mesh" XMLUsePhisicMesh ro_file				
				WriteTextProperty objaux "emitter" XMLEmitter ro_file
				WriteText3Property objaux "emitter_offset_x" "emitter_offset_y" "emitter_offset_z" XMLEmitterOffset ro_file
				WriteTextProperty objaux "emitter2" XMLEmitter2 ro_file
				WriteText3Property objaux "emitter2_offset_x" "emitter2_offset_y" "emitter2_offset_z" XMLEmitter2Offset ro_file
				WriteTextProperty objaux "emitter3" XMLEmitter3 ro_file
				WriteText3Property objaux "emitter3_offset_x" "emitter3_offset_y" "emitter3_offset_z" XMLEmitter3Offset ro_file
				WriteTextProperty objaux "emitter4" XMLEmitter4 ro_file
				WriteText3Property objaux "emitter4_offset_x" "emitter4_offset_y" "emitter4_offset_z" XMLEmitter4Offset ro_file
				WriteTextProperty objaux "billboard" XMLBillboard ro_file
				WriteText3Property objaux "billboard_offset_x" "billboard_offset_y" "billboard_offset_z" XMLBillboardOffset ro_file
				WriteTextProperty objaux "room" XMLRoom ro_file
				
				if (GetUserProp objaux "render_to_layer" == true) then (
					format (XMLLayer + XML1Value) (GetUserProp objaux "render_layer") to:ro_file
				)
				format (XMLCloseTag) to:ro_file
			)
			if (GetUserProp objaux "export_type" == "wall_trap_mesh") then (
				format (ro_animated + XMLName + XML1Value + XMLCore + XML1Value) ObjName (GetUserProp objaux "anim_model") to:ro_file
				format (XMLPos + XML3Value + XMLYaw + XML1Value) tranX tranY tranZ yawAng to:ro_file
				format (XMLPitch + XML1Value + XMLRoll + XML1Value + XMLScale + XML3Value + XMLVisible + XML1Value) pitchAng rollAng ObjScale.x ObjScale.y ObjScale.z visible to:ro_file
				
				WriteCheckProp objaux "use_phisic_mesh" XMLUsePhisicMesh ro_file				
				WriteTextProperty objaux "emitter" XMLEmitter ro_file
				WriteText3Property objaux "emitter_offset_x" "emitter_offset_y" "emitter_offset_z" XMLEmitterOffset ro_file
				WriteTextProperty objaux "emitter2" XMLEmitter2 ro_file
				WriteText3Property objaux "emitter2_offset_x" "emitter2_offset_y" "emitter2_offset_z" XMLEmitter2Offset ro_file
				WriteTextProperty objaux "emitter3" XMLEmitter3 ro_file
				WriteText3Property objaux "emitter3_offset_x" "emitter3_offset_y" "emitter3_offset_z" XMLEmitter3Offset ro_file
				WriteTextProperty objaux "emitter4" XMLEmitter4 ro_file
				WriteText3Property objaux "emitter4_offset_x" "emitter4_offset_y" "emitter4_offset_z" XMLEmitter4Offset ro_file
				WriteTextProperty objaux "billboard" XMLBillboard ro_file
				WriteText3Property objaux "billboard_offset_x" "billboard_offset_y" "billboard_offset_z" XMLBillboardOffset ro_file
				WriteTextProperty objaux "room" XMLRoom ro_file
				WriteTextProperty objaux "wt_speed_opening" XMLSpeedOpening ro_file
				WriteTextProperty objaux "wt_speed_closing" XMLSpeedClosing ro_file
				WriteTextProperty objaux "wt_time_out" XMLTimeOut ro_file
				WriteTextProperty objaux "wt_side" XMLSide ro_file
				format (XMLFinalPos + XML3Value) (getUserProp objaux "wt_final_pos_x") (getUserProp objaux "wt_final_pos_y") (getUserProp objaux "wt_final_pos_z") to:ro_file
				
				if (GetUserProp objaux "render_to_layer" == true) then (
					format (XMLLayer + XML1Value) (GetUserProp objaux "render_layer") to:ro_file
				)
				
				format (XMLCloseTag) to:ro_file
			)
			
			if (GetUserProp objaux "export_type" == "trigger") then (
				local bb = nodeLocalBoundingBox objaux
				local sizebb = RHTranslationToLH(bb[2] - bb[1])
				sizebb.x = abs sizebb.x
				sizebb.y = abs sizebb.y
				sizebb.z = abs sizebb.z
				format (trigger_tag + XMLName + XML1Value + XMLPlatfName + XML1Value) (getUserProp objaux "triggerName") "" to:trigg_file
				format (XMLPos + XML3Value + XMLShape + XML1Value) tranX tranY tranZ (getUserProp objaux "trigger_shape") to:trigg_file
				format (XMLSize + XML3Value + XMLTypeEvent + XML1Value) sizebb.x sizebb.y sizebb.z (getUserProp objaux "trigger_type_event") to:trigg_file
				format (XMLScriptFunc + XML1Value + XMLParam1 + XML1Value) (getUserProp objaux "trigger_script") (getUserProp objaux "trigger_param1") to:trigg_file
				
				WriteTextProperty objaux "trigger_param2" XMLParam2 trigg_file
				
				if (getUserProp objaux "trigger_type_event2" != "") then (
					WriteTextProperty objaux "trigger_type_event2" XMLTypeEvent2 trigg_file
					WriteTextProperty objaux "trigger_param1_event2" XMLParam1Event2 trigg_file
					WriteTextProperty objaux "trigger_param2_event2" XMLParam2Event2 trigg_file
					WriteTextProperty objaux "trigger_script_event2" XMLScriptFunc2 trigg_file
				)
				
				if (getUserProp objaux "trigger_type_event3" != "") then (
					WriteTextProperty objaux "trigger_type_event3" XMLTypeEvent3 trigg_file
					WriteTextProperty objaux "trigger_param1_event3" XMLParam1Event3 trigg_file
					WriteTextProperty objaux "trigger_param2_event3" XMLParam2Event3 trigg_file
					WriteTextProperty objaux "trigger_script_event3" XMLScriptFunc3 trigg_file
				)
				format (XMLGroup + XML1Value + XMLPaint + XML1Value + XMLColor + XML3Value) (getUserProp objaux "trigger_group") (getUserProp objaux "trigger_paint") (objaux.wirecolor.r / 255) (objaux.wirecolor.g / 255) (objaux.wirecolor.b / 255) to:trigg_file
				
				if ((getUserProp objaux "trigger_duration") != "") and ((getUserProp objaux "trigger_duration") != undefined) then (
					format (XMLMaxTime + XML1Value) (getUserProp objaux "trigger_duration") to:trigg_file
				)
				if ((getUserProp objaux "trigger_update") != "") and ((getUserProp objaux "trigger_update") != undefined) then (
					format (XMLUpdateFun + XML1Value) (getUserProp objaux "trigger_update") to:trigg_file
				)
				if ((getUserProp objaux "trigger_platform_name") != "") and ((getUserProp objaux "trigger_platform_name") != undefined) then (
					format (XMLUpdateFun + XML1Value) (getUserProp objaux "trigger_platform_name") to:trigg_file
				)
				format (XMLCloseTag) to:trigg_file
			)
		)
	)
	format (ro_close_file_tag) to:ro_file
	close ro_file
	format (trigger_close_file_tag) to:trigg_file
	close trigg_file
)