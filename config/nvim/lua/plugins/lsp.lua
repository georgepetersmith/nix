return {
  'neovim/nvim-lspconfig',
  dependencies = {
    {'seblj/roslyn.nvim', ft = 'cs'},
    {
      'saghen/blink.cmp',
      lazy = false,
      dependencies = 'rafamadriz/friendly-snippets',
      version = 'v0.*',
      opts = { appearance = { nerd_font_variant = 'normal' } },
    },
  },
  opts = {
    servers = {
      gopls = {},
      ts_ls = {},
      yamlls = {},
      tailwindcss = {},
      jsonls = {},
      astro = {},
      marksman = {},
    }
  },
  config = function(_, opts)

    local lspconfig = require('lspconfig')
    for server, config in pairs(opts.servers) do
      config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
      lspconfig[server].setup(config)
    end

    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'LSP actions',
      callback = function(event)
        local opts = {buffer = event.buf}
        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<leader>n', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<leader>.', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        vim.keymap.set('n', 'gh', '<cmd>lua vim.diagnostic.open_float()<cr>')
      end,
    })

    require'roslyn'.setup({
      exe = "roslyn-language-server"
    })

    vim.g.rustaceanvim = {
      server = {
        on_attach = function(client, bufnr)
          vim.keymap.set("n", "K", function()
            vim.cmd.RustLsp({ "hover", "actions" })
          end, { buffer = bufnr })
        end,
      },
    }

  end
}
