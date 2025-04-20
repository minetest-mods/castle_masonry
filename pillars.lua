
local S = minetest.get_translator("castle_masonry")

assert(table.insert_all, "Your Luanti/Minetest version is too old or uses an incomplete version of 'builtin'")

local function copy_merge(template, overwrites)
	local out = {}
	for k, v in pairs(template) do
		out[k] = v
	end
	for k, v in pairs(overwrites) do
		out[k] = v
	end
	return out
end

castle_masonry.register_pillar = function(material)
	local composition_def, burn_time, tile, desc = castle_masonry.get_material_properties(material)
	local crossbrace_connectable_groups = {}
	for group, val in pairs(composition_def.groups) do
		crossbrace_connectable_groups[group] = val
	end
	crossbrace_connectable_groups.crossbrace_connectable = 1

	local mod_name = minetest.get_current_modname()
	local name_prefix = mod_name .. ":pillar_" .. material.name

	-- Node Definition
	local template = {
		drawtype = "nodebox",
		-- groups: Intentionally generate an error if not overwritten:
		--    bad argument #7 to 'register_item_raw' (table expected, got boolean)
		groups = true,
		paramtype = "light",
		paramtype2 = "facedir",
		sounds = composition_def.sounds,
		tiles = tile,
		_mcl_hardness = composition_def._mcl_hardness or 0.8,
		_mcl_blast_resistance = composition_def._mcl_blast_resistance or 1,
		_mcl_stonecutter_recipes = {material.composition_material or material.craft_material},
	}

	core.register_node(name_prefix .. "_bottom", copy_merge(template, {
		description = S("@1 Pillar Base", desc),
		groups = crossbrace_connectable_groups,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5,-0.5,-0.5,0.5,-0.375,0.5},
				{-0.375,-0.375,-0.375,0.375,-0.125,0.375},
				{-0.25,-0.125,-0.25,0.25,0.5,0.25},
			},
		},
	}))

	core.register_node(name_prefix.."_bottom_half", copy_merge(template, {
		description = S("@1 Half Pillar Base", desc),
		groups = composition_def.groups,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, 0, 0.5, -0.375, 0.5},
				{-0.375, -0.375, 0.125, 0.375, -0.125, 0.5},
				{-0.25, -0.125, 0.25, 0.25, 0.5, 0.5},
			},
		},
	}))

	core.register_node(name_prefix .. "_top", copy_merge(template, {
		description = S("@1 Pillar Top", desc),
		groups = crossbrace_connectable_groups,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5,0.3125,-0.5,0.5,0.5,0.5},
				{-0.375,0.0625,-0.375,0.375,0.3125,0.375},
				{-0.25,-0.5,-0.25,0.25,0.0625,0.25},
			},
		},
	}))

	core.register_node(name_prefix .. "_top_half", copy_merge(template, {
		description = S("@1 Half Pillar Top", desc),
		groups = composition_def.groups,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, 0.3125, 0, 0.5, 0.5, 0.5},
				{-0.375, 0.0625, 0.125, 0.375, 0.3125, 0.5},
				{-0.25, -0.5, 0.25, 0.25, 0.0625, 0.5},
			},
		},
	}))

	core.register_node(name_prefix .. "_middle", copy_merge(template, {
		description = S("@1 Pillar Middle", desc),
		groups = crossbrace_connectable_groups,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.25,-0.5,-0.25,0.25,0.5,0.25},
			},
		},
	}))

	core.register_node(name_prefix .. "_middle_half", copy_merge(template, {
		description = S("@1 Half Pillar Middle", desc),
		groups = composition_def.groups,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.25, -0.5, 0.25, 0.25, 0.5, 0.5},
			},
		},
	}))

	core.register_node(name_prefix .. "_crossbrace", copy_merge(template, {
		description = S("@1 Crossbrace", desc),
		groups = composition_def.groups,
		node_box = {
			type = "connected",
			fixed = {-0.25,0.25,-0.25,0.25,0.5,0.25},
			connect_front = {-0.25,0.25,-0.75,0.25,0.5,-0.25}, -- -Z
			connect_left = {-0.25,0.25,-0.25,-0.75,0.5,0.25}, -- -X
			connect_back = {-0.25,0.25,0.25,0.25,0.5,0.75}, -- +Z
			connect_right = {0.25,0.25,-0.25,0.75,0.5,0.25}, -- +X
		},
		connects_to = {
			name_prefix.."_crossbrace",
			name_prefix.."_extended_crossbrace",
			"group:crossbrace_connectable"},
		connect_sides = { "front", "left", "back", "right" },
	}))

	core.register_node(name_prefix .. "_extended_crossbrace", copy_merge(template, {
		description = S("@1 Extended Crossbrace", desc),
		groups = composition_def.groups,
		node_box = {
			type = "fixed",
			fixed = {-1.25,0.25,-0.25,1.25,0.5,0.25},
		},
	}))

	minetest.register_craft({
		output = name_prefix.."_bottom 4",
		recipe = {
			{"",material.craft_material,""},
			{"",material.craft_material,""},
			{material.craft_material,material.craft_material,material.craft_material} },
	})

	minetest.register_craft({
		output = name_prefix.."_top 4",
		recipe = {
			{material.craft_material,material.craft_material,material.craft_material},
			{"",material.craft_material,""},
			{"",material.craft_material,""} },
	})

	minetest.register_craft({
		output = name_prefix.."_middle 2",
		recipe = {
			{material.craft_material},
			{material.craft_material},
			{material.craft_material} },
	})

	minetest.register_craft({
		output = name_prefix.."_crossbrace 10",
		recipe = {
			{material.craft_material,"",material.craft_material},
			{"",material.craft_material,""},
			{material.craft_material,"",material.craft_material} },
	})

	minetest.register_craft({
		output = name_prefix.."_middle_half 2",
		type="shapeless",
		recipe = {name_prefix.."_middle"},
	})
	minetest.register_craft({
		output = name_prefix.."_middle",
		type="shapeless",
		recipe = {name_prefix.."_middle_half", name_prefix.."_middle_half"},
	})

	minetest.register_craft({
		output = name_prefix.."_top_half 2",
		type="shapeless",
		recipe = {name_prefix.."_top"},
	})
	minetest.register_craft({
		output = name_prefix.."_top",
		type="shapeless",
		recipe = {name_prefix.."_top_half", name_prefix.."_top_half"},
	})

	minetest.register_craft({
		output = name_prefix.."_bottom_half 2",
		type="shapeless",
		recipe = {name_prefix.."_bottom"},
	})
	minetest.register_craft({
		output = name_prefix.."_bottom",
		type="shapeless",
		recipe = {name_prefix.."_bottom_half", name_prefix.."_bottom_half"},
	})

	minetest.register_craft({
		output = name_prefix.."_extended_crossbrace",
		type="shapeless",
		recipe = {name_prefix.."_crossbrace"},
	})

	minetest.register_craft({
		output = name_prefix.."_crossbrace",
		type="shapeless",
		recipe = {name_prefix.."_extended_crossbrace"},
	})

	if burn_time > 0 then
		minetest.register_craft({
			type = "fuel",
			recipe = name_prefix.."_top",
			burntime = burn_time*5/4,
		})
		minetest.register_craft({
			type = "fuel",
			recipe = name_prefix.."_top_half",
			burntime = burn_time*5/8,
		})
		minetest.register_craft({
			type = "fuel",
			recipe = name_prefix.."_bottom",
			burntime = burn_time*5/4,
		})
		minetest.register_craft({
			type = "fuel",
			recipe = name_prefix.."_bottom_half",
			burntime = burn_time*5/8,
		})
		minetest.register_craft({
			type = "fuel",
			recipe = name_prefix.."_middle",
			burntime = burn_time*6/4,
		})
		minetest.register_craft({
			type = "fuel",
			recipe = name_prefix.."_middle_half",
			burntime = burn_time*6/8,
		})
		minetest.register_craft({
			type = "fuel",
			recipe = name_prefix.."_crossbrace",
			burntime = burn_time*5/10,
		})
		minetest.register_craft({
			type = "fuel",
			recipe = name_prefix.."_extended_crossbrace",
			burntime = burn_time*5/10,
		})
	end

end

local PILLAR_VARIANTS = {
	"_bottom",
	"_bottom_half",
	"_crossbrace",
	"_middle",
	"_middle_half",
	"_top",
	"_top_half",
	"_bottom",
	"_bottom_half",
	"_crossbrace",
	"_middle",
	"_middle_half",
	"_top",
	"_top_half"
}

-- The original castle mod had "pillars_", plural, which didn't match the arrowslit and murderhole standard.
castle_masonry.register_pillar_alias = function(old_mod_name, old_material_name, new_mod_name, new_material_name)
	for _, suffix in ipairs(PILLAR_VARIANTS) do
		core.register_alias(
			old_mod_name .. ":pillars_" .. old_material_name .. suffix,
			new_mod_name .. ":pillar_"  .. new_material_name .. suffix
		)
	end
end

castle_masonry.register_arrowslit_alias_force = function(old_mod_name, old_material_name, new_mod_name, new_material_name)
	for _, suffix in ipairs(PILLAR_VARIANTS) do
		core.register_alias_force(
			old_mod_name .. ":pillars_" .. old_material_name .. suffix,
			new_mod_name .. ":pillar_"  .. new_material_name .. suffix
		)
	end
end
