# Credmgr



A basic credential management utility for securely storing secrets on your linux machine.


## Installation



Run `install.sh` to install dependencies from apt-get and create required files.
- credmgr will be installed in `/usr/bin/`
- credentials file will be created in `$HOME/credmgr/cmgr.cpt`



The user will be prompted to CREATE A MASTER PASSWORD FOR SECURING THEIR CREDENTIALS

## Usage

Run the `credmgr` command


Options:

`-a`, `--add`
- Adds a credential reading data from prompts.

`-g NAME`, `--get NAME`
- Retrieves a credential where NAME is the credential ID.

`-l`, `--list`
- Retrieves a list of all credential IDs.


### Notes


The ccrypt which provides encryption for this tool uses AES-256 encryption, see http://www.nist.gov/aes for more information.



USE THIS TOOL AT YOUR OWN RISK. I DO NOT PROVIDE A GUARANTEE OF SECURITY.\
THIS TOOL SHOULD NOT BE USED ON A SYSTEM SHARED WITH UNTRUSTED ADMIN USERS.