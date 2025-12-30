-- Colorscheme name:    gruber-darker.nvim
-- Description:         Port of gruber-darker theme for neovim
-- Author:              https://github.com/shaunsingh

local util = require("gruber-darker.util")

local bufferline = require("bufferline.theme")

-- Load the theme
local set = function()
	util.load()
end

-- Setup function for plugin managers that expect it
local setup = function(opts)
	opts = opts or {}
	-- Apply any configuration options if provided
	for key, value in pairs(opts) do
		vim.g["gruber_darker_" .. key] = value
	end
	-- Load the theme
	util.load()
end

return { set = set, setup = setup, bufferline = bufferline }
