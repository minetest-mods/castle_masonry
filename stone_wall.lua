
local S = minetest.get_translator("castle_masonry")
local has_mcl = minetest.get_modpath("mcl_core")
local gravel = has_mcl and "mcl_core:gravel" or "default:gravel"
local desert_stone = has_mcl and "mcl_core:redsandstone" or "default:desert_stone"
local sandstone = has_mcl and "mcl_core:sandstone" or "default:sandstone"
local stonebrick = has_mcl and "mcl_core:stonebrick" or "default:stonebrick"
local obsidian = has_mcl and "mcl_core:obsidian" or "default:obsidian"
local cobble = has_mcl and "mcl_core:cobble" or "default:cobble"


minetest.register_alias("castle:stonewall",         "castle_masonry:stonewall")
minetest.register_alias("castle:dungeon_stone",     "castle_masonry:dungeon_stone")
minetest.register_alias("castle:rubble",            "castle_masonry:rubble")
minetest.register_alias("castle:stonewall_corner",  "castle_masonry:stonewall_corner")

minetest.register_node("castle_masonry:stonewall", {
	description = S("Castle Wall"),
	drawtype = "normal",
	tiles = {"castle_stonewall.png"},
	paramtype = "light",
	drop = "castle_masonry:stonewall",
	groups = {cracky=3, pickaxey=1, stonecuttable=1},
	_mcl_hardness = 1,
	_mcl_blast_resistance = 1,
	sunlight_propagates = false,
	sounds = castle_masonry.sounds.node_sound_stone_defaults(),
})

minetest.register_node("castle_masonry:rubble", {
	description = S("Castle Rubble"),
	drawtype = "normal",
	tiles = {"castle_rubble.png"},
	paramtype = "light",
	groups = {crumbly=3, shovely=1, falling_node=1, stonecuttable=1},
	_mcl_hardness = 0.8,
	_mcl_blast_resistance = 1,
	sounds = castle_masonry.sounds.node_sound_gravel_defaults(),
})

minetest.register_craft({
	output = "castle_masonry:stonewall",
	recipe = {
		{cobble},
		{desert_stone},
	}
})

minetest.register_craft({
	output = "castle_masonry:rubble",
	recipe = {
		{"castle_masonry:stonewall"},
	}
})

minetest.register_craft({
	output = "castle_masonry:rubble 2",
	recipe = {
		{gravel},
		{desert_stone},
	}
})

minetest.register_node("castle_masonry:stonewall_corner", {
	drawtype = "normal",
	paramtype = "light",
	paramtype2 = "facedir",
	description = S("Castle Corner"),
	tiles = {"castle_corner_stonewall_tb.png^[transformR90",
		 "castle_corner_stonewall_tb.png^[transformR180",
		 "castle_corner_stonewall1.png",
		 "castle_stonewall.png",
		 "castle_stonewall.png",
		 "castle_corner_stonewall2.png"},
	groups = {cracky=3, pickaxey=1},
	_mcl_hardness = 1,
	_mcl_blast_resistance = 1,
	_mcl_stonecutter_recipes = {"castle_masonry:stonewall"},
	sounds = castle_masonry.sounds.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "castle_masonry:stonewall_corner",
	recipe = {
		{"", "castle_masonry:stonewall"},
		{"castle_masonry:stonewall", sandstone},
	}
})

if minetest.get_modpath("moreblocks") then
	stairsplus:register_all("castle_masonry", "stonewall", "castle_masonry:stonewall", {
		description = S("Stone Wall"),
		tiles = {"castle_stonewall.png"},
		groups = {cracky=3, pickaxey=1, not_in_creative_inventory=1},
		_mcl_hardness = 0.8,
		_mcl_blast_resistance = 1,
		sounds = castle_masonry.sounds.node_sound_stone_defaults(),
		sunlight_propagates = true,
	})

	stairsplus:register_all("castle_masonry", "rubble", "castle_masonry:rubble", {
		description = S("Rubble"),
		tiles = {"castle_rubble.png"},
		groups = {cracky=3, pickaxey=1, not_in_creative_inventory=1},
		sounds = castle_masonry.sounds.node_sound_gravel_defaults(),
		sunlight_propagates = true,
	})

	stairsplus:register_alias_all("castle", "stonewall", "castle_masonry", "stonewall")
	stairsplus:register_alias_all("castle", "rubble", "castle_masonry", "rubble")

