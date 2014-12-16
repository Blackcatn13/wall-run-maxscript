function CopyTextures FilePath Objs =
(
	local l_MaterialArray = #()
	local L_Path =  FilePath+"textures/"
	--Explorador de directorio de destino
	/*	FilePath=getSavePath caption:"Select Data Folder" initialDir:FilePath
		format "Path updated to: \"%\" \n" FilePath*/
	if doesFileExist L_Path == false then (
		makeDir L_Path all:true
		format "directorio % creado \n" L_Path
	)
	--)
	if FilePath!=undefined then (		
		--local out_name=GetSaveFileName filename:(GetMeshesPathExport L_Path/*()*/+$.name+".mesh") caption:"Select output file to export file" types:" mesh(*.mesh)|*.mesh|All Files(*.*)|*.*|"
		local TexturesArray = GetTextures Objs
		for i=1 to TexturesArray.count do (
			format "% \n" TexturesArray[i]
			if TexturesArray[i]!=undefined then (
				for matArray = 1 to l_MaterialArray.count do
				(
					if l_MaterialArray[matArray] == i then
					(	
						FileName = filenameFromPath TexturesArray[i]
						FilePathName = L_Path + FileName
						format "Copy file Name: \"%\" \n" FilePathName
						if doesFileExist FilePathName then (
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
			format "directorio % creado \n" FilePath
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
					format "FilePath is %\n" FilePath
					format "Object is %\n" objs
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
		format "directorio % creado \n" FilePath
	)
	
	local file=createfile (FilePath + "renderable_objects.xml")
	-- Para escribir sobre el fichero de tipo carácter stream utilizando la función format
	format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
	format "<renderable_objects>\n" to:file
	local geom = geometry as array
	local cores = GetObjectCores geom
	for obj in Objects do (
		format "Object %\n" a
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
	local YawAngle=GetYaw Obj.transform
	local PitchAngle= GetPitch Obj.transform
	local RollAngle= GetRoll Obj.transform
	local Translation=Obj.transform.translation
	local ObjScale=Obj.scale
	
	--ExportMesh Obj pathToCopy (Obj.name + ".mesh") realPath true
	--messageBox "mesh exportado"

	format "\t<mesh_instance name=\"%\" core=\"%\" " Obj.name Core to:File
	format " pos=\"% % %\" yaw=\"%\" " Translation.x Translation.z Translation.y YawAngle to:File
	format " pitch=\"%\" roll=\"%\" scale=\"%\" />\n" PitchAngle RollAngle ObjScale.x to:File

)

--Exportar Animated Meshed creando su XML y .mesh
function ExportAnimMeshManager objs FilePath AbsPath copyTexts expMesh=
(
	if objs == undefined then (
		messageBox "No hi ha res seleccionat, no es pot exportar." title:"NO SELECTION"
	) else (
		if doesFileExist FilePath == false then (
			makeDir FilePath all:true
			format "directorio % creado \n" FilePath
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
					format "FilePath is %\n" FilePath
					format "Object is %\n" objs
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
		format "directorio % creado \n" FilePath
	)
	
	local file=createfile (FilePath + "renderable_objects.xml")
	-- Para escribir sobre el fichero de tipo carácter stream utilizando la función format
	format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
	format "<renderable_objects>\n" to:file
	local geom = geometry as array
	local cores = GetObjectCores geom
	for obj in Objects do (
		format "Object %\n" a
		if iskindof obj Editable_Mesh do (
			ExportRenderableObjects obj (GetObjectCore cores obj) FilePath realPath file
		)
	)
	
	format "</renderable_objects>\n" to:file
	-- Para cerrar el fichero de tipo carácter stream
	close file
	
	ExportStaticMeshManager geometry FilePath realPath true true
)

function GetMeshesPathExport FilePath AbsPath =
(
	local newPath= pathConfig.convertPathToRelativeTo FilePath AbsPath
	format "test %\n" newPath
	return newPath
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
	ss = Objs as array
	ss2 = Objs as array
	format "Objects in scene %\n" ss
	exclud = #()
	for i=1 to ss.count do (
		format "looking for item % in exclude: %\n" ss[i] exclud
		InstanceMgr.GetInstances ss[i] &instances
		format "Instances of % are %\n" ss[i] instances		
		if notInArray exclud instances then (
			appendIfUnique exclud ss[i]
		) else (
			format "\n% is an instance of a core\n" ss[i]
			continue
		)
	)
	format "\nfinal cores %\n" exclud
	return exclud
)

function notInArray array1 array2 =
(
	local cores = deepcopy array1
	format "array of cores contains %\n" cores
	format "instances to look for %\n" array2
	format "size of cores %\n" cores.count
	if cores.count >= 1 then (
		pos = findItem array2 cores[1]
		if pos != 0 then (
			format "returning false\n"
			return false
		) else (
			if cores.count > 1 then (
				format "returning true and going to next element\n"
				return (true and notInArray (deleteItem cores 1) array2)
			) else (
				format "returning true\n"
				return true
			)
		)
	)
	format "returning true\n"
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
	format "Textures to copy %\n" arrayTextures
	return arrayTextures
)

/*Funciones de transformada*/
function GetYaw transform =
(
	return (transform as eulerangles).z
)
function GetPitch transform =
(
	return (transform as eulerangles).x
)
function GetRoll transform =
(
	return (transform as eulerangles).y
)

function RHTranslationToLH translation =
(
	return point3 translation.x translation.z translation.y
)

function GetScale _scale =
(
	return point3 _scale.x _scale.z _scale.y
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
	format "Selection % \n" Objs
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
		format "Object % created \n" nnl[i].name
		convertToMesh nnl[i]
		)
		
		if (classof Objs) != PathName then	
			Select nnl	
		
		return nnl
	)
	else
	(
		format "No selected Items \n"
	)
	
)

fn DeleteClonedObjects ObjArray =
(
	for i = 1 to ObjArray.count do
	(
		format "Eliminando % \n" ObjArray[i]
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
