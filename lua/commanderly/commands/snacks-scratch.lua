return {
  {
    title = "Toggle Scratch Buffer",
    id = "snacks_scratch_toggle",
    desc = "Toggle scratch buffer.",
    run = function()
      require('snacks').scratch()
    end,
    keywords = "snacks scratch",
  },
  {
    title = "Select Scratch Buffer",
    id = "snacks_scratch_select",
    desc = "Select scratch buffer.",
    run = function()
      require('snacks').scratch.select()
    end,
    keywords = "snacks scratch",
  },
}
