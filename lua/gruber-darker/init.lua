-- Colorscheme name:    gruber-darker.nvim
-- Description:         Port of gruber-darker theme for neovim
-- Author:              https://github.com/shaunsingh

local util = require("gruber-darker.util")

local bufferline = require("bufferline.theme")

-- Load the theme
local set = function()
	util.load()
end

return { set = set, bufferline = bufferline }
