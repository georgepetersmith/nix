return {
  'neovim/nvim-lspconfig',
  dependencies = {
    {'seblj/roslyn.nvim', ft = 'cs'},
    {
      'saghen/blink.cmp',
      lazy = false,
      dependencies = 'rafamadriz/friendly-snippets',
      version = 'v0.*',
    }
  },
  config = function()

    local lspconfig = require('lspconfig')
    for server, config in pairs(opts.servers) do
      -- passing config.capabilities to blink.cmp merges with the capabilities in your
      -- `opts[server].capabilities, if you've defined it
      config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
      lspconfig[server].setup(config)
    end

    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'LSP actions',
      callback = function(event)
        local opts = {buffer = event.buf}

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        vim.keymap.set('n', 'gh', '<cmd>lua vim.diagnostic.open_float()<cr>')
      end,
    })

    lspconfig.rust_analyzer.setup({})
    lspconfig.ts_ls.setup({})
    lspconfig.bashls.setup({})
    lspconfig.yamlls.setup({})
    lspconfig.tailwindcss.setup({})
    lspconfig.jsonls.setup({})
    lspconfig.astro.setup({})
    lspconfig.marksman.setup({})
    lspconfig.gopls.setup({})

    require'roslyn'.setup({
      exe = "roslyn-language-server"
    })

  end
}
