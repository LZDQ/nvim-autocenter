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

Default setup

```lua
require("nvim-autocenter").setup{
    -- auto center only when the cursor is within this range vertically
    ratio_top = 1/3,
    ratio_bot = 2/3,
    -- plugin support
    plugins = {
        -- auto center when inserting newline inside curly brackets
        autopairs = true,
    }
}
```

## Usage

This plugin exposes a function.

Calling `require("nvim-autocenter").center()` will center the current line. Works with normal and insert mode.

## Plugins supported

[windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)

Automatically center when inserting newline inside curly brackets.

## TODO list

1. - [x] Add 1/3 check
2. - [ ] Not TODO anymore //Add more ratios, not just zz which means 1/2
