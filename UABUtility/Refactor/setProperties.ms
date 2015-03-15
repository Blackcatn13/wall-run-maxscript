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

rollout UABSetProperties "UAB Set Properties" width:544 height:456
(
	groupBox RenderGp "Render" pos:[8,8] width:528 height:200
	groupBox PhysicsGp "Physics" pos:[8,216] width:256 height:88
	groupBox EventsGp "Events" pos:[272,216] width:264 height:56
	checkBox RenderExportCheckBox "Export" pos:[16,32] width:56 height:16
	checkBox RenderVisibleCheckBox "Visible" pos:[16,64] width:56 height:16
	checkBox LayerCheckBox "Layer" pos:[16,96] width:56 height:16
	dropDownList RenderExportList "" pos:[88,32] width:168 height:21
	dropDownList RenderLayerList "" pos:[88,96] width:168 height:21
	label AnimModelLabel "Anim. model" pos:[16,128] width:64 height:16
	editText AnimModelText "" pos:[88,128] width:168 height:16
	label TechniqueLabel "Technique" pos:[16,160] width:64 height:16
	editText TechniqueText "" pos:[88,160] width:168 height:16
	checkBox PhysicsGenerateCheckBox "Generate" pos:[16,240] width:64 height:16
	dropDownList PhysicsGenerateList "" pos:[88,240] width:168 height:21
	checkBox PhysicsLayerCheckBox "Layer" pos:[16,272] width:56 height:16
	dropDownList PhysicsLayerList "" pos:[88,272] width:168 height:21
	groupBox LogicGp "Logic" pos:[8,312] width:256 height:88
	checkBox LogicGenerateCheckBox "Generate" pos:[16,336] width:64 height:16
	dropDownList LogicGenerateList "" pos:[88,336] width:168 height:21
	checkBox ShowNormal "Show normal" pos:[96,368] width:88 height:16
	checkBox CameraVisibility "Don't test camera visibility" pos:[264,32] width:216 height:16
	checkBox WorldTransform "Don't export world transform" pos:[264,64] width:216 height:16
	editText LinkedBoneText "" pos:[368,96] width:152 height:16
	checkBox LinkedBoneCheck "Linked to bone" pos:[264,96] width:96 height:16
	checkBox Cinematics "Export to cinematics" pos:[264,128] width:216 height:16
	checkBox EventGenerateCheck "Generate" pos:[280,240] width:64 height:16
	dropDownList EventGenerateList "" pos:[352,240] width:176 height:21
	groupBox TracksGp "Tracks" pos:[272,280] width:128 height:56
	checkBox GenerateTracks "Generate" pos:[304,304] width:64 height:16
	groupBox CamerasGp "Cameras" pos:[272,344] width:264 height:56
	checkBox CycleCam "Cycle" pos:[280,368] width:56 height:16
	groupBox LightsGp "Lights" pos:[408,280] width:128 height:56
	checkBox GenerateLights "Generate" pos:[440,304] width:64 height:16
	checkBox ReverseCam "Reverse" pos:[368,368] width:64 height:16
	checkBox OnceCam "Once" pos:[456,368] width:56 height:16
	button GetButton "Get" pos:[160,416] width:104 height:32
	button SetButton "Set" pos:[272,416] width:104 height:32
	
	--Eventos 
	local RenderLayers = #("solid", "skybox", "alpha_objects","alpha_blend_objects", "particles")
	
	
	on UABSetProperties open do
	(
		-- malla estática, malla animada
		local ExportMeshes=#("instance_mesh", "animated_mesh")
		
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
)
