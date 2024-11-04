```tree
.
└── ~/.config/nixos/
    ├── hosts/                                # configurations for hosts
    │   └── [*hostname].nix
    ├── modules/                              # shared modules    
    ├── users/                                # configurations for users
    │   └── [*username].nix
    ├── configuration.nix                     # default configuation for installation
    ├── home.nix                              # entry of home-manager
    ├── flake.lock                            # version locker for Flakes, and do not modify it
    └── flake.nix                             # flake configuration
```
