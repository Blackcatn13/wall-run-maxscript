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
	edittext AnimModelText "" pos:[88,112] width:176 height:16 enabled:false
	checkbox PhysicsGenerateCheckBox "Generate" pos:[16,176] width:72 height:16
	checkbox PhysicsLayerCheckBox "Layer" pos:[16,208] width:72 height:16
	dropdownList PhysicsGenerateList "" pos:[96,176] width:168 height:21
	dropdownList PhysicsLayerList "" pos:[96,208] width:168 height:21
	checkbox LogicGenerateCheckBox "Generate" pos:[16,264] width:72 height:16
	dropdownList LogicGenerateList "" pos:[96,264] width:168 height:21
	button GetButton "Get" pos:[8,352] width:96 height:24
	button btn82 "Set" pos:[176,352] width:96 height:24
	
	--Eventos 

	on UABSetProperties open do
	(
		local InstantMeshes=#("instance_mesh", "animated_mesh")
		local RenderLayers = #("solid", "alpha_objects","alpha_blend_objects", "particles")
	)
)
