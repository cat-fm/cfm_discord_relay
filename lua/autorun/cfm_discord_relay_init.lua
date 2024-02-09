if SERVER then
  AddCSLuaFile( "cfm_discord_relay/cl_init.lua" )

  include( "cfm_discord_relay_config/config.lua" )
  include( "cfm_discord_relay/sv_init.lua" )
end

if CLIENT then
  include( "cfm_discord_relay/cl_init.lua" )
end