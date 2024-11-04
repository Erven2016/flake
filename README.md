```tree
.
└── ~/.config/nixos/
    ├── hardware/ # 共用硬件配置
    ├── home-manager/ # 共用 home-manager 配置文件
    ├── hosts/ # 主机配置/
    │   └── [*hostname].nix
    ├── modules/ # 共用模块
    ├── users/ # 用户配置/
    │   └── [*username].nix
    ├── configuration.nix # 默认配置
    ├── flake.lock # flake 版本锁（一般不用动）
    └── flake.nix # flake 配置文件
```
