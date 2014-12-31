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
	checkBox cameraVisibility "Don't test camera visibility" pos:[264,32] width:216 height:16
	checkBox worldTransform "Don't export world transform" pos:[264,64] width:216 height:16
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

	
	
	on UABSetProperties open do
	(
		-- malla estática, malla animada
		local ExportMeshes=#("instance_mesh", "animated_mesh")
		local RenderLayers = #("solid", "alpha_objects","alpha_blend_objects", "particles")
		--malla triangular, forma convexa, forma caja, forma esfera, forma plano, forma cápsula
		local PhysicsGenerate=#("triangle_mesh", "convex_shape","box_shape", "plane_shape","capsule_shape")
		local PhysicsLayer=#("logic")
		--cajas de eventos, esferas de eventos, escaleras, filos agarrables, filos dónde dejarse caer
		local LogicGenerate=#("box_event", "sphere_event","stairs", "holding_edges","falling_edges")
		
		RenderExportList.items = ExportMeshes
		RenderLayerList.items = RenderLayers
		PhysicsGenerateList.items = PhysicsGenerate
		PhysicsLayerList.items=PhysicsLayer
		LogicGenerateList.items = LogicGenerate
		
	)
	
	on GetButton pressed  do
	(
		if RenderExportCheckBox.checked then
		(	
			GetUserProperty $ RenderExportList "export_type"
		)
		
		GetUserProperty $ RenderVisibleCheckBox "visible"
		
		if LayerCheckBox.checked then
		(	
			GetUserProperty $ RenderLayerList "export_layer"
		)
		
		
		if(getUserProp $ "anim_model") != undefined then
		(
			AnimModelText.text = (getUserProp $ "anim_model")
		)
		
		
		if PhysicsGenerateCheckBox.checked then
		(	
			GetUserProperty $ PhysicsGenerateList "generated_physics"
		)
		
		if PhysicsLayerCheckBox.checked then
		(	
			GetUserProperty $ PhysicsLayerList "physics_layer"
		)
		
		if LogicGenerateCheckBox.checked then
		(	
			GetUserProperty $ LogicGenerateList "generate_logic"
		)
		
	)
	
	on SetButton pressed  do
	(
		if ((classof $) == ObjectSet) then
		(
			for i = 1 to $.count do
			(
				if RenderExportCheckBox.checked then
				(	
					SetUserProperty $[i] "export_type" RenderExportList.items[RenderExportList.selection]
				)
				
				SetUserProperty $[i]  "visible" RenderVisibleCheckBox.checked
				
				if LayerCheckBox.checked then
				(	
					SetUserProperty $[i]  "export_layer" RenderLayerList.items[RenderLayerList.selection]
				)
				
				if PhysicsGenerateCheckBox.checked then
				(	
					SetUserProperty $[i]  "generated_physics" PhysicsGenerateList.items[PhysicsGenerateList.selection]
				)
				
				if PhysicsLayerCheckBox.checked then
				(	
					SetUserProperty $[i]  "physics_layer" PhysicsLayerList.items[PhysicsLayerList.selection]
				)
				
				if LogicGenerateCheckBox.checked then
				(	
					SetUserProperty $[i]  "generate_logic" LogicGenerateList.items[LogicGenerateList.selection]
				)
				
				if AnimModelText.text != "" or (getUserProp $ "anim_model")!=undefined then
				(
					SetUserProperty $[i]  "anim_model" AnimModelText.text
				)
			)
		)
		else
		(
			if RenderExportCheckBox.checked then
			(	
				SetUserProperty $ "export_type" RenderExportList.items[RenderExportList.selection]
			)
				
			SetUserProperty $ "visible" RenderVisibleCheckBox.checked
			
			if LayerCheckBox.checked then
			(	
				SetUserProperty $ "export_layer" RenderLayerList.items[RenderLayerList.selection]
			)
			
			if PhysicsGenerateCheckBox.checked then
			(	
				SetUserProperty $ "generated_physics" PhysicsGenerateList.items[PhysicsGenerateList.selection]
			)
			
			if PhysicsLayerCheckBox.checked then
			(	
				SetUserProperty $ "physics_layer" PhysicsLayerList.items[PhysicsLayerList.selection]
			)
			
			if LogicGenerateCheckBox.checked then
			(	
				SetUserProperty $ "generate_logic" LogicGenerateList.items[LogicGenerateList.selection]
			)
			
			if AnimModelText.text != "" or (getUserProp $ "anim_model")!=undefined then
			(
				SetUserProperty $ "anim_model" AnimModelText.text
			)
		)
	)
)
fn GetUserProperty Obj GUIObj StrProperty = 
(
	--local message = (classof GUIObj)
	--messagebox message
	if (getUserProp $ StrProperty)!=undefined then
	(
		--Aquí uno por cada tipo de elemento de GUI
		if (classof GUIObj) == ComboBoxControl then
		(
			GUIObj.selected = (getUserProp Obj StrProperty)
		)
		
		if (classof GUIObj) == CheckBoxControl then
		(
			GUIObj.checked = (getUserProp Obj StrProperty)
		)
		
	)
	else
	(
		messageBox ("Undefined property: \"" + StrProperty +"\".") title:"Undefined Property"
	)
)

fn SetUserProperty Obj StrProperty StrValue =
(
	setUserProp Obj StrProperty StrValue
)
