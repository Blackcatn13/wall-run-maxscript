fileIn "Common.ms"

function exportLights _path absPath lightsList=
(
	if UABUtility.debug then
		format "[exportLights] starting export of lights\n"
	local file
	local _lights
	format "lights list %\n" lightsList
	if lightsList == undefined then (
		_lights = lights as array
	) else ( 
		if classof lightsList == ObjectSet then (
			_lights = lightsList as array
		) else (
			_lights = #(lightsList)
		)
	)
	format "lights list %\n" _lights
	if _lights.count >= 1 then (
		if UABUtility.debug then
			format "[exportLights] exporting % ligths\n" _lights.count
		if doesFileExist _path == false then (
			makeDir _path all:true
			if UABUtility.debug then
				format "[exportLights] directorio % creado \n" _path
		)
		file = createfile (_path + "lights.xml")
		format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
		format "<lights>\n" to:file
		for i=1 to _lights.count do (
			if (findString ((classof _lights[i]) as string) "light") != undefined or (findString ((classof _lights[i]) as string) "spot") != undefined then (
				if (GetUserProp _lights[i] "lights") == true then (
					if (classof _lights[i] == Omnilight) then (
						ExportOmniLight _lights[i] file
					)
					if (classof _lights[i] == targetspot) then (
						ExportSpot _lights[i] file
					)
					if (classof _lights[i] == TargetDirectionallight) then (
						ExportDirectional _lights[i] file
					)
				)
			)
		)
		format "</lights>" to:file
		close file
	)
)

function ExportDirectional _light file =
(
	if UABUtility.debug then
		format "[ExportDirectional] starting export of directional light\n"
	local pos = RHTranslationToLH(_light.pos)
	local dir = RHTranslationToLH(_light.target.pos - _light.pos)
	local col = _light.rgb
	local inten = _light.multiplier
	local start = _light.farAttenStart
	local end = _light.farAttenEnd
	format "\t<light name=\"%\" type=\"%\" " _light.name "directional" to:file
	format "pos=\"% % %\" dir=\"% % %\" " pos.x pos.y pos.z dir.x dir.y dir.z to:file
	format "color=\"% % %\" intensity=\"%\" " col.r col.g col.b inten to:file
	format "att_start_range=\"%\" att_end_range=\"%\"/>\n" start end to:file
	if UABUtility.debug then
		format "[ExportDirectional] directional light exported\n"
)	

function ExportSpot _light file =
(
	if UABUtility.debug then
		format "[ExportSpot] starting export of Spot\n"
	local pos = RHTranslationToLH(_light.pos)
	local dir = RHTranslationToLH(_light.target.pos - _light.pos)
	local col = _light.rgb
	local inten = _light.multiplier
	local start = _light.farAttenStart
	local end = _light.farAttenEnd
	format "\t<light name=\"%\" type=\"%\" " _light.name "spot" to:file
	format "pos=\"% % %\" dir=\"% % %\" " pos.x pos.y pos.z dir.x dir.y dir.z to:file
	format "color=\"% % %\" intensity=\"%\" " col.r col.g col.b inten to:file
	format "angle=\"%\" fall_off=\"%\" " _light.hotspot _light.falloff to:file
	format "att_start_range=\"%\" att_end_range=\"%\"/>\n" start end to:file
	if UABUtility.debug then
		format "[ExportSpot] spot light exported\n"
)	

function ExportOmniLight obj file =
(
	if UABUtility.debug then
		format "[ExportOmniLight] starting export of omni light\n"
	local namel = obj.name
	local type = "omni"
	local pos = RHTranslationToLH obj.pos
	local colorl = obj.rgb
	local intensity = obj.multiplier
	local startatt = obj.farAttenStart
	local endatt = obj.farAttenEnd
	
	format "\t<light name=\"%\" type=\"%\" " namel type to:file
	format "pos=\"% % %\" color=\"% % %\" " pos.x pos.y pos.z colorl.r colorl.g colorl.b to:file 
	format "intensity=\"%\" att_start_range=\"%\" " intensity startatt to:file
	format "att_end_range=\"%\"/>\n" endatt to:file
	if UABUtility.debug then
		format "[ExportOmniLight] omni light exported\n"
)
