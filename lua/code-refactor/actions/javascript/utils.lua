local ts_utils = require('nvim-treesitter.ts_utils')

local M = {}

M.get_function_node_at_cursor = function()
  local node = ts_utils.get_node_at_cursor()

  -- 'function' means non-arrow anonymous function
  while node ~= nil
    and node:type() ~= 'function_declaration'
    and node:type() ~= 'function'
    and node:type() ~= 'arrow_function' do
    node = node:parent()
  end

  if node == nil then
    return nil
  end

  return node
end

M.get_function_info_from_node = function(node)
  if node:type() ~= "function_declaration"
    and node:type() ~= "function"
    and node:type() ~= "arrow_function" then
    return nil
  end

  -- Extract the function name, and body, and rest.
  local func_name, body
  local rest = {}

  local buf = vim.api.nvim_get_current_buf()
  local start_row, start_col, end_row, end_col = node:range()
  local children = ts_utils.get_named_children(node)
  if node:type() == 'function_declaration' then
    func_name = vim.treesitter.get_node_text(children[1], buf)
    body = vim.treesitter.get_node_text(children[#children], buf)

    for i = 2, #children - 1 do
      table.insert(rest, vim.treesitter.get_node_text(children[i], buf))
    end
  else
    local parent = node:parent()
    if parent:type() == 'variable_declarator' then
      start_row, start_col, _, _ = parent:parent():range()
      func_name = vim.treesitter.get_node_text(parent:named_child(0), buf)
    else
      func_name = ''
    end

    body = vim.treesitter.get_node_text(children[#children], buf)
  end

  return {
    func_name = func_name,
    rest = rest,
    body = body,
    start_row = start_row,
    start_col = start_col,
    end_row = end_row,
    end_col = end_col,
  }
end

return M
