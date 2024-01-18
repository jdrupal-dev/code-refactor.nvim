local ts_utils = require("nvim-treesitter.ts_utils")
local utils = require('code-refactor.utils')

local M = {
  title = "Negate expression"
}

M.is_available = function ()
  local node = ts_utils.get_node_at_cursor()
  while node ~= nil
    and node:type() ~= "boolean"
    and node:type() ~= "function_call_expression"
    and node:type() ~= "binary_expression"
    and node:type() ~= "unary_op_expression" do
    node = node:parent()
  end

  return node
end

M.get_negated_expression = function (node)
  local buf = vim.api.nvim_get_current_buf()
  local expression = vim.treesitter.get_node_text(node, buf)

  if node:type() == "boolean" then
    if expression == "true" then
      return "false"
    elseif expression == "TRUE" then
      return "FALSE"
    elseif expression == "false" then
      return "true"
    elseif expression == "FALSE" then
      return "TRUE"
    end
  end

  -- Simply wrap the expression in !() to negate it.
  -- Could probably be done in a better way, but that is way more complicated.
  if string.sub(expression, 0, 2) == "!(" then
    local _, _, new_expression = string.find(expression, "!%((.*)%)")
    return new_expression
  end

  return "!(" .. expression .. ")"
end

M.run = function()
  local node = M.is_available()
  if not node then
    return
  end

  -- Get the current cursor position, to restore after the function is replaced.
  local win = vim.api.nvim_get_current_win()
  local cursor_pos = vim.api.nvim_win_get_cursor(win)

  local start_row, start_col, end_row, end_col = node:range()

  local new_expression = M.get_negated_expression(node)
  if not new_expression then
    return
  end

  utils.replace_text_in_buffer(start_row, start_col, end_row, end_col, vim.split(new_expression, "\n"))
  vim.api.nvim_win_set_cursor(win, cursor_pos)
end

return M

