local utils = require("commanderly.utils")

return {
  -- Commands --
  {
    title = "Open Command Editor",
    id = "open_command_line_window",
    desc = "Edit a command in a special command-line window.",
    run = { keys = "q:" },
  },
  {
    title = "Open Search Editor",
    id = "open_command_line_search_window",
    desc = "Edit a search string in a special command-line window.",
    run = { keys = "q/" },
  },
  {
    title = "Repeat Last Edit",
    id = "repeat_last_change",
    desc = "Repeat the last change.",
    run = { keys = "." },
  },
  {
    title = "Repeat Last Command Line",
    id = "repeat_last_command_line",
    desc = "Repeat the last command-line.",
    run = { keys = "@:" },
  },
  {
    title = "Repeat Last Commanderly Command",
    id = "commanderly_repeat",
    desc = "Repeat the last command selected from the command palette.",
  },

  -- Clipboard --
  {
    title = "Copy Selected Text",
    id = "copy_to_clipboard",
    desc = "Copy the selected text to the system clipboard.",
    mode = "visual",
    run = { keys = '"*y' },
    keywords = "clipboard edit text",
  },
  {
    title = "Cut Selected Text",
    id = "cut_to_clipboard",
    desc = 'Cut the selected text and move it to the system clipboard.',
    run = { keys = '"*d' },
    keywords = "clipboard edit text",
  },
  {
    title = "Paste From Clipboard",
    id = "paste_from_clipboard",
    desc = "Paste using the system clipboard.",
    mode = "normal",
    run = { keys = '"*p' },
    keywords = "clipboard edit text",
  },
  {
    title = "Paste From Clipboard",
    id = "paste_from_clipboard_over_selection",
    desc = "Paste using the system clipboard.",
    mode = "visual",
    run = function()
      utils.paste_over_selected_text('"*p')
    end,
    keywords = "edit text",
  },
  {
    title = "Yank",
    id = "y",
    desc = "Yank the selected text.",
    mode = "visual",
    run = { keys = "y" },
    keywords = "edit text yank",
  },
  {
    title = "Yank Current Line",
    id = "yy",
    desc = "Yank the current line.",
    mode = "normal",
    run = { keys = "yy" },
    keywords = "edit text yank",
  },
  {
    title = "Paste",
    id = "paste_over_selection",
    desc = "Paste the last yanked text.",
    mode = "visual",
    run = utils.paste_over_selected_text,
    keywords = "edit text yank",
  },
  {
    title = "Paste",
    id = "p",
    desc = "Paste the last yanked text.",
    mode = "normal",
    run = { keys = "p" },
    keywords = "edit text yank",
  },

  -- Diagnostics --
  {
    title = "Show Diagnostics",
    id = "show_diagnostics",
    desc = "Show hints, warnings, and errors from language servers.",
    requires = function()
      return not utils.are_diagnostics_enabled()
    end,
    run = utils.enable_diagnostics,
    keywords = "lsp",
  },
  {
    title = "Hide Diagnostics",
    id = "hide_diagnostics",
    desc = "Hide hints, warnings, and errors from language servers.",
    requires = utils.are_diagnostics_enabled,
    run = utils.disable_diagnostics,
    keywords = "lsp",
  },
  {
    title = "Move to Next Diagnostic",
    id = "next_diagnostic",
    desc = "Move the cursor to the next diagnostic in this file.",
    run = vim.diagnostic.goto_next,
    requires = utils.has_attached_lsp,
    keywords = "lsp",
  },
  {
    title = "Move to Previous Diagnostic",
    id = "previous_diagnostic",
    desc = "Move the cursor to the previous diagnostic in this file.",
    run = vim.diagnostic.goto_prev,
    requires = utils.has_attached_lsp,
    keywords = "lsp",
  },
  {
    title = "Reveal Diagnostics Popup",
    id = "diagnostic_open_float",
    desc = "Show diagnostics in a floating window.",
    run = vim.diagnostic.open_float,
    requires = utils.has_attached_lsp,
    keywords = "lsp show",
  },
  {
    title = "Record Diagnostic Locations",
    id = "diagnostic_setloclist",
    desc = "Add diagnostics for the current file to its location list.",
    run = vim.diagnostic.setloclist,
    requires = utils.has_attached_lsp,
    keywords = "lsp",
  },

  -- Editing --
  {
    title = "Convert Selection to Uppercase",
    id = "U",
    desc = "Convert selected text to uppercase.",
    mode = "visual",
    run = { keys = "U" },
    keywords = "text",
  },
  {
    title = "Delete Current Line",
    id = "dd",
    desc = "Delete the line currently under the cursor.",
    mode = "normal",
    run = { keys = "dd" },
  },
  {
    title = "Delete Selected Text",
    id = "d",
    desc = "Delete the currently selected text.",
    mode = "visual",
    run = { keys = "d" },
  },
  {
    title = "Undo Last Change",
    id = "u",
    desc = "Undo the last change.",
    run = { keys = "u" },
  },
  {
    title = "Redo Change",
    id = "redo_change",
    desc = "Redo one change which was undone.",
    run = { keys = "<C-R>" },
  },

  -- Files --
  {
    title = "New File",
    id = "new_file",
    desc = "Create new untitled file.",
    run = "enew",
    keywords = "create",
  },
  {
    title = "Reload Current File",
    id = "edit",
    desc = "Reload the current file from the disk.",
    run = "edit",
    keywords = "refresh",
  },
  {
    title = "Revert File",
    id = "revert_file",
    desc = "Discard current changes and reload the current file from the disk.",
    run = "edit!",
  },
  {
    title = "Close Current File",
    id = "close_file",
    desc = "Close the current file.",
    run = "bd",
  },
  {
    title = "Discard Current File",
    id = "discard_file",
    desc = "Close the current file without saving any changes.",
    run = "bd!",
    keywords = "close without saving",
  },
  {
    title = "Close All Files",
    id = "close_all_files",
    desc = "Close all of the currently open files.",
    run = "%bd",
  },
  {
    title = "Save Current File",
    id = "save_file",
    desc = "Write the current file to disk.",
    run = "write",
  },
  {
    title = "Show Next File",
    id = "next_buffer",
    desc = "Show the next buffer in the current view.",
    run = "bnext",
  },
  {
    title = "Show Previous File",
    id = "previous_buffer",
    desc = "Show the previous buffer in the current view.",
    run = "bprevious",
  },

  -- Location List --
  {
    title = "Open Location Window",
    id = "open_loclist",
    desc = "Open the loclist window for the current file.",
    requires = function()
      return not utils.is_loclist_open()
    end,
    run = "lopen",
    keywords = "show loclist",
  },
  {
    title = "Close Location Window",
    id = "close_loclist",
    desc = "Close the loclist window for the current file.",
    requires = utils.is_loclist_open,
    run = "lclose",
    keywords = "hide loclist",
  },

  -- LSP --
  {
    title = "Format Current File",
    id = "lsp_format",
    desc = "Automatically format the current file.",
    requires = utils.has_attached_lsp,
    run = vim.lsp.buf.format,
    keywords = "lsp",
  },
  {
    title = "Rename",
    id = "lsp_rename",
    desc = "Rename all references to the symbol under the cursor.",
    requires = utils.has_attached_lsp,
    run = vim.lsp.buf.rename,
    keywords = "lsp refactor",
  },
  {
    title = "Code Action",
    id = "lsp_code_action",
    desc = "Select a code action available at the current cursor position.",
    requires = utils.has_attached_lsp,
    run = vim.lsp.buf.code_action,
    keywords = "lsp",
  },
  {
    title = "Jump to Definition",
    id = "lsp_goto_definition",
    desc = "Jump to the definition of the symbol under the cursor.",
    requires = utils.has_attached_lsp,
    run = vim.lsp.buf.definition,
    keywords = "lsp",
  },
  {
    title = "Show Hover Window",
    id = "lsp_hover",
    desc = (
        "Display hover information about the symbol under the cursor in a"
            .. " floating window. Calling this function twice jumps into the"
            .. " floating window."
        ),
    requires = utils.has_attached_lsp,
    run = vim.lsp.buf.hover,
    keywords = "lsp",
  },
  {
    title = "Show Signature Help",
    id = "lsp_signature_help",
    desc = "Display the signature of the symbol under the cursor.",
    requires = utils.has_attached_lsp,
    run = vim.lsp.buf.signature_help,
    keywords = "lsp",
  },

  -- Messages --
  {
    title = "Open Messages Window",
    id = "open_messages_window",
    desc = "Open a window for viewing recent messages.",
    run = "messages",
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
            utils.set_for_all_normal_windows('number', false)
            utils.set_for_all_normal_windows('relativenumber', false)
          end,
        }
      else
        return {
          title = "Show Line Numbers",
          desc = "Show line numbers.",
          run = function()
            vim.wo.number = true
            utils.set_for_all_normal_windows('number', true)
            utils.set_for_all_normal_windows('relativenumber', false)
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
            utils.set_for_all_normal_windows('number', true)
            utils.set_for_all_normal_windows('relativenumber', false)
          end,
        }
      else
        return {
          title = "Show Relative Line Numbers",
          desc = "Use relative line numbers.",
          run = function()
            utils.set_for_all_normal_windows('number', true)
            utils.set_for_all_normal_windows('relativenumber', true)
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
      return not utils.is_quickfix_open()
    end,
    run = "copen",
  },
  {
    title = "Close Quickfix Window",
    desc = "Close the quickfix window.",
    requires = utils.is_quickfix_open,
    run = "cclose",
  },

  -- Search --
  {
    title = "Find Current Word",
    id = "find_current_word",
    desc = "Search for the word nearest to the cursor.",
    run = { keys = "*" },
    keywords = "search",
  },
  {
    title = "Find Next",
    id = "find_next",
    desc = "Repeat the last search and go to the next result.",
    run = { keys = "n" },
    keywords = "search",
  },
  {
    title = "Find Previous",
    id = "find_previous",
    desc = "Repeat the last search and go to the previous result.",
    run = { keys = "N" },
    keywords = "search",
  },

  -- Splits --
  {
    title = "Split Window Horizontally",
    id = "horizontal_split",
    desc = "Split the current window horizontally.",
    run = "sp",
  },
  {
    title = "Split Window Vertically",
    id = "vertical_split",
    desc = "Split the current window vertically.",
    run = "vsp",
  },
  {
    title = "Close Window",
    id = "close_window",
    desc = "Close the current window.",
    run = "quit",
    keywords = "quit",
  },
  {
    title = "Close Window (without saving)",
    id = "close_window_without_saving",
    desc = "Close the current window without saving any changes.",
    run = "quit!",
    keywords = "quit",
  },
  {
    title = "Move to Left Window",
    id = "window_left",
    desc = "Move the cursor to the left window.",
    run = "wincmd h",
  },
  {
    title = "Move to Lower Window",
    id = "window_down",
    desc = "Move the cursor to the lower window.",
    run = "wincmd j",
  },
  {
    title = "Move to Upper Window",
    id = "window_up",
    desc = "Move the cursor to the upper window.",
    run = "wincmd k",
  },
  {
    title = "Move to Right Window",
    id = "window_right",
    desc = "Move the cursor to the right window.",
    run = "wincmd l",
  },
  {
    title = "Close Other Windows",
    id = "window_close_others",
    desc = "Make the current window the only one on the screen.",
    run = "wincmd o",
    keywords = "focus",
  },
  {
    title = "Rotate Windows Right",
    id = "window_rotate_right",
    desc = "Rotate windows downwards and rightwards.",
    run = "wincmd r",
  },
  {
    title = "Rotate Windows Left",
    id = "window_rotate_left",
    desc = "Rotate windows upwards and leftwards.",
    run = "wincmd R",
  },
  {
    title = "Auto-Resize Windows",
    id = "window_auto_resize",
    desc = "Resize all windows to be roughly equally high and wide.",
    run = "wincmd =",
  },
  {
    title = "Increase Window Height",
    id = "increase_window_height",
    desc = "Increase the height of the current window.",
    run = "resize +2",
  },
  {
    title = "Decrease Window Height",
    id = "decrease_window_height",
    desc = "Decrease the height of the current window.",
    run = "resize -2",
  },
  {
    title = "Increase Window Width",
    id = "increase_window_width",
    desc = "Increase the width of the current window.",
    run = "vertical resize +2",
  },
  {
    title = "Decrease Window Width",
    id = "decrease_window_width",
    desc = "Decrease the width of the current window.",
    run = "vertical resize -2",
  },

  -- Tabs --
  {
    title = "Convert Tabs to Spaces",
    id = "retab",
    desc = "Replace all tabs with spaces, using the current value of tabstop.",
    keywords = "retab",
    run = "retab",
    -- TODO: Maybe have a prompt that asks for the value of tabstop.
  },

  -- Text --
  {
    title = "Remove Trailing Whitespace",
    id = "remove_trailing_whitespace",
    desc = "Delete trailing whitespace in the current file.",
    run = function()
      local curpos = vim.api.nvim_win_get_cursor(0)
      vim.cmd([[keeppatterns %s/\s\+$//e]])
      vim.api.nvim_win_set_cursor(0, curpos)
    end,
    keywords = "delete",
  },
}
