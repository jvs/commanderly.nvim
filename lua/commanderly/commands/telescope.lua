local utils = require("commanderly.utils")

local commands = {
  {
    title = "Change colorscheme",
    id = "telescope_colorscheme",
    desc = "Pick from the available color schemes.",
    keywords = "pick theme",
    run = "Telescope colorscheme",
  },
  {
    title = "Explore Vim Options",
    id = "telescope_vim_options",
    desc = "Explore vim options and view or modify their current values.",
    run = "Telescope vim_options",
    keywords = "settings",
  },
  {
    title = "Find Buffers",
    id = "telescope_buffers",
    desc = "Search for currently open buffers.",
    run = "Telescope buffers",
  },
  {
    title = "Find Files",
    id = "telescope_find_files",
    desc = "Search for files in the current working directory.",
    keywords = "search",
    run = "Telescope find_files",
  },
  {
    title = "Find Recent Files",
    id = "telescope_oldfiles",
    desc = "Search for previously open files.",
    keywords = "search",
    run = "Telescope oldfiles",
  },
  {
    title = "Find Repository Files",
    id = "telescope_git_files",
    desc = "Search for files in the current git repository.",
    keywords = "git",
    run = "Telescope git_files",
  },
  {
    title = "View Git Commits",
    id = "telescope_git_commits",
    desc = "List git commits.",
    keywords = "history",
    run = "Telescope git_commits",
  },
  {
    title = "View File History",
    id = "telescope_git_bcommits",
    desc = "List git commits for the current file.",
    keywords = "git commits",
    run = "Telescope git_bcommits",
  },
  {
    title = "View Git Branches",
    id = "telescope_git_branches",
    desc = "List git branches for the current repostory.",
    keywords = "checkout",
    run = "Telescope git_branches",
  },
  {
    title = "View Git Status",
    id = "telescope_git_status",
    desc = "View the current changes in each file.",
    run = "Telescope git_status",
  },
  {
    title = "View Git Stash",
    id = "telescope_git_stash",
    desc = "View the currently stashed items in git.",
    run = "Telescope git_stash",
  },
  {
    title = "Resume Search",
    id = "telescope_resume",
    desc = "Resume the previous search.",
    keywords = "back find",
    run = "Telescope resume",
  },
  {
    title = "View References",
    id = "telescope_lsp_references",
    desc = "View all the references to the symbol under the cursor.",
    requires = utils.has_attached_lsp,
    run = "Telescope lsp_references",
    keywords = "lsp telescope",
  },
  {
    title = "View Symbols",
    id = "telescope_lsp_document_symbols",
    desc = "View all the symbols defined in the current file.",
    requires = utils.has_attached_lsp,
    run = "Telescope lsp_document_symbols",
    keywords = "lsp telescope",
  },
  {
    title = "Search Definitions",
    id = "telescope_treesitter",
    desc = "Search variable names and functions in the current file.",
    keywords = "variables functions names definitions",
    run = "Telescope treesitter",
  },
  {
    title = "Search Commands",
    id = "telescope_commands",
    desc = "Search all of the currently available commands.",
    run = "Telescope commands",
  },
  {
    title = "Search Command History",
    id = "telescope_command_history",
    desc = "Search commands that were executed recently.",
    run = "Telescope command_history",
  },
  {
    title = "Search in Current File",
    id = "telescope_current_buffer_fuzzy_find",
    desc = "Fuzzily search for a string in the current file.",
    run = "Telescope current_buffer_fuzzy_find",
  },
  {
    title = "Search in Files",
    id = "telescope_live_grep",
    desc = "Search for a string in the current working directory.",
    keywords = "find grep",
    run = "Telescope live_grep",
  },
  {
    title = "Search for Current Word",
    id = "telescope_grep_string",
    desc = "Searches for the string under the cursor in the current working directory.",
    keywords = "files find grep word",
    run = "Telescope grep_string",
  },
  {
    title = "Search Help Tags",
    id = "telescope_help_tags",
    desc = "Lists available help tags and opens a new window with the relevant help info.",
    run = "Telescope help_tags",
  },
  {
    title = "Search Keymappings",
    id = "telescope_keymaps",
    desc = "Search all of the current keymappings.",
    keywords = "find key mapping keymap",
    run = "Telescope keymaps",
  },
  {
    title = "Search Location List",
    id = "telescope_loclist",
    desc = "Search items from the current window's location list.",
    run = "Telescope loclist",
  },
  {
    title = "Search Quickfix List",
    id = "telescope_quickfix",
    desc = "Search items in the quickfix list.",
    run = "Telescope quickfix",
  },
  {
    title = "Search Diagnostics",
    id = "telescope_diagnostics",
    desc = "Search all current diagnostics.",
    run = "Telescope diagnostics",
  },
  {
    title = "Open Telescope",
    id = "telescope",
    desc = "View a list of available fuzzy finders.",
    run = "Telescope search tool",
  },
}

return commands
