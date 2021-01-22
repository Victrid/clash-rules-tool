# Clash Rules Tool

Here is a tool to select, generate and upload your own clash rules.

## Usage



After creating  ` some.cfg` files as `cfg.example` and placing them into direct or proxy directories, you may run `./rules.sh generate_config` to generate a configurable file via markdown format.

Edit these files, and run `./rules.sh generate` to generate a rule-provider file.

You may upload them to a OpenClash server by running `./rules.sh upload`. But first you need to copy `./config.sh.example`to `./config.sh` and edit them to configure the uploading. Remember to upload your ssh-key first.

