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

rollout UABSetProperties "UAB Set Properties" width:951 height:786
(
	GroupBox PhysicsGp "Physics" pos:[7,597] width:255 height:91
	GroupBox EventsGp "Events" pos:[271,595] width:272 height:56
	checkbox RenderExportCheckBox "Export" pos:[16,32] width:56 height:16
	checkbox RenderVisibleCheckBox "Visible" pos:[16,64] width:56 height:16
	checkbox LayerCheckBox "Layer" pos:[16,96] width:56 height:16
	dropdownList RenderExportList "" pos:[88,32] width:168 height:21
	dropdownList RenderLayerList "" pos:[88,96] width:168 height:21
	label AnimModelLabel "Anim. model" pos:[16,128] width:64 height:16
	edittext AnimModelText "" pos:[88,128] width:168 height:16
	label TechniqueLabel "Technique" pos:[16,160] width:64 height:16
	edittext TechniqueText "" pos:[88,160] width:168 height:16
	checkbox PhysicsGenerateCheckBox "Generate" pos:[15,619] width:64 height:16
	dropdownList PhysicsGenerateList "" pos:[87,619] width:168 height:21
	checkbox PhysicsLayerCheckBox "Layer" pos:[15,651] width:56 height:16
	dropdownList PhysicsLayerList "" pos:[87,651] width:168 height:21
	GroupBox LogicGp "Logic" pos:[7,691] width:256 height:88
	checkbox LogicGenerateCheckBox "Generate" pos:[15,715] width:64 height:16
	dropdownList LogicGenerateList "" pos:[87,715] width:168 height:21
	checkbox showNormal "Show normal" pos:[95,747] width:88 height:16
	checkbox CameraVisibility "Don't test camera visibility" pos:[264,32] width:216 height:16
	checkbox WorldTransform "Don't export world transform" pos:[264,64] width:216 height:16
	edittext LinkedBoneText "" pos:[368,96] width:152 height:16
	checkbox LinkedBoneCheck "Linked to bone" pos:[264,96] width:96 height:16
	checkbox Cinematics "Export to cinematics" pos:[264,128] width:216 height:16
	checkbox EventGenerateCheck "Generate" pos:[279,619] width:64 height:16
	dropdownList EventGenerateList "" pos:[351,619] width:176 height:21
	GroupBox TracksGp "Tracks" pos:[271,659] width:272 height:56
	checkbox GenerateTracks "Generate" pos:[279,683] width:64 height:16
	checkbox RotateTracks "Rotate" pos:[350,683] width:60 height:16
	checkbox FollowTracks "Follow" pos:[460,683] width:64 height:16
	checkbox BackTracks "Back" pos:[410,683] width:40 height:16
	GroupBox CamerasGp "Cameras" pos:[271,723] width:272 height:56
	checkbox CycleCam "Cycle" pos:[279,747] width:56 height:16
	GroupBox LightsGp "Lights" pos:[552,14] width:248 height:354
	checkbox GenerateLights "Generate" pos:[568,40] width:64 height:16
	checkbox ReverseCam "Reverse" pos:[367,747] width:64 height:16
	checkbox OnceCam "Once" pos:[455,747] width:56 height:16
	button GetButton "Get" pos:[304,160] width:104 height:32
	button SetButton "Set" pos:[416,160] width:104 height:32

	label lbl3 "Platform Type" pos:[17,190] width:72 height:14
	dropdownList RenderPlatformList "" pos:[88,184] width:168 height:21
	
	GroupBox grp25 "Render" pos:[7,8] width:536 height:581
	GroupBox grp27 "Breakable Platform" pos:[10,244] width:266 height:49
	label TriggerNameLabel "Trigger Name" pos:[21,265] width:65 height:17
	edittext TriggerNameText "" pos:[96,263] width:149 height:17
	GroupBox PolyPlatformGroup "Poly Platform" pos:[9,296] width:266 height:148
	label ActivationDistanceLabel "Act. Distance" pos:[25,390] width:71 height:16
	edittext ActivationDistanceText "" pos:[105,387] width:40 height:16
	GroupBox MovingPlatformGroup "Moving Platform" pos:[288,295] width:247 height:149
	label SpeedLabel "Speed" pos:[298,320] width:38 height:16
	edittext SpeedText "" pos:[339,320] width:40 height:15
	GroupBox grp32 "Way Points" pos:[295,342] width:233 height:95
	label WP1Label "1" pos:[309,356] width:9 height:16
	label WP1YLabel "Y" pos:[379,354] width:9 height:12
	edittext WP1YText "" pos:[387,352] width:40 height:16
	label WP1ZLabel "Z" pos:[437,354] width:9 height:12
	edittext WP1ZText "" pos:[446,352] width:40 height:16
	label WP1XLabel "X" pos:[324,355] width:9 height:12
	edittext WP1XText "" pos:[333,353] width:40 height:15
	label WP2Label "2" pos:[309,376] width:11 height:16
	label WP2YLabel "Y" pos:[379,374] width:9 height:12
	edittext WP2YText "" pos:[387,372] width:40 height:16
	label WP2ZLabel "Z" pos:[437,374] width:9 height:12
	edittext WP2ZText "" pos:[446,372] width:40 height:16
	label WP2XLabel "X" pos:[324,375] width:9 height:12
	edittext WP2XText "" pos:[333,373] width:40 height:15
	label WP3Label "3" pos:[309,397] width:10 height:16
	label WP3YLabel "Y" pos:[379,395] width:9 height:12
	edittext WP3YText "" pos:[387,393] width:40 height:16
	label lbl46 "Z" pos:[437,395] width:9 height:12
	edittext WP3ZText "" pos:[446,393] width:40 height:16
	label WP3XLabel "X" pos:[324,396] width:9 height:12
	edittext WP3XText "" pos:[333,394] width:40 height:15
	label WP4Label "4" pos:[309,417] width:10 height:16
	label WP4YLabel "Y" pos:[379,415] width:9 height:12
	edittext WP4YText "" pos:[387,413] width:40 height:16
	label lbl50 "Z" pos:[437,415] width:9 height:12
	edittext WP4ZText "" pos:[446,413] width:40 height:16
	label WP4XLabel "X" pos:[324,416] width:9 height:12
	edittext WP4XText "" pos:[333,414] width:40 height:15
		
	label FinalPositionLabel "Final Position" pos:[23,328] width:68 height:16
	label PolyDirectionLabel "Direction" pos:[25,359] width:62 height:16
	label PolyFinalPosLabelY "Y" pos:[152,329] width:9 height:12
	label PolyFinalPosLabelZ "Z" pos:[210,328] width:9 height:12
	label PolyFinalPosLabelX "X" pos:[97,330] width:9 height:12
	label PolyDirectionLabelY "Y" pos:[152,360] width:9 height:12
	label PolyDirectionLabelZ "Z" pos:[210,360] width:9 height:12
	label PolyDirectionLabelX "X" pos:[97,361] width:9 height:12
	edittext PolyFinalPosXText "" pos:[107,326] width:37 height:16
	edittext PolyFinalPosYText "" pos:[161,326] width:37 height:16
	edittext PolyFinalPosZText "" pos:[219,327] width:37 height:16
	edittext PolyDirectionXText "" pos:[107,357] width:37 height:16
	edittext PolyDirectionYText "" pos:[161,357] width:37 height:16
	edittext PolyDirectionZText "" pos:[219,357] width:37 height:16
	
	GroupBox grp28 "Triggers" pos:[15,444] width:520 height:140
	label lbl67 "Trigger Name" pos:[31,468] width:72 height:16
	edittext TriggerName "" pos:[95,468] width:144 height:16
	dropdownList ShapeDL "" pos:[95,492] width:72 height:21
	label lbl68 "Shape" pos:[31,492] width:56 height:16
	label lbl69 "Group" pos:[31,516] width:56 height:16
	dropdownList GroupDL "" pos:[95,516] width:72 height:21
	label lbl70 "Event Type" pos:[255,468] width:80 height:16
	dropdownList eventType "" pos:[343,468] width:88 height:21
	checkbox PaintIt "Paint It" pos:[455,468] width:72 height:16
	label lbl71 "Parameter 1" pos:[255,492] width:80 height:16
	label lbl72 "Script Function" pos:[255,516] width:80 height:16
	edittext Param1 "" pos:[343,492] width:168 height:16
	edittext ScriptFunction "" pos:[343,516] width:168 height:16
	label lbl301 "Duration" pos:[39,556] width:51 height:14
	edittext DurationTime "" pos:[87,556] width:50 height:16
	edittext UpdateFunction "" pos:[343,540] width:168 height:16
	label lbl157 "Update Function" pos:[255,540] width:80 height:16
	edittext PlatfName "" pos:[343,564] width:168 height:16
	label lbl198 "Platform Name" pos:[255,564] width:80 height:16
	label PhisicsSizeLabel "Phisics Size" pos:[17,218] width:58 height:17
	label PhisicSizeXLabel "X:" pos:[90,218] width:13 height:13
	edittext PhisicSizeXText "" pos:[102,216] width:36 height:16
	
	label PhisicSizeYLabel "Y:" pos:[144,218] width:13 height:13
	edittext PhisicSizeYText "" pos:[156,216] width:36 height:16
	label PhisicSizeZLabel "Z:" pos:[203,218] width:13 height:13
	edittext PhisicSizeZText "" pos:[214,216] width:36 height:16
	label TimeOutLabel "Time Out" pos:[166,390] width:52 height:16
	edittext TimeOutText "" pos:[219,387] width:40 height:16
	label SpeedPolyLabel "Speed" pos:[25,418] width:36 height:16
	edittext SpeedPolyText "" pos:[58,415] width:40 height:16
	label LightNamePolyLabel "Light Name" pos:[116,418] width:59 height:16
	edittext LightNamePolyText "" pos:[173,415] width:86 height:16
	label RoomLabel "Room" pos:[366,216] width:38 height:16
	dropdownList RoomText "" pos:[407,216] width:81 height:21

	checkbox GenShadowMap "Generate ShadowMap" pos:[568,64] width:136 height:16
	GroupBox shadowProp "Shadow map properties" pos:[569,88] width:215 height:264
	label lbl48 "ShadowMap format" pos:[584,120] width:104 height:16
	label lbl49 "Ortho size w:" pos:[584,152] width:64 height:16
	dropdownList ShadowDynType "" pos:[696,120] width:80 height:21
	edittext orthoWidth "" pos:[648,152] width:56 height:16
	label lbl56 "h:" pos:[712,152] width:8 height:16
	edittext orthoHeight "" pos:[720,152] width:56 height:16
	label lbl51 "Shad. size w:" pos:[584,176] width:64 height:16
	label lbl52 "h:" pos:[712,176] width:8 height:16
	edittext ShadowHeight "" pos:[720,176] width:56 height:16
	edittext ShadowWidth "" pos:[648,176] width:56 height:16
	checkbox staticShadow "Generate Static shadow" pos:[584,200] width:152 height:16
	label lbl53 "Static Shadow format" pos:[584,224] width:104 height:16
	dropdownList ShadowStatType "" pos:[696,224] width:80 height:21
	edittext LayersToRender "" pos:[584,280] width:184 height:64
	label lbl54 "Renderable layers, separated by comas" pos:[584,248] width:176 height:24

	GroupBox grp14 "Door" pos:[552,379] width:249 height:61
	label FinalPositionDoorLabel "Final Position" pos:[557,400] width:66 height:18
	label FinalPositionXLabel "X" pos:[627,400] width:9 height:15

	label FinalPositionYLabel "Y" pos:[682,400] width:9 height:15
	label FinalPositionZLabel "Z" pos:[740,400] width:9 height:15
	edittext FinalPositionXDoorText "" pos:[632,400] width:45 height:17
	edittext FinalPositionYDoorText "" pos:[688,400] width:45 height:17
	edittext FinalPositionZDoorText "" pos:[748,400] width:45 height:17
	checkbox ScenePhisicCheckbox "Physic Mesh" pos:[275,216] width:91 height:17
	GroupBox grp15 "Particles" pos:[291,243] width:242 height:50
	label EmitterLabel "Emitter" pos:[301,265] width:45 height:18
	edittext EmitterText "" pos:[346,264] width:162 height:17
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
		ShadowDynType.items = ImageType
		ShadowStatType.items = ImageType
		RoomText.items = RoomList
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
		GetUserProperty obj RotateTracks "rotate_track"
		GetUserProperty obj FollowTracks "follow_track"
		GetUserProperty obj BackTracks "back_track"
		GetUserProperty obj CycleCam "cam_cycle"
		GetUserProperty obj ReverseCam "cam_reverse"
		GetUserProperty obj OnceCam "cam_once"
		GetUserProperty obj GenerateLights "lights"
		GetUserProperty obj ScenePhisicCheckbox "use_phisic_mesh"
		GetUserProperty obj RoomText "room"
	
		--- Platform Properties----
		GetUserProperty obj RenderPlatformList "platform_type"
		GetUserProperty obj PhisicSizeXText "phisics_size_x"
		GetUserProperty obj PhisicSizeYText "phisics_size_y"
		GetUserProperty obj PhisicSizeZText "phisics_size_z"
		--break platform
		GetUserProperty obj TriggerNameText "trigger_name"
		-- Poly platform
		GetUserProperty obj PolyFinalPosXText "poly_final_pos_x"
		GetUserProperty obj PolyFinalPosYText "poly_final_pos_y"
		GetUserProperty obj PolyFinalPosZText "poly_final_pos_z"
		GetUserProperty obj PolyDirectionXText "poly_direction_x"
		GetUserProperty obj PolyDirectionYText "poly_direction_y"
		GetUserProperty obj PolyDirectionZText "poly_direction_z"
		GetUserProperty obj ActivationDistanceText "activation_distance"
		GetUserProperty obj TimeOutText "time_out"
		GetUserProperty obj SpeedPolyText "speed_poly"
		GetUserProperty obj LightNamePolyText "light_name"
		
		-- Moveable platform
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
		
		-- Door
		GetUserProperty obj FinalPositionXDoorText "door_final_pos_x"
		GetUserProperty obj FinalPositionYDoorText "door_final_pos_y"
		GetUserProperty obj FinalPositionZDoorText "door_final_pos_z"
		
		--Particles
		GetUserProperty obj EmitterText "emitter"
		
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
				SetUserProperty $[i] "rotate_track" RotateTracks.checked
				SetUserProperty $[i] "follow_track" FollowTracks.checked
				SetUserProperty $[i] "back_track" BackTracks.checked
				SetUserProperty $[i] "cam_cycle" CycleCam.checked
				SetUserProperty $[i] "cam_reverse" ReverseCam.checked
				SetUserProperty $[i] "cam_once" OnceCam.checked
				SetUserProperty $[i] "lights" GenerateLights.checked
				SetUserProperty $[i] "ShadowMap" GenShadowMap.checked
				if GenShadowMap.checked then (
					SetUserProperty $[i] "dynImageType" ShadowDynType.items[ShadowDynType.selection]
					SetUserProperty $[i] "orthoWidth" orthoWidth.text
					SetUserProperty $[i] "orthoHeight" orthoHeight.text
					SetUserProperty $[i] "mapWidth" ShadowWidth.text
					SetUserProperty $[i] "mapHeight" ShadowHeight.text
					SetUserProperty $[i] "staticShadow" staticShadow.checked
					SetUserProperty $[i] "staImageType" ShadowStatType.items[ShadowStatType.selection]
					SetUserProperty $[i] "rednerablesList" LayersToRender.text
				)
				
				--scene_phisic
				if PhisicSizeXText.text != "" or (getUserProp $[i] "phisics_size_x")!=undefined then
				(
					SetUserProperty $[i] "phisics_size_x" PhisicSizeXText.text
				)
				if PhisicSizeYText.text != "" or (getUserProp $[i] "phisics_size_y")!=undefined then
				(
					SetUserProperty $[i] "phisics_size_y" PhisicSizeYText.text
				)
				if PhisicSizeZText.text != "" or (getUserProp $[i] "phisics_size_z")!=undefined then
				(
					SetUserProperty $[i] "phisics_size_z" PhisicSizeZText.text
				)
				
				SetUserProperty $[i]  "use_phisic_mesh" ScenePhisicCheckbox.checked
				SetUserProperty $[i]  "room" RoomText.items[RoomText.selection]
				-- Door Properties
				if RenderExportList.items[RenderExportList.selection] == "door" then (
					SetUserProperty $[i] "door_final_pos_x" FinalPositionXDoorText.text
					SetUserProperty $[i] "door_final_pos_y" FinalPositionYDoorText.text
					SetUserProperty $[i] "door_final_pos_z" FinalPositionZDoorText.text
					
				)
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
						SetUserProperty $[i] "time_out" TimeOutText.text
						SetUserProperty $[i] "speed_poly" SpeedPolyText.text
						SetUserProperty $[i] "light_name" LightNamePolyText.text
	
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
				--triggers
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
				
				--Particles
				SetUserProperty $[i] "emitter" EmitterText.text
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
			SetUserProperty $ "rotate_track" RotateTracks.checked
			SetUserProperty $ "follow_track" FollowTracks.checked
			SetUserProperty $ "back_track" BackTracks.checked
			SetUserProperty $ "cam_cycle" CycleCam.checked
			SetUserProperty $ "cam_reverse" ReverseCam.checked
			SetUserProperty $ "cam_once" OnceCam.checked
			SetUserProperty $ "lights" GenerateLights.checked
			SetUserProperty $ "ShadowMap" GenShadowMap.checked
			if GenShadowMap.checked then (
				SetUserProperty $ "dynImageType" ShadowDynType.items[ShadowDynType.selection]
				SetUserProperty $ "orthoWidth" orthoWidth.text
				SetUserProperty $ "orthoHeight" orthoHeight.text
				SetUserProperty $ "mapWidth" ShadowWidth.text
				SetUserProperty $ "mapHeight" ShadowHeight.text
				SetUserProperty $ "staticShadow" staticShadow.checked
				SetUserProperty $ "staImageType" ShadowStatType.items[ShadowStatType.selection]
				SetUserProperty $ "rednerablesList" LayersToRender.text
			)
			
			if PhisicSizeXText.text != "" or (getUserProp $ "phisics_size_x")!=undefined then
			(
				SetUserProperty $ "phisics_size_x" PhisicSizeXText.text
			)
			if PhisicSizeYText.text != "" or (getUserProp $ "phisics_size_y")!=undefined then
			(
				SetUserProperty $ "phisics_size_y" PhisicSizeYText.text
			)
			if PhisicSizeZText.text != "" or (getUserProp $ "phisics_size_z")!=undefined then
			(
				SetUserProperty $ "phisics_size_z" PhisicSizeZText.text
			)
			SetUserProperty $  "use_phisic_mesh" ScenePhisicCheckbox.checked
			SetUserProperty $ "room" RoomText.items[RoomText.selection]
				-- Door Properties
			if RenderExportList.items[RenderExportList.selection] == "door" then (
				SetUserProperty $ "door_final_pos_x" FinalPositionXDoorText.text
				SetUserProperty $ "door_final_pos_y" FinalPositionYDoorText.text
				SetUserProperty $ "door_final_pos_z" FinalPositionZDoorText.text
					
			)
			
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
					SetUserProperty $ "time_out" TimeOutText.text
					SetUserProperty $ "speed_poly" SpeedPolyText.text
					SetUserProperty $ "light_name" LightNamePolyText.text
	
					
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
			
			--Particles
			SetUserProperty $ "emitter" EmitterText.text
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
	on orthoWidth entered key do
	(
		orthoWidth.bold = false
	)
	on orthoHeight entered key do
	(
		orthoHeight.bold = false
	)
	on ShadowHeight entered key do
	(
		ShadowHeight.bold = false
	)
	on ShadowWidth entered key do
	(
		ShadowWidth.bold = false
	)
	on LayersToRender entered key do
	(
		LayersToRender.bold = false
	)
)
