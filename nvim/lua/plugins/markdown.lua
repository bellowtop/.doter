return {
  -- Markdown support (highlighting is built into Neovim 0.12 via treesitter)
  {
    "mzlogin/vim-markdown-toc",
    ft = "markdown",
    cmd = {
      "GenTocGFM",
      "GenTocRedcarpet",
      "GenTocGitLab",
      "UpdateToc",
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    build = ":call mkdp#util#install()",
    ft = "markdown",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
    },
  },
}
