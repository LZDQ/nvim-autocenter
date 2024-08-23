# nvim-autocenter

Auto zz when inserting some specific patterns.

## Installation

vim-plug

```
Plug 'LZDQ/nvim-autocenter'
```

## Setup

Example setup

```lua
require("nvim-autocenter").setup{
    autopairs = true,  -- auto center when inserting newline inside curly brackets
}
```

## Usage

This plugin exposes a function.

Calling `autocenter.center` will center the current line. Works with normal and insert mode.

## Plugins supported

[windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)

Automatically center when inserting newline inside curly brackets.

## TODO list

1. - [ ] Add 1/3 check
2. - [ ] Add more ratios, not just zz which means 1/2
