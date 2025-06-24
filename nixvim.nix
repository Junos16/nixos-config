{ config, pkgs, inputs, nixvim, ... }:

{
  imports = [ nixvim.homeManagerModules.nixvim ];
  
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    
    colorschemes.cyberdream = {
      enable = true;
      settings = {
        transparent = true;
        italic_comments = true;
        hide_fillchars = true;
        borderless_telescope = true;
        terminal_colors = true;
      };
    };
    
    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      swapfile = false;
      backup = false;
      undofile = true;
      hlsearch = false;
      incsearch = true;
      termguicolors = true;
      scrolloff = 8;
      signcolumn = "yes";
      updatetime = 50;
      colorcolumn = "80";
      cursorline = true;
      clipboard = "unnamedplus";
    };

    clipboard.providers.wl-copy.enable = true;	
    globals.mapleader = " ";
    
    keymaps = [
      { mode = "n"; key = "<leader>pv"; action = "<cmd>Ex<CR>"; }
      { mode = "v"; key = "J"; action = ":m '>+1<CR>gv=gv"; }
      { mode = "v"; key = "K"; action = ":m '<-2<CR>gv=gv"; }
      { mode = "n"; key = "<C-d>"; action = "<C-d>zz"; }
      { mode = "n"; key = "<C-u>"; action = "<C-u>zz"; }
      { mode = "n"; key = "n"; action = "nzzzv"; }
      { mode = "n"; key = "N"; action = "Nzzzv"; }

      # LaTeX specific
      { mode = "n"; key = "<leader>ll"; action = "<cmd>VimtexCompile<CR>"; }
      { mode = "n"; key = "<leader>lv"; action = "<cmd>VimtexView<CR>"; }
      { mode = "n"; key = "<leader>lc"; action = "<cmd>VimtexClean<CR>"; }
      { mode = "n"; key = "<leader>le"; action = "<cmd>VimtexErrors<CR>"; }
      { mode = "n"; key = "<leader>lt"; action = "<cmd>VimtexTocToggle<CR>"; }
      
      # Typst specific  
      { mode = "n"; key = "<leader>tt"; action = "<cmd>TypstWatch<CR>"; }
      { mode = "n"; key = "<leader>tv"; action = "<cmd>TypstPreview<CR>"; }
      
      # Markdown
      { mode = "n"; key = "<leader>mp"; action = "<cmd>MarkdownPreview<CR>"; }
      { mode = "n"; key = "<leader>ms"; action = "<cmd>MarkdownPreviewStop<CR>"; }
    ];
    
    plugins = {

      vimtex = {
        enable = true;
        texlivePackage = pkgs.texliveFull;
        # bibliography = [ "~/references/zotero.bib" ];
        settings = {
          view_method = "zathura";
          compiler_method = "latexmk";
          compiler_latexmk = {
            continuous = 1;
            callback = 1;
          };
          quickfix_mode = 0;
          view_automatic = 1;
          view_forward_search_on_start = 0;
        };
      };

      typst-vim = {
        enable = true;
        settings = {
          auto_open_quickfix = false;
          pdf_viewer = "zathura";
        };
      };

      markdown-preview = {
        enable = true;
        settings = {
          auto_start = 0;
          auto_close = 1;
          refresh_slow = 0;
          command_for_global = 0;
          open_to_the_world = 0;
          open_ip = "127.0.0.1";
          browser = "firefox";
          echo_preview_url = 0;
          browserfunc = "";
          preview_options = {
            disable_sync_scroll = 0;
            sync_scroll_type = "middle";
          };
          filetypes = ["markdown"];
        };
      };
  
      cmp.settings = {
        autoEnableSources = true;
        sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
          { name = "bibtex"; } 
        ];
      };
      
      lualine = {
        enable = true;
        theme = "auto";
      };
      
      nvim-tree = {
        enable = true;
        openOnSetup = false;
      };
      
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
        };
      };
      
      treesitter = {
        enable = true;
        nixGrammars = true;
      };
      
      lsp = {
        enable = true;
        servers = {
          nil-ls.enable = true; # Nix LSP
          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          tsserver.enable = true;
          pyright.enable = true;
        };
      };
      
      indent-blankline.enable = true;
      gitsigns.enable = true;
      which-key.enable = true;
    };
  };
}
