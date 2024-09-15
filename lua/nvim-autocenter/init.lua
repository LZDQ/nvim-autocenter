local M = {}

local default_config = {
	-- auto center only when the cursor is not within this range vertically
	ratio_top = 1 / 3,
	ratio_bot = 2 / 3,
	-- When to call `autozz`. Choose between 'always', 'empty', and 'never'.
	-- 'always' means to always do autozz when buffer text changes.
	-- 'empty'  means to do autozz only when the current line contains whitespaces.
	-- 'never'  means do not autozz. If you choose never, you should enable autopairs.
	when = 'empty',
	-- plugin support
	plugins = {
		-- auto center when pressing enter inside specific brackets
		autopairs = {
			enabled = true,
			-- These are rules to auto center when pressing enter after it.
			-- Each item is the lhs of the rule.
			rules_with_cr = {
				"{",
				"'''",
				'"""',
			}
		}
	},
	filetypes = {
		-- Enable or disable filetypes. Use REGEX!!
		-- Wildcard * doesn't work, use .* plz.
		-- disabled rules beats enabled rules when contradicting.
		enabled = { ".*" },
		disabled = { "json" },
	}
}

local function is_blank_line()
	return vim.api.nvim_get_current_line():match("^%s*$")
end

local function is_empty_line()
	return #vim.api.nvim_get_current_line() == 0
end

local function at_end_of_line_i()
	return #vim.api.nvim_get_current_line() == vim.api.nvim_win_get_cursor(0)[2]
end

-- Center the current line (zz)
-- Works in insert mode and normal mode
function M.center()
	-- Check if line number is the same to avoid recursion and improve functionality
	local line_num = vim.api.nvim_win_get_cursor(0)[1]
	if line_num == M.cache.last_line_num then
		return
	else
		M.cache.last_line_num = line_num
	end

	local mode = vim.api.nvim_get_mode().mode

	if mode == 'i' then
		if is_empty_line() then
			vim.cmd("normal! zz")

		elseif at_end_of_line_i() then
			-- local line = vim.api.nvim_get_current_line()
			-- vim.notify("cc. line: " .. line)
			-- To avoid spaces being deleted, first insert a placeholder 'x' and delete it later.
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('x<ESC>zz"_xa', true, false, true), "n", true)
			
		else
			-- To avoid spaces being deleted, first insert a placeholder 'x' and delete it later.
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('x<ESC>zz"_xi', true, false, true), "n", true)
			-- vim.notify("placeholder. line: " .. line)
		end

	elseif mode == 'n' then
		vim.cmd("normal! zz")

	else
		print("Not supported in '" .. mode .. "' mode")

	end
end

-- Check whether within range (defaults to [1/3, 2/3])
function M.within_range()
	local line = vim.fn.winline()
	local height = vim.api.nvim_win_get_height(0)
	return M.config.ratio_top * height <= line and line <= M.config.ratio_bot * height
end

function M.check_filetype()
	if vim.bo.buftype ~= "" then
		return false
	end
	for _, pat in ipairs(M.config.filetypes.disabled) do
		if string.match(vim.bo.filetype, pat) then
			return false
		end
	end
	for _, pat in ipairs(M.config.filetypes.enabled) do
		if string.match(vim.bo.filetype, pat) then
			return true
		end
	end
	return false
end

-- Center the current line if not within range
function M.autozz()
	-- vim.notify("autozz")
	-- Check filetypes.
	if not M.check_filetype() then
		return
	end
	-- vim.notify("filetype ok")

	if not M.within_range() then
		M.center()
	end
end

function M.setup(opts)
	M.config = vim.tbl_deep_extend('force', default_config, opts or {})
	M.cache = {}

	if M.config.when == "always" then
		vim.api.nvim_create_autocmd("TextChangedI", {
			callback = M.autozz,
		})
	elseif M.config.when == "empty" then
		vim.api.nvim_create_autocmd("TextChangedI", {
			callback = function()
				-- Check this in advance to avoid lagging nvim
				if M.within_range() then
					return
				end
				if is_blank_line() then
					M.autozz()
				end
			end
		})
	elseif M.config.when == "never" then
		-- do nothing
	end

	if M.config.plugins.autopairs.enabled then
		vim.api.nvim_create_autocmd("User", {
			callback = function()
				local status, npairs = pcall(require, "nvim-autopairs")
				if not status then
					return
				end

				local function map_cr_autozz()
					if M.within_range() then
						return '<c-g>u<CR><CMD>normal! ====<CR><up><end><CR>'
					else
						return '<c-g>u<CR><CMD>normal! ====zz<CR><up><end><CR>'
					end
				end

				for _, lhs in ipairs(M.config.plugins.autopairs.rules_with_cr) do
					npairs.get_rule(lhs):replace_map_cr(map_cr_autozz)
				end
			end,
		})
	end
end

return M
