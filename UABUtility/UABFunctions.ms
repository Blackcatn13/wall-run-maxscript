function CopyTextures FilePath Objs =
(
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

function ExportStaticMeshManager FilePath AbsPath=
(
	if doesFileExist FilePath == false then (
		makeDir FilePath all:true
		format "directorio % creado \n" FilePath
	)
	local file
	try(
		 file=createfile (FilePath + "static_meshes.xml")
		
		-- Para escribir sobre el fichero de tipo carácter stream utilizando la función format
		format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
		format "<static_meshes>\n" to:file
		if (classof $)==ObjectSet then
		(
			local arrayCores = GetObjectCores $
			for i = 1 to arrayCores.count do
			(
				local pathaux = GetMeshesPathExport FilePath AbsPath
				MeshFile = pathaux + "meshes//" + arrayCores[i].name + ".mesh"
				format "\t<static_mesh name=\"%\" filename=\"%\"/>\n" arrayCores[i].name MeshFile to:file
			)
		)else
		(
			local pathaux = GetMeshesPathExport FilePath AbsPath
			MeshFile = pathaux + "meshes//" + $.name + ".mesh"
			format "\t<static_mesh name=\"%\" filename=\"%\"/>\n" $.name MeshFile to:file
		)
		format "</static_meshes>\n" to:file
		-- Para cerrar el fichero de tipo carácter stream
		close file
	)catch
	(
		close file
		errorStr = getCurrentException() 
		format "Exception in ExportStaticMeshManager: % \n" errorStr
		
	)
	return true
)

function ExportStaticMesh ExportMeshCheck FilePath Obj=
(
	if doesFileExist FilePath == false then (
		makeDir FilePath all:true
		format "directorio % creado \n" FilePath
	)
	local file
	try(
		file=createfile (FilePath + "renderable_objects.xml")
		-- Para escribir sobre el fichero de tipo carácter stream utilizando la función format
		format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
		format "<renderable_objects>\n" to:file
		
		if (classof Obj)==ObjectSet then
		(
			local arrayCores = GetObjectCores Obj
			for i = 1 to arrayCores.count do
			(
				ExportRenderableObjects ExportMeshCheck Obj[i] file (FilePath + "/Meshes")
			)
			
		)
		else
		(
			--TODO que pasa si solo hay un objeto seleccionado?
			ExportRenderableObjects ExportMeshCheck Obj file (FilePath + "/Meshes")
		)
		format "</renderable_objects>\n" to:file
		-- Para cerrar el fichero de tipo carácter stream
		close file
	)
	catch
	(
		close file
		errorStr = getCurrentException() 
		format "Exception in ExportStaticMesh: % \n" errorStr
		
	)
)

function ExportRenderableObjects ExportChecked Obj File MeshPath =
(
	local YawAngle=GetYaw Obj.transform
	local PitchAngle= GetPitch Obj.transform
	local RollAngle= GetRoll Obj.transform
	local Translation=Obj.transform.translation
	local ObjScale=Obj.scale
	if ExportChecked == true then
	(
		--Exportamos el .mesh
		if doesFileExist MeshPath == false then
		(
			makeDir MeshPath all:true
		)
		ExportMesh Obj (MeshPath +"\\"+Obj.name+".mesh")  
		messageBox "mesh exportado"
				
		format "\t<mesh_instance name=\"%\" core=\"%\" pos=\"%\" yaw=\"%\" pitch=\"%\" roll=\"%\" scale=\"%\" />\n" Obj.name "CoreObject" Translation YawAngle PitchAngle RollAngle ObjScale to:File
	)
	else
	(
		format "\t<mesh_instance name=\"%\" pos=\"%\" yaw=\"%\" pitch=\"%\" roll=\"%\" scale=\"%\" />\n"  Obj.name Translation YawAngle PitchAngle RollAngle ObjScale  to:File
	)	
	
)

function GetMeshesPathExport FilePath AbsPath =
(
	local newPath= pathConfig.convertPathToRelativeTo FilePath AbsPath
	format "test %\n" newPath
	return newPath
)

function GetObjectCores Objs = 
(
	local arrayCores = #()
	if (classof Objs)==ObjectSet then
	(
		for i = 1 to Objs.count do
		(
			format "bucle 1 \n"
			--local numInstances = InstanceMgr.GetInstances Objs[i] &instances
			-- Mirar si tiene más de una instancia. Si no la tiene se añade directamente
			if InstanceMgr.GetInstances Objs[i] &instances == 1 then
			(
				format "% Solo tiene una instancia \n" Objs[i]
				append arrayCores Objs[i]
			)else 
			(
			-- Recorrer arrayCores
				-- Si Obj[i] no es instancia de ninguno de los elementos del vector se añade si no existe ya
				addToArrayCores = true
				for arrayCoresIndex = 1 to arrayCores.count do
				(
					if (areNodesInstances Objs[i] arrayCores[arrayCoresIndex]) = true or (Objs[i].name == arrayCores[arrayCoresIndex].name) then
					(
						addToArrayCores = false
					)
				)
				-- Si se cumplen las condiciones se añade
				if addToArrayCores == true then
				(
					append arrayCores Objs[i]
				)
			
			)
		)
	)
	
	return arrayCores
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
			if((classof Obj)==ObjectSet) then
				getVert Obj[1] 1
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
		maxOps.cloneNodes (Objs) cloneType:#instance newNodes:&nnl #nodialog
		for i = 1 to nnl.count do
		(
			if(classof Objs) == ObjectSet then
				nnl[i].name = (Objs[i].name +"_MeshCopy")
			else
				nnl[i].name = (Objs.name +"_MeshCopy")
		format "Object % created \n" nnl[i].name
		convertToMesh nnl[i]
		)
		
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
		delete ObjArray[i]	
	)
)