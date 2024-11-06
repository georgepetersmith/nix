return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  enabled = true,
  dependencies = { 
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }
  },
  opts = {
    defaults = {
      path_display = { 'smart' }
    },
    pickers = {
      find_files = {
        theme = "dropdown",
        previewer = false
      }
    }
  },
  keys = {
    { '<leader>f', '<cmd>Telescope find_files<cr>' },
    { '<leader>/', '<cmd>Telescope live_grep<cr>' },
    { '<leader>b', '<cmd>Telescope buffers<cr>' },
    { '<leader>h', '<cmd>Telescope help_tags<cr>' },
    { '<leader>;', '<cmd>Telescope resume<cr>' },
    { '<leader>i', '<cmd>Telescope lsp_finder<cr>' },
    { 'gr', '<cmd>Telescope lsp_references<cr>' },
    { 'gi', '<cmd>Telescope lsp_implementations<cr>' },
    { '<leader>s', '<cmd>Telescope lsp_document_symbols<cr>' },
    { '<leader>S', '<cmd>Telescope lsp_workspace_symbols<cr>' },
    { '<leader>d', '<cmd>Telescope lsp_document_diagnostics<cr>' }
  },
  config = function()
    require('telescope').load_extension('fzf')
  end
}
