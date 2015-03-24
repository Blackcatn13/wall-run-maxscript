rollout UABSetProperties "UAB Set Properties" width:555 height:691
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
	button GetButton "Get" pos:[158,645] width:104 height:32
	button SetButton "Set" pos:[270,645] width:104 height:32
	
	--Eventos 
	local RenderLayers = #("solid", "skybox", "alpha_objects","alpha_blend_objects", "particles")
	
	
	
	
	
		
	label lbl3 "Platform Type" pos:[17,190] width:72 height:14
	dropdownList RenderPlatformList "" pos:[88,184] width:168 height:21
	label TriggerNameLabel "Trigger Name" pos:[21,247] width:65 height:17
	edittext TriggerNameText "" pos:[96,247] width:149 height:17
	
	GroupBox grp27 "Breakable Platform" pos:[10,231] width:266 height:47
	GroupBox PolyPlatformGroup "Poly Platform" pos:[10,284] width:266 height:107
	label ActivationDistanceLabel "Act. Distance" pos:[25,367] width:71 height:16
	edittext ActivationDistanceText "" pos:[105,364] width:40 height:16
	GroupBox MovingPlatformGroup "Moving Platform" pos:[288,231] width:247 height:161
	label SpeedLabel "Speed" pos:[298,248] width:38 height:16
	edittext SpeedText "" pos:[339,248] width:40 height:15
	GroupBox grp32 "Way Points" pos:[295,271] width:233 height:113
	label WP1Label "1" pos:[309,293] width:9 height:16
	label WP1YLabel "Y" pos:[379,292] width:9 height:12
	edittext WP1YText "" pos:[387,289] width:40 height:16
	label WP1ZLabel "Z" pos:[437,292] width:9 height:12
	edittext WP1ZText "" pos:[446,289] width:40 height:16
	label WP1XLabel "X" pos:[324,293] width:9 height:12
	edittext WP1XText "" pos:[333,290] width:40 height:15
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
	label PolyFinalPosLabelZ "Z" pos:[210,306] width:9 height:12
	label PolyFinalPosLabelX "X" pos:[97,307] width:9 height:12
	label PolyDirectionLabelY "Y" pos:[152,337] width:9 height:12
	label PolyDirectionLabelZ "Z" pos:[210,337] width:9 height:12
	label PolyDirectionLabelX "X" pos:[97,338] width:9 height:12
	edittext PolyFinalPosXText "" pos:[107,303] width:37 height:16
	edittext PolyFinalPosYText "" pos:[161,303] width:37 height:16
	edittext PolyFinalPosZText "" pos:[223,303] width:37 height:16
	edittext PolyDirectionXText "" pos:[107,334] width:37 height:16
	edittext PolyDirectionYText "" pos:[161,334] width:37 height:16
	edittext PolyDirectionZText "" pos:[223,334] width:37 height:16
	on UABSetProperties open do
	(
		-- malla estática, malla animada
		local ExportMeshes=#("instance_mesh", "animated_mesh", "platform_mesh")
		
		--malla triangular, forma convexa, forma caja, forma esfera, forma plano, forma cápsula
		local PhysicsGenerate=#("triangle_mesh", "convex_shape","box_shape", "plane_shape","capsule_shape")
		local PhysicsLayer=#("logic")
		--cajas de eventos, esferas de eventos, escaleras, filos agarrables, filos dónde dejarse caer
		local LogicGenerate=#("box_event", "sphere_event","stairs", "holding_edges","falling_edges")
		local EventGenerate=#("event1")
		RenderExportList.items = ExportMeshes
		RenderLayerList.items = RenderLayers
		PhysicsGenerateList.items = PhysicsGenerate
		PhysicsLayerList.items=PhysicsLayer
		LogicGenerateList.items = LogicGenerate
		EventGenerateList.items = EventGenerate
		--Plataformas
		local RenderPlatform=#("static","breakable","moving","pinchos","poly")
		RenderPlatformList.items = RenderPlatform
		
	)
	on AnimModelText entered key do
	(
				AnimModelText.bold = false
		)
	on TechniqueText entered key do
	(
			TechniqueText.bold = false
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
		)
	)
	on ActivationDistanceText entered key do
	(
			ActivationDistanceText.bold = false
		)
	on SpeedText entered key do
	(
			SpeedText.bold = false
		)
	on WP1YText entered key do
	(
			WP1YText.bold = false
		)
	on WP1ZText entered key do
	(
			WP1ZText.bold = false
		)
	on WP1XText entered key do
	(
			WP1XText.bold = false
		)
	on WP2YText entered key do
	(
			WP2YText.bold = false
		)
	on WP2ZText entered key do
	(
			WP2ZText.bold = false
		)
	on WP2XText entered key do
	(
			WP2XText.bold = false
		)
	on WP3YText entered key do
	(
			WP3YText.bold = false
		)
	on WP3ZText entered key do
	(
			WP3ZText.bold = false
		)
	on WP3XText entered key do
	(
			WP3XText.bold = false
		)
	on WP4YText entered key do
	(
			WP4YText.bold = false
		)
	on WP4ZText entered key do
	(
			WP4ZText.bold = false
		)
	on WP4XText entered key do
	(
			WP4XText.bold = false
		)
)

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
