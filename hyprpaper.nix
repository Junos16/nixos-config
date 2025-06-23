{ config, pkgs, ... }:

{
  # Hyprpaper configuration
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    # Preload wallpapers
    preload = /home/hriddhit/Downloads/wallpaper-bluegreen.jpg
    #preload = ~/.config/wallpapers/cyberpunk_alt.jpg
    
    # Set wallpaper for each monitor
    wallpaper = ,/home/hriddhit/Downloads/wallpaper-bluegreen.jpg
    
    # Enable splash text
    splash = true
    
    # Fully disable ipc
    ipc = off
  '';

  # Create wallpapers directory and add some default wallpapers
  # home.file.".config/wallpapers/cyberpunk.jpg".source = pkgs.fetchurl {
  #   url = "https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=1920&h=1080&fit=crop";
  #   sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  # };

  # Alternative: Create a simple solid color wallpaper using imagemagick
  # home.activation.createWallpaper = ''
  #   if [ ! -f ~/.config/wallpapers/cyberpunk.jpg ]; then
  #     mkdir -p ~/.config/wallpapers
  #     ${pkgs.imagemagick}/bin/convert -size 1920x1080 gradient:"#0a0e1a-#1a1f2e" ~/.config/wallpapers/cyberpunk.jpg
  #     ${pkgs.imagemagick}/bin/convert -size 1920x1080 gradient:"#0f1419-#00d4ff" ~/.config/wallpapers/cyberpunk_alt.jpg
  #   fi
  # '';
}
