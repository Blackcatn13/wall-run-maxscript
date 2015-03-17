-- UABUtility Variables
global debug = true
global levels=#("","level1","level2", "level3","level4", "level5", "main menu", "select player")
global realPath
global FileExtension = ".mesh"
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
global CopyTextures = true
global ExportMeshes = false
global Override = true
global PathToCopy
global RelativePathToCopy

-- XMLStrings

global XMLVersion		= "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n"
global XMLCloseTag		= "/>\n"
global XMLEndTag		= ">\n"
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
global XMLInitCol 		= " initial_collision="
global XMLSpeed			= " speed="
global XMLGroup			= " group="
global XMLShape			= " shape="
global XMLPlatfName		= " platform_name="
global XMLPaint			= " paint="
global XMLMaxTime 		= " max_time="
global XMLTypeEvent 	= " type_event="
global XMLScriptFunc	= " script_function="
global XMLParam1		= " param1="
global XMLSize			= " size="
global XMLUpdateFun     = " update_function="
global XML1Value      	= "\"%\""
global XML3Value		= "\"% % %\""


-- Properties values
global RenderLayers = #("solid", "skybox", "alpha_objects", "alpha_blend_objects", "particles")
global MeshType = #("mesh_instance", "animated_model", "platform_mesh", "trigger")
global PhysicsType = #("triangle_mesh", "convex_shape", "box_shape", "plane_shape", "capsule_shape")
global PhysicsLayer = #("logic")
global logicGenerate = #("box_event", "sphere_event")
global EventList = #("event1")
global RenderPlatform=#("static","breakable","moving","pinchos","poly")
global RedimAxis=#("x","y","z")
global EventTypeL = #("enter", "stay", "leave")
global GroupsList = #("1", "2", "3")
global TriggerShapeL = #("box", "sphere")

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