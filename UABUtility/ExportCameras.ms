global camera_open_file_tag			= "<cameras>\n"
global camera_close_file_tag		= "</cameras>\n"
global camera_fixed 				= "\t<fixed_camera"
global camera_key_controller		= "\t<key_camera_controller"
global camera_key 					= "\t<key"
global camera_open_key_controller 	= "<camera_key_controller"
global camera_close_key_controller	= "</camera_key_controller>\n"

global cam_file
global cam_to_export

function exportStaticCamera cam =
(
	if debug then
		format "[exportStaticCamera] starting export of static camera\n"
	local pos = RHTranslationToLH cam.pos
	local targetDist
	if cam.type == #free then (
		targetDist = cam.baseObject.TargetDistance
	) else (
		targetDist = cam.TargetDistance
	)
	local _lookat = RHTranslationToLH (pos - cam.dir * targetDist)
	local fov = DegToRad cam.fov
	format (camera_fixed + XMLName + XML1Value) cam.name to:cam_file
	format (XMLPos + XML3Value + XMLLookAt + XML3Value) pos.x pos.y pos.z _lookat.x _lookat.y _lookat.z to:cam_file
	format (XMLFov + XML1Value + XMLNear_plane + XML1Value + XMLFar_plane + XML1Value + XMLCloseTag) fov cam.nearClip cam.farClip to:cam_file
	if debug then
		format "[exportStaticCamera] camera exported\n"
)

function exportCameraKeyFrames cam fileNameWithPath =
(
	select cam
	if debug then
		format "[exportCameraKeyFrames] starting export of animated camera\n"
	local file = createfile (fileNameWithPath)
	format (XMLVersion) to:file
	format (camera_open_key_controller + XMLName + XML1Value ) cam.name to:file
	if (getUserProp cam "cam_once") == true then
		local once = true
	else 
		local once = false
	if (getUserProp cam "cam_cycle") == true then
		local cycle = true
	else 
		local cycle = false
	if (getUserProp cam "cam_reverse") == true then
		local _reverse = true
	else 
		local _reverse = false
	format (XMLOnce + XML1Value + XMLCycle + XML1Value + XMLReverse + XML1Value + XMLEndTag) once cycle _reverse to:file
	local animStart = animationRange.start
	local animStop = animationRange.end
	local fr = frameRate
	local key = (at time animStop trackbar.getNextKeyTime()).frame
	if debug then (
		format "[exportCameraKeyFrames] range of animation % - %\n" animStart animStop
		format "[exportCameraKeyFrames] frameRate of animation = %\n" fr
		format "[exportCameraKeyFrames] first key to export %\n" key
	)
	do (
		if debug then
			format "[exportCameraKeyFrames] exporting key %\n" key
		_time = key / fr
		pos = at time key cam.pos
		dir = at time key cam.dir
		if cam.type == #free then (
			targetDist = at time key cam.baseObject.TargetDistance
			_lookat = RHTranslationToLH (pos - dir * targetDist)
		) else (
			targetDist = at time key cam.TargetDistance
			_lookat = at time key RHTranslationToLH(cam.Target.pos)
		)
		--_lookat = RHTranslationToLH (pos - dir * targetDist)
		pos = RHTranslationToLH(pos)
		fov = DegToRad (at time key cam.fov)
		near = at time key cam.nearClip
		far = at time key cam.farclip
		format (camera_key + XMLTime + XML1Value) _time to:file
		format (XMLPos + XML3Value + XMLLookAt + XML3Value) pos.x pos.y pos.z _lookat.x _lookat.y _lookat.z to:file
		format (XMLFov + XML1Value + XMLNear_plane + XML1Value + XMLFar_plane + XML1Value + XMLCloseTag) fov near far to:file
		key = (at time key trackbar.getNextKeyTime()).frame
    ) while key > animStart
    format (camera_close_key_controller) to:file
	close file
	if debug then
		format "[exportCameraKeyFrames] export keys ended\n"
)

function exportAnimatedCamera cam= 
(
	if debug then
		format "[exportAnimatedCamera] starting export of animated camera\n"

	CreatePath (PathToCopy + AnimatedCamerasPath)
	
	local pathaux = GetMeshesPathExport (RelativePathToCopy + AnimatedCamerasPath) PathToCopy
	local camXML = pathaux + cam.name + ".xml"
	local camAbsXML = PathToCopy + AnimatedCamerasPath + cam.name + ".xml"

	format (camera_key_controller + XMLName + XML1Value + XMLFile + XML1Value + XMLCloseTag) cam.name camXML to:cam_file
	if debug then
		format "[exportAnimatedCamera] starting export of keys\n"
	exportCameraKeyFrames cam camAbsXML
	if debug then
		format "[exportAnimatedCamera] camera exported\n"
)

function exportCameras cameraList=
(
	if debug then
		format "[exportCameras] starting export of cameras\n"
	if cameraList == undefined then (
		cam_to_export = cameras as array
	) else ( 
		if classof cameraList == ObjectSet then (
			cam_to_export = cameraList
		) else (
			cam_to_export = #(cameraList)
		)
	)
	if cam_to_export.count >= 1 then (
		if debug then
			format "[exportCameras] exporting % cameras\n" cam_to_export.count

		CreatePath PathToCopy
		
		cam_file = createfile (PathToCopy + CamerasFileName)

		format (XMLVersion) to:cam_file
		format (camera_open_file_tag) to:cam_file

		for i=1 to cam_to_export.count do (
			if (findString ((classof cam_to_export[i]) as string) "camera") != undefined then (
				if cam_to_export[i].pos.isAnimated == true then (
					if debug then
						format "[exportCameras] exporting animated camera\n"
					exportAnimatedCamera cam_to_export[i]
				) else (
					if debug then
						format "[exportCameras] exporting static camera\n"
					exportStaticCamera cam_to_export[i] 
				)
			)
		)
		format (camera_close_file_tag) to:cam_file
		close cam_file
	)
)

