fileIn "Common.ms"

function exportCameras _path absPath cameraList=
(
	if UABUtility.debug then
		format "[exportCameras] starting export of cameras\n"
	local file
	local cams
	if cameraList == undefined then (
		cams = cameras as array
	) else ( 
		cams = #(cameraList)
	)
	if cams.count >= 1 then (
		if UABUtility.debug then
			format "[exportCameras] exporting % cameras\n" cams.count
		if doesFileExist _path == false then (
			makeDir _path all:true
			if UABUtility.debug then
				format "[exportCameras] directorio % creado \n" _path
		)
		file = createfile (_path + "cameras.xml")
		format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
		format "<cameras>\n" to:file
		for i=1 to cams.count do (
			if (findString ((classof cams[i]) as string) "camera") != undefined then (
				if cams[i].pos.isAnimated == true then (
					if UABUtility.debug then
						format "[exportCameras] exporting animated camera\n"
					exportAnimatedCamera cams[i] file _path absPath
				) else (
					if UABUtility.debug then
						format "[exportCameras] exporting static camera\n"
					exportStaticCamera cams[i] file 
				)
			)
		)
		format "</cameras>" to:file
		close file
		
	)
)

function exportStaticCamera cam file =
(
	if UABUtility.debug then
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
	format "\t<fixed_camera name=\"%\" " cam.name to:file
	format " pos=\"% % %\" lookat=\"% % %\" " pos.x pos.y pos.z _lookat.x _lookat.y _lookat.z to:File
	format " fov=\"%\" near_plane=\"%\" far_plane=\"%\" />\n" fov cam.nearClip cam.farClip to:File
	if UABUtility.debug then
		format "[exportStaticCamera] camera exported\n"
)

function exportAnimatedCamera cam file _path absPath= 
(
	if UABUtility.debug then
		format "[exportAnimatedCamera] starting export of animated camera\n"
	if doesFileExist (_path + "cameras//") == false then (
		makeDir (_path + "cameras//") all:true
		if UABUtility.debug then
			format "[exportAnimatedCamera] directorio % creado \n" _path
	)
	local pathaux = GetMeshesPathExport (_path + "cameras/") absPath
	local camXML = pathaux + cam.name + ".xml"
	local camAbsXML = _path + "cameras/" + cam.name + ".xml"
	format "\t<key_camera_controller name=\"%\" file=\"%\" />\n" cam.name camXML to:file
	if UABUtility.debug then
		format "[exportAnimatedCamera] starting export of keys\n"
	exportCameraKeyFrames cam camAbsXML
	if UABUtility.debug then
		format "[exportAnimatedCamera] camera exported\n"
)

function exportCameraKeyFrames cam fileNameWithPath =
(
	select cam
	if UABUtility.debug then
		format "[exportCameraKeyFrames] starting export of animated camera\n"
	local file = createfile (fileNameWithPath)
	format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
	format "<camera_key_controller name=\"%\" " cam.name to:file
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
	
	format "once=\"%\" cycle=\"%\" reverse=\"%\">\n" once cycle _reverse to:file
	local animStart = animationRange.start
	local animStop = animationRange.end
	local fr = frameRate
	local key = (at time animStop trackbar.getNextKeyTime()).frame
	if UABUtility.debug then (
		format "[exportCameraKeyFrames] range of animation % - %\n" animStart animStop
		format "[exportCameraKeyFrames] frameRate of animation = %\n" fr
		format "[exportCameraKeyFrames] first key to export %\n" key
	)
	do (
		if UABUtility.debug then
			format "[exportCameraKeyFrames] exporting key %\n" key
		_time = key / fr
		pos = at time key RHTranslationToLH(cam.pos)
		dir = at time key cam.dir
		if cam.type == #free then (
			targetDist = at time key cam.baseObject.TargetDistance
			_lookat = RHTranslationToLH (pos - dir * targetDist)
		) else (
			targetDist = at time key cam.TargetDistance
			_lookat = at time key RHTranslationToLH(cam.Target.pos)
		)
		--_lookat = RHTranslationToLH (pos - dir * targetDist)
		fov = DegToRad (at time key cam.fov)
		near = at time key cam.nearClip
		far = at time key cam.farclip
		format "<key time=\"%\" " _time to:file
		format " pos=\"% % %\" lookat=\"% % %\" " pos.x pos.y pos.z _lookat.x _lookat.y _lookat.z to:file
		format " fov=\"%\" near_plane=\"%\" far_plane=\"%\" />\n" fov near far to:file	
		key = (at time key trackbar.getNextKeyTime()).frame
    ) while key > animStart
	format "</camera_key_controller>" to:file
	close file
	if UABUtility.debug then
		format "[exportCameraKeyFrames] export keys ended\n"
)