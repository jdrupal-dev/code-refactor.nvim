local js_utils = require "code-refactor.actions.javascript.utils"
local ts_utils = require('nvim-treesitter.ts_utils')
local utils = require('code-refactor.utils')
local M = {}

local function has_braces(node)
  if not node or node:type() ~= "arrow_function" then
    return false
  end

  local children = ts_utils.get_named_children(node)
  return children[#children]:type() == 'statement_block'
end

local function get_title(node)
  if has_braces(node) then
    return "Remove braces from arrow function"
  end
  return "Add braces to arrow function"
end

M.is_available = function()
  local node = js_utils.get_function_node_at_cursor()
  M.title = get_title(node)
  if node == nil or node:type() ~= "arrow_function" then
    return nil
  end
  return node
end

M.run = function()
  local node = M.is_available()
  if not node then
    return
  end

  local func_info = js_utils.get_function_info_from_node(node)
  if not func_info then
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local children = ts_utils.get_named_children(node)

  -- Get the current cursor position, to restore after the function is replaced.
  local win = vim.api.nvim_get_current_win()
  local cursor_pos = vim.api.nvim_win_get_cursor(win)

  if not has_braces(node) then
    func_info.body = "{\nreturn " .. func_info.body .. ";\n}"
  else
    local body_node = children[#children]
    local return_stmt_node = body_node:named_child(0)
    if return_stmt_node and return_stmt_node:type() == 'return_statement' then
      func_info.body = vim.treesitter.get_node_text(return_stmt_node:named_child(0), buf)
    end
  end

  for i = 1, #children - 1 do
    local child_text = vim.treesitter.get_node_text(children[i], buf)
    table.insert(func_info.rest, child_text)
  end

  local rest_str = table.concat(func_info.rest)
  -- Construct the new function.
  local new_func = rest_str .. " => " .. func_info.body
  if #func_info.func_name > 0 then
    new_func = "const " .. func_info.func_name .. " = " .. rest_str .. " => " .. func_info.body
  end

  utils.replace_text_in_buffer(
    func_info.start_row,
    func_info.start_col,
    func_info.end_row,
    func_info.end_col,
    vim.split(new_func, "\n")
  )
  vim.api.nvim_win_set_cursor(win, cursor_pos)
end

return M
