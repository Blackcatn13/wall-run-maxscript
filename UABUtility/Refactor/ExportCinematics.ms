global cinematic_open_file_tag 		= "<cinematic"
global cinematic_close_file_tag		= "</cinematic>\n"
global cinematic_object_open_tag	= "\t<cinematic_object"
global cinematic_object_close_tag	= "\t</cinematic_object>\n"
global co_key_frame_open_tag		= "\t\t<cinematic_object_key_frame"

global cinematic_file

function ExportAnimatedObject Obj =
(
	select Obj
	if debug then 
		format "[ExportAnimatedObject] starting export of animated object %\n" Obj.name
	local object_manager = "solid"
	format (cinematic_object_open_tag + XMLResource + XML1Value + XMLRendManager + XML1Value + XMLCloseTag) Obj.name object_manager to:cinematic_file

	local animStart = animationRange.start
	local animStop = animationRange.end
	local fr = frameRate
	local key = (at time animStop trackbar.getNextKeyTime()).frame
	if debug then (
		format "[ExportAnimatedObject] range of animation % - %\n" animStart animStop
		format "[ExportAnimatedObject] frameRate of animation = %\n" fr
		format "[ExportAnimatedObject] first key to export %\n" key
	)
	do (
		if debug then 
			--format "[ExportAnimatedObject] exporting key %\n" key
		_time = key / fr
		local pos = at time key RHTranslationToLH(Obj.pos)
		local yaw = DegToRad (GetYaw (at time key Obj.transform))
		local pitch = DegToRad (GetPitch (at time key Obj.transform))
		local roll = DegToRad (GetRoll (at time key Obj.transform))
		local _scale = at time key RHTranslationToLH(Obj.scale)
		format (co_key_frame_open_tag + XMLTime + XML1Value) _time to:cinematic_file
		format (XMLPos + XML3Value + XMLYaw + XML1Value) pos.x pos.y pos.z yaw to:cinematic_file
		format (XMLPitch + XML1Value + XMLRoll + XML1Value + XMLScale + XML3Value + XMLCloseTag) pitch roll _scale.x _scale.y _scale.z to:cinematic_file

		key = (at time key trackbar.getNextKeyTime()).frame
	) while key > animStart
	format (cinematic_object_close_tag) to:cinematic_file
	if debug then
		format "[ExportAnimatedObject] exported % correctly\n" Obj.name
)

function ExportCinematics name =
(
	if debug then
		format "[ExportCinematics] starting export of cinematic with name %\n" cinematicName
	
	CreatePath PathToCopy


	cinematic_file = createfile (PathToCopy + CinematicFileName)
	format (XMLVersion) to:cinematic_file
	local frames = animationRange.end.frame - animationRange.start.frame + 1
	local duration = frames / frameRate
	format (cinematic_open_file_tag + XMLName + XML1Value + XMLDuration + XML1Value) cinematicName duration to:cinematic_file
	local objs = Geometry as array
	for i = 1 to objs.count do (
		if (GetUserProp objs[i] "cinematics") == true then (
			ExportAnimatedObject objs[i] cinematic_file
		)
	)
	format (cinematic_close_file_tag) to:cinematic_file
	close cinematic_file
)
