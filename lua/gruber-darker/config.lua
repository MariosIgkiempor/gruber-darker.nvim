---@alias ItalicType
---|"strings"
---|"comments"
---|"operators"
---|"folds"

---@alias InvertType
---|"signs"
---|"tabline"
---|"visual"

---@alias VariantType
---|"dark"
---|"light"

---@class GruberDarkerOpts
---@field bold boolean
---@field variant VariantType
---@field invert table<InvertType, boolean>
---@field italic table<ItalicType, boolean>
---@field undercurl boolean
---@field underline boolean

---@type GruberDarkerOpts
local DEFAULTS = {
	bold = true,
	variant = nil, -- Will be auto-detected from vim.o.background
	invert = {
		signs = false,
		tabline = false,
		visual = false,
	},
	italic = {
		strings = true,
		comments = true,
		operators = false,
		folds = true,
	},
	undercurl = true,
	underline = true,
}

---@class ConfigMgr
---@field private resolved_opts GruberDarkerOpts
---@field private auto_detect_variant boolean
local ConfigMgr = {}
ConfigMgr.__index = ConfigMgr

---@type ConfigMgr|nil
local instance = nil

---Get GruberDarker user preferences
---@return GruberDarkerOpts
---@nodiscard
function ConfigMgr.get_opts()
	if instance ~= nil then
		local opts = vim.deepcopy(instance.resolved_opts)
		-- Always auto-detect variant if it was originally set to auto-detect
		if instance.auto_detect_variant then
			opts.variant = vim.o.background == "light" and "light" or "dark"
		end
		print("Config get_opts (with instance): variant =", opts.variant, "auto_detect =", instance.auto_detect_variant, "vim.o.background =", vim.o.background)
		return opts
	end

	local opts = vim.deepcopy(DEFAULTS)
	-- Auto-detect variant if it's nil
	if opts.variant == nil then
		opts.variant = vim.o.background == "light" and "light" or "dark"
	end
	print("Config get_opts (no instance): variant =", opts.variant, "vim.o.background =", vim.o.background)
	return opts
end

---Set GruberDarker colorscheme options
---@param opts? GruberDarkerOpts
function ConfigMgr.setup(opts)
	local final_opts = vim.tbl_deep_extend("force", DEFAULTS, opts or {})
	
	-- Check if we should auto-detect variant
	local should_auto_detect = final_opts.variant == nil
	
	-- Auto-detect variant based on vim.o.background if variant is nil
	if final_opts.variant == nil then
		final_opts.variant = vim.o.background == "light" and "light" or "dark"
	end
	
	-- Allow reconfiguration by resetting instance
	instance = setmetatable({
		resolved_opts = final_opts,
		auto_detect_variant = should_auto_detect,
	}, ConfigMgr)
end

return ConfigMgr
