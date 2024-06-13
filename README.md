# Insult ZSH Plugin

Insult ZSH is a fun and entertaining plugin for ZSH that displays random insults in your terminal. It adds a touch of humor to your command-line experience.

## Features

- Displays random insults every time you open a new terminal session or run the `insult` command.
- Provides a collection of hilarious and creative insults to lighten up your coding environment.
- Easy to install and configure.

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

Once the Insult ZSH plugin is installed, it will automatically display a random insult every time you open a new terminal session.

You can also manually trigger an insult by running the `insult` command in your terminal.

## Customization

If you want to add your own insults or modify the existing ones, you can edit the `insult-zsh.plugin.zsh` file. The insults are stored in an array called `insults`. Feel free to add, remove, or customize the insults to your liking.

## Contributing

Contributions are welcome! If you have any ideas, suggestions, or new insults to add, please open an issue or submit a pull request on the [GitHub repository](https://github.com/MohamedElashri/insult-zsh).

## License

This project is licensed under the [MIT License](LICENSE).

## Disclaimer

Please note that the insults provided by this plugin are intended for humorous purposes only. Use them responsibly and ensure that they align with your workplace or environment's code of conduct.

Enjoy the fun and laughter that Insult ZSH brings to your terminal!
