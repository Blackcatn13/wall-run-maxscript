fileIn "Common.ms"

function CopyTextures FilePath Objs =
(
	local l_MaterialArray = #()
	local L_Path =  FilePath+"textures/"
	--Explorador de directorio de destino
	/*	FilePath=getSavePath caption:"Select Data Folder" initialDir:FilePath
		format "Path updated to: \"%\" \n" FilePath*/
	if doesFileExist L_Path == false then (
		makeDir L_Path all:true
		if UABUtility.debug then
			format "[CopyTextures] directorio % creado \n" L_Path
	)
	--)
	if FilePath!=undefined then (		
		--local out_name=GetSaveFileName filename:(GetMeshesPathExport L_Path/*()*/+$.name+".mesh") caption:"Select output file to export file" types:" mesh(*.mesh)|*.mesh|All Files(*.*)|*.*|"
		local TexturesArray = GetTextures Objs
		for i=1 to TexturesArray.count do (
			format "[CopyTextures] % \n" TexturesArray[i]
			if TexturesArray[i]!=undefined then (
				for matArray = 1 to l_MaterialArray.count do
				(
					if l_MaterialArray[matArray] == i then
					(	
						FileName = filenameFromPath TexturesArray[i]
						FilePathName = L_Path + FileName
						if UABUtility.debug then
							format "[CopyTextures] Copy file Name: \"%\" \n" FilePathName
						if doesFileExist FilePathName and false then (
							if (queryBox "File already exists in destination folder. Override?" title: "File alreay exists" true) == true then (
								deleteFile FilePathName
								copyFile TexturesArray[i] FilePathName
							)
						) else (
							copyFile TexturesArray[i] FilePathName
						)
					)
				) 
			)
		)
	)
)

function ExportStaticMeshManager objs FilePath AbsPath copyTexts expMesh=
(
	if objs == undefined then (
		messageBox "No hi ha res seleccionat, no es pot exportar." title:"NO SELECTION"
	) else (
		if doesFileExist FilePath == false then (
			makeDir FilePath all:true
			if UABUtility.debug then
				format "[ExportStaticMeshManager] directorio % creado \n" FilePath
		)
		local file=createfile (FilePath + "static_meshes.xml")
		
		-- Para escribir sobre el fichero de tipo carácter stream utilizando la función format
		format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
		format "<static_meshes>\n" to:file
		if (classof objs)==ObjectSet then
		(
			local arrayCores = GetObjectCores objs
			for i = 1 to arrayCores.count do
			(
				local pathaux = GetMeshesPathExport FilePath AbsPath
				MeshFile = pathaux + "meshes//" + arrayCores[i].name + ".mesh"
				format "\t<static_mesh name=\"%\" filename=\"%\"/>\n" arrayCores[i].name MeshFile to:file
				if (expMesh and copyTexts) then (
					ExportMesh arrayCores[i]  FilePath (arrayCores[i].name + ".mesh") realPath true
				) else (
					if expMesh then (
						ExportMesh arrayCores[i]  FilePath (arrayCores[i].name + ".mesh") realPath false
					)
					if copyTexts then (
						CopyTextures FilePath arrayCores[i]
					)
				)
			)
		) else (
			local pathaux = GetMeshesPathExport FilePath AbsPath
			MeshFile = pathaux + "meshes//" + objs.name + ".mesh"
			format "\t<static_mesh name=\"%\" filename=\"%\"/>\n" objs.name MeshFile to:file
			if (expMesh and copyTexts) then (
				ExportMesh objs  FilePath ($.name + ".mesh") realPath true
			) else (
				if expMesh then (
					ExportMesh objs  FilePath ($.name + ".mesh") realPath false
				)
				if copyTexts then (
					if UABUtility.debug then (
						format "[ExportStaticMeshManager] FilePath is %\n" FilePath
						format "[ExportStaticMeshManager] Object is %\n" objs
					)
					CopyTextures FilePath objs
				)
			)
		)
		format "</static_meshes>\n" to:file
		-- Para cerrar el fichero de tipo carácter stream
		close file
	)
	return true
)

