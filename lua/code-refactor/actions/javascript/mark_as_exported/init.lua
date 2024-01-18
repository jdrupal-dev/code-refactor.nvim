local ts_utils = require("nvim-treesitter.ts_utils")
local utils = require('code-refactor.utils')

local M = {
  title = "Mark as exported"
}

M.is_available = function()
  local node = ts_utils.get_node_at_cursor()
  while node ~= nil
    and node:parent()
    and node:parent():type() ~= "program" do
    node = node:parent()
  end

  if not node or not node:parent() or node:parent():type() ~= "program" then
    return nil
  end

  if node:type() == "function_declaration" then
    M.title = "Export function declaration"
    return node
  elseif node:type() == "type_alias_declaration" then
    M.title = "Export type alias"
  elseif node:type() == "interface_declaration" then
    M.title = "Export interface"
  elseif node:type() == "lexical_declaration" then
    M.title = "Export variable"
    return node
  end

  return nil
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

  local node_text = vim.treesitter.get_node_text(node, buf)

  node_text = "export " .. node_text

  utils.replace_text_in_buffer(start_row, start_col, end_row, end_col, vim.split(node_text, "\n"))
  vim.api.nvim_win_set_cursor(win, cursor_pos)
end

return M
