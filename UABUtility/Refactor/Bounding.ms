fn BoundingBox Obj =
(
	local Xmin, Ymin, Zmin, Xmax, Ymax,Zmax

	for i = 1 to Obj.numVerts do 
	(
		-- Init variables para comparar
		if i == 1 then
		(
			Xmin = (getVert Obj i).x
			Ymin = (getVert Obj i).y
			Zmin = (getVert Obj i).z
			Xmax = (getVert Obj i).x
			Ymax = (getVert Obj i).y
			Zmax = (getVert Obj i).z	
		)
		else(
			-- Pillar x,y,z min
			if(getVert Obj i).x <= Xmin then
				Xmin = (getVert Obj i).x
			if (getVert Obj i).y <= Ymin then
				Ymin = (getVert Obj i).y
			if (getVert Obj i).z <= Zmin then
				Zmin = (getVert Obj i).z
			-- Pillar x,y,z max
			if (getVert Obj i).x >= Xmax then
				Xmax = (getVert Obj i).x
			if (getVert Obj i).y >= Ymax then
				Ymax = (getVert Obj i).y
			if (getVert Obj i).z >= Zmax then
				Zmax = (getVert Obj i).z
		)
	)

	return #(Xmin, Ymin, Zmin, Xmax, Ymax, Zmax)
)

fn BoundingSphere Obj =
(
	local BSCenter, XCenter, YCenter, ZCenter
	local BSRadius = 0
	local BBox = BoundingBox Obj
	
	XCenter = (BBox[4] + BBox[1])/2
	YCenter = (BBox[5] + BBox[2])/2
	ZCenter = (BBox[6] + BBox[3])/2
	
	BSCenter = [XCenter,YCenter,ZCenter]
	if UABUtility.debug then
		format "BScenter % \n" BSCenter
	
	for i = 1 to Obj.numVerts do 
	(
		RadiusDistance = sqrt((((getVert Obj i).x - BSCenter[1])^2) + (((getVert Obj i).y - BSCenter[2])^2) + (((getVert Obj i).z - BSCenter[3])^2))
		if RadiusDistance > BSRadius then
			BSRadius = RadiusDistance
	)
	if UABUtility.debug then
		format "BSRadius : % \n" BSRadius
	
	return #(BSCenter[1], BSCenter[2], BSCenter[3], BSRadius)
	
)