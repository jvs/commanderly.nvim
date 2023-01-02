local function is_quickfix_open()
  for _, info in pairs(vim.fn.getwininfo()) do
    if info.quickfix == 1 then
      return true
    end
  end
  return false
end

local function is_loclist_open()
  -- TODO: Figure out how to tell if the loclist is open for the current window.
  local winid = vim.api.nvim_get_current_win()
  local wininfo = vim.fn.getwininfo(winid)[1]
  local tabnr = wininfo.tabnr
  -- local wincol = vim.fn.wincol()
  local wincol = wininfo.wincol
  for _, info in pairs(vim.fn.getwininfo()) do
    if info.loclist == 1 and info.tabnr == tabnr and info.wincol == wincol then
      return true
    end
  end
  return false
end

local function has_attached_lsp()
  local filter = { bufnr = vim.fn.bufnr() }
  local clients = vim.lsp.get_active_clients(filter)
  local num_clients = #vim.tbl_keys(clients)
  return num_clients > 0
end

-- For now, assume diagnostics start out enabled.
-- TODO: Figure out how to detect if diagnostics are enabled.
local are_diagnostics_enabled = true

local commands = {
  -- Buffers --
  {
    title = "Show Next Buffer",
    id = "next_buffer",
    desc = "Show the next buffer in the current view.",
    alias = "bnext",
  },
  {
    title = "Show Previous Buffer",
    id = "previous_buffer",
    desc = "Show the previous buffer in the current view.",
    alias = "bprevious",
  },

  -- Commands --
  {
    title = "Open Command Editor",
    desc = "Edit a command in a special command-line window.",
    run = "q:",
  },
  {
    title = "Open Search Editor",
    desc = "Edit a search string in a special command-line window.",
    run = "q/",
  },

  -- Configuration --
  {
    title = "Reload Neovim Configuration",
    id = "source_vimrc",
    desc = function()
      return ":source " .. os.getenv("MYVIMRC")
    end,
    alias = "source $MYVIMRC",
    keywords = "source vimrc",
  },

  -- Diagnostics --
  {
    title = "Show Diagnostics",
    id = "show_diagnostics",
    desc = "Show hints, warnings, and errors from language servers.",
    requires = function()
      return not are_diagnostics_enabled
    end,
    run = function()
      are_diagnostics_enabled = true
      vim.diagnostic.enable()
    end,
    keywords = "lsp",
  },
  {
    title = "Hide Diagnostics",
    id = "hide_diagnostics",
    desc = "Hide hints, warnings, and errors from language servers.",
    requires = function()
      return are_diagnostics_enabled
    end,
    run = function()
      are_diagnostics_enabled = false
      vim.diagnostic.disable()
    end,
    keywords = "lsp",
  },
  {
    title = "Move to Next Diagnostic",
    id = "next_diagnostic",
    desc = "Move the cursor to the next diagnostic in this file.",
    run = vim.diagnostic.goto_next,
    requires = has_attached_lsp,
    -- alias = "lua vim.diagnostic.goto_next()",
    keywords = "lsp",
  },
  {
    title = "Move to Previous Diagnostic",
    id = "previous_diagnostic",
    desc = "Move the cursor to the previous diagnostic in this file.",
    run = vim.diagnostic.goto_prev,
    requires = has_attached_lsp,
    -- alias = "lua vim.diagnostic.goto_prev()",
    keywords = "lsp",
  },
  {
    title = "Reveal Diagnostics Popup",
    id = "diagnostic_open_float",
    desc = "Show diagnostics in a floating window.",
    run = vim.diagnostic.open_float,
    requires = has_attached_lsp,
    keywords = "lsp",
  },
  {
    title = "Record Diagnostic Locations",
    id = "diagnostic_setloclist",
    desc = "Add diagnostics for the current file to its location list.",
    run = vim.diagnostic.setloclist,
    requires = has_attached_lsp,
    keywords = "lsp",
  },

  -- Files --
  {
    title = "New File",
    desc = "Create new untitled file.",
    alias = "enew",
  },
  {
    title = "Reload Current File",
    desc = "Reload the current file from the disk.",
    alias = "edit",
  },
  {
    title = "Revert File",
    desc = "Discard current changes and reload the current file from the disk.",
    alias = "edit!",
  },
  {
    title = "Close Current File",
    desc = "Close the current file.",
    alias = "bd",
  },
  {
    title = "Discard Current File",
    desc = "Close the current file without saving any changes.",
    alias = "bd!",
    keywords = "close without saving",
  },
  {
    title = "Close All Files",
    desc = "Close all of the currently open files.",
    alias = "%bd",
  },
  {
    title = "Save Current File",
    desc = "Write the current file to disk.",
    alias = "write",
  },

  -- Location List --
  {
    title = "Open Location Window",
    desc = "Open the loclist window for the current file.",
    requires = function()
      return not is_loclist_open()
    end,
    alias = "lopen",
    keywords = "show",
  },
  {
    title = "Close Location Window",
    desc = "Close the loclist window for the current file.",
    requires = function()
      return is_loclist_open()
    end,
    alias = "lclose",
    keywords = "hide",
  },

  -- LSP --
  {
    title = "Format Current File",
    id = "lsp_format",
    desc = "Automatically format the current file.",
    requires = has_attached_lsp,
    run = vim.lsp.buf.format,
    keywords = "lsp",
  },
  {
    title = "Rename",
    id = "lsp_rename",
    desc = "Rename all references to the symbol under the cursor.",
    requires = has_attached_lsp,
    run = vim.lsp.buf.rename,
    keywords = "lsp refactor",
  },
  {
    title = "Code Action",
    id = "lsp_code_action",
    desc = "Select a code action available at the current cursor position.",
    requires = has_attached_lsp,
    run = vim.lsp.buf.code_action,
    keywords = "lsp",
  },
  {
    title = "Jump to Definition",
    id = "lsp_goto_definition",
    desc = "Jump to the definition of the symbol under the cursor.",
    requires = has_attached_lsp,
    run = vim.lsp.buf.definition,
    keywords = "lsp",
  },
  {
    title = "View References",
    id = "telescope_lsp_references",
    desc = "View all the references to the symbol under the cursor.",
    requires = has_attached_lsp,
    alias = "Telescope lsp_references",
    keywords = "lsp telescope",
  },
  {
    title = "View Symbols",
    id = "telescope_lsp_document_symbols",
    desc = "View all the symbols defined in the current file.",
    requires = has_attached_lsp,
    alias = "Telescope lsp_document_symbols",
    keywords = "lsp telescope",
  },
  {
    title = "Show Hover Window",
    id = "lsp_hover",
    desc = (
      "Display hover information about the symbol under the cursor in a"
      .. " floating window. Calling this function twice jumps into the"
      .. " floating window."
    ),
    requires = has_attached_lsp,
    run = vim.lsp.buf.hover,
    keywords = "lsp",
  },
  {
    title = "Show Signature Help",
    id = "lsp_signature_help",
    desc = "Display the signature of the symbol under the cursor.",
    requires = has_attached_lsp,
    run = vim.lsp.buf.signature_help,
    keywords = "lsp",
  },

  -- Options --
  {
    id = "toggle_cursor_line",
    render = function()
      if vim.o.cursorline then
        return {
          title = "Hide Cursor Line",
          desc = "Do not highlight the line of the cursor.",
          run = function()
            vim.o.cursorline = false
          end,
        }
      else
        return {
          title = "Show Cursor Line",
          desc = "Highlight the line of the cursor.",
          run = function()
            vim.o.cursorline = true
          end,
        }
      end
    end,
  },
  {
    id = "toggle_line_numbers",
    render = function()
      if vim.wo.number or vim.wo.relativenumber then
        return {
          title = "Hide Line Numbers",
          desc = "Do not show line numbers.",
          run = function()
            vim.wo.number = false
            vim.wo.relativenumber = false
          end,
        }
      else
        return {
          title = "Show Line Numbers",
          desc = "Show line numbers.",
          run = function()
            vim.wo.number = true
          end,
        }
      end
    end,
  },
  {
    id = "toggle_relative_line_numbers",
    render = function()
      if vim.wo.relativenumber then
        return {
          title = "Disable Relative Line Numbers",
          desc = "Use absolute line numbers.",
          run = function()
            vim.wo.number = true
            vim.wo.relativenumber = false
          end,
        }
      else
        return {
          title = "Show Relative Line Numbers",
          desc = "Use relative line numbers.",
          run = function()
            vim.wo.relativenumber = true
          end,
        }
      end
    end,
  },
  {
    id = "toggle_word_wrap",
    render = function()
      if vim.o.wrap then
        return {
          title = "Disable Word Wrapping",
          desc = "Display each line of text on a single line.",
          run = function()
            vim.o.wrap = false
            vim.keymap.del("n", "k")
            vim.keymap.del("n", "j")
          end,
        }
      else
        return {
          title = "Enable Word Wrapping",
          desc = "Use multiple lines to display long lines of text.",
          run = function()
            vim.o.wrap = true
            vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
            vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
          end,
        }
      end
    end,
  },

  -- Paths --
  {
    title = "Copy Absolute Path",
    desc = "Copy the absolute path of the current file to the clipboard.",
    run = function()
      vim.cmd("let @+ = expand('%:p')")
      -- TODO: Figure out how to display this even when Telescope was in insert
      -- mode when this command was selected. (This comment applies to all
      -- commands that try to print messages.)
      print('Copied "' .. vim.fn.expand("%:p") .. '" to the clipboard.')
    end,
  },
  {
    title = "Copy Relative Path",
    desc = "Copy the relative path of the current file to the clipboard.",
    run = function()
      vim.cmd("let @+ = expand('%')")
      print('Copied "' .. vim.fn.expand("%") .. '" to the clipboard.')
    end,
  },
  {
    title = "Yank Absolute Path",
    desc = "Yank the absolute path of the current file.",
    run = function()
      vim.cmd('let @" = expand("%:p")')
      print('Yanked "' .. vim.fn.expand("%:p") .. '".')
    end,
  },
  {
    title = "Yank Relative Path",
    desc = "Yank the relative path of the current file.",
    run = function()
      vim.cmd('let @" = expand("%")')
      print('Yanked "' .. vim.fn.expand("%") .. '"')
    end,
  },

  -- Quickfix --
  {
    title = "Open Quickfix Window",
    desc = "Open the quickfix window.",
    requires = function()
      return not is_quickfix_open()
    end,
    alias = "copen",
  },
  {
    title = "Close Quickfix Window",
    desc = "Close the quickfix window.",
    requires = function()
      return is_quickfix_open()
    end,
    alias = "cclose",
  },

  -- Splits --
  {
    title = "Split Window Horizontally",
    id = "horizontal_split",
    desc = "Split the current window horizontally.",
    alias = "sp",
  },
  {
    title = "Split Window Vertically",
    id = "vertical_split",
    desc = "Split the current window vertically.",
    alias = "vsp",
  },
  {
    title = "Close Window",
    desc = "Close the current window.",
    alias = "quit",
    keywords = "quit",
  },
  {
    title = "Close Window (without saving)",
    desc = "Close the current window without saving any changes.",
    alias = "quit!",
    keywords = "quit",
  },
  {
    title = "Move to Left Window",
    id = "window_left",
    desc = "Move the cursor to the left window.",
    alias = "wincmd h",
  },
  {
    title = "Move to Lower Window",
    id = "window_down",
    desc = "Move the cursor to the lower window.",
    alias = "wincmd j",
  },
  {
    title = "Move to Upper Window",
    id = "window_up",
    desc = "Move the cursor to the upper window.",
    alias = "wincmd k",
  },
  {
    title = "Move to Right Window",
    id = "window_right",
    desc = "Move the cursor to the right window.",
    alias = "wincmd l",
  },

  -- Tabs --
  {
    title = "Convert Tabs to Spaces",
    id = "retab",
    desc = "Replace all tabs with spaces, using the current value of tabstop.",
    keywords = "retab",
    alias = "retab",
    -- TODO: Maybe have a prompt that asks for the value of tabstop.
  },
}

return commands
