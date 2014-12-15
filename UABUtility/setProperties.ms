rollout UABSetProperties "UAB Set Properties" width:280 height:392
(
	GroupBox grp12 "Render" pos:[8,16] width:263 height:129
	GroupBox grp13 "Physics" pos:[8,160] width:264 height:80
	GroupBox grp14 "Logic" pos:[8,248] width:264 height:56
	checkbox RenderExportCheckBox "Export" pos:[16,32] width:72 height:16
	checkbox RenderVisibleCheckBox "Visible" pos:[16,56] width:72 height:16
	checkbox LayerCheckBox "Layer" pos:[16,80] width:72 height:16
	dropdownList RenderExportList "" pos:[96,32] width:168 height:21
	dropdownList RenderLayerList "" pos:[96,72] width:168 height:21
	label AnimModelLabel "Anim. Model" pos:[16,112] width:64 height:16
	edittext AnimModelText "" pos:[88,112] width:176 height:16 enabled:true
	checkbox PhysicsGenerateCheckBox "Generate" pos:[16,176] width:72 height:16
	checkbox PhysicsLayerCheckBox "Layer" pos:[16,208] width:72 height:16
	dropdownList PhysicsGenerateList "" pos:[96,176] width:168 height:21
	dropdownList PhysicsLayerList "" pos:[96,208] width:168 height:21
	checkbox LogicGenerateCheckBox "Generate" pos:[16,264] width:72 height:16
	dropdownList LogicGenerateList "" pos:[96,264] width:168 height:21
	button GetButton "Get" pos:[8,352] width:96 height:24
	button SetButton "Set" pos:[176,352] width:96 height:24
	
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
