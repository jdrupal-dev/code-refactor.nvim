local js_utils = require("code-refactor.actions.javascript.utils")
local ts_utils = require('nvim-treesitter.ts_utils')
local utils = require('code-refactor.utils')

local M = {}

local function get_title()
  local node = js_utils.get_function_node_at_cursor()
  if node == nil then
    return ""
  end

  if node:type() == "arrow_function" then
    return "Convert arrow function to function declaration"
  end

  return "Convert function declaration to arrow function"
end

local function ensure_parentheses(str)
  if not string.find(str, "^%s*%(") then
    return "(" .. str .. ")"
  end
  return str
end

M.is_available = function ()
  M.title = get_title()
  return js_utils.get_function_node_at_cursor()
end

M.run = function ()
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

  if node:type() ~= 'function_declaration' then
    if children[#children]:type() ~= 'statement_block' then
      func_info.body = "{\nreturn " .. func_info.body .. "\n}"
    end

    for i = 1, #children - 1 do
      local child_text = vim.treesitter.get_node_text(children[i], buf)
      -- Parameter without parentheses needs to get parenthesized.
      if children[i]:type() == 'identifier' then
        child_text = ensure_parentheses(child_text)
      end
      table.insert(func_info.rest, child_text)
    end
  end

  local rest_str = table.concat(func_info.rest)

  -- Simplify return statement if possible when converting to arrow
  if node:type() ~= 'arrow_function' then
    local body_node = children[#children]
    if body_node:type() == 'statement_block' then
      local return_stmt_node = body_node:named_child(0)
      if return_stmt_node and return_stmt_node:type() == 'return_statement' then
        func_info.body = vim.treesitter.get_node_text(return_stmt_node:named_child(0), buf)
      end
    end
  end

  -- Construct the new function.
  local new_func
  if node:type() == 'function_declaration' then
    new_func = "const " .. func_info.func_name .. " = " .. rest_str .. " => " .. func_info.body
  elseif node:type() == 'function' then
    new_func = rest_str .. " => " .. func_info.body
  else
    new_func = "function " .. func_info.func_name .. rest_str .. " " .. func_info.body
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

