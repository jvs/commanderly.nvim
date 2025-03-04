return {
  {
    title = "Change colorscheme",
    id = "snacks_picker_colorscheme",
    desc = "Pick from the available color schemes.",
    run = function()
      require('snacks').picker.colorschemes()
    end,
    keywords = "pick color scheme theme snacks",
  },
}
