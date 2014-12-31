fileIn "Common.ms"

function exportCameras _path absPath=
(
	format "[exportCameras] starting export of cameras\n"
	local file
	local cams = cameras as array
	if cams.count >= 1 then (
		format "[exportCameras] exporting % cameras\n" cams.count
		if doesFileExist _path == false then (
			makeDir _path all:true
			format "[exportCameras] directorio % creado \n" _path
		)
		file = createfile (_path + "cameras.xml")
		format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
		format "<cameras>\n" to:file
		for i=1 to cams.count do (
			if (findString ((classof cams[i]) as string) "camera") != undefined then (
				if cams[i].pos.isAnimated == true then (
					format "[exportCameras] exporting animated camera\n"
					exportAnimatedCamera cams[i] file _path absPath
				) else (
					format "[exportCameras] exporting static camera\n"
					exportStaticCamera cams[i] file 
				)
			)
		)
		format "</cameras>\n" to:file
		close file
	)
	-- per cada camera
		-- comprovar si es animada o no
			-- si no animada exportar tal qual <fixed_camera name, pos, lookat, near, far, fov/>
			-- si es animada
				-- <key_camera_controller name="cam" file="...cam.xml"/>
					-- generar el nou xml ...cam.xml amb la info de cada keyframe
						-- <camera_key_controller name="CameraMOV2">
							--<key time="0.0" pos="-26.8859 9.80159 -6.46455" look_at="-20.3781 3.19479
							-- 8.47801" fov="0.602417" near_plane="1.0" far_plane="1000.0"/>
)

function exportStaticCamera cam file =
(
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
	format "[exportStaticCamera] camera exported\n"
)

function exportAnimatedCamera cam file _path absPath= 
(
	format "[exportAnimatedCamera] starting export of animated camera\n"
	if doesFileExist (_path + "cameras//") == false then (
		makeDir (_path + "cameras//") all:true
		format "[exportAnimatedCamera] directorio % creado \n" _path
	)
	local pathaux = GetMeshesPathExport (_path + "cameras/") absPath
	local camXML = pathaux + cam.name + ".xml"
	local camAbsXML = _path + "cameras/" + cam.name + ".xml"
	format "\t<key_camera_controller name=\"%\" file=\"%\" />\n" cam.name camXML to:file
	format "[exportAnimatedCamera] starting export of keys\n"
	exportCameraKeyFrames cam camAbsXML
	format "[exportAnimatedCamera] camera exported\n"
)

function exportCameraKeyFrames cam fileNameWithPath =
(
	select cam
	format "[exportCameraKeyFrames] starting export of animated camera\n"
	local file = createfile (fileNameWithPath)
	format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
	format "<camera_key_controller name=\"%\">\n" cam.name to:file
	local animStart = animationRange.start
	local animStop = animationRange.end
	local fr = frameRate
	local key = (at time animStop trackbar.getNextKeyTime()).frame
	format "[exportCameraKeyFrames] range of animation % - %\n" animStart animStop
	format "[exportCameraKeyFrames] frameRate of animation = %\n" fr
	format "[exportCameraKeyFrames] first key to export %\n" key
	do (
		format "[exportCameraKeyFrames] exporting key %\n" key
		_time = key / fr
		pos = at time key RHTranslationToLH(cam.pos)
		dir = at time key cam.dir
		if cam.type == #free then (
			targetDist = at time key cam.baseObject.TargetDistance
		) else (
			targetDist = at time key cam.TargetDistance
		)
		_lookat = RHTranslationToLH (pos - dir * targetDist)
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
	format "[exportCameraKeyFrames] export keys ended\n"
)