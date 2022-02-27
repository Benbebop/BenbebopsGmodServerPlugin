-- stole this code from some legit aimbot so i dont feel too bad about it, also it sucked so i had to clean it
	
local util = util
local player = player
local input = input
local bit = bit
local hook = hook
local aimtarget
local MASK_SHOT = MASK_SHOT

local function GetPos( v )
	local eyes = v:LookupAttachment("eyes")
	return(eyes && v:GetAttachment(eyes).Pos || v:LocalToWorld(v:OBBCenter()))
end
	 
local function Valid( ply, v )
	if(!v || !v:IsValid() || v:Health() < 1 || v:IsDormant() || v == ply) then return false end
	local trace = {
		mask = MASK_SHOT,
		endpos = GetPos(v),
		start = ply:EyePos(),
		filter = {ply, v},
	}
	return(util.TraceLine(trace).Fraction == 1)
end

local function GetTarget( ply )
	if (Valid( ply, aimtarget)) then return end
	aimtarget = nil
	local allplys = player.GetAll()
	for i = 1, #allplys do
		local v = allplys[i]
		if (!Valid( ply, v)) then continue end
		aimtarget = v
		return
	end
end

function fuckemup( ply, ucmd )
	GetTarget()
	if (enabled && aimtarget) then
		local pos = (GetPos(aimtarget) - ply:EyePos()):Angle()
		ucmd:SetViewAngles(pos)
	end
end

return fuckemup

--hook.Add("CreateMove", "", function(ucmd)
--	GetTarget()
--	if (input.IsKeyDown(KEY_LALT) && aimtarget) then
--		local pos = (GetPos(aimtarget) - me:EyePos()):Angle()
--		ucmd:SetViewAngles(pos)
--		--ucmd:SetButtons(bit.bor(ucmd:GetButtons(), 1))
--		-- ^autofire
--	end
--end)
