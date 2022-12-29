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
    preview_cutoff = 1,

    width = function(_, max_columns, _)
      return math.min(max_columns, 100)
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
}


local make_finder = function(opts, commands)
  local max_title_width = 0
  local max_desc_width = 0
  local results = {}

  for _, command in pairs(commands) do
    table.insert(results, command)
    local next_title_width = strings.strdisplaywidth(command.title or "")
    local next_desc_width = strings.strdisplaywidth(command.desc or "")

    max_title_width = math.max(max_title_width, next_title_width)
    max_desc_width = math.max(max_desc_width, next_desc_width)
  end

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = max_title_width + 4 },
      { width = max_desc_width },
    }
  }

  local make_display = function(entry)
    local command = entry.value
    return displayer {
      { command.title or "", "TelescopeResultsIdentifier" },
      { command.desc or "", "TelescopeResultsComment" },
    }
  end

  table.sort(results, function(a, b) return a.title <= b.title end)

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
    finder = make_finder(opts, commanderly.commands),
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


return telescope.register_extension{
  setup = setup,
  exports = { commanderly = main },
}
