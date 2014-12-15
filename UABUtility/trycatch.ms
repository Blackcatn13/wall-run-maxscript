fileIn "UABFunctions.ms"

/**THIS IS A TEST MS**/
fn testTry Obj =
(
		try
		(
			format "Clase: % \n" (classof Obj)
			if((classof Obj)==ObjectSet) then
				getVert Obj[1] 1
			else
				getVert Obj 1
		)
		catch 
		(
			format "Errroooooooooor % \n" (getCurrentException())
				
			errorStr = getCurrentException() 
				
			TryCloneObjects Obj
				
--MeshCatchAction errorStr Obj (testTry $)
		/*	if (findString errorStr "Mesh operation on non-mesh") != undefined  then
			(
				--Clonar objeto/s como Core o instance segun sea (Si no se especifica lo contrario se copia como sea)
				maxOps.cloneNodes ($) cloneType:#instance newNodes:&nnl #nodialog
				for i = 1 to nnl.count do
				(
					if(classof $) == ObjectSet then
						nnl[i].name = ($[i].name +"_MeshCopy")
					else
						nnl[i].name = ($.name +"_MeshCopy")
					format "Object % created \n" nnl[i].name
					convertToMesh nnl[i]
					
				)
						
						
				Select nnl
				*/
				--Clonar
			/*	if (findString errorStr "Mesh operation on non-mesh") != undefined  then
				(
					ClonedObjects = CloneObjects Obj errorStr
					--Hacer lo que tenga que hacer
					testTry $
					--Eliminar clones
					DeleteClonedObjects ClonedObjects
				)
			/*for i = 1 to nnl.count do
			(
				delete nnl[i]	
			)*/
		)
	)
--)


/*fn MeshCatchAction StrError Obj _Function =
(
	if (findString StrError "Mesh operation on non-mesh") != undefined  then
	(
		--Clonar objeto/s como Core o instance segun sea (Si no se especifica lo contrario se copia como sea)
		maxOps.cloneNodes ($) cloneType:#instance newNodes:&nnl #nodialog
		for i = 1 to nnl.count do
		(
			nnl[i].name = ($.name +"_MeshCopy")
			format "Object % created \n" nnl[i].name
			convertToMesh nnl[i]
			
		)
			
			--Hacer lo que tenga que hacer
		Select nnl
		_Function
			
				--Eliminar clones
		/*	for i = 1 to nnl.count do
			(
				delete nnl[i]	
			)
			
	)
)*/
testTry $