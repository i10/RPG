# RPG

RPG is a tool for generating human-readable passwords that strives at being as simple as possible

* Passwords are generated from syllables, numbers, and symbols
* Syllables can be capitalized to enhance security at a very low cost for the user.
* Symbols are picked from the iPhone's first (Symbols 1) and second (Symbols 2) keyboard layout to allow quick entry on your mobile phone.
* Certain characters can be excluded from the password generation process to avoid typographical similarities (l vs. I)
* For each password a secure hash (SHA-1) is generated consisting of 40 HEX characters, which can be used for extra strong passwords.
* A minimized version of the RPG window stays on top of other applications to aid password entry where copy&paste is not available
* Passwords and Hashes can be generated via the Services Menu from other applications (enable in System Preferences, Keyboard)

Find more information on the [RPG Website](http://hci.rwth-aachen.de/RPG).

## Installation

### Install from AppStore

Download and install the app from the [Mac AppStore](https://itunes.apple.com/lk/app/rpg/id429891952).

### Install as a Service

RPG can be installed as a service that allows you generate a password anywhere via the context menu. To enable the service, open the Keyboard page of System Preferences and activate 'Generate Password' in the Services section of the Keyboard Shortcuts tab. Here, you can also configure a keyboard shortcut.

## Acknowledgements

RPG was written by Jonathan Diehl with generous support by Jan-Peter Krämer and Thorsten Karrer.

RPG uses the [BGHUD AppKit](http://www.macfanatic.net/blog/2008/06/17/bghud-appkit-impressive-hud-framework/) by Tim Davis with some minor modifications.
