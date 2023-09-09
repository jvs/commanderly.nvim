local has_telescope, telescope = pcall(require, 'telescope')

if not has_telescope then
  error('This plugins requires nvim-telescope/telescope.nvim')
end

local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")

local strings = require("plenary.strings")
local commanderly = require("commanderly")


local user_opts = {
  cache_picker = false,

  theme = "commanderly",
  results_title = false,
  sorting_strategy = "ascending",
  layout_strategy = "center",
  layout_config = {
    width = function(_, max_columns, _)
      return math.min(max_columns, 108)
    end,

    height = function(_, _, max_lines)
      return math.min(max_lines, 20)
    end,
  },

  border = true,
  borderchars = {
    prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
    results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
    preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
  },

  previewer = false,
  -- winblend = 10,
}


local make_finder = function(opts, commands)
  local title_width = 0
  local desc_width = 0
  local keys_width = 0

  local padding = 4
  local max_title_width = 40
  local max_keys_width = 10
  local expected_width = 108

  local results = {}

  for _, command in pairs(commands) do
    table.insert(results, command)
    local next_title_width = strings.strdisplaywidth(command.title or "")
    local next_keys_width = strings.strdisplaywidth(command.keymapping or "")
    title_width = math.max(title_width, next_title_width)
    keys_width = math.max(keys_width, next_keys_width)
  end

  title_width = math.min(title_width + padding, max_title_width)
  keys_width = math.min(keys_width, max_keys_width)
  desc_width = expected_width - title_width - keys_width - 10

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = title_width },
      { width = desc_width },
      { width = keys_width },
    }
  }

  local make_display = function(entry)
    local command = entry.value
    return displayer {
      { command.title or "" },
      { command.desc or "", "TelescopeResultsComment" },
      { command.shortcut or "", "TelescopeResultsIdentifier" },
    }
  end

  table.sort(results, function(a, b)
    if a.title ~= b.title then
      return a.title < b.title
    else
      return (a.desc or "") < (b.desc or "")
    end
  end)

  return finders.new_table {
    results = results,
    entry_maker = function(command)
      return {
        value = command,
        display = make_display,
        ordinal = (command.title or "") .. " " .. (command.keywords or ""),
      }
    end,
  }
end


local setup = function(opts)
  user_opts = vim.tbl_extend("force", user_opts, opts or {})
end


local main = function(opts)
  opts = vim.tbl_extend("force", user_opts, opts or {})

  pickers.new(opts, {
    prompt_title = "Commands",
    finder = make_finder(opts, commanderly.get_commands()),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          commanderly.run(selection.value)
        end
      end)
      return true
    end,
  }):find()
end


return telescope.register_extension {
  setup = setup,
  exports = { commanderly = main },
}
