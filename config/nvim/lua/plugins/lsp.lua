return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v3.x',
  dependencies = {
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/cmp-path'},
    {'hrsh7th/nvim-cmp'},
    {'saadparwaiz1/cmp_luasnip'},
    {'L3MON4D3/LuaSnip', opts = {}, dependencies = { 'rafamadriz/friendly-snippets' }},
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig'},
    {
      'seblj/roslyn.nvim',
      enabled = false,
      commit="11168911d35ea276b1fbd8fa33f7564325b6c624",
      opts = {},
      ft = 'cs'
    },
  },
  config = function ()
    local lsp_zero = require('lsp-zero')

    local lsp_attach = function(client, bufnr)
      local opts = {buffer = bufnr}
      lsp_zero.default_keymaps(opts)
      vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
      vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
      vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
      vim.keymap.set('n', '<leader>n', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
      vim.keymap.set('n', '<leader>.', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
      vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    end

    lsp_zero.on_attach(lsp_attach)

    local capabilies = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities() )
    lsp_zero.extend_lspconfig({
      capabilities = capabilities
    })

    require('mason').setup({})
    require('mason-lspconfig').setup({
      ensure_installed = {
        'jsonls',
        'nil_ls',
        'yamlls',
        'astro',
        'bashls',
        'cssls',
        'css_variables',
        'dockerls',
        'html',
        'htmx',
        'marksman',
        'sqls',
        'tailwindcss',
      },
      handlers = {
        function(server_name)
          require('lspconfig')[server_name].setup({})
        end,
      }
    })

    require'lspconfig'.rust_analyzer.setup{}

    local cmp = require('cmp')
    local cmp_action = require('lsp-zero').cmp_action()
    local cmp_format = require('lsp-zero').cmp_format({details = true})

    require('luasnip.loaders.from_vscode').lazy_load()

    cmp.setup({
      sources = {
        {name = 'nvim_lsp'},
        {name = 'luasnip'},
        {name = 'path'}
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
      }),
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      formatting = cmp_format,
    })
  end,
}
