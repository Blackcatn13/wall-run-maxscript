global lights_open_file_tag			= "<lights>\n"
global lights_close_file_tag		= "</lights>\n"
global light_tag 					= "\t<light"
global light_close_tag 				= "\t</light>\n"
global dynamic_tag					= "\t\t<dynamic"

global light_file

function ExportShadowProperties _light =
(
	local DynShadow = (GetUserProp _light "ShadowMap")
	local DynType = (GetUserProp _light "dynImageType")
	local orthoWidth = (GetUserProp _light "orthoWidth")
	local orthoHeight = (GetUserProp _light "orthoHeight")
	local mapWidth = (GetUserProp _light "mapWidth")
	local mapHeight = (GetUserProp _light "mapHeight")
	local staticShadow = (GetUserProp _light "staticShadow")
	local StaticType = (GetUserProp _light "staImageType")
	local renderables = (GetUserProp _light "rednerablesList")

	format (XMLGenShadow + XML1Value + XMLDynShadowType + XML1Value) DynShadow DynType to:light_file
	format (XMLOrthoWidth + XML1Value + XMLOrthoHeight + XML1Value) orthoWidth orthoHeight to:light_file
	format (XMLShadowWidth + XML1Value + XMLShadowHeight + XML1Value) mapWidth mapHeight to:light_file
	format (XMLStaticShadow + XML1Value + XMLStaShadowType + XML1Value + XMLEndTag) staticShadow StaticType to:light_file
	for word in (filterString renderables ",") do
	(
		format (dynamic_tag + XMLRendManager + XML1Value + XMLCloseTag) word to:light_file
	)
	format (light_close_tag) to:light_file
) 

function ExportDirectional _light =
(
	if debug then
		format "[ExportDirectional] starting export of directional light\n"
	local pos = RHTranslationToLH(_light.pos)
	local dir = RHTranslationToLH(_light.target.pos - _light.pos)
	local col = _light.rgb / 255
	local inten = _light.multiplier
	local start = _light.farAttenStart
	local end = _light.farAttenEnd
	format (light_tag + XMLName + XML1Value + XMLType + XML1Value) _light.name "directional" to:light_file
	format (XMLPos + XML3Value + XMLDir + XML3Value) pos.x pos.y pos.z dir.x dir.y dir.z to:light_file
	format (XMLColor + XML3Value + XMLIntensity + XML1Value) col.r col.g col.b inten to:light_file
	format (XMLAttStartRange + XML1Value + XMLAttEndRange + XML1Value) start end to:light_file
	if (GetUserProp _light "ShadowMap") == true then (
		ExportShadowProperties _light
	) else (
		format (XMLCloseTag) to:light_file
	)
	if debug then
		format "[ExportDirectional] directional light exported\n"
)	

function ExportSpot _light =
(
	if debug then
		format "[ExportSpot] starting export of Spot\n"
	local pos = RHTranslationToLH(_light.pos)
	local dir = RHTranslationToLH(_light.target.pos - _light.pos)
	local col = _light.rgb / 255 
	local inten = _light.multiplier
	local start = _light.farAttenStart
	local end = _light.farAttenEnd
	format (light_tag + XMLName + XML1Value + XMLType + XML1Value) _light.name "spot" to:light_file
	format (XMLPos + XML3Value + XMLDir + XML3Value) pos.x pos.y pos.z dir.x dir.y dir.z to:light_file
	format (XMLColor + XML3Value + XMLIntensity + XML1Value) col.r col.g col.b inten to:light_file
	format (XMLAngle + XML1Value + XMLFallOff + XML1Value) _light.hotspot _light.falloff to:light_file
	format (XMLAttStartRange + XML1Value + XMLAttEndRange + XML1Value) start end to:light_file
	if (GetUserProp _light "ShadowMap") == true then (
		ExportShadowProperties _light
	) else (
		format (XMLCloseTag) to:light_file
	)
	if debug then
		format "[ExportSpot] spot light exported\n"
)	

function ExportOmniLight obj =
(
	if debug then
		format "[ExportOmniLight] starting export of omni light\n"
	local namel = obj.name
	local type = "omni"
	local pos = RHTranslationToLH obj.pos
	local colorl = obj.rgb / 255
	local intensity = obj.multiplier
	local startatt = obj.farAttenStart
	local endatt = obj.farAttenEnd
	format (light_tag + XMLName + XML1Value + XMLType + XML1Value) namel type to:light_file
	format (XMLPos + XML3Value + XMLColor + XML3Value) pos.x pos.y pos.z colorl.r colorl.g colorl.b to:light_file 
	format (XMLIntensity + XML1Value + XMLAttStartRange + XML1Value) intensity startatt to:light_file
	format (XMLAttEndRange + XML1Value) endatt to:light_file
	if (GetUserProp _light "ShadowMap") == true then (
		ExportShadowProperties _light
	) else (
		format (XMLCloseTag) to:light_file
	)
	if debug then
		format "[ExportOmniLight] omni light exported\n"
)

function exportLights lightsList=
(
	if debug then
		format "[exportLights] starting export of lights\n"
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
	if debug then
		format "lights list %\n" _lights
	if _lights.count >= 1 then (
		if debug then
			format "[exportLights] exporting % ligths\n" _lights.count

		CreatePath PathToCopy

		light_file = createfile (PathToCopy + LightsFileName)

		format (XMLVersion) to:light_file
		format (lights_open_file_tag) to:light_file
		
		for i=1 to _lights.count do (
			if (findString ((classof _lights[i]) as string) "light") != undefined or (findString ((classof _lights[i]) as string) "spot") != undefined then (
				if (GetUserProp _lights[i] "lights") == true then (
					if (classof _lights[i] == Omnilight) then (
						ExportOmniLight _lights[i]
					)
					if (classof _lights[i] == targetspot) then (
						ExportSpot _lights[i]
					)
					if (classof _lights[i] == TargetDirectionallight) then (
						ExportDirectional _lights[i]
					)
				)
			)
		)
		format (lights_close_file_tag) to:light_file
		close light_file
	)
)
