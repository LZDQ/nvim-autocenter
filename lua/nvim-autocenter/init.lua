local M = {}

local default_config = {
	autopairs = true,
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

function M.setup(opts)
    M.config = vim.tbl_deep_extend('force', default_config, opts or {})
	if M.config.autopairs then
		vim.api.nvim_create_autocmd("User", {
			callback = function ()
				local status, npairs = pcall(require, "nvim-autopairs")
				if ~status then
					return
				end
				local rule_curly_brackets = npairs.get_rule("{")
				rule_curly_brackets:replace_map_cr(function ()
					return '<c-g>u<CR><CMD>normal! ====<CR><up><end><CR>' .. 'x<ESC>zzs'
				end)
			end,
		})
	end
end

return M
