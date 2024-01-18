# code-refactor.nvim

**code-refactor.nvim** a collection of nifty code actions that do not require a LSP.

## :lock: Requirements

- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

## :package: Installation

Install this plugin using your favorite plugin manager, and then call
`require("code-refactor").setup()`.

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "jdrupal-dev/code-refactor.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
        { "<leader>cc", "<cmd>CodeActions all<CR>", desc = "Show code-refactor.nvim (not LSP code actions)" },
    },
    config = function()
        require("code-refactor").setup({
            -- Configuration here, or leave empty to use defaults.
        })
    end
}
```

## :rocket: Usage

Run the `:CodeActions all` command to show a select list of available actions under the cursor.

Run `:CodeActions [x]` to run a specific code action.\
For example: `:CodeActions toggle_arrow_function_braces`.

## :gear: Configuration

The default configuration is found in `lua/code-refactor/config.lua`.\
Simply call `require("code-refactor").setup` with the desired options.

To disable code actions for any given language, simply return an empty table in `file_types`.
```lua
require("code-refactor").setup({
    available_actions = {
        javascript = {
            file_types = {},
        },
    },
})
```

## :sparkles: Available actions 

NB: This plugin is under active development, so new languages and actions will be added regularly.

|                         Name | JavaScript |    PHP     |
|------------------------------|:----------:|:----------:|
|                  **General** |            |            |
|                 Flip ternary |    yes     |    yes     |
|            Negate expression |    yes     |    yes     |
|               **JavaScript** |            |            |
|       Convert arrow function |    yes     |            |
| Toggle arrow function braces |    yes     |            |
|             Mark as exported |    yes     |            |
