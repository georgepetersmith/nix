return {
  "ibhagwan/fzf-lua",
  opts = {
    "skim",
    keymap = {
      builtin = {
        true,
        ["<Esc>"] = "hide",
      },
    },
    winopts = {
      preview = {
        hidden = "hidden"
      }
    },
  },
  keys = {
    { '<leader>f', '<cmd>FzfLua files<cr>' },
    { '<leader>/', '<cmd>FzfLua live_grep<cr>' },
    { '<leader>b', '<cmd>FzfLua buffers<cr>' },
    { '<leader>h', '<cmd>FzfLua help_tags<cr>' },
    { '<leader>;', '<cmd>FzfLua resume<cr>' },
    { '<leader>i', '<cmd>FzfLua lsp_finder<cr>' },
    { '<leader>s', '<cmd>FzfLua lsp_document_symbols<cr>' },
    { '<leader>S', '<cmd>FzfLua lsp_workspace_symbols<cr>' },
    { '<leader>d', '<cmd>FzfLua lsp_document_diagnostics<cr>' },
    { 'gr', '<cmd>FzfLua lsp_references<cr>' },
    { 'gi', '<cmd>FzfLua lsp_implementations<cr>' },
    { 'gD', '<cmd>FzfLua lsp_declarations<cr>' },
  },
}
