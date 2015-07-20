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
	lilac = "\169160160255";
	purple = "\169240000240";
}

-- Server Settings
parse("sv_friendlyfire 0")
parse("mp_startmoney 3600")
parse("mp_infammo 1")
parse("mp_kevlar 1")
parse("mp_autoteambalance 1")
parse("mp_damagefactor  1.0")
parse("mp_turretdamage 14")
parse("mp_killteambuildings 1")
parse("mp_unbuildable \"Barricade,Barbed Wire,Wall I,Wall II,Wall III,Gate Field,Dispenser,Supply,Teleporter Exit,Teleporter Entrance\"")
parse("mp_unbuyable \"Tactical Shield,Kevlar,Kevlar+Helm,He,Flashbang,Smoke Grenade,Flare,Night Vision,M3,XM1014\"")
parse("mp_killbuildings 1")
parse("mp_deathdrop 4")