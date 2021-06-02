# wp-install (PowerShell)

## Description
A PowerShell script for quick [WordPress](https://wordpress.org/) installation on local web servers.

Using this script you can define a specific WordPress configuration and create multiple websites with the same settings, skipping boring and time consuming manual tasks (WordPress download, setup process, theme and plugins installation...).

The script takes advantage of the [WP-CLI](https://wp-cli.org/) power, creating and running a list of commands witch actually install and configure a full WordPress instance.

## Requirements
- **Windows OS** (tested on Windows 10)
- **PowerShell** configured to allow scripts execution (check [Execution Policy](http://go.microsoft.com/fwlink/?LinkID=135170))
- **local Apache+MySQL/MariaDB+PHP environment** (tested on [Laragon](https://laragon.org))
- **the `mysql` command working in PowerShell** (ensure the `bin` folder of MySQL/MariaDB is in the `PATH` environment variable)
- **WordPress** (tested up to version 5.7)
- **WP-CLI** (tested up to version 2.5.0)
- **ensure that your system can run WordPress ([requirements](https://wordpress.org/download/)) and WP-CLI ([requirements](https://wp-cli.org/#installing))**

## Installation
- clone or download this repository in a folder.
- download latest WP-CLI version from https://wp-cli.org/#installing and put the `wp-cli.phar` file into the script folder.
- ensure the folder contains the following files:
  - `wp-cli.phar`
  - `wp-cli.yml`
  - `wp-install.ps1`
- open the `wp-install.ps1` file with a text editor (Visual Studio Code, Notepad++, PowerShell ISE...).
- carefully read all comments and change the script configuration values to fit your local environment (please check the following [Configuration](#configuration) section).

## Configuration
Before running the script for the first time, please check the values between these two lines:

```PowerShell
# ====== SCRIPT CONFIGURATION START =============
...
# ====== SCRIPT CONFIGURATION END ===============
```

Most variable names should be self-explanatory, however some of them have a comment on the right.

Check the environment settings first and change them to fit your system. The `$php` variable allows you to select a specific PHP version in case you have multiple versions installed.

Then go ahead with the WordPress settings, where you can define the basic setup options.

----------

For further WordPress customization, please have a look to the code between these two lines:

```PowerShell
# ====== OPTIONAL WORDPRESS SETTINGS START ======
...
# ====== OPTIONAL WORDPRESS SETTINGS END ========
```

This part is different from the previous one as it contains full WP-CLI commands, not just values.

The script currently contains a few commands which can be deleted or modified to meet your needs (or kept as they are!).

If you need to set other options, you have to write the correct command and add it to the commands list. Each new line should be similar to this:

```PowerShell
$commands += "$php $wpCli [command] --path=$wpFolderPath [command_parameters]"
```

Just replace `[command]` and `[command_parameters]`.

----------

Additional WP-CLI settings are available inside the `wp-cli.yml`.

You can add or change existing settings below this line:

```YML
# ====== COMMANDS CONFIGURATION ======
```

Currently this file allows to configure:
-  custom PHP code that will be added to the `wp-config.php` file, using the `extra-php` parameter of the `config create` command.
-  a list of plugins to be installed
-  a list of plugins to be deleted
-  the theme to be deleted
-  a list of themes to be deleted

Please check the comments in the file to know more about the existing configuration.

For more details about the WP-CLI configuration file, please take a look at [this page](https://make.wordpress.org/cli/handbook/config/).

## Usage
**Parameters:**
- `wpFolderName` (mandatory): insert the name of the folder in which the site will be installed (this folder will be created inside the web server root).
- `wpTitle` (mandatory): insert the title of the site.
- `verboseMode` (optional): prints out the commands during the script execution.
- `testMode` (optional): if enabled, the script DO NOT runs the commands; useful together with `verboseMode` to just have a preview of the commands that would be run, useless otherwise.

To run `wp-install` open a PowerShell window, move to the script folder and run the script passing values for mandatory parameters.

**Examples:**

Create a new WordPress instance:

```PowerShell
.\wp-install.ps1 -wpFolderName "wp_test_site" -wpTitle "Testing WordPress"
```

Create a new WordPress instance and print the commands while being executed:

```PowerShell
.\wp-install.ps1 -wpFolderName "wp_test_site" -wpTitle "Testing WordPress" -verboseMode
```

Only print the list of commands that would be executed by the script:

```PowerShell
.\wp-install.ps1 -wpFolderName "wp_test_site" -wpTitle "Testing WordPress" -verboseMode -testMode
```

## Changelog
### [1.4.0] - 2021-06-02
**Added**
- Added commands to update core, plugins and themes language files.
- Added PHP code to enable WordPress debug in the `wp-cli.yml` file.
- Added comments to the PHP code in the `wp-cli.yml` file.

**Changed**
- Moved the lists of plugins and themes to be installed/deleted from the script configuration variables to the `wp-cli.yml` file. Please check the comments in the file for more details.

### [1.3.0] - 2020-04-09
**Changed**
- Moved the extra-php setting from the script to the YML configuration file. The code can now be added in a easier way and the output will be multiline.

### [1.2.2] - 2020-01-14
**Changed**
- Modified random string generation function to have only lower case letters in table prefix.

### [1.2.1] - 2019-11-17
**Changed**
- Removed from the script configuration the names of plugins and themes to install/remove to have a more cleaner base script.

### [1.2.0] - 2019-09-22
**Added**

- Added the `$wpExtraPhp` variable for the `--extra-php` parameter value.
- Added the `$wpDisableAutoUpdates` variable to disable the WordPress auto updates.
- Added the `$wpDisableFileEdit` variable to disable the WordPress internal file editor.

### [1.1.0] - 2019-09-21
**Added**

- Delete WordPress `readme.html` file.

### [1.0.1] - 2019-08-25
**Fixed**

- Changed the `$serverRootFolderPath` variable default value which should not have a trailing slash.

### [1.0.0] - 2019-08-16
**Added**

- Initial script version released.

## License
[MIT](https://choosealicense.com/licenses/mit/)