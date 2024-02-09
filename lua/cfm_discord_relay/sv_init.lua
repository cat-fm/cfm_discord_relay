util.AddNetworkString( "cfm.discord_relay" )

require( "gwsockets" )
if not GWSockets then return end

local avatars = {}

local function fetchAvatar( steamId64 )
  if avatars[ steamId64 ] then return avatars[ steamId64 ] end

  http.Fetch( "http://steamcommunity.com/profiles/" .. steamId64 .. "/?xml=1", function( body )
    local link = string.match( body, "https://avatars.akamai.steamstatic.com/.-jpg" )
    if not link then return end

    avatars[ steamId64 ] = string.Replace( link, ".jpg", "_full.jpg" )
  end )
end

local socket = GWSockets.createWebSocket( string.format( "ws://%s:%s", CFM.Discord.Host, CFM.Discord.Port ) )
socket:setHeader( "Authorization", CFM.Discord.Password )
socket:open()

function socket:onMessage( message )
  local data = util.JSONToTable( message )

  net.Start( "cfm.discord_relay" )
    net.WriteTable( data )
  net.Broadcast()
end

hook.Add( "PlayerAuthed", "cfm.discord_relay.create_cache", function( _, steamId64 )
  fetchAvatar( steamId64 )
end )

hook.Add( "PlayerDisconnected", "cfm.discord_relay.clear_cache", function( ply )
  avatars[ ply:SteamID64() ] = nil
end )

hook.Add( "PlayerSay", "cfm.discord_relay", function( ply, text )
  socket:write( util.TableToJSON( {
    avatar = avatars[ ply:SteamID64() ],
    username = ply:Name(),
    message = text
  } ) )
end )