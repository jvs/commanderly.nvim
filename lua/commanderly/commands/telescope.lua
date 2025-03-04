-- Commands for opening Telescope.
-- Requires 'nvim-telescope/telescope.nvim'.

local utils = require("commanderly.utils")

return {
  -- {
  --   title = "Change colorscheme",
  --   id = "telescope_colorscheme",
  --   desc = "Pick from the available color schemes.",
  --   run = "Telescope colorscheme",
  --   keywords = "pick theme telescope",
  -- },
  {
    title = "Explore Vim Options",
    id = "telescope_vim_options",
    desc = "Explore vim options and view or modify their current values.",
    run = "Telescope vim_options",
    keywords = "settings telescope",
  },
  {
    title = "Find Buffers",
    id = "telescope_buffers",
    desc = "Search for currently open buffers.",
    run = "Telescope buffers",
    keywords = "telescope",
  },
  {
    title = "Find Files",
    id = "telescope_find_files",
    desc = "Search for files in the current working directory.",
    run = "Telescope find_files",
    keywords = "search telescope",
  },
  {
    title = "Find Recent Files",
    id = "telescope_oldfiles",
    desc = "Search for previously open files.",
    run = "Telescope oldfiles",
    keywords = "search telescope",
  },
  {
    title = "Find Repository Files",
    id = "telescope_git_files",
    desc = "Search for files in the current git repository.",
    run = "Telescope git_files",
    keywords = "git telescope",
  },
  {
    title = "View Git Commits",
    id = "telescope_git_commits",
    desc = "List git commits.",
    run = "Telescope git_commits",
    keywords = "history git telescope",
  },
  {
    title = "View File History",
    id = "telescope_git_bcommits",
    desc = "List git commits for the current file.",
    run = "Telescope git_bcommits",
    keywords = "git commits telescope",
  },
  {
    title = "View Git Branches",
    id = "telescope_git_branches",
    desc = "List git branches for the current repostory.",
    run = "Telescope git_branches",
    keywords = "checkout git telescope",
  },
  {
    title = "View Git Status",
    id = "telescope_git_status",
    desc = "View the current changes in each file.",
    run = "Telescope git_status",
    keywords = "git telescope",
  },
  {
    title = "View Git Stash",
    id = "telescope_git_stash",
    desc = "View the currently stashed items in git.",
    run = "Telescope git_stash",
    keywords = "git telescope",
  },
  {
    title = "Resume Search",
    id = "telescope_resume",
    desc = "Resume the previous search.",
    run = function()
      require("telescope.builtin").resume({ initial_mode = "normal" })
    end,
    keywords = "back find telescope",
  },
  {
    title = "Find Definitions",
    id = "telescope_lsp_definitions",
    desc = "Find the definition of the symbol under the cursor.",
    requires = utils.has_attached_lsp,
    -- run = "Telescope lsp_definitions",
    run = function()
      require('telescope.builtin').lsp_definitions({ initial_mode = "normal" })
    end,
    keywords = "lsp telescope",
  },
  {
    title = "Find Type Definition",
    id = "telescope_lsp_type_definitions",
    desc = "Find the type of the symbol under your cursor.",
    requires = utils.has_attached_lsp,
    run = function()
      require('telescope.builtin').lsp_type_definitions({ initial_mode = "normal" })
    end,
    keywords = "lsp telescope",
  },
  {
    title = "Find References",
    id = "telescope_lsp_references",
    desc = "View references to the symbol under the cursor.",
    requires = utils.has_attached_lsp,
    -- run = "Telescope lsp_references",
    run = function()
      require('telescope.builtin').lsp_references({ initial_mode = "normal" })
    end,
    keywords = "lsp telescope",
  },
  -- {
  --   title = "View Symbols",
  --   id = "telescope_lsp_document_symbols",
  --   desc = "View all the symbols defined in the current file.",
  --   requires = utils.has_attached_lsp,
  --   run = "Telescope lsp_document_symbols",
  --   keywords = "lsp telescope",
  -- },
  {
    title = "Search Document Symbols",
    id = "telescope_lsp_document_symbols",
    desc = "Fuzzy find all the symbols in your current document.",
    requires = utils.has_attached_lsp,
    run = "Telescope lsp_document_symbols",
    -- run = function()
    --   require('telescope.builtin').lsp_document_symbols()
    -- end,
    keywords = "lsp telescope",
  },
  {
    title = "Search Workspace Symbols",
    id = "telescope_lsp_workspace_symbols",
    desc = "Fuzzy find all the symbols in your current workspace.",
    requires = utils.has_attached_lsp,
    run = "Telescope lsp_dynamic_workspace_symbols",
    -- run = function()
    --   require('telescope.builtin').lsp_dynamic_workspace_symbols()
    -- end,
    keywords = "lsp telescope",
  },
  {
    title = "Search Treesitter",
    id = "telescope_treesitter",
    desc = "Search variable names and functions in the current file.",
    run = "Telescope treesitter",
    keywords = "variables functions names definitions telescope",
  },
  {
    title = "Search Commands",
    id = "telescope_commands",
    desc = "Search all of the currently available commands.",
    run = "Telescope commands",
    keywords = "telescope",
  },
  {
    title = "Search Command History",
    id = "telescope_command_history",
    desc = "Search commands that were executed recently.",
    run = "Telescope command_history",
    keywords = "telescope",
  },
  {
    title = "Search in Current File",
    id = "telescope_current_buffer_fuzzy_find",
    desc = "Fuzzily search for a string in the current file.",
    run = "Telescope current_buffer_fuzzy_find",
    keywords = "telescope",
  },
  {
    title = "Search in Files",
    id = "telescope_live_grep",
    desc = "Search for a string in the current working directory.",
    run = "Telescope live_grep",
    keywords = "find grep telescope",
  },
  {
    title = "Search for Current Word",
    id = "telescope_grep_string",
    desc = "Searches for the string under the cursor in the current working directory.",
    run = "Telescope grep_string",
    keywords = "files find grep word telescope",
  },
  {
    title = "Search Help Tags",
    id = "telescope_help_tags",
    desc = "Lists available help tags and opens a new window with the relevant help info.",
    run = "Telescope help_tags",
    keywords = "telescope",
  },
  {
    title = "Search Keymappings",
    id = "telescope_keymaps",
    desc = "Search all of the current keymappings.",
    run = "Telescope keymaps",
    keywords = "keymapping telescope",
  },
  {
    title = "Search Location List",
    id = "telescope_loclist",
    desc = "Search items from the current window's location list.",
    run = "Telescope loclist",
    keywords = "telescope loclist",
  },
  {
    title = "Search Quickfix List",
    id = "telescope_quickfix",
    desc = "Search items in the quickfix list.",
    run = "Telescope quickfix",
    keywords = "telescope",
  },
  {
    title = "Search Diagnostics",
    id = "telescope_diagnostics",
    desc = "Search all current diagnostics.",
    run = "Telescope diagnostics",
    keywords = "telescope",
  },
  {
    title = "View All Registers",
    id = "telescope_registers",
    desc = "Search all current registers.",
    run = "Telescope registers",
    keywords = "search telescope",
  },
  {
    title = "Open Telescope",
    id = "telescope",
    desc = "View a list of available fuzzy finders.",
    run = "Telescope",
    keywords = "fuzzy search tool telescope",
  },
}
