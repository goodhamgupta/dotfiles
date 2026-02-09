---@type LazySpec
return {
  {
    "lspcontainers/lspcontainers.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    lazy = true,
  },
  {
    "AstroNvim/astrolsp",
    opts = function(_, opts)
      local supported_servers = {
        bashls = "bashls",
        clangd = "clangd",
        basedpyright = "pyright",
        denols = "denols",
        dockerls = "dockerls",
        gopls = "gopls",
        graphql = "graphql",
        html = "html",
        intelephense = "intelephense",
        jsonls = "jsonls",
        lemminx = "lemminx",
        lua_ls = "lua_ls",
        omnisharp = "omnisharp",
        powershell_es = "powershell_es",
        prismals = "prismals",
        pylsp = "pylsp",
        pyright = "pyright",
        rust_analyzer = "rust_analyzer",
        solargraph = "solargraph",
        svelte = "svelte",
        tailwindcss = "tailwindcss",
        terraformls = "terraformls",
        ts_ls = "tsserver",
        tsserver = "tsserver",
        volar = "vuels",
        vuels = "vuels",
        yamlls = "yamlls",
      }

      local function apply_lspcontainer(server, server_opts)
        server_opts = server_opts or {}
        local container_server = supported_servers[server]
        if not (container_server and vim.fn.executable "docker" == 1) then return server_opts end

        local lspcontainers = require "lspcontainers"

        local function container_root(new_root_dir)
          local git_dir = vim.fs.find(".git", { path = new_root_dir, upward = true })[1]
          if git_dir then return vim.fs.dirname(git_dir) end
          return new_root_dir
        end

        if server == "pyright" or server == "basedpyright" then
          local user_root_dir = server_opts.root_dir
          server_opts.root_dir = function(fname)
            local detected_root
            if type(user_root_dir) == "function" then detected_root = user_root_dir(fname) end
            if type(detected_root) ~= "string" or detected_root == "" then
              detected_root = vim.fs.dirname(fname)
            end
            return container_root(detected_root)
          end
        end

        local user_before_init = server_opts.before_init
        server_opts.before_init = function(params, config)
          params.processId = vim.NIL
          if user_before_init then return user_before_init(params, config) end
        end

        local user_on_new_config = server_opts.on_new_config
        server_opts.on_new_config = function(new_config, new_root_dir)
          if user_on_new_config then user_on_new_config(new_config, new_root_dir) end
          new_config.cmd = lspcontainers.command(container_server, { root_dir = container_root(new_root_dir) })
        end

        return server_opts
      end

      opts.handlers = opts.handlers or {}
      local default_handler = opts.handlers[1]

      opts.handlers[1] = function(server, server_opts)
        server_opts = apply_lspcontainer(server, server_opts)

        if default_handler then
          return default_handler(server, server_opts)
        end

        require("lspconfig")[server].setup(server_opts)
      end

      for server_name, handler in pairs(opts.handlers) do
        if type(server_name) == "string" and type(handler) == "function" then
          opts.handlers[server_name] = function(server, server_opts)
            return handler(server, apply_lspcontainer(server, server_opts))
          end
        end
      end
    end,
  },
}
