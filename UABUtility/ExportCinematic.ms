fileIn "Common.ms"

function ExportCinematics _path absPath cinematicName =
(
	if UABUtility.debug then
		format "[ExportCinematics] starting export of cinematic with name %\n" cinematicName
	local file
	if doesFileExist _path == false then (
			makeDir _path all:true
			if UABUtility.debug then
				format "[ExportCinematics] directorio % creado \n" _path
		)
		file = createfile (_path + "cinematic.xml")
		format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
		local frames = animationRange.end.frame - animationRange.start.frame + 1
		local duration = frames / frameRate
		format "<cinematic name=\"%\" duration=\"%\">\n" cinematicName duration to:file
		local objs = Geometry as array
		for i = 1 to objs.count do (
			if (GetUserProp objs[i] "cinematics") == true then (
				ExportAnimatedObject objs[i] file
			)
		)
		format "</cinematic>" to:file
		close file
)

function ExportAnimatedObject Obj file =
(
	select Obj
	if UABUtility.debug then 
		format "[ExportAnimatedObject] starting export of animated object %\n" Obj.name
	local object_manager = "solid"
	format "\t<cinemati_object resource=\"%\" renderable_objects_manager=\"%\">\n" Obj.name object_manager to:file
	local animStart = animationRange.start
	local animStop = animationRange.end
	local fr = frameRate
	local key = (at time animStop trackbar.getNextKeyTime()).frame
	if UABUtility.debug then (
		format "[ExportAnimatedObject] range of animation % - %\n" animStart animStop
		format "[ExportAnimatedObject] frameRate of animation = %\n" fr
		format "[ExportAnimatedObject] first key to export %\n" key
	)
	do (
		if UABUtility.debug then 
			--format "[ExportAnimatedObject] exporting key %\n" key
		_time = key / fr
		local pos = at time key RHTranslationToLH(Obj.pos)
		local yaw = DegToRad (GetYaw (at time key Obj.transform))
		local pitch = DegToRad (GetPitch (at time key Obj.transform))
		local roll = DegToRad (GetRoll (at time key Obj.transform))
		local _scale = at time key RHTranslationToLH(Obj.scale)
		format "\t\t<cinematic_object_key_frame time=\"%\" " _time to:file
		format "pos =\"% % %\ yaw=\"%\" " pos.x pos.y pos.z yaw to:file
		format "pitch=\"%\" roll=\"%\" scale=\"% % %\"/>\n" pitch roll _scale.x _scale.y _scale.z to:file
		key = (at time key trackbar.getNextKeyTime()).frame
	) while key > animStart
	format "\t</cinematic_object>\n" to:file
	if UABUtility.debug then
		format "[ExportAnimatedObject] exported % correctly\n" Obj.name
)