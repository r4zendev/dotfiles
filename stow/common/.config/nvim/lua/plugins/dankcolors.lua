return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#101416',
				base01 = '#101416',
				base02 = '#929b9e',
				base03 = '#929b9e',
				base04 = '#effaff',
				base05 = '#f8fdff',
				base06 = '#f8fdff',
				base07 = '#f8fdff',
				base08 = '#ff9fbe',
				base09 = '#ff9fbe',
				base0A = '#93e0ff',
				base0B = '#a5ffaf',
				base0C = '#c6efff',
				base0D = '#93e0ff',
				base0E = '#a6e6ff',
				base0F = '#a6e6ff',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#929b9e',
				fg = '#f8fdff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#93e0ff',
				fg = '#101416',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#929b9e' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#c6efff', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#a6e6ff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#93e0ff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#93e0ff',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#c6efff',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a5ffaf',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#effaff' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#effaff' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#929b9e',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