function ExportStaticMesh FilePath realPath=
(
	if doesFileExist FilePath == false then (
		makeDir FilePath all:true
		if UABUtility.debug then
			format "[ExportStaticMesh] directorio % creado \n" FilePath
	)
	
	local file=createfile (FilePath + "renderable_objects.xml")
	-- Para escribir sobre el fichero de tipo carácter stream utilizando la función format
	format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
	format "<renderable_objects>\n" to:file
	local geom = geometry as array
	local cores = GetObjectCores geom
	for obj in Objects do (
		if UABUtility.debug then
			format "[ExportStaticMesh] Object %\n" obj
		if iskindof obj Editable_Mesh do (
			ExportRenderableObjects obj (GetObjectCore cores obj) FilePath realPath file
		)
	)
	
	format "</renderable_objects>\n" to:file
	-- Para cerrar el fichero de tipo carácter stream
	close file
	
	ExportStaticMeshManager geometry FilePath realPath true true
)

function ExportRenderableObjects Obj Core pathToCopy realPath File =
(
	local YawAngle=DegToRad (GetYaw Obj.transform)
	local PitchAngle=DegToRad (GetPitch Obj.transform)
	local RollAngle=DegToRad (GetRoll Obj.transform)
	local Translation=Obj.transform.translation
	local ObjScale=Obj.scale
	local tranX = formattedPrint Translation.x format:"f"
	local tranY = formattedPrint Translation.y format:"f"
	local tranZ = formattedPrint Translation.z format:"f"
	
	--ExportMesh Obj pathToCopy (Obj.name + ".mesh") realPath true
	--messageBox "mesh exportado"

	if (getUserProp Obj "export_type") == "animated_mesh" then (
		format "\t<animated_model name=\"%\" core=\"%\" " Obj.name (getUserProp Obj "anim_model") to:File
	) else (
		format "\t<mesh_instance name=\"%\" core=\"%\" " Obj.name Core to:File
	)
	format " pos=\"% % %\" yaw=\"%\" "  tranX tranZ tranY YawAngle to:File
	format " pitch=\"%\" roll=\"%\" scale=\"% % %\" />\n" PitchAngle RollAngle ObjScale.x ObjScale.z ObjScale.y to:File
)

function GetObjectCore cores obj = 
(
	pos = findItem cores obj 
	if pos != 0 then (
		return (obj.name)
	) else (
		InstanceMgr.GetInstances obj &instances
		for i = 1 to instances.count do (
			pos = findItem cores instances[i]
			if pos != 0	then (
				return (cores[pos].name)
			)
		)
	)
)

function GetObjectCores Objs = 
(
	local start = timeStamp()
	local list = dotnetobject "System.Collections.Generic.List`1[System.String]"
	local cores=#()
	ss = Objs as array
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
	format "[GetObjectCores] time to calculate cores is %\n" (end - start)
	return cores
)

function notInArray array1 array2 =
(
	local cores = deepcopy array1
	if UABUtility.debug then (
		format "[notInArray] array of cores contains %\n" cores
		format "[notInArray] instances to look for %\n" array2
		format "[notInArray] size of cores %\n" cores.count
	)
	if cores.count >= 1 then (
		pos = findItem array2 cores[1]
		if pos != 0 then (
			if UABUtility.debug then
				format "[notInArray] returning false\n"
			return false
		) else (
			if cores.count > 1 then (
				if UABUtility.debug then
					format "[notInArray] returning true and going to next element\n"
				return (true and notInArray (deleteItem cores 1) array2)
			) else (
				if UABUtility.debug then
					format "[notInArray] returning true\n"
				return true
			)
		)
	)
	if UABUtility.debug then
		format "[notInArray] returning true\n"
	return true
)


function GetTextures Objs =
(
	local arrayTextures = #()
	if(classof Objs)== ObjectSet then (
		for i=1 to Objs.count do (
			if Objs[i].material != undefined then (
				if classof(Objs.material) == Multimaterial then (
					for i = 1 to Objs.material.numsubs do (
						append arrayTextures  Objs.material[i].diffuseMap.bitmap.filename
					)
				) else (					
					append arrayTextures Objs.material.diffuseMap.bitmap.filename
				)
			)
		)
	) else (
		if classof(Objs.material) == Multimaterial then (
			for i = 1 to Objs.material.numsubs do (
				append arrayTextures  Objs.material[i].diffuseMap.bitmap.filename
			)
		) else (					
			append arrayTextures Objs.material.diffuseMap.bitmap.filename
		)
	)
	if UABUtility.debug then
		format "[GetTextures] Textures to copy %\n" arrayTextures
	return arrayTextures
)

/***Catch functions*************/
fn TryCloneObjects Obj =
(
	local ClonedObjects
		try
		(
			if((classof Obj)==ObjectSet or (classof Obj) == PathName) then
			(
				for i = 1 to Obj.count do
					getVert Obj[i] 1
			)
			else
				getVert Obj 1
		)
		catch
		(
			--errorStr = getCurrentException() 
			ClonedObjects = CloneObjects Obj
		)
		return ClonedObjects
		
)


