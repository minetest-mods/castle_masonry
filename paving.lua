minetest.register_alias("castle:pavement",      	"castle_masonry:pavement_brick")
minetest.register_alias("castle:pavement_brick",	"castle_masonry:pavement_brick")
minetest.register_alias("castle:roofslate",			"castle_masonry:roofslate")

local S = minetest.get_translator("castle_masonry")
local has_mcl = minetest.get_modpath("mcl_core")
local cobble = has_mcl and "mcl_core:cobble" or "default:cobble"


minetest.register_node("castle_masonry:pavement_brick", {
	description = S("Paving Stone"),
	drawtype = "normal",
	tiles = {"castle_pavement_brick.png"},
	groups = {cracky=2, pickaxey=2},
	_mcl_hardness = 1,
	_mcl_blast_resistance = 1,
	paramtype = "light",
	sounds = castle_masonry.sounds.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "castle_masonry:pavement_brick 4",
	recipe = {
		{"group:stone", cobble},
		{cobble, "group:stone"},
	}
})


if minetest.get_modpath("moreblocks") then
	stairsplus:register_all("castle_masonry", "pavement_brick", "castle_masonry:pavement_brick", {
		description = S("Pavement Brick"),
		tiles = {"castle_pavement_brick.png"},
		groups = {cracky=2, pickaxey=2, not_in_creative_inventory=1},
		sounds = castle_masonry.sounds.node_sound_stone_defaults(),
		sunlight_propagates = true,
	})
	stairsplus:register_alias_all("castle", "pavement_brick", "castle_masonry", "pavement_brick")
elseif minetest.get_modpath("mcl_stairs") then
	mcl_stairs.register_stair_and_slab("pavement_brick", "castle_masonry:pavement_brick",
		{pickaxey=2},
		{"castle_pavement_brick.png"},
		S("Castle Pavement Stair"),
		S("Castle Pavement Slab"),
		castle_masonry.sounds.node_sound_stone_defaults()
	)
elseif minetest.get_modpath("stairs") then
	stairs.register_stair_and_slab("pavement_brick", "castle_masonry:pavement_brick",
		{cracky=2},
		{"castle_pavement_brick.png"},
		S("Castle Pavement Stair"),
		S("Castle Pavement Slab"),
		castle_masonry.sounds.node_sound_stone_defaults()
	)
end


minetest.register_node("castle_masonry:roofslate", {
	drawtype = "raillike",
	description = S("Roof Slates"),
	inventory_image = "castle_slate.png",
	paramtype = "light",
	walkable = false,
	tiles = {'castle_slate.png'},
	climbable = true,
	selection_box = {
		type = "fixed",
		fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
	},
	groups = {cracky=3, pickaxey=1, attached_node=1},
	_mcl_hardness = 0.8,
	_mcl_blast_resistance = 1,
	sounds = castle_masonry.sounds.node_sound_stone_defaults(),
})

local mod_building_blocks = minetest.get_modpath("building_blocks")
local mod_streets = minetest.get_modpath("streets") or minetest.get_modpath("asphalt")
local has_mcl = minetest.get_modpath("mcl_core")
local gravel = has_mcl and "mcl_core:gravel" or "default:gravel"

if mod_building_blocks then
	minetest.register_craft({
		output = "castle_masonry:roofslate 4",
		recipe = {
			{ "building_blocks:Tar" , gravel },
			{ gravel,       "building_blocks:Tar" }
		}
	})

	minetest.register_craft( {
		output = "castle_masonry:roofslate 4",
		recipe = {
			{ gravel,       "building_blocks:Tar" },
			{ "building_blocks:Tar" , gravel }
		}
	})
end

if mod_streets then
	minetest.register_craft( {
		output = "castle_masonry:roofslate 4",
		recipe = {
			{ "streets:asphalt" , gravel },
			{ gravel,   "streets:asphalt" }
		}
	})

	minetest.register_craft( {
		output = "castle_masonry:roofslate 4",
		recipe = {
			{ gravel,   "streets:asphalt" },
			{ "streets:asphalt" , gravel }
		}
	})
end

if not (mod_building_blocks or mod_streets) then
	minetest.register_craft({
		type = "cooking",
		output = "castle_masonry:roofslate",
		recipe = gravel,
	})

end
