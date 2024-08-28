# nvim-autocenter

Auto zz when inserting.

## Demo


https://github.com/user-attachments/assets/df50d1b3-4504-4f16-b0c7-e7eb3551e7a3




## Requirements

Tested only on latest release, but will work on other versions as well.

## Installation

vim-plug

```
Plug 'LZDQ/nvim-autocenter'
```

## Usage

Auto center the current line when inserting.

By default, only center the current line when the current line is whitespaces and the cursor is within [1/3, 2/3] of the screen height.

To disable the check of whitespaces and always center when inserting outside the range, change the `when` parameter in the setup to "always".

To disable auto centering when inserting text, change `when` to "never". In this case, you should enable plugin support for nvim-autopairs (auto centering when pressing enter in a pair of curly brackets), or this plugin is completely functionless.

## Setup

Default setup. Leave it empty if you don't want to change it.

```lua
require("nvim-autocenter").setup{
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
		-- auto center when pressing enter inside curly brackets
		autopairs = true,
	},
	filetypes = {
		-- Enable or disable filetypes. Use REGEX!!
		-- Wildcard * doesn't work, use .* plz.
		-- disabled rules beats enabled rules when contradicting.
		enabled = { ".*" },
		disabled = { "json" },
	}
}
```

## Plugins supported

[windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)

Automatically center when inserting newline inside curly brackets.

