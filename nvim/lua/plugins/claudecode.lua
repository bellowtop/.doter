local toggle_key = "<C-t>"

-- ClaudeCode terminal command switcher using environment variable
-- claudecode.nvim captures terminal_cmd at setup() time, so setting the env
-- var alone is not enough; re-apply it through terminal.setup() to take
-- effect in the running session.
local function switch_claude_terminal_cmd(new_cmd)
  vim.env.CLAUDE_TERMINAL_CMD = new_cmd
  local ok, terminal = pcall(require, "claudecode.terminal")
  if ok and type(terminal.setup) == "function" then
    terminal.setup({}, new_cmd, {})
  end
  print("Switched ClaudeCode terminal command to: " .. new_cmd)
end

-- Create user commands for switching terminal commands
vim.api.nvim_create_user_command('ClaudeDefault', function()
  switch_claude_terminal_cmd('claude')
end, {})

vim.api.nvim_create_user_command('ClaudeCCR', function()
  switch_claude_terminal_cmd('ccr code')
end, {})

vim.api.nvim_create_user_command('ClaudeDS', function()
  switch_claude_terminal_cmd('claude-ds')
end, {})

return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    lazy = false,  -- 立即加载插件
    keys = {
      -- 主要的 toggle 快捷键
      { toggle_key, "<cmd>ClaudeCodeFocus<cr>", desc = "Claude Code", mode = { "n", "x" } },
      -- 备用快捷键，如果 C-t 也有问题
      { "<C-,>", "<cmd>ClaudeCodeFocus<cr>", desc = "Claude Code (backup)", mode = { "n", "x" } },

      -- 其他常用快捷键
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
    opts = {
      -- 动态获取终端命令，支持运行时切换
      terminal_cmd = vim.env.CLAUDE_TERMINAL_CMD or "claude",

      terminal = {
        -- 终端提供者
        provider = "snacks",

        ---@module "snacks"
        ---@type snacks.win.Config|{}
        snacks_win_opts = {
          position = "float",
          width = 0.9,
          height = 0.9,
          border = "rounded",
          title = " Claude Code ",
          title_pos = "center",
          keys = {
            claude_hide = {
              toggle_key,
              function(self)
                self:hide()
              end,
              mode = "t",
              desc = "Hide",
            },
            claude_hide_backup = {
              "<C-,>",
              function(self)
                self:hide()
              end,
              mode = "t",
              desc = "Hide (backup)",
            },
          },
          -- 环境变量配置
          env = {
            -- 在这里添加你的环境变量
            -- 例如：HTTP_PROXY = "http://localhost:9910",
            -- 或者：CLAUDE_API_KEY = "your_key_here",
          },
        },
      },
    },
  },
}