fn CloneObjects Objs = 
(
	if UABUtility.debug then
		format "[CloneObjects] Selection % \n" Objs
	if Objs != undefined then
	(
	--Clonar objeto/s como Core o instance segun sea (Si no se especifica lo contrario se copia como sea)
		maxOps.cloneNodes (Objs) newNodes:&nnl #nodialog
		for i = 1 to nnl.count do
		(
			if(classof Objs) == ObjectSet or  (classof Objs) == PathName then
				nnl[i].name = uniqueName (Objs[i].name +"_MeshCopy_") numDigits:3
			else
				nnl[i].name = uniqueName (Objs.name +"_MeshCopy_") numDigits:3
			if UABUtility.debug then
				format "[CloneObjects] Object % created \n" nnl[i].name
			convertToMesh nnl[i]
		)
		
		if (classof Objs) != PathName then	
			Select nnl	
		
		return nnl
	)
	else
	(
		if UABUtility.debug then
			format "[CloneObjects] No selected Items \n"
	)
	
)

fn DeleteClonedObjects ObjArray =
(
	for i = 1 to ObjArray.count do
	(
		if UABUtility.debug then
			format "[DeleteClonedObjects] Eliminando % \n" ObjArray[i]
		delete ObjArray[i]	
	)
)
/****End Catch function ****/

--Función que genera un array de todos los materiales asignados a los objetos
function CreateMaterialArray Objs =
(
	local array=#()
	if(classof Objs)== ObjectSet then (
		for obj=1 to Objs.count do (
			for i=1 to (getNumFaces Objs[i]) do 
			(
				append array Objs[obj].material[(getFaceMatID Objs[obj] i)].diffuseMap.bitmap.filename
			)
		)
	)else
	(
		for i=1 to (getNumFaces Objs) do 
		(
			append array Objs.material[(getFaceMatID Objs i)].diffuseMap.bitmap.filename
		)
	)
	
	for i in array.count to 1 by -1 do
	(
		id = findItem array array[i]
		if (id != i) do deleteItem array i
	)
	return array
)

/*
--Exportar Animated Meshed creando su XML y .mesh
function ExportAnimMeshManager objs FilePath AbsPath copyTexts expMesh=
(
	if objs == undefined or objs.count == 0 then (
		messageBox "No hi ha res animat seleccionat, no es pot exportar." title:"NO SELECTION"
	) else (
		if doesFileExist FilePath == false then (
			makeDir FilePath all:true
			format "directorio % creado \n" FilePath
		)
		local file=createfile (FilePath + "animated_models.xml")
		
		-- Para escribir sobre el fichero de tipo carácter stream utilizando la función format
		format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
		format "<animated_models>\n" to:file
		if objs.count > 1 then
		(
			local arrayCores = GetObjectCores objs
			for i = 1 to arrayCores.count do
			(
				local pathaux = GetMeshesPathExport FilePath AbsPath
				MeshFile = pathaux + "meshes//" + arrayCores[i].name + ".mesh"
				format "\t<animated_model name=\"%\" filename=\"%\"/>\n" arrayCores[i].name MeshFile to:file
				if (expMesh and copyTexts) then (
					ExportMesh arrayCores[i]  FilePath (arrayCores[i].name + ".mesh") realPath true
				) else (
					if expMesh then (
						ExportMesh arrayCores[i]  FilePath (arrayCores[i].name + ".mesh") realPath false
					)
					if copyTexts then (
						CopyTextures FilePath arrayCores[i]
					)
				)
			)
		) else (
			local pathaux = GetMeshesPathExport FilePath AbsPath
			MeshFile = pathaux + "meshes//" + objs[1].name + ".mesh"
			format "\t<animated_model name=\"%\" filename=\"%\"/>\n" objs[1].name MeshFile to:file
			if (expMesh and copyTexts) then (
				ExportMesh objs[1]  FilePath (objs[1].name + ".mesh") realPath true
			) else (
				if expMesh then (
					ExportMesh objs[1]  FilePath (objs[1].name + ".mesh") realPath false
				)
				if copyTexts then (
					format "FilePath is %\n" FilePath
					format "Object is %\n" objs[1]
					CopyTextures FilePath objs[1]
				)
			)
		)
		format "</animated_models>\n" to:file
		-- Para cerrar el fichero de tipo carácter stream
		close file
	)
	return true
)
*/