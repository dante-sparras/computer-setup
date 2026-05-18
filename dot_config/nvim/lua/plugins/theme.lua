return {
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      styles = {
        comments = "italic",
        keywords = "italic",
      },
    },
    config = function(_, opts)
      require("onedarkpro").setup(opts)
      vim.cmd.colorscheme("onedark_dark")
    end,
  },
}
