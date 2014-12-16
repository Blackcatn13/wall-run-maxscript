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


-- Dibujar la BB para probar
/*BoundingVertex = BoundingBox $
xp = BoundingVertex[1] - BoundingVertex[4]
yp = BoundingVertex[2] - BoundingVertex[5]
zp = BoundingVertex[3] - BoundingVertex[6]
mybox = box pos: [((BoundingVertex[4] + BoundingVertex[1] )/2),((BoundingVertex[2] + BoundingVertex[5] )/2),(BoundingVertex[6] )] length:yp width:xp height:zp xray:on
*/
fn BoundingSphere Obj =
(
	local BSCenter, XCenter, YCenter, ZCenter
	local BSRadius = 0
	local BBox = BoundingBox Obj
	
	XCenter = (BBox[4] + BBox[1])/2
	YCenter = (BBox[5] + BBox[2])/2
	ZCenter = (BBox[6] + BBox[3])/2
	
	BSCenter = [XCenter,YCenter,ZCenter]
	
	format "BScenter % \n" BSCenter
	
	for i = 1 to Obj.numVerts do 
	(
		RadiusDistance = sqrt((((getVert Obj i).x - BSCenter[1])^2) + (((getVert Obj i).y - BSCenter[2])^2) + (((getVert Obj i).z - BSCenter[3])^2))
		if RadiusDistance > BSRadius then
			BSRadius = RadiusDistance
	)
	format "BSRadius : % \n" BSRadius
	
	return #(BSCenter[1], BSCenter[2], BSCenter[3], BSRadius)
	
)

--Dibujar esfera para probar

/*BSphere = BoundingSphere $
mySphere = sphere radius:BSphere[4] position: [BSphere[1],BSphere[2],BSphere[3]] xray: on*/
