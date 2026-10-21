# Insult ZSH Plugin

Insult ZSH is a fun and entertaining plugin for ZSH that displays random insults in your terminal. It adds a touch of humor to your command-line experience.

## Features

- Displays configurable roasts when Zsh cannot find a command.
- Provides context-aware messages, typo suggestions, and English-language roasts tailored to non-English commands.
- Preserves an existing `command_not_found_handler` and needs no external dependencies.

## Installation

There are several ways to install the Insult ZSH plugin:

### Using Oh My Zsh

1. Clone the repository into your Oh My Zsh custom plugins directory:
   ```
   git clone https://github.com/MohamedElashri/insult-zsh.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/insult-zsh
   ```

2. Add `insult-zsh` to the plugins array in your `.zshrc` file:
   ```
   plugins=(... insult-zsh)
   ```

3. Restart your terminal or run `source ~/.zshrc` to reload the configuration.

### Using Antigen

1. Add the following line to your `.zshrc` file:
   ```
   antigen bundle MohamedElashri/insult-zsh
   ```

2. Restart your terminal or run `source ~/.zshrc` to reload the configuration.

### Using Zinit

1. Add the following line to your `.zshrc` file:

   ```
   zinit light MohamedElashri/insult-zsh
   ```

2. Restart your terminal or run `source ~/.zshrc` to apply the changes.


### Manual Installation

1. Clone the repository to a directory of your choice:
   ```
   git clone https://github.com/MohamedElashri/insult-zsh.git /path/to/insult-zsh
   ```

2. Add the following line to your `.zshrc` file:
   ```
   source /path/to/insult-zsh/insult-zsh.plugin.zsh
   ```

3. Restart your terminal or run `source ~/.zshrc` to reload the configuration.

## Usage

Once installed, the plugin responds when you enter a command that cannot be found, for example `gti` instead of `git`. It does not display a roast merely from opening a terminal, nor does it provide an `insult` command.

## Non-English command roasts

When an **unknown command name** uses a recognizable Unicode script, the plugin
selects a language-specific **English-language roast**. All roast messages are
written in English; the language or script is used only to pick the joke.
It recognizes Arabic, Cyrillic (Russian text), Greek, Chinese Han, Japanese
kana, Korean Hangul, and Devanagari (Hindi text). Accented Latin-script command
names receive a generic Unicode-themed roast. Common ASCII greetings and
words such as `bonjour`, `hola`, `hallo`, and `ciao` have dedicated
English roast pools inspired by French, Spanish, German, and Italian.

For example, typing an unrecognized `مرحبا` selects an English roast about
Arabic-script commands, while `bonjour` may produce "Very chic. Still not a command."
The original command name is still printed as typed. Roast selection follows
`ZSH_ROAST_LEVEL` (1=dry, 2=sarcastic, 3=hostile), and the existing
`ZSH_ROAST_CHANCE`, repeat avoidance, colors, and command suggestions remain
in effect.

Set `ZSH_ROAST_NON_ENGLISH=0` in the plugin's configuration section to disable
script-aware selection. You can customize the
`ZSH_ROAST_LANGUAGE_*` arrays to change the English-language messages.

Detection is intentionally lightweight and has no external dependencies.
It checks only **missing executable names**, not arguments to valid commands.
Script identification is approximate (e.g., Han characters are also used in
Japanese, and Arabic/Cyrillic/Devanagari scripts are each used by multiple
languages). It cannot reliably detect arbitrary ASCII-only foreign words.

## Customization

If you want to add your own insults or modify the existing ones, you can edit the `insult-zsh.plugin.zsh` file. The messages are stored in `ZSH_ROAST_*` arrays. Feel free to add, remove, or customize the insults to your liking.

## Contributing

Contributions are welcome! If you have any ideas, suggestions, or new insults to add, please open an issue or submit a pull request on the [GitHub repository](https://github.com/MohamedElashri/insult-zsh).

## License

This project is licensed under the [MIT License](LICENSE).

## Disclaimer

Please note that the insults provided by this plugin are intended for humorous purposes only. Use them responsibly and ensure that they align with your workplace or environment's code of conduct.

Enjoy the fun and laughter that Insult ZSH brings to your terminal!
