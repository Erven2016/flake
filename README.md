# Erven2016's NixOS Configuration

## Usage

### Creating a new host

Making a directory in `root/hosts/` can create a new host, and the name
of directory will be used as the hostname of this host.

And `configuration.nix`, `hardware-configuration.nix` and `metadata.nix` these
three files must be created under the host directory.

- `configuration.nix`: Individual configuration for a host.
- `hardware-configration.nix`: A configuration that describes hardware information of a host.
  Normally, it should not be modified.
- `metadata.nix`: Storing some options about a host. Options are defined
  in `utils/options/metadata.nix`.

```bash

# A host that hostname is `kvm-test` will be created in this example:

# changing current directory to config
cd path/to/config

# Creating the host directory
mkdir hosts/kvm-test

# Creating must-have files
touch hosts/kvm-test/{configuration,metadata}.nix

# Copying hardware-configuration.nix of this host to config
cp path/to/hardware-configuration.nix hosts/kvm-test/hardware-configuration.nix

# Putting your configuration to `configuratiion.nix` and `metadata.nix`
# then don't forget to add your work to git.
git add hosts/kvm-test

# Last run nixos-build, but you need to specify the hostname at first time.
sudo nixos-rebuild switch --flake .#kvm-test --impure --show-trace
```

### Creating a new user

Similar to creating a new host described above, you just need to create a directory (aka username)
in `root/users/`, and the directory includes two main files `default.nix` and `home.nix`.
The `default.nix` will be imported to `config.users.users.<username>` automatically, and
`home.nix` will be imported to `home-manager.users.<username>`. So be carefully to the scope when
you are writing user configuration.

You need adding the user to `hosts/<hostname>/metadata.nix` which the host you want
to apply the user to:

```nix
# hosts/<hostname>/metadata.nix
{
  # emit ...

  users = [ "<username>" ];
}
```
