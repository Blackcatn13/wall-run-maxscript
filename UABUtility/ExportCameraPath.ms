global cp_open_file_tag 	= "<camera_path>\n"
global cp_close_file_tag 	= "</camera_path>\n"
global cp_spline_open_tag 	= "\t<spline"
global cp_spline_close_tag 	= "\t</spline>\n"
global cp_point_tag			= "\t\t<point"

global cp_file

function comparenames str1 str2 = stricmp str1.name str2.name

function ExportCameraPath =
(
	scene_shapes = shapes as Array
	-- order array to export the lines by name
	qSort scene_shapes comparenames

	CreatePath PathToCopy

	cp_file = createfile (PathToCopy + CameraPathFileName)

	format (XMLVersion) to:cp_file
	format (cp_open_file_tag) to:cp_file
	for spl = 1 to scene_shapes.count do
	(
		for s = 1 to (numsplines scene_shapes[spl]) do
		(
			spl_name = "line_" + s as string
			format (cp_spline_open_tag + XMLName + XML1Value + XMLEndTag) spl_name to:cp_file
			local rotateSet = GetUserProp scene_shapes[spl] "rotate_track"
			local followSet = GetUserProp scene_shapes[spl] "follow_track"
			local backSet = getUserProp scene_shapes[spl] "back_track"
			for k = 1 to (numknots scene_shapes[spl] s) do 
			(
				pos = getKnotPoint scene_shapes[spl] s k
				pos_name = "p" + k as string
				format (cp_point_tag + XMLID + XML1Value + XMLPos + XML3Value) pos_name pos.x pos.z pos.y to:cp_file
				if rotateSet == true then
					format (XMLCanRotate + XML1Value) "true" to:cp_file
				end
				if followSet == true then
					format (XMLFollowY + XML1Value) "true" to:cp_file
				end
				if backSet == true then
					format (XMLCanGoBack + XML1Value) "true" to:cp_file
				end
				format (XMLCloseTag) to:cp_file
			)
			format (cp_spline_close_tag) to:cp_file
		)
	)
	format (cp_close_file_tag) to:cp_file
	close cp_file
)