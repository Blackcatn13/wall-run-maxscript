fileIn "UABFunctions.ms"
fileIn "Common.ms"

/**THIS IS A TEST MS**/
fn testTry Obj =
(
	local ArrayObjects = #()
	/*	try
		(
		/*	format "Clase: % \n" (classof Obj)
			if((classof Obj)==ObjectSet or (classof Obj)==PathName ) then
				for i = 1 to Obj.count do
					getVert Obj[i] 1
			else
				getVert Obj 1*/
			ArrayObjects =	TryCloneObjects Obj
	/*	)
		catch 
		(
			--format "Errroooooooooor % \n" (getCurrentException())
				
			--errorStr = getCurrentException() 
				
		
				
				--Clonar
			/*	if (findString errorStr "Mesh operation on non-mesh") != undefined  then
				(
					ClonedObjects = CloneObjects Obj errorStr
					--Hacer lo que tenga que hacer
					testTry $
					--Eliminar clones
					DeleteClonedObjects ClonedObjects
				)
			*/
	--	)
		--Al acabar borrar
		if ArrayObjects != undefined and ArrayObjects.count >= 1 then
			DeleteClonedObjects ArrayObjects
	)

testTry $