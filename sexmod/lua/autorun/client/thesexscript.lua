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
	LocalPlayer():PrintMessage( HUD_PRINTCENTER, net.ReadString() )
end )

net.Receive( "SexSoundClient", function()
	surface.PlaySound( net.ReadString() )
end )

end