--{{{ HEROES REBORN / UTILITIES
--{{{ READ info.lua

-- @utils
-- Table containing various useful functions such as wrappers, etc
utils = {
	-- ############################################################################################## Quick Quad Building

	-- @utils.build(owner_id, building_id, tile_x, tile_y, building_team)
	-- Spawns a building (Simple wrapper)
	-- TODO: Buildlimit system
	build = function(id, bid, x, y, team)
		if bid ~= 0 then
			if not entity(x, y, "exists") then parse(string.format("spawnobject %d %d %d 0 0 %d %d", bid, x, y, team, id))
			else msg2(id, reb.color.neg.."Don't build on entities!@C") end
		end
	end;

	-- @utils.quad(owner_id, size, base_building, [alternative building], [modifier], [escape])
	-- Build a quad of a specific building
	quad = function(id, size, Aid, Bid, mod, eq)
		local x, y, team, build, alg, Bid, mod, eq = player(id, "tilex"), player(id, "tiley"), player(id, "team"), utils.build, (size - 1) / 2, Bid or Aid, mod or 2, eq or 0
		for i = x - alg, x + alg do if ((i - (x - alg)) %mod==eq) then build(id, Aid, i, y - alg, team) else build(id, Bid, i, y - alg, team) end end
		for i = x - alg, x + alg do if ((i - (x - alg)) %mod==eq) then build(id, Aid, i, y + alg, team) else build(id, Bid, i, y + alg, team) end end
		for i = y - alg + 1, y + alg - 1 do if ((i - (y - alg)) %mod==eq) then build(id, Aid, x - alg, i, team) else build(id, Bid, x - alg, i, team) end end
		for i = y - alg + 1, y + alg - 1 do if ((i - (y - alg)) %mod==eq) then build(id, Aid, x + alg, i, team) else build(id, Bid, x + alg, i, team) end end
	end;
}