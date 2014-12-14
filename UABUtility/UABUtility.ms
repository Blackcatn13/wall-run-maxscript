fileIn "setProperties.ms"
fileIn "UABFunctions.ms"
fileIn "ExportMesh.ms"
fileIn "BBoxBSphere.ms"

global realPath

utility UABUtility "UAB Utility" width:152 height:360
(
	
		-- Contenido de la utility
		button btnSetPath "Set Path" pos:[8,8] width:136 height:28
		label PathLabel pos:[8,40] width:136 height:76 readOnly:true
		checkbox ExportMeshCheck "Export Mesh" pos:[8,124] width:136 height:16
		checkbox CopyTexturesCheck "Copy Textures" pos:[8,148] width:136 height:16
		GroupBox grp1 "Export" pos:[8,196] width:136 height:120
		button ExportLightsButton "Lights" pos:[16,220] width:56 height:16
		button ExportMeshButton "Mesh" pos:[80,220] width:56 height:16
		button ExportCameraButton "Camera" pos:[16,244] width:56 height:16
		button ExportSceneButton "Scene" pos:[16,292] width:120 height:16
		button ExportStaticMeshManagerButton "Static Mesh Manager" pos:[16,268] width:120 height:16
		groupBox grp2 "Tools" pos:[8,324] width:136 height:48
		button btnSetProperties "Set Properties" pos:[16,348] width:120 height:16
		dropDownList LevelList "" pos:[8,172] width:136 height:21
		
		--Eventos de la utility
		
		--Esta función se llama al pulsarse sobre el btón ExportMeshButton
	
		on UABUtility open do
		(
			--PathLabel.text = "C:/Users/IBM_ADMIN/this_works?/Desktop/uabEngines/UABEngine_2_12/bin/Videogame/Data/auxi/testing/the_size_of_this_labels"--"Path: D://UABEngine/Data"
			--global ExportPath = PathLabel.text
			local levels=#("","level1","level2", "level3","level4", "main menu", "select player")
			LevelList.items=levels
		)
		
		on btnSetPath pressed do
		(
			-- TODO, si el filtered[idx].count > 22 peta
			local data_path = getSavePath caption:"Exe path" initialDir:"C:\\" 
			PathLabel.text = data_path
			realPath = data_path
			local filtered = filterString data_path "\\"
			local idx = 1
			local auxstring = ""
			PathLabel.text = auxstring
			while idx <= filtered.count do (
				
				if (filtered[idx].count + auxstring.count) <  22 then (
					auxstring = auxstring + filtered[idx] + "\\"
					idx = idx + 1
				) else (
					if filtered[idx].count > 22 then (
						auxstring = auxstring + filtered[idx] + "\\"
						idx = idx + 1
					)
					auxstring = auxstring + "\n"
					PathLabel.text = PathLabel.text + auxstring
					auxstring = ""
				)
			)
			if auxstring != "" then (
				PathLabel.text = PathLabel.text + auxstring
			)
		)
		on ExportMeshButton pressed do
		(
		--Implementad aquí el código de pulsado de este botón
			local pathToCopy = realPath + "\\Data\\" + LevelList.items[LevelList.selection] + "\\"
			--Si CopyTextures checked copia las texturas
			/*if CopyTexturesCheck.checked == true then
			(
				format "Copiamos \n"
				CopyTextures pathToCopy $
			)*/
			format "name is %\n" (pathToCopy + "meshes\\" + $.name + ".mesh")
			try
			(
				ExportMesh $  pathToCopy ($.name + ".mesh") realPath true
			)
			catch
			(
				errorStr = getCurrentException() 
				if (findString errorStr "Mesh operation on non-mesh") != undefined  then
				(
					ClonedObjects = CloneObjects $ errorStr
					--Hacer lo que tenga que hacer
					ExportMesh $  pathToCopy ($.name + ".mesh") realPath true
					--Eliminar clones
					DeleteClonedObjects ClonedObjects
				)
				else
					format "% \n" errorStr
			)
			--Si ExportMesh checked exportar el mesh
			/*if ExportMeshCheck.checked == true then
			(
				ExportStaticMesh true pathToCopy $
			)
			else 
			(
				-- Exportar solo transformación y posicion
				ExportStaticMesh false pathToCopy $
			)*/
		)
		on ExportStaticMeshManagerButton pressed do
		(
			local pathToCopy = realPath + "\\Data\\" + LevelList.items[LevelList.selection] + "\\"
			if (ExportMeshCheck.checked and CopyTexturesCheck.checked) then (
				try
				(
					ExportMesh $  pathToCopy ($.name + ".mesh") realPath true
					CopyTextures pathToCopy $
				)
				catch
				(
					errorStr = getCurrentException() 
					if (findString errorStr "Mesh operation on non-mesh") != undefined  then
					(
						ClonedObjects = CloneObjects $ errorStr
						--Hacer lo que tenga que hacer
						ExportMesh $  pathToCopy ($.name + ".mesh") realPath true
						CopyTextures pathToCopy $
						--Eliminar clones
						DeleteClonedObjects ClonedObjects
					)
					else
						format "% \n" errorStr
				)
			) else (
				if ExportMeshCheck.checked then 
				(
					try
					(
						ExportMesh $  pathToCopy ($.name + ".mesh") realPath false
					)
					catch
					(
						errorStr = getCurrentException() 
						if (findString errorStr "Mesh operation on non-mesh") != undefined  then
						(
							ClonedObjects = CloneObjects $ errorStr
							--Hacer lo que tenga que hacer
							ExportMesh $  pathToCopy ($.name + ".mesh") realPath false
							--Eliminar clones
							DeleteClonedObjects ClonedObjects
						)
						else
							format "% \n" errorStr
					)
				)
				if CopyTexturesCheck.checked then (
					try
					(
						CopyTextures pathToCopy $
					)
					catch
					(
						errorStr = getCurrentException() 
						if (findString errorStr "Mesh operation on non-mesh") != undefined  then
						(
							ClonedObjects = CloneObjects $ errorStr
							--Hacer lo que tenga que hacer
							CopyTextures pathToCopy $
							--Eliminar clones
							DeleteClonedObjects ClonedObjects
						)
						else
							format "% \n" errorStr						
					)
				)
			)

			format "pathToCopy %\n" pathToCopy
			try(
				ExportStaticMeshManager pathToCopy realPath
			)
			catch
			(
				errorStr = getCurrentException() 
				if (findString errorStr "Mesh operation on non-mesh") != undefined  then
				(
					ClonedObjects = CloneObjects $ errorStr
					--Hacer lo que tenga que hacer
					CopyTextures pathToCopy $
					--Eliminar clones
					DeleteClonedObjects ClonedObjects
				)	
				else
					format "% \n" errorStr
			)
			format "Static Mesh Manager Exportado \n"
		)
		
		on btnSetProperties pressed do
		(
			createDialog UABSetProperties
		)
)

	


