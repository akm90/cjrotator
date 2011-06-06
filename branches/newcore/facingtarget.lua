function Load()
	system.SetTimerCallback("MindScrewLocal",50)
	wow.PrintChat("\"Am I Behind? 1.2\" loaded", -1 )
end
function Unload()
    wow.PrintChat("\"Am I Behind? 1.2\" unloaded", -1 )
end
function Get3DDistance(x1, y1, z1, x2, y2, z2)
	d1 = x2 - x1 d1 = d1*d1
	d2 = y2 - y1 d2 = d2*d2
	d3 = z2 - z1 d3 = d3*d3
	return math.sqrt(d1+d2+d3)
end
function GetDistance(x1, y1, x2, y2)
     d1 = x2 - x1
     d1 = d1*d1
     d2 = y2 - y1
     d2 = d2*d2
     return math.sqrt(d1+d2)
end
function MindScrewLocal()
	local ax,ay,locationvalue;
 
	speciallocationvalue = nil
 
	if(tx==-1)then wow.DoString("AmIBehind=\"notarget\"")
	return
	end
 
	if target.type == 3 and target.target.type == 4 then
		ptdist,tttdist,pttdist = GetDistance(player.x,player.y,target.x,target.y),GetDistance(target.target.x,target.target.y,target.x,target.y),GetDistance(player.x,player.y,target.target.x,target.target.y)
		speciallocationvalue = (ptdist^2+tttdist^2-pttdist^2)/(2*ptdist*tttdist)
	end
 
	ax=player.x-target.x
	ay=player.y-target.y
 
	if not speciallocationvalue then 
		locationvalue=ax*math.cos(-target.rot)-ay*math.sin(-target.rot)
	else
		locationvalue=speciallocationvalue
	end
	
	locationvalueb=ax*math.cos(-player.rot)-ay*math.sin(-player.rot)
 
	if(locationvalue<0)then
		wow.DoString("AmIBehind=true")
	else
		wow.DoString("AmIBehind=false")
	end
	
	if(locationvalueb<0)then
		wow.DoString("AmIFacing=true")
	else
		wow.DoString("AmIFacing=false")
	end
	sptdist = Get3DDistance(player.x,player.y,player.z,target.x,target.y,target.z)
	wow.DoString("PlayerToTarget="..sptdist)
	
	spfdist = Get3DDistance(player.x,player.y,player.z,focus.x,focus.y,focus.z)
	wow.DoString("PlayerToFocus="..spfdist)
end