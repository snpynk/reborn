--{{{ HEROES REBORN / VALUES
--{{{ READ info.lua

-- Player data table
pi = {}

-- Core Settings (Do not change unless you know what you're doing!)
reb.UPRATE = 4
reb.TICK = 0

-- Colors
reb.color = {
	pos = "\169000255000"; -- positive
	neg = "\169255000000"; -- negative
	neu = "\169255200000"; -- neutral
	black = "\169000000000";
	lilac = "\169160160255";
	purple = "\169240000240";
}

-- Server Settings
function reb.settings()
	parse("sv_friendlyfire 0")
	parse("mp_startmoney 3500")
	parse("mp_infammo 1")
	parse("mp_kevlar 1")
	parse("mp_autoteambalance 1")
	parse("mp_damagefactor  1.0")
	parse("mp_turretdamage 13")
	parse("mp_killteambuildings 1")
	parse("mp_unbuildable \"Barricade,Barbed Wire,Wall I,Wall II,Wall III,Gate Field,Dispenser,Supply,Teleporter Exit,Teleporter Entrance\"")
	parse("mp_killbuildings 1")
	parse("mp_deathdrop 4")
	parse("sv_checkusgnlogin 1")
	parse("sv_fow 0")
	parse("mp_buymenu 'Nothing'")

	if game("sv_gamemode") == 1 then
		parse("mp_randomspawn 1")
		parse("mp_radar 0")
	end
end