local M = {}

local default_config = {
	ratio_top = 1/3,
	ratio_bot = 2/3,
	plugins = {
		autopairs = true,
	}
}

-- Center the current line (zz)
-- Works in insert mode and normal mode
function M.center()
	local mode = vim.api.nvim_get_mode().mode
	if mode == 'i' then
		-- To avoid spaces being deleted, first insert a placeholder 'x' and delete it later.
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("x<ESC>zzs", true, false, true), "n", true)
	elseif mode == 'n' or mode == 'v' then
		vim.command("normal! zz")
	else
		print("Not supported in '" .. mode .. "' mode")
	end
end

function M.setup(opts)
    M.config = vim.tbl_deep_extend('force', default_config, opts or {})
	if M.config.plugins.autopairs then
		vim.api.nvim_create_autocmd("User", {
			callback = function ()
				local status, npairs = pcall(require, "nvim-autopairs")
				if not status then
					return
				end
				npairs.get_rule("{"):replace_map_cr(function ()
					local res = '<c-g>u<CR><CMD>normal! ====<CR><up><end><CR>'
					local line = vim.fn.winline()
					local height = vim.api.nvim_win_get_height(0)
					if M.config.ratio_top * height > line or
						M.config.ratio_bot * height < line then
						res = res .. 'x<ESC>zzs'
					end
					return res
				end)
			end,
		})
	end
end

return M
