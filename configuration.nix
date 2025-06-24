# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  hardware.enableRedistributableFirmware = true;
  boot.modprobeConfig.enable = true;
  boot.extraModprobeConfig = ''
    options iwlwifi power_save=0
  '';
  boot.supportedFilesystems = [ "ntfs" ];

  boot.kernelParams = [
    "pcie_aspm=off"
    "nvidia-drm.modeset=1"
    "nvidea.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Configure keymap in X11
  # services.xserver = {
  #   enable = true;
  #   xkb = {
  #     layout = "us";
  #     variant = "";
  #   };
  # };

  programs.zsh.enable = true;
  programs.git.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hriddhit = {
    isNormalUser = true;
    description = "Hriddhit Datta";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "storage" "plugdev" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features
  = [ "nix-command" "flakes" ];

  # nix.settings.max-jobs = 1;
  # nix.settings.cores = 4;
  
  nix.settings.substituters = [
    "https://cache.nixos.org/"
  ];
  
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];

  # sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Graphics
  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = [ 
    "nvidia" 
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };  
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.setPath.enable = true;
  };

  # services.gdm.enable = false;
  # services.gdm.enable = false;
  # services.lightdm.enable = false;
  # services.sddm.enable = false;
  # services.getty.autoLogin.enable = false;

  # Display Manager
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       comand = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd 'dbus-run-session Hyprland' --theme border-=magenta;text=cyan;prompt=green;time=red;action=blue --remember --remember-session";
  #       user = "greeter";
  #     };
  #   };
  #   restart = true;
  # };

  # Systemd service ordering
  # systemd.services.greetd = {
  #   unitConfig = {
  #     After = [ 
  #       "systemd-user-sessions.service" 
  #       "getty@tty1.service" 
  #       "plymouth-quit.service" 
  #     ];
  #   };
  #   serviceConfig = {
  #     Type = "idle";
  #     RestartSec = "1";
  #     StandardInput = "tty";
  #     StandardOutput = "tty";
  #     StandardError = "jounral";
  #     TTYPath = "/dev/tty1";
  #     TTYReset = true;
  #     TTYHangup = true;
  #   };
  # };

  # Core system services
  services = {
    dbus.enable = true;
    udisks2.enable = true;
    udev = {
      enable = true;
      extraRules = ''  
        # Auto-mount USB drives
        KERNEL=="sd[a-z]*", SUBSYSTEMS=="usb", ACTION=="add", RUN+="${pkgs.systemd}/bin/systemd-run --property=Type=oneshot --property=RemainAfterExit=yes --property=ExecStop='${pkgs.util-linux}/bin/umount /mnt/%k' ${pkgs.util-linux}/bin/mkdir -p /mnt/%k && ${pkgs.util-linux}/bin/mount /dev/%k /mnt/%k"
  
        # Auto-unmount USB drives on removal
        KERNEL=="sd[a-z]*", SUBSYSTEMS=="usb", ACTION=="remove", RUN+="${pkgs.systemd}/bin/systemd-run --property=Type=oneshot ${pkgs.util-linux}/bin/umount /mnt/%k && ${pkgs.util-linux}/bin/rmdir /mnt/%k"
      '';
    };
    devmon.enable = true;
    gvfs.enable = true;
  };

  # Polkit authentication agent
  security.polkit.enable = true;

  # Systemd service for polkit authentication agent
  # systemd.user.services.polkit-gnome-authentication-agent-1 = {
  #   description = "polkit-gnome-authentication-agent-1";
  #   wantedBy = [ "graphical-session.target" ];
  #   wants = [ "graphical-session.target" ];
  #   after = [ "graphical-session.target" ];
  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #     Restart = "on-failure";
  #     RestartSec = 1;
  #     TimeoutStopSec = 10;
  #   };
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    git
    curl
    lshw
    home-manager
    usbutils
    util-linux
    polkit_gnome
    imagemagick
    ntfs3g
    # systemd
    # dbus
  ];

  # Environment variables for better Wayland support
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
  };
  
  # Enable dconf for GTK applications
  programs.dconf.enable = true;

  # XDG Desktop Portal
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      common.default = "hyprland";
      hyprland.default = [
        "hyprland"
	      "gtk"
      ];
    };
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
