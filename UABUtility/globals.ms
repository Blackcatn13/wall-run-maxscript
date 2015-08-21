-- UABUtility Variables
global debug = true
global levels=#("","level1","level2", "level3","level4", "level5", "main menu", "select player")
global realPath
global FileExtension = ".mesh"
global PhysXExtension = ".phsx"
global DataDirectory = "Data\\"
global MeshDirectory = "meshes\\"
global TextureDirectory = "textures\\"
global staticMeshFileName = "static_meshes.xml"
global renderableObjectsFileName = "renderable_objects.xml"
global CamerasFileName = "cameras.xml"
global AnimatedCamerasPath = "cameras\\"
global LightsFileName = "lights.xml"
global CinematicFileName = "cinematic.xml"
global TriggerFileName = "triggers.xml"
global PhysXFileName = "LevelCooking.xml"
global PhysXSceneElementFileName = "SceneElementCooking.xml"
global CameraPathFileName = "camera_path.xml"
global SoundFileName = "WWSounds.xml"
global CopyTextures = true
global ExportMeshes = false
global Override = true
global PhysxExport = false
global PathToCopy
global RelativePathToCopy

-- XMLStrings

global XMLVersion		= "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n"
global XMLCloseTag		= "/>\n"
global XMLEndTag		= ">\n"
global XMLCarryRet		= "\n"
global XMLTab			= "\t"
global XML2Tab			= "\t\t"
global XMLName			= " name="
global XMLFilename		= " filename="
global XMLCore			= " core="
global XMLPos			= " pos="
global XMLYaw			= " yaw="
global XMLPitch			= " pitch="
global XMLRoll			= " roll="
global XMLScale			= " scale="
global XMLVisible		= " visible="
global XMLLookAt		= " lookat="
global XMLFov			= " fov="
global XMLNear_plane	= " near_plane="
global XMLFar_plane		= " far_plane="
global XMLFile			= " file="
global XMLTime			= " time="
global XMLOnce 			= " once="
global XMLCycle 		= " cycle="
global XMLReverse		= " reverse="
global XMLType			= " type="
global XMLDir 			= " dir="
global XMLColor 		= " color="
global XMLIntensity 	= " intensity="
global XMLAttStartRange	= " att_start_range="
global XMLAttEndRange	= " att_end_range="
global XMLAngle			= " angle="
global XMLFallOff		= " fall_off="
global XMLResource		= " resource="
global XMLRendManager	= " renderable_objects_manager="
global XMLDuration		= " duration="
global XMLTriggerName   = " trigger_name="
global XMLFromX			= " from_x="
global XMLFromZ			= " from_z="
global XMLBackPos		= " back_position="
global XMLForthPos		= " forth_position="
global XMLRedAxis		= " redim_axis="
global XMLRedScale		= " redim_scale="
global XMLActDist		= " activation_distance="
global XMLTimeOut		= " time_out="
global XMLInitCol 		= " initial_collision="
global XMLSpeed			= " speed="
global XMLRoom			= " room="
global XMLLightName		= " light="
global XMLGroup			= " group="
global XMLShape			= " shape="
global XMLPlatfName		= " platform_name="
global XMLPaint			= " paint="
global XMLMaxTime 		= " max_time="
global XMLTypeEvent 	= " type_event="
global XMLScriptFunc	= " script_function="
global XMLParam1		= " param1="
global XMLParam2		= " param2="

global XMLTypeEvent2 	= " type_event2="
global XMLScriptFunc2	 	= " script_function2="
global XMLParam1Event2	= " param1_event2="
global XMLParam2Event2	= " param2_event2="

global XMLTypeEvent3 	= " type_event3="
global XMLScriptFunc3		= " script_function3="
global XMLParam1Event3	= " param1_event3="
global XMLParam2Event3	= " param2_event3="

global XMLSize			= " size="
global XMLUpdateFun     = " update_function="
global XMLLayer			= " layer="
global XMLDefault 		= " default="
global XMLFinalPos		= " final_position="
global XMLDirection		= " direction="
global XMLRegister		= " register="
global XMLEvent			= " event="
global XMLPhisicSize	= " phisic_size="
global XMLGameObject	= " GameObject="
global XMLGenShadow		= " generate_shadow_map="
global XMLDynShadowType = " shadow_map_format_type="
global XMLOrthoWidth	= " ortho_shadow_map_width="
global XMLOrthoHeight   = " ortho_shadow_map_height="
global XMLShadowWidth	= " shadow_map_width="
global XMLShadowHeight  = " shadow_map_height="
global XMLStaticShadow  = " generate_static_shadowm_map="
global XMLStaShadowType = " static_shadowm_map_format_type="
global XMLDynamicIntensity = " dynamic_intensity="
global XMLCanRotate		= " can_rotate="
global XMLCanGoBack		= " can_go_back="
global XMLFollowY		= " follow_player_y="
global XMLID 			= " id="
global XMLEmitter		= " emitter="
global XMLEmitter2		= " emitter2="
global XMLEmitter3		= " emitter3="
global XMLEmitter4		= " emitter4="
global XMLBillboard		= " billboard="
global XMLEmitterOffset = " emitter_offset="
global XMLEmitter2Offset = " emitter2_offset="
global XMLEmitter3Offset = " emitter3_offset="
global XMLEmitter4Offset = " emitter4_offset="
global XMLBillboardOffset = " billboard_offset="
global XMLUsePhisicMesh	= " use_phisics_mesh="
global XMLSide			= " side="
global XMLSpeedOpening 	= " speed_opening="
global XMLSpeedClosing  = " speed_closing="
global XML1Value      	= "\"%\""
global XML3Value		= "\"% % %\""


-- Properties values
global RenderLayers = #("solid", "skybox", "alpha_objects", "alpha_blend_objects", "particles", "phisics", "poly", "enabled_poly", "collectible", "enemies", "player", "puzzle", "mov_platforms", "invisible", "breakable", "glow")
global MeshType = #("mesh_instance", "animated_model", "platform_mesh", "trigger", "switch_instance", "door", "wall_trap_mesh")
global PhysicsType = #("triangle_mesh", "convex_shape", "box_shape", "plane_shape", "capsule_shape")
global PhysicsLayer = #("logic")
global logicGenerate = #("box_event", "sphere_event")
global EventList = #("event1")
global RenderPlatform=#("static","breakable","moving","pinchos","poly")
global RedimAxis=#("x","y","z")
global EventTypeL = #("enter", "stay", "leave")
global EventTypeL2 = #("","enter", "stay", "leave")
global GroupsList = #("1", "2", "3", "18")
global TriggerShapeL = #("box", "sphere")
global ImageType = #("R32F", "A8R8G8B8", "R8G8B8", "X8R8G8B8")
global RoomList = #("0", "1", "2", "3", "4", "5", "6", "7", "8","9","10","11")
global SideListText=#("left", "right", "up", "down")

-- Vertex declaration
global VERTEX_XYZ 		= 0x1
global VERTEX_NORMAL 	= 0x2
global VERTEX_TANGENT 	= 0x4
global VERTEX_BINORMAL 	= 0x8
global VERTEX_TEXTURE1 	= 0x10
global VERTEX_TEXTURE2 	= 0x20
global VERTEX_DIFFUSE 	= 0x40
global VERTEX_CUBEMAP 	= 0x200
global VERTEX_RNM 		= 0x400

-- ExportMesh Variables
global MeshPath
global TexturePath
global RelativeMeshPath
global RelativeTexturePath