elseif minetest.get_modpath("mcl_stairs") then
	mcl_stairs.register_stair_and_slab("stonewall", {
		baseitem = "castle_masonry:stonewall",
		description = S("Castle StoneWall"),
		groups = {pickaxey=1, stonecuttable=1},
		overrides = {
			_mcl_stonecutter_recipes = {"castle_masonry:stonewall"}
		},
	})
	mcl_stairs.register_stair_and_slab("rubble", {
		baseitem = "castle_masonry:rubble",
		description = S("Castle Rubble"),
		groups = {shovely=1, stonecuttable=1},
		overrides = {
			_mcl_stonecutter_recipes = {"castle_masonry:rubble"}
		},
	})
elseif minetest.get_modpath("stairs") then
	stairs.register_stair_and_slab("stonewall", "castle_masonry:stonewall",
		{cracky=3, pickaxey=1},
		{"castle_stonewall.png"},
		S("Castle Stonewall Stair"),
		S("Castle Stonewall Slab"),
		castle_masonry.sounds.node_sound_stone_defaults()
	)

	stairs.register_stair_and_slab("rubble", "castle_masonry:rubble",
		{cracky=3},
		{"castle_rubble.png"},
		S("Castle Rubble Stair"),
		S("Castle Rubble Slab"),
		castle_masonry.sounds.node_sound_stone_defaults()
	)
end

--------------------------------------------------------------------------------------------------------------

minetest.register_node("castle_masonry:dungeon_stone", {
	description = S("Dungeon Stone"),
	drawtype = "normal",
	tiles = {"castle_dungeon_stone.png"},
	groups = {cracky=2, pickaxey=2, stonecuttable=1},
	_mcl_hardness = 1,
	_mcl_blast_resistance = 1,
	paramtype = "light",
	sounds = castle_masonry.sounds.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "castle_masonry:dungeon_stone 2",
	recipe = {
		{stonebrick, obsidian},
	}
})

minetest.register_craft({
	output = "castle_masonry:dungeon_stone 2",
	recipe = {
		{stonebrick},
		{obsidian},
	}
})


if minetest.get_modpath("moreblocks") then
	stairsplus:register_all("castle_masonry", "dungeon_stone", "castle_masonry:dungeon_stone", {
		description = S("Dungeon Stone"),
		tiles = {"castle_dungeon_stone.png"},
		groups = {cracky=2, pickaxey=2, not_in_creative_inventory=1},
		sounds = castle_masonry.sounds.node_sound_stone_defaults(),
		sunlight_propagates = true,
	})

	stairsplus:register_alias_all("castle", "dungeon_stone", "castle_masonry", "dungeon_stone")

elseif minetest.get_modpath("mcl_stairs") then
	mcl_stairs.register_stair_and_slab("dungeon_stone", {
		baseitem = "castle_masonry:dungeon_stone",
		description = S("Dungeon Stone"),
		groups = {pickaxey=2, stonecuttable=1},
		overrides = {
			_mcl_stonecutter_recipes = {"castle_masonry:dungeon_stone"}
		},
	})
elseif minetest.get_modpath("stairs") then
	stairs.register_stair_and_slab("dungeon_stone", "castle_masonry:dungeon_stone",
		{cracky=2, pickaxey=2},
		{"castle_dungeon_stone.png"},
		S("Dungeon Stone Stair"),
		S("Dungeon Stone Slab"),
		castle_masonry.sounds.node_sound_stone_defaults()
	)
end
