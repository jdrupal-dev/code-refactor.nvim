local utils = require("code-refactor.utils")

local M = {}

function M.setup(cfg)
  M.__conf = vim.tbl_deep_extend("keep", cfg or {}, require("code-refactor.config"))

  -- Create command to show code actions.
  vim.api.nvim_create_user_command('CodeActions',
    function(opts)
      if opts.fargs[1] == "all" then
        M.show_code_actions()
        return
      end

      local language = M.get_language_in_current_buffer()
      if not language then
        print("No actions for current filetype")
        return
      end

      local has_action, action = pcall(
        require,
        "code-refactor.actions." .. language .. "." .. opts.fargs[1]
      )
      if has_action then
        action.run()
      end
    end,
    {
      nargs = 1,
      complete = function (arglead)
        return vim.tbl_filter(function(arg)
          return arg:match("^" .. arglead)
        end, vim.tbl_extend("keep", { "all" }, M.get_actions_under_cursor().list))
      end
    }
  )
end

M.get_language_in_current_buffer = function()
  for language, value in pairs(M.__conf.available_actions) do
    for _, filetype in ipairs(value.file_types) do
      if filetype == vim.bo.filetype then
        return language
      end
    end
  end
  return nil
end

M.get_actions_under_cursor = function()
  local language = M.get_language_in_current_buffer()
  if not language then
    return { list = {} }
  end

  return {
    type = language,
    list = utils.table_keys(utils.filter_table(require("code-refactor.actions." .. language), function(item)
      return item.is_available()
    end)),
  }
end

function M.show_code_actions()
  local actions = M.get_actions_under_cursor()
  if next(actions.list) == nil then
    print("No available code actions")
    return
  end

  vim.ui.select(
    actions.list,
    {
      prompt = "Code actions",
      telescope = require("telescope.themes").get_cursor(),
      format_item = function (item)
        return require("code-refactor.actions." .. actions.type .. "." .. item).title
      end
    },
    function(selected)
      if selected then
        require("code-refactor.actions." .. actions.type .. "." .. selected).run()
      end
    end
  )
end

return M

