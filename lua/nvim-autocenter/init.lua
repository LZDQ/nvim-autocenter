local M = {}

local default_config = {
    -- auto center only when the cursor is within this range vertically
	ratio_top = 1/3,
	ratio_bot = 2/3,
	-- When to call `autozz`. Choose between 'always', 'empty', and 'never'.
	-- 'always' means to always do autozz when buffer text changes.
	-- 'empty'  means to do autozz only when the current line contains whitespaces.
	-- 'never'  means do not autozz. If you choose never, you should enable autopairs.
	when = 'empty',
    -- plugin support
	plugins = {
		-- auto center when inserting newline inside curly brackets
		autopairs = true,
	},
	filetypes = {
		-- Enable or disable filetypes. Use REGEX!!
		-- Wildcard * doesn't work, use .* plz.
		-- disabled rules beats enabled rules when contradicting.
		enabled = {".*"},
		disabled = {"json"},
	}
}

-- Center the current line (zz)
-- Works in insert mode and normal mode
function M.center()
	local mode = vim.api.nvim_get_mode().mode
	if mode == 'i' then
		-- To avoid spaces being deleted, first insert a placeholder 'x' and delete it later.
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("x<ESC>zzs", true, false, true), "n", true)
	elseif mode == 'n' then
		vim.command("normal! zz")
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
	for _, pat in ipairs(M.config.filetypes.disabled) do
		if string.match(vim.bo.filetype, pat) then
			return false
		end
	end
	vim.notify("not disabled")
	for _, pat in ipairs(M.config.filetypes.enabled) do
		if string.match(vim.bo.filetype, pat) then
			return true
		end
	end
	vim.notify("not enabled")
	return false
end

-- Center the current line if not within range
function M.autozz()
	-- Check filetypes.
	if not M.check_filetype() then
		return
	end

	-- vim.notify("autozz")
	if not M.within_range() then
		M.center()
	end
end

function M.is_line_blank()
	local line = vim.api.nvim_get_current_line()
    return line:match("^%s*$")
end

function M.setup(opts)
    M.config = vim.tbl_deep_extend('force', default_config, opts or {})

	if M.config.when == "always" then
		vim.api.nvim_create_autocmd("TextChangedI", {
			callback = M.autozz,
		})
	elseif M.config.when == "empty" then
		vim.api.nvim_create_autocmd("TextChangedI", {
			callback = function ()
				-- Check this in advance to avoid lagging nvim
				if M.within_range() then
					return
				end
				if M.is_line_blank() then
					M.autozz()
				end
			end
		})
	elseif M.config.when == "never" then
		-- do nothing
	end

	if M.config.plugins.autopairs then
		vim.api.nvim_create_autocmd("User", {
			callback = function ()
				local status, npairs = pcall(require, "nvim-autopairs")
				if not status then
					return
				end
				npairs.get_rule("{"):replace_map_cr(function ()
					local res = '<c-g>u<CR><CMD>normal! ====<CR><up><end><CR>'
					if not M.within_range() then
						res = res .. 'x<ESC>zzs'
					end
					return res
				end)
			end,
		})
	end
end

return M
