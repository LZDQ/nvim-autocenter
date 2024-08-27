# nvim-autocenter

Auto zz when inserting some specific patterns.

## Requirements

Tested only on latest release, but will work on other versions as well.

## Installation

vim-plug

```
Plug 'LZDQ/nvim-autocenter'
```

## Setup

Default setup. Leave it empty if you don't want to change it.

```lua
require("nvim-autocenter").setup{
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
		-- auto center when pressing enter inside curly brackets
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
```

## Plugins supported

[windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)

Automatically center when inserting newline inside curly brackets.

