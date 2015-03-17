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

rollout UABSetProperties "UAB Set Properties" width:843 height:691
(
	GroupBox PhysicsGp "Physics" pos:[7,454] width:255 height:91
	GroupBox EventsGp "Events" pos:[271,452] width:264 height:56
	checkbox RenderExportCheckBox "Export" pos:[16,32] width:56 height:16
	checkbox RenderVisibleCheckBox "Visible" pos:[16,64] width:56 height:16
	checkbox LayerCheckBox "Layer" pos:[16,96] width:56 height:16
	dropdownList RenderExportList "" pos:[88,32] width:168 height:21
	dropdownList RenderLayerList "" pos:[88,96] width:168 height:21
	label AnimModelLabel "Anim. model" pos:[16,128] width:64 height:16
	edittext AnimModelText "" pos:[88,128] width:168 height:16
	label TechniqueLabel "Technique" pos:[16,160] width:64 height:16
	edittext TechniqueText "" pos:[88,160] width:168 height:16
	checkbox PhysicsGenerateCheckBox "Generate" pos:[15,476] width:64 height:16
	dropdownList PhysicsGenerateList "" pos:[87,476] width:168 height:21
	checkbox PhysicsLayerCheckBox "Layer" pos:[15,508] width:56 height:16
	dropdownList PhysicsLayerList "" pos:[87,508] width:168 height:21
	GroupBox LogicGp "Logic" pos:[7,548] width:256 height:88
	checkbox LogicGenerateCheckBox "Generate" pos:[15,572] width:64 height:16
	dropdownList LogicGenerateList "" pos:[87,572] width:168 height:21
	checkbox showNormal "Show normal" pos:[95,604] width:88 height:16
	checkbox CameraVisibility "Don't test camera visibility" pos:[264,32] width:216 height:16
	checkbox WorldTransform "Don't export world transform" pos:[264,64] width:216 height:16
	edittext LinkedBoneText "" pos:[368,96] width:152 height:16
	checkbox LinkedBoneCheck "Linked to bone" pos:[264,96] width:96 height:16
	checkbox Cinematics "Export to cinematics" pos:[264,128] width:216 height:16
	checkbox EventGenerateCheck "Generate" pos:[279,476] width:64 height:16
	dropdownList EventGenerateList "" pos:[351,476] width:176 height:21
	GroupBox TracksGp "Tracks" pos:[271,516] width:128 height:56
	checkbox GenerateTracks "Generate" pos:[303,540] width:64 height:16
	GroupBox CamerasGp "Cameras" pos:[271,580] width:264 height:56
	checkbox CycleCam "Cycle" pos:[279,604] width:56 height:16
	GroupBox LightsGp "Lights" pos:[407,516] width:128 height:56
	checkbox GenerateLights "Generate" pos:[439,540] width:64 height:16
	checkbox ReverseCam "Reverse" pos:[367,604] width:64 height:16
	checkbox OnceCam "Once" pos:[455,604] width:56 height:16
	button GetButton "Get" pos:[293,645] width:104 height:32
	button SetButton "Set" pos:[405,645] width:104 height:32

	label lbl3 "Platform Type" pos:[17,190] width:72 height:14
	dropdownList RenderPlatformList "" pos:[88,184] width:168 height:21
	GroupBox PlatformProperties "Platforms Properties" pos:[549,20] width:282 height:416
	label TriggerNameLabel "Trigger Name" pos:[567,54] width:65 height:17
	edittext TriggerNameText "" pos:[642,54] width:149 height:17
	
	GroupBox grp25 "Render" pos:[7,9] width:828 height:436
	GroupBox grp27 "Breakable Platform" pos:[556,38] width:266 height:47
	GroupBox SpikePlatformGroup "Spike Platform" pos:[556,91] width:266 height:89
	checkbox FromXCheckBox "From X" pos:[567,111] width:58 height:14
	checkbox FromZCheckBox "From Z" pos:[634,111] width:58 height:14
	label BackPositionLabel "Back Position" pos:[567,135] width:68 height:12
	label RedimScaleLabel "Redim. Scale" pos:[686,205] width:65 height:12
	edittext RedimScaleText "" pos:[748,203] width:29 height:15
	label BackPositionYLabel "Y" pos:[698,135] width:9 height:12
	edittext BackPositionYText "" pos:[707,132] width:40 height:16
	label BackPositionZLabel "Z" pos:[759,135] width:9 height:12
	edittext BackPositionZText "" pos:[768,132] width:40 height:16
	label ForthPositionLabel "Forth Position" pos:[567,156] width:68 height:12
	label ForthPositionXLabel "X" pos:[639,156] width:9 height:12
	edittext ForthPositionXText "" pos:[648,153] width:40 height:15
	label ForthPositionYLabel "Y" pos:[697,156] width:9 height:12
	edittext ForthPositionYText "" pos:[707,153] width:40 height:16
	label ForthPositionZLabel "Z" pos:[760,156] width:9 height:12
	edittext ForthPositionZText "" pos:[769,153] width:40 height:16
	GroupBox PolyPlatformGroup "Poly Platform" pos:[557,187] width:266 height:73
	label RedimAxisLabel "Redim. Axis" pos:[567,204] width:62 height:14
	dropdownList RedimAxisList "" pos:[636,204] width:37 height:21
	label ActivationDistanceLabel "Act. Distance" pos:[567,236] width:71 height:16
	edittext ActivationDistanceText "" pos:[639,236] width:40 height:15
	checkbox InitialCollisionCheckBox "Initial Collision" pos:[715,236] width:96 height:14
	GroupBox MovingPlatformGroup "Moving Platform" pos:[557,266] width:266 height:161
	label BackPositionXLabel "X" pos:[639,136] width:9 height:12
	edittext BackPositionXText "" pos:[648,133] width:40 height:15
	label SpeedLabel "Speed" pos:[567,283] width:38 height:16
	edittext SpeedText "" pos:[608,283] width:40 height:15
	GroupBox grp32 "Way Points" pos:[564,306] width:251 height:113
	label WP1Label "1" pos:[578,328] width:9 height:16
	label WP1YLabel "Y" pos:[648,327] width:9 height:12
	edittext WP1YText "" pos:[656,324] width:40 height:16
	label WP1ZLabel "Z" pos:[706,327] width:9 height:12
	edittext WP1ZText "" pos:[715,324] width:40 height:16
	label WP1XLabel "X" pos:[593,328] width:9 height:12
	edittext WP1XText "" pos:[602,325] width:40 height:15
	label WP2Label "2" pos:[578,350] width:11 height:16
	label WP2YLabel "Y" pos:[648,349] width:9 height:12
	edittext WP2YText "" pos:[656,346] width:40 height:16
	label WP2ZLabel "Z" pos:[706,349] width:9 height:12
	edittext WP2ZText "" pos:[715,346] width:40 height:16
	label WP2XLabel "X" pos:[593,350] width:9 height:12
	edittext WP2XText "" pos:[602,347] width:40 height:15
	label WP3Label "3" pos:[578,371] width:10 height:16
	label WP3YLabel "Y" pos:[648,370] width:9 height:12
	edittext WP3YText "" pos:[656,367] width:40 height:16
	label lbl46 "Z" pos:[706,370] width:9 height:12
	edittext WP3ZText "" pos:[715,367] width:40 height:16
	label WP3XLabel "X" pos:[593,371] width:9 height:12
	edittext WP3XText "" pos:[601,368] width:40 height:15
	label WP4Label "4" pos:[578,391] width:10 height:16
	label WP4YLabel "Y" pos:[648,390] width:9 height:12
	edittext WP4YText "" pos:[656,387] width:40 height:16
	label lbl50 "Z" pos:[706,390] width:9 height:12
	edittext WP4ZText "" pos:[715,387] width:40 height:16
	label WP4XLabel "X" pos:[593,391] width:9 height:12
	edittext WP4XText "" pos:[602,388] width:40 height:15

	groupBox grp28 "Triggers" pos:[16,328] width:520 height:100
	label lbl67 "Trigger Name" pos:[32,352] width:72 height:16
	editText TriggerName "" pos:[96,352] width:144 height:16
	dropDownList ShapeDL "" pos:[96,376] width:72 height:21
	label lbl68 "Shape" pos:[32,376] width:56 height:16
	label lbl69 "Group" pos:[32,400] width:56 height:16
	dropDownList GroupDL "" pos:[96,400] width:72 height:21
	label lbl70 "Event Type" pos:[272,352] width:72 height:16
	dropDownList EventType "" pos:[336,352] width:88 height:21
	checkbox PaintIt "Paint It" pos:[440,352] width:80 height:16
	label lbl71 "Parameter 1" pos:[264,376] width:72 height:16
	label lbl72 "Script Function" pos:[264,400] width:72 height:16
	editText Param1 "" pos:[344,376] width:168 height:16
	editText ScriptFunction "" pos:[344,400] width:168 height:16
	label lbl301 "Duration" pos:[191,379] width:51 height:14
	editText DurationTime "" pos:[191,397] width:50 height:18
	
	on UABSetProperties open do
	(	
		RenderExportList.items = MeshType
		RenderLayerList.items = RenderLayers
		PhysicsGenerateList.items = PhysicsType
		PhysicsLayerList.items=PhysicsLayer
		LogicGenerateList.items = logicGenerate
		EventGenerateList.items = EventList
		RenderPlatformList.items = RenderPlatform
		RedimAxisList.items = RedimAxis
		ShapeDL.items = TriggerShapeL
		GroupDL.items = GroupsList
		EventType.items = EventTypeL
	)
	
	on GetButton pressed  do
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
		GetUserProperty obj FromXCheckBox "from_x"
		GetUserProperty obj FromZCheckBox "from_z"
		GetUserProperty obj BackPositionXText "back_position_x"
		GetUserProperty obj BackPositionYText "back_position_y"
		GetUserProperty obj BackPositionZText "back_position_z"
		GetUserProperty obj ForthPositionXText "forth_position_x"
		GetUserProperty obj ForthPositionYText "forth_position_y"
		GetUserProperty obj ForthPositionZText "forth_position_z"
		GetUserProperty obj RedimAxisList "redim_axis"
		GetUserProperty obj RedimScaleText "redim_scale"
		GetUserProperty obj ActivationDistanceText "activation_distance"
		GetUserProperty obj InitialCollisionCheckBox "initial_collision"
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
		
		GetUserProperty obj TriggerName "triggerName"
		GetUserProperty obj ShapeDL "trigger_shape"
		GetUserProperty obj GroupDL "trigger_group"
		GetUserProperty obj EventType "trigger_type_event"
		GetUserProperty obj PaintIt "trigger_paint"
		GetUserProperty obj Param1 "trigger_param1"
		GetUserProperty obj ScriptFunction "trigger_script"
		GetUserProperty obj DurationTime "trigger_duration"
	)
	
	on SetButton pressed  do
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
				--	if RenderPlatformList.selection == "breakable"  then (
					SetUserProperty $[i] "trigger_name" TriggerNameText.text
					--)
					------End Breakable---
					------Spikes---------
					--if RenderPlatformList.selection == "spikes"  then (
					SetUserProperty $[i] "from_x" FromXCheckBox.checked
					SetUserProperty $[i] "from_z" FromZCheckBox.checked
					SetUserProperty $[i] "back_position_x" BackPositionXText.text
					SetUserProperty $[i] "back_position_y" BackPositionYText.text
					SetUserProperty $[i] "back_position_z" BackPositionZText.text
					SetUserProperty $[i] "forth_position_x" ForthPositionXText.text
					SetUserProperty $[i] "forth_position_y" ForthPositionYText.text
					SetUserProperty $[i] "forth_position_z" ForthPositionZText.text
					--)
					----End Spikes----
					----Poly----------
					--if RenderPlatformList.selection == "poly"  then (
					SetUserProperty $[i] "redim_axis" RedimAxisList.items[RedimAxisList.selection]
					SetUserProperty $[i] "redim_scale" RedimScaleText.text
					SetUserProperty $[i] "activation_distance" ActivationDistanceText.text
					SetUserProperty $[i] "initial_collision" InitialCollisionCheckBox.checked
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
				SetUserProperty $[i] "trigger_param1" Param1.test		
				SetUserProperty $[i] "trigger_script" ScriptFunction.text 
				SetUserProperty $[i] "trigger_duration" DurationTime.text
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
				--)
				------End Breakable---
				------Spikes---------
				--if RenderPlatformList.selection == "spikes"  then (
				SetUserProperty $ "from_x" FromXCheckBox.checked
				SetUserProperty $ "from_z" FromZCheckBox.checked
				SetUserProperty $ "back_position_x" BackPositionXText.text
				SetUserProperty $ "back_position_y" BackPositionYText.text
				SetUserProperty $ "back_position_z" BackPositionZText.text
				SetUserProperty $ "forth_position_x" ForthPositionXText.text
				SetUserProperty $ "forth_position_y" ForthPositionYText.text
				SetUserProperty $ "forth_position_z" ForthPositionZText.text
				--)
				----End Spikes----
				----Poly----------
				--if RenderPlatformList.selection == "poly"  then (
				SetUserProperty $ "redim_axis" RedimAxisList.items[RedimAxisList.selection]
				SetUserProperty $ "redim_scale" RedimScaleText.text
				SetUserProperty $ "activation_distance" ActivationDistanceText.text
				SetUserProperty $ "initial_collision" InitialCollisionCheckBox.checked
				--)
				---End Poly-----
				--Moving Platform----
				--if RenderPlatformList.selection == "moving"  then (
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
				--)
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
		)
	)
	
	on AnimModelText entered key do (
		AnimModelText.bold = false
	)
		
	on TechniqueText entered key do (
		TechniqueText.bold = false
	)
	
	on LinkedBoneText entered key do (
		LinkedBoneText.bold = false
	)

	on BackPositionXText entered key do (
		BackPositionXText.bold = false
	)

	on BackPositionYText entered key do (
		BackPositionYText.bold = false
	)

	on BackPositionZText entered key do (
		BackPositionZText.bold = false
	)

	on ForthPositionXText entered key do (
		ForthPositionXText.bold = false
	)

	on ForthPositionYText entered key do (
		ForthPositionYText.bold = false
	)

	on ForthPositionZText entered key do (
		ForthPositionZText.bold = false
	)

	on ActivationDistanceText entered key do (
		ActivationDistanceText.bold = false
	)

	on SpeedText entered key do (
		SpeedText.bold = false
	)

	on WP1XText entered key do (
		WP1XText.bold = false
	)

	on WP1YText entered key do (
		WP1YText.bold = false
	)

	on WP1ZText entered key do (
		WP1ZText.bold = false
	)

	on WP2XText entered key do (
		WP2XText.bold = false
	)

	on WP2YText entered key do (
		WP2YText.bold = false
	)

	on WP2ZText entered key do (
		WP2ZText.bold = false
	)

	on WP3XText entered key do (
		WP3XText.bold = false
	)

	on WP3YText entered key do (
		WP3YText.bold = false
	)

	on WP3ZText entered key do (
		WP3ZText.bold = false
	)

	on WP4XText entered key do (
		WP4XText.bold = false
	)

	on WP4YText entered key do (
		WP4YText.bold = false
	)

	on WP4ZText entered key do (
		WP4ZText.bold = false
	)

	on Param1 entered key do (
		Param1.bold = false
	)

	on ScriptFunction entered key do (
		ScriptFunction.bold = false
	)

	on TriggerName entered key do (
		TriggerName.bold = false
	)

	on DurationTime entered key do (
		DurationTime.bold = false
	)
)
