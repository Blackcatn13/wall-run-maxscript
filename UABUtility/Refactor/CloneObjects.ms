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
	if debug then
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
			if debug then
				format "[CloneObjects] Object % created \n" nnl[i].name
			convertToMesh nnl[i]
		)
		
		if (classof Objs) != PathName then	
			Select nnl	
		
		return nnl
	)
	else
	(
		if debug then
			format "[CloneObjects] No selected Items \n"
	)
	
)

fn DeleteClonedObjects ObjArray =
(
	for i = 1 to ObjArray.count do
	(
		if debug then
			format "[DeleteClonedObjects] Eliminando % \n" ObjArray[i]
		delete ObjArray[i]	
	)
)