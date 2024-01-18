local ts_utils = require("nvim-treesitter.ts_utils")
local utils = require('code-refactor.utils')
local negate_expression = require("code-refactor.actions.php.negate_expression")

local M = {
  title = "Flip ternary"
}

M.is_available = function()
  local node = ts_utils.get_node_at_cursor()
  while node ~= nil and node:type() ~= "conditional_expression" do
    node = node:parent()
  end

  return node
end

M.run = function()
  local node = M.is_available()
  if not node then
    return
  end

  -- Get the current cursor position, to restore after the function is replaced.
  local win = vim.api.nvim_get_current_win()
  local cursor_pos = vim.api.nvim_win_get_cursor(win)

  local buf = vim.api.nvim_get_current_buf()
  local start_row, start_col, end_row, end_col = node:range()
  local children = ts_utils.get_named_children(node)

  local expression = negate_expression.get_negated_expression(children[1])
  local consequence = vim.treesitter.get_node_text(children[2], buf)
  local alternative = vim.treesitter.get_node_text(children[3], buf)

  local new_ternary = expression .. " ? " .. alternative .. " : " .. consequence

  utils.replace_text_in_buffer(start_row, start_col, end_row, end_col, vim.split(new_ternary, "\n"))
  vim.api.nvim_win_set_cursor(win, cursor_pos)
end

return M

