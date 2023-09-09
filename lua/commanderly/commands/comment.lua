  -- Two simple commands to toggle comments.
  -- Requires 'numToStr/Comment.nvim'.
return {
  {
    title = "Toggle Comment",
    id = "toggle_comment_current_line",
    desc = "Comment or uncomment current line.",
    run = function()
      require("Comment.api").toggle.linewise.current()
    end,
    mode = "normal",
  },
  {
    title = "Toggle Comment",
    id = "toggle_comment_selected_lines",
    desc = "Comment or uncomment currently selected lines.",
    run = {
      keys = "<ESC><CMD>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>"
    },
    mode = "visual",
  },
}
