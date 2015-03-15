-- UABUtility Variables
global debug = true
global levels=#("","level1","level2", "level3","level4", "level5", "main menu", "select player")
global realPath
global FileExtension = ".mesh"
global DataDirectory = "\\Data\\"
global MeshDirectory = "meshes\\"
global TextureDirectory = "textures\\"
global staticMeshFileName = "static_meshes.xml"
global renderableObjectsFileName = "renderable_objects.xml"
global CopyTextures = true
global ExportMeshes = false
global Override = true
global PathToCopy

-- XMLStrings

global XMLVersion = "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n"
global XMLCloseTag = "/>\n"
global XMLName = " name="
global XMLFilename = " filename="
global XMLCore = " core="
global XMLPos = " pos="
global XMLYaw = " yaw="
global XMLPitch = " pitch="
global XMLRoll = " roll="
global XMLScale = " scale="
global XMLVisible = " visible="


-- Properties values
global RenderLayers = #("solid", "skybox", "alpha_objects", "alpha_blend_objects", "particles")
global MeshType = #("mesh_instance", "animated_model")
global PhysicsType = #("triangle_mesh", "convex_shape", "box_shape", "plane_shape", "capsule_shape")
global PhysicsLayer = #("logic")
global logicGenerate = #("box_event", "sphere_event")
global EventList = #("event1")

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