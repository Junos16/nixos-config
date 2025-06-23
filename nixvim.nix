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
      # clipboard = "unnamedplus";
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
    ];
    
    plugins = {
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
      
      cmp = {
        enable = true;
        autoEnableSources = true;
      };
      
      indent-blankline.enable = true;
      gitsigns.enable = true;
      which-key.enable = true;
    };
  };
}
