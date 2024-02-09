net.Receive( "cfm.discord_relay", function( len, ply )
  local data = net.ReadTable()

  chat.AddText( Color( 88, 101, 242 ), "[Discord] ", Color( 255, 255, 255 ), data[ "username" ], ": ", data[ "message" ] )
end )