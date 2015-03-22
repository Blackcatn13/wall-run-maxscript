fn GetUserProperty Obj GUIObj StrProperty = 
(
	--local message = (classof GUIObj)
	--messagebox message
	if (getUserProp $ StrProperty)!=undefined then
	(
		--format "gui element type % and gui name %\n" (classof GUIObj) GUIObj.name
		--Aquí uno por cada tipo de elemento de GUI
		if (classof GUIObj) == ComboBoxControl then (
			local items = GUIObj.items
			local position = findItem items (getUserProp Obj StrProperty)
			GUIObj.selection = position
		)
		
		if (classof GUIObj) == CheckBoxControl then (
			if (getUserProp Obj StrProperty) == true then
				GUIObj.checked = true
			else
				GUIObj.checked = false
		)
		
		if (classof GUIObj) == EditTextControl then (
			GUIObj.text = (getUserProp Obj StrProperty as string)
			GUIObj.bold = true
		)
		
	)
	else
	(
		--messageBox ("Undefined property: \"" + StrProperty +"\".") title:"Undefined Property"
		false
	)
)

fn SetUserProperty Obj StrProperty StrValue =
(
	setUserProp Obj StrProperty StrValue
)

rollout UABSetProperties "UAB Set Properties" width:552 height:807
(
	GroupBox PhysicsGp "Physics" pos:[7,561] width:255 height:91
	GroupBox EventsGp "Events" pos:[271,559] width:272 height:56
	checkbox RenderExportCheckBox "Export" pos:[16,32] width:56 height:16
	checkbox RenderVisibleCheckBox "Visible" pos:[16,64] width:56 height:16
	checkbox LayerCheckBox "Layer" pos:[16,96] width:56 height:16
	dropdownList RenderExportList "" pos:[88,32] width:168 height:21
	dropdownList RenderLayerList "" pos:[88,96] width:168 height:21
	label AnimModelLabel "Anim. model" pos:[16,128] width:64 height:16
	edittext AnimModelText "" pos:[88,128] width:168 height:16
	label TechniqueLabel "Technique" pos:[16,160] width:64 height:16
	edittext TechniqueText "" pos:[88,160] width:168 height:16
	checkbox PhysicsGenerateCheckBox "Generate" pos:[15,583] width:64 height:16
	dropdownList PhysicsGenerateList "" pos:[87,583] width:168 height:21
	checkbox PhysicsLayerCheckBox "Layer" pos:[15,615] width:56 height:16
	dropdownList PhysicsLayerList "" pos:[87,615] width:168 height:21
	GroupBox LogicGp "Logic" pos:[7,655] width:256 height:88
	checkbox LogicGenerateCheckBox "Generate" pos:[15,679] width:64 height:16
	dropdownList LogicGenerateList "" pos:[87,679] width:168 height:21
	checkbox showNormal "Show normal" pos:[95,711] width:88 height:16
	checkbox CameraVisibility "Don't test camera visibility" pos:[264,32] width:216 height:16
	checkbox WorldTransform "Don't export world transform" pos:[264,64] width:216 height:16
	edittext LinkedBoneText "" pos:[368,96] width:152 height:16
	checkbox LinkedBoneCheck "Linked to bone" pos:[264,96] width:96 height:16
	checkbox Cinematics "Export to cinematics" pos:[264,128] width:216 height:16
	checkbox EventGenerateCheck "Generate" pos:[279,583] width:64 height:16
	dropdownList EventGenerateList "" pos:[351,583] width:176 height:21
	GroupBox TracksGp "Tracks" pos:[271,623] width:134 height:56
	checkbox GenerateTracks "Generate" pos:[303,647] width:64 height:16
	GroupBox CamerasGp "Cameras" pos:[271,687] width:272 height:56
	checkbox CycleCam "Cycle" pos:[279,711] width:56 height:16
	GroupBox LightsGp "Lights" pos:[412,623] width:131 height:56
	checkbox GenerateLights "Generate" pos:[439,647] width:64 height:16
	checkbox ReverseCam "Reverse" pos:[367,711] width:64 height:16
	checkbox OnceCam "Once" pos:[455,711] width:56 height:16
	button GetButton "Get" pos:[159,757] width:104 height:32
	button SetButton "Set" pos:[271,757] width:104 height:32

	label lbl3 "Platform Type" pos:[17,190] width:72 height:14
	dropdownList RenderPlatformList "" pos:[88,184] width:168 height:21
	
	GroupBox grp25 "Render" pos:[7,9] width:536 height:541
	
	
	GroupBox grp27 "Breakable Platform" pos:[10,221] width:266 height:56
	label TriggerNameLabel "Trigger Name" pos:[21,247] width:65 height:17
	edittext TriggerNameText "" pos:[96,237] width:149 height:17
	GroupBox PolyPlatformGroup "Poly Platform" pos:[10,283] width:266 height:107
	label ActivationDistanceLabel "Act. Distance" pos:[25,367] width:71 height:16
	edittext ActivationDistanceText "" pos:[105,364] width:40 height:16
	GroupBox MovingPlatformGroup "Moving Platform" pos:[288,221] width:247 height:170
	label SpeedLabel "Speed" pos:[298,238] width:38 height:16
	edittext SpeedText "" pos:[339,238] width:40 height:15
	GroupBox grp32 "Way Points" pos:[295,271] width:233 height:113
	label WP1Label "1" pos:[309,295] width:9 height:16
	label WP1YLabel "Y" pos:[379,294] width:9 height:12
	edittext WP1YText "" pos:[387,291] width:40 height:16
	label WP1ZLabel "Z" pos:[437,294] width:9 height:12
	edittext WP1ZText "" pos:[446,291] width:40 height:16
	label WP1XLabel "X" pos:[324,295] width:9 height:12
	edittext WP1XText "" pos:[333,292] width:40 height:15
	label WP2Label "2" pos:[309,315] width:11 height:16
	label WP2YLabel "Y" pos:[379,314] width:9 height:12
	edittext WP2YText "" pos:[387,311] width:40 height:16
	label WP2ZLabel "Z" pos:[437,314] width:9 height:12
	edittext WP2ZText "" pos:[446,311] width:40 height:16
	label WP2XLabel "X" pos:[324,315] width:9 height:12
	edittext WP2XText "" pos:[333,312] width:40 height:15
	label WP3Label "3" pos:[309,336] width:10 height:16
	label WP3YLabel "Y" pos:[379,335] width:9 height:12
	edittext WP3YText "" pos:[387,332] width:40 height:16
	label lbl46 "Z" pos:[437,335] width:9 height:12
	edittext WP3ZText "" pos:[446,332] width:40 height:16
	label WP3XLabel "X" pos:[324,336] width:9 height:12
	edittext WP3XText "" pos:[333,333] width:40 height:15
	label WP4Label "4" pos:[309,356] width:10 height:16
	label WP4YLabel "Y" pos:[379,355] width:9 height:12
	edittext WP4YText "" pos:[387,352] width:40 height:16
	label lbl50 "Z" pos:[437,355] width:9 height:12
	edittext WP4ZText "" pos:[446,352] width:40 height:16
	label WP4XLabel "X" pos:[324,356] width:9 height:12
	edittext WP4XText "" pos:[333,353] width:40 height:15
		
	label FinalPositionLabel "Final Position" pos:[23,305] width:68 height:16
	label PolyDirectionLabel "Direction" pos:[25,336] width:62 height:16
	label PolyFinalPosLabelY "Y" pos:[152,306] width:9 height:12
	label PolyFinalPosLabelZ "Z" pos:[210,305] width:9 height:12
	label PolyFinalPosLabelX "X" pos:[97,307] width:9 height:12
	label PolyDirectionLabelY "Y" pos:[152,337] width:9 height:12
	label PolyDirectionLabelZ "Z" pos:[210,337] width:9 height:12
	label PolyDirectionLabelX "X" pos:[97,338] width:9 height:12
	edittext PolyFinalPosXText "" pos:[107,303] width:37 height:16
	edittext PolyFinalPosYText "" pos:[161,303] width:37 height:16
	edittext PolyFinalPosZText "" pos:[219,304] width:37 height:16
	edittext PolyDirectionXText "" pos:[107,334] width:37 height:16
	edittext PolyDirectionYText "" pos:[161,334] width:37 height:16
	edittext PolyDirectionZText "" pos:[219,334] width:37 height:16
	
	GroupBox grp28 "Triggers" pos:[15,401] width:520 height:140
	label lbl67 "Trigger Name" pos:[31,425] width:72 height:16
	edittext TriggerName "" pos:[95,425] width:144 height:16
	dropdownList ShapeDL "" pos:[95,449] width:72 height:21
	label lbl68 "Shape" pos:[31,449] width:56 height:16
	label lbl69 "Group" pos:[31,473] width:56 height:16
	dropdownList GroupDL "" pos:[95,473] width:72 height:21
	label lbl70 "Event Type" pos:[255,425] width:80 height:16
	dropdownList eventType "" pos:[343,425] width:88 height:21
	checkbox PaintIt "Paint It" pos:[455,425] width:72 height:16
	label lbl71 "Parameter 1" pos:[255,449] width:80 height:16
	label lbl72 "Script Function" pos:[255,473] width:80 height:16
	edittext Param1 "" pos:[343,449] width:168 height:16
	edittext ScriptFunction "" pos:[343,473] width:168 height:16
	label lbl301 "Duration" pos:[39,513] width:51 height:14
	edittext DurationTime "" pos:[87,513] width:50 height:16
	edittext UpdateFunction "" pos:[343,497] width:168 height:16
	label lbl157 "Update Function" pos:[255,497] width:80 height:16
	edittext PlatfName "" pos:[343,521] width:168 height:16
	label lbl198 "Platform Name" pos:[255,521] width:80 height:16
	
	
	
	
		
	


























	on UABSetProperties open do
	(	
		RenderExportList.items = MeshType
		RenderLayerList.items = RenderLayers
		PhysicsGenerateList.items = PhysicsType
		PhysicsLayerList.items=PhysicsLayer
		LogicGenerateList.items = logicGenerate
		EventGenerateList.items = EventList
		RenderPlatformList.items = RenderPlatform
		ShapeDL.items = TriggerShapeL
		GroupDL.items = GroupsList
		EventType.items = EventTypeL
	)
	on AnimModelText entered key do
	(
			AnimModelText.bold = false
		)
	on TechniqueText entered key do
	(
			TechniqueText.bold = false
		)
	on LinkedBoneText entered key do
	(
			LinkedBoneText.bold = false
		)
	on GetButton pressed do
	(
		local obj
		if ((classof $) == ObjectSet) then (
			obj = $[1]
		) else ( 
			obj = $
		)
		
		GetUserProperty obj RenderExportCheckBox "export"
		GetUserProperty obj RenderExportList "export_type"
		GetUserProperty obj RenderVisibleCheckBox "visible"
		GetUserProperty obj LayerCheckBox "render_to_layer"
		GetUserProperty obj RenderLayerList "render_layer"
		GetUserProperty obj AnimModelText "anim_model"
		GetUserProperty obj TechniqueText "technique"
		GetUserProperty obj CameraVisibility "test_camera"
		GetUserProperty obj WorldTransform "export_world"
		GetUserProperty obj LinkedBoneCheck "linked"
		GetUserProperty obj LinkedBoneText "bone_linked"
		GetUserProperty obj Cinematics "cinematics"
		GetUserProperty obj PhysicsGenerateCheckBox "physics"
		GetUserProperty obj PhysicsGenerateList "physics_type"
		GetUserProperty obj PhysicsLayerCheckBox "physics_to_layer"
		GetUserProperty obj PhysicsLayerList "physics_layer"
		GetUserProperty obj LogicGenerateCheckBox "logic"
		GetUserProperty obj LogicGenerateList "logic_type"
		GetUserProperty obj ShowNormal "normal"
		GetUserProperty obj EventGenerateCheck "event"
		GetUserProperty obj EventGenerateList "event_type"
		GetUserProperty obj GenerateTracks "track"
		GetUserProperty obj CycleCam "cam_cycle"
		GetUserProperty obj ReverseCam "cam_reverse"
		GetUserProperty obj OnceCam "cam_once"
		GetUserProperty obj GenerateLights "lights"
	
		--- Platform Properties----
		GetUserProperty obj RenderPlatformList "platform_type"
		GetUserProperty obj TriggerNameText "trigger_name"
		GetUserProperty obj PolyFinalPosXText "poly_final_pos_x"
		GetUserProperty obj PolyFinalPosYText "poly_final_pos_y"
		GetUserProperty obj PolyFinalPosZText "poly_final_pos_z"
		GetUserProperty obj PolyDirectionXText "poly_direction_x"
		GetUserProperty obj PolyDirectionYText "poly_direction_y"
		GetUserProperty obj PolyDirectionZText "poly_direction_z"
		
		
		GetUserProperty obj ActivationDistanceText "activation_distance"
	
		GetUserProperty obj SpeedText "speed"
		GetUserProperty obj WP1XText "wp1_x"
		GetUserProperty obj WP1YText "wp1_y"
		GetUserProperty obj WP1ZText "wp1_z"
		GetUserProperty obj WP2XText "wp2_x"
		GetUserProperty obj WP2YText "wp2_y"
		GetUserProperty obj WP2ZText "wp2_z"
		GetUserProperty obj WP3XText "wp3_x"
		GetUserProperty obj WP3YText "wp3_y"
		GetUserProperty obj WP3ZText "wp3_z"
		GetUserProperty obj WP4XText "wp4_x"
		GetUserProperty obj WP4YText "wp4_y"
		GetUserProperty obj WP4ZText "wp4_z"
	)
	on SetButton pressed do
	(
		if ((classof $) == ObjectSet) then
		(
			for i = 1 to $.count do
			(
				SetUserProperty $[i] "export" RenderExportCheckBox.checked
				if RenderExportCheckBox.checked then
				(	
					SetUserProperty $[i] "export_type" RenderExportList.items[RenderExportList.selection]
				)
				SetUserProperty $[i] "visible" RenderVisibleCheckBox.checked
				SetUserProperty $[i] "render_to_layer" LayerCheckBox.checked
				if LayerCheckBox.checked then
				(	
					SetUserProperty $[i] "render_layer" RenderLayerList.items[RenderLayerList.selection]
				)
				if AnimModelText.text != "" or (getUserProp $[i] "anim_model")!=undefined then
				(
					SetUserProperty $[i] "anim_model" AnimModelText.text
				)
				if TechniqueText.text != "" or (getUserProp $[i] "technique")!=undefined then
				(
					SetUserProperty $[i] "technique" TechniqueText.text
				)
				SetUserProperty $[i] "test_camera" CameraVisibility.checked
				SetUserProperty $[i] "export_world" WorldTransform.checked
				SetUserProperty $[i] "linked" LinkedBoneCheck.checked
				if LinkedBoneText.text != "" or (getUserProp $[i] "bone_linked")!=undefined then
				(
					SetUserProperty $[i] "bone_linked" LinkedBoneText.text
				)
				SetUserProperty $[i] "cinematics" Cinematics.checked
				SetUserProperty $[i] "physics" PhysicsGenerateCheckBox.checked
				if PhysicsGenerateCheckBox.checked then (
					SetUserProperty $[i] "physics_type" PhysicsGenerateList.items[PhysicsGenerateList.selection]
				)
				SetUserProperty $[i] "physics_to_layer" PhysicsLayerCheckBox.checked
				if PhysicsLayerCheckBox.checked then (
					SetUserProperty $[i] "physics_layer" PhysicsLayerList.items[PhysicsLayerList.selection] 
				)
				SetUserProperty $[i] "logic" LogicGenerateCheckBox.checked
				if LogicGenerateCheckBox.checked then (
					SetUserProperty $[i] "logic_type" LogicGenerateList.items[LogicGenerateList.selection]
				)
				SetUserProperty $[i] "normal" ShowNormal.checked
				SetUserProperty $[i] "event" EventGenerateCheck.checked
				if EventGenerateCheck.checked then (
					SetUserProperty $[i] "event_type" EventGenerateList.items[EventGenerateList.selection]
				)
				SetUserProperty $[i] "track" GenerateTracks.checked
				SetUserProperty $[i] "cam_cycle" CycleCam.checked
				SetUserProperty $[i] "cam_reverse" ReverseCam.checked
				SetUserProperty $[i] "cam_once" OnceCam.checked
				SetUserProperty $[i] "lights" GenerateLights.checked
	
				---Platform properties
				if RenderExportList.items[RenderExportList.selection] == "platform_mesh" then (
					SetUserProperty $[i] "platform_type" RenderPlatformList.items[RenderPlatformList.selection]
					-------Breakable-----  
					--if RenderPlatformList.selection == "breakable"  then (
						SetUserProperty $[i] "trigger_name" TriggerNameText.text
					--)
					------End Breakable---
					------Spikes---------
					--if RenderPlatformList.selection == "spikes"  then (
					--)
					----End Spikes----
					----Poly----------
					--if RenderPlatformList.selection == "poly"  then (
						SetUserProperty $[i] "poly_final_pos_x" PolyFinalPosXText.text
						SetUserProperty $[i] "poly_final_pos_y" PolyFinalPosYText.text
						SetUserProperty $[i] "poly_final_pos_z" PolyFinalPosZText.text
						SetUserProperty $[i] "poly_direction_x" PolyDirectionXText.text
						SetUserProperty $[i] "poly_direction_y" PolyDirectionYText.text
						SetUserProperty $[i] "poly_direction_z" PolyDirectionZText.text
						SetUserProperty $[i] "activation_distance" ActivationDistanceText.text
					--)
					---End Poly-----
					--Moving Platform----
					--if RenderPlatformList.selection == "moving"  then (
						SetUserProperty $[i] "speed" SpeedText.text
						SetUserProperty $[i] "wp1_x" WP1XText.text
						SetUserProperty $[i] "wp1_y" WP1YText.text
						SetUserProperty $[i] "wp1_z" WP1ZText.text
						SetUserProperty $[i] "wp2_x" WP2XText.text
						SetUserProperty $[i] "wp2_y" WP2YText.text
						SetUserProperty $[i] "wp2_z" WP2ZText.text
						SetUserProperty $[i] "wp3_x" WP3XText.text
						SetUserProperty $[i] "wp3_y" WP3YText.text
						SetUserProperty $[i] "wp3_z" WP3ZText.text
						SetUserProperty $[i] "wp4_x" WP4XText.text
						SetUserProperty $[i] "wp4_y" WP4YText.text
						SetUserProperty $[i] "wp4_z" WP4ZText.text
					--)
					--End Moving Platform---
				)
	
				SetUserProperty $[i] "triggerName" TriggerName.text 	
				SetUserProperty $[i] "trigger_shape" ShapeDL.items[ShapeDL.selection]
				SetUserProperty $[i] "trigger_group" GroupDL.items[GroupDL.selection]		
				SetUserProperty $[i] "trigger_type_event" EventType.items[EventType.selection] 		
				SetUserProperty $[i] "trigger_paint" PaintIt.checked		
				SetUserProperty $[i] "trigger_param1" Param1.text		
				SetUserProperty $[i] "trigger_script" ScriptFunction.text 
				SetUserProperty $[i] "trigger_duration" DurationTime.text
				SetUserProperty $[i] "trigger_update" UpdateFunction.text 
				SetUserProperty $[i] "trigger_platform_name" PlatfName.text
			)
		)
		else
		(
			SetUserProperty $ "export" RenderExportCheckBox.checked
			if RenderExportCheckBox.checked then
			(	
				SetUserProperty $ "export_type" RenderExportList.items[RenderExportList.selection]
			)
			SetUserProperty $ "visible" RenderVisibleCheckBox.checked
			SetUserProperty $ "render_to_layer" LayerCheckBox.checked
			if LayerCheckBox.checked then
			(	
				SetUserProperty $ "render_layer" RenderLayerList.items[RenderLayerList.selection]
			)
			if AnimModelText.text != "" or (getUserProp $ "anim_model")!=undefined then
			(
				SetUserProperty $ "anim_model" AnimModelText.text
			)
			if TechniqueText.text != "" or (getUserProp $ "technique")!=undefined then
			(
				SetUserProperty $ "technique" TechniqueText.text
			)
			SetUserProperty $ "test_camera" CameraVisibility.checked
			SetUserProperty $ "export_world" WorldTransform.checked
			SetUserProperty $ "linked" LinkedBoneCheck.checked
			if LinkedBoneText.text != "" or (getUserProp $ "bone_linked")!=undefined then
			(
				SetUserProperty $ "bone_linked" LinkedBoneText.text
			)
			SetUserProperty $ "cinematics" Cinematics.checked
			SetUserProperty $ "physics" PhysicsGenerateCheckBox.checked
			if PhysicsGenerateCheckBox.checked then (
				SetUserProperty $ "physics_type" PhysicsGenerateList.items[PhysicsGenerateList.selection]
			)
			SetUserProperty $ "physics_to_layer" PhysicsLayerCheckBox.checked
			if PhysicsLayerCheckBox.checked then (
				SetUserProperty $ "physics_layer" PhysicsLayerList.items[PhysicsLayerList.selection] 
			)
			SetUserProperty $ "logic" LogicGenerateCheckBox.checked
			if LogicGenerateCheckBox.checked then (
				SetUserProperty $ "logic_type" LogicGenerateList.items[LogicGenerateList.selection]
			)
			SetUserProperty $ "normal" ShowNormal.checked
			SetUserProperty $ "event" EventGenerateCheck.checked
			if EventGenerateCheck.checked then (
				SetUserProperty $ "event_type" EventGenerateList.items[EventGenerateList.selection]
			)
			SetUserProperty $ "track" GenerateTracks.checked
			SetUserProperty $ "cam_cycle" CycleCam.checked
			SetUserProperty $ "cam_reverse" ReverseCam.checked
			SetUserProperty $ "cam_once" OnceCam.checked
			SetUserProperty $ "lights" GenerateLights.checked
			---Platform properties
			if RenderExportList.items[RenderExportList.selection] == "platform_mesh" then (
				SetUserProperty $ "platform_type" RenderPlatformList.items[RenderPlatformList.selection]
				-------Breakable-----
			--	if RenderPlatformList.selection == "breakable"  then (
					SetUserProperty $ "trigger_name" TriggerNameText.text
		--		)
				------End Breakable---
				------Spikes---------
			
				
				------Spikes---------
				--if RenderPlatformList.selection == "spikes"  then (
				--)
				----End Spikes----
				----Poly----------
				--if RenderPlatformList.selection == "poly"  then (
					SetUserProperty $ "poly_final_pos_x" PolyFinalPosXText.text
					SetUserProperty $ "poly_final_pos_y" PolyFinalPosYText.text
					SetUserProperty $ "poly_final_pos_z" PolyFinalPosZText.text
					SetUserProperty $ "poly_direction_x" PolyDirectionXText.text
					SetUserProperty $ "poly_direction_y" PolyDirectionYText.text
					SetUserProperty $ "poly_direction_z" PolyDirectionZText.text
					SetUserProperty $ "activation_distance" ActivationDistanceText.text
					
			--	)
					---End Poly-----
					--Moving Platform----
			--	if RenderPlatformList.selection == "moving"  then (
					SetUserProperty $ "speed" SpeedText.text
					SetUserProperty $ "wp1_x" WP1XText.text
					SetUserProperty $ "wp1_y" WP1YText.text
					SetUserProperty $ "wp1_z" WP1ZText.text
					SetUserProperty $ "wp2_x" WP2XText.text
					SetUserProperty $ "wp2_y" WP2YText.text
					SetUserProperty $ "wp2_z" WP2ZText.text
					SetUserProperty $ "wp3_x" WP3XText.text
					SetUserProperty $ "wp3_y" WP3YText.text
					SetUserProperty $ "wp3_z" WP3ZText.text
					SetUserProperty $ "wp4_x" WP4XText.text
					SetUserProperty $ "wp4_y" WP4YText.text
					SetUserProperty $ "wp4_z" WP4ZText.text
			--	)
					--End Moving Platform---
				
			)
			SetUserProperty $ "triggerName" TriggerName.text 	
			SetUserProperty $ "trigger_shape" ShapeDL.items[ShapeDL.selection]
			SetUserProperty $ "trigger_group" GroupDL.items[GroupDL.selection]		
			SetUserProperty $ "trigger_type_event" EventType.items[EventType.selection] 		
			SetUserProperty $ "trigger_paint" PaintIt.checked		
			SetUserProperty $ "trigger_param1" Param1.text		
			SetUserProperty $ "trigger_script" ScriptFunction.text 
			SetUserProperty $ "trigger_duration" DurationTime.text
			SetUserProperty $ "trigger_update" UpdateFunction.text 
			SetUserProperty $ "trigger_platform_name" PlatfName.text
		)
	)
	on TriggerName entered key do
	(
			TriggerName.bold = false
		)
	on Param1 entered key do
	(
			Param1.bold = false
		)
	on ScriptFunction entered key do
	(
			ScriptFunction.bold = false
		)
	on DurationTime entered key do
	(
			DurationTime.bold = false
		)
	on UpdateFunction entered key do
	(
			UpdateFunction.bold = false
		)
	on PlatfName entered key do
	(
			PlatfName.bold = false
		)
)
