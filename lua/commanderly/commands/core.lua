local function is_quickfix_open()
  for _, info in pairs(vim.fn.getwininfo()) do
    if info.quickfix == 1 then
      return true
    end
  end
  return false
end

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
  {
    title = "Update Plugins",
    id = "packer_sync",
    desc = "Source vimrc and run PackerSync",
    alias = "source $MYVIMRC | PackerSync",
    requires = "packer",
    keywords = "packer sync",
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
    title = "Close All Files",
    desc = "Close all of the currently open files.",
    alias = "%bd",
  },
  {
    title = "Save Current File",
    desc = "Write the current file to disk.",
    alias = "write",
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
    run = "<C-W><C-H>",
  },
  {
    title = "Move to Lower Window",
    id = "window_down",
    desc = "Move the cursor to the lower window.",
    run = "<C-W><C-J>",
  },
  {
    title = "Move to Upper Window",
    id = "window_up",
    desc = "Move the cursor to the upper window.",
    run = "<C-W><C-K>",
  },
  {
    title = "Move to Right Window",
    id = "window_right",
    desc = "Move the cursor to the right window.",
    run = "<C-W><C-L>",
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
