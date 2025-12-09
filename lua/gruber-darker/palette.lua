local Color = require("gruber-darker.color")
local config = require("gruber-darker.config")

local M = {}

-- Dark mode palette
local dark_palette = {
	none = Color.none(),
	fg = Color.new(0xe4e4e4),
	["fg+1"] = Color.new(0xf4f4ff),
	["fg+2"] = Color.new(0xf5f5f5),
	white = Color.new(0xffffff),
	black = Color.new(0x000000),
	["bg-1"] = Color.new(0x101010),
	bg = Color.new(0x181818),
	["bg+1"] = Color.new(0x282828),
	["bg+2"] = Color.new(0x453d41),
	["bg+3"] = Color.new(0x484848),
	["bg+4"] = Color.new(0x52494e),
	["red-1"] = Color.new(0xc73c3f),
	red = Color.new(0xf43841),
	["red+1"] = Color.new(0xff4f58),
	green = Color.new(0x73d936),
	yellow = Color.new(0xffdd33),
	brown = Color.new(0xcc8c3c),
	quartz = Color.new(0xe4e4e4),
	["niagara-2"] = Color.new(0x303540),
	["niagara-1"] = Color.new(0x565f73),
	niagara = Color.new(0xf4f4ff),
	wisteria = Color.new(0x9e95c7),
}

-- Light mode palette
local light_palette = {
	none = Color.none(),
	fg = Color.new(0x282828),
	["fg+1"] = Color.new(0x181818),
	["fg+2"] = Color.new(0x101010),
	white = Color.new(0xffffff),
	black = Color.new(0x000000),
	["bg-1"] = Color.new(0xffffff),
	bg = Color.new(0xf8f8f8),
	["bg+1"] = Color.new(0xeeeeee),
	["bg+2"] = Color.new(0xe0e0e0),
	["bg+3"] = Color.new(0xd0d0d0),
	["bg+4"] = Color.new(0xb8b8b8),
	["red-1"] = Color.new(0xa02c2f),
	red = Color.new(0xd42c35),
	["red+1"] = Color.new(0xe03c45),
	green = Color.new(0x5ba524),
	yellow = Color.new(0xb8860b),
	brown = Color.new(0x8b6914),
	quartz = Color.new(0x282828),
	["niagara-2"] = Color.new(0xd0d5db),
	["niagara-1"] = Color.new(0x4a5568),
	niagara = Color.new(0x2d3748),
	wisteria = Color.new(0x6b5b95),
}

-- Return the appropriate palette based on variant
local function get_palette()
	local opts = config.get_opts()
	print("Palette get_palette: variant =", opts.variant, "vim.o.background =", vim.o.background)
	if opts.variant == "light" then
		print("Using light_palette")
		return light_palette
	else
		print("Using dark_palette")
		return dark_palette
	end
end

-- Populate M with the active palette
local function load_palette()
	local palette = get_palette()
	for key, value in pairs(palette) do
		M[key] = value
	end
end

local palette_loaded = false

-- Function to ensure palette is loaded
local function ensure_palette_loaded()
	if not palette_loaded then
		load_palette()
		palette_loaded = true
	end
end

-- Function to reload palette when variant changes
function M.reload()
	-- Clear existing colors
	for key in pairs(M) do
		if key ~= "reload" then
			M[key] = nil
		end
	end
	load_palette()
	palette_loaded = true
end

-- Use metatable to load palette lazily when colors are accessed
return setmetatable(M, {
	__index = function(t, key)
		ensure_palette_loaded()
		return rawget(t, key)
	end
})
