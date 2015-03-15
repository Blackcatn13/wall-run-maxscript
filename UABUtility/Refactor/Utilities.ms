global scene_geometry
global scene_geometry_toExport
global scene_cores

function GetObjectCores Obj =
(
	local start = timeStamp()
	local list = dotnetobject "System.Collections.Generic.List`1[System.String]"
	local cores=#()
	ss = Obj as array
	for i = 1 to ss.count do (
		InstanceMgr.GetInstances ss[i] &instances
		local isCore = true
		for j = 1 to instances.count do (
			if list.Contains instances[j].name then (
				isCore = false
			)
		)
		if isCore then (
			list.Add ss[i].name
			appendifUnique cores ss[i]
		)
	)
	local end = timeStamp()
	if debug then
		format "[GetObjectCores] time to calculate cores is %\n" (end - start)
	return cores
)

function getGeometryandCores =
(
	scene_geometry = geometry as Array
	scene_geometry_toExport = #()
	for i = 1 to scene_geometry.count do
	(
		if (GetUserProp scene_geometry[i] "export") == true then (
			appendifUnique scene_geometry_toExport scene_geometry[i]
		)
	)
	scene_cores = GetObjectCores scene_geometry_toExport
)

function GetObjectCore obj =
(
	pos = findItem scene_cores obj 
	if pos != 0 then (
		return (obj.name)
	) else (
		InstanceMgr.GetInstances obj &instances
		for i = 1 to instances.count do (
			pos = findItem scene_cores instances[i]
			if pos != 0	then (
				return (scene_cores[pos].name)
			)
		)
	)
)

function CreatePath path =
(
	if doesFileExist (path) == false then 
	(
		makeDir (path) all:true
		if debug then
			format "[ExportMesh] directorio % creado \n" path
	)
)