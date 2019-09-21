# wp-install (PowerShell)

## Description
A PowerShell script for quick [Wordpress](https://wordpress.org/) installation on local web servers.

Using this script you can define a specific Wordpress configuration and create multiple websites with the same settings, skipping boring and time consuming manual tasks (Wordpress download, setup process, theme and plugins installation...).

The script takes advantage of the [WP-CLI](https://wp-cli.org/) power, creating and running a list of commands witch actually install and configure a full Wordpress instance.

## Requirements
- **Windows OS** (tested on Windows 8.1 and Windows 10)
- **PowerShell** configured to allow scripts execution (check [Execution Policy](http://go.microsoft.com/fwlink/?LinkID=135170))
- **local Apache+MySQL/MariaDB+PHP environment** (tested on [XAMPP](https://www.apachefriends.org) and [Laragon](https://laragon.org))
- **the `mysql` command working in PowerShell** (ensure the `bin` folder of MySQL/MariaDB is in the `PATH` environment variable)
- **WP-CLI** (tested with 2.3.0 version)
- **ensure that your system can run Wordpress ([requirements](https://wordpress.org/download/)) and WP-CLI ([requirements](https://wp-cli.org/#installing))**

## Installation
- clone or download and extract this repository in a folder.
- download latest WP-CLI version from https://wp-cli.org/#installing and put the `wp-cli.phar` file into the script folder.
- ensure the folder contains the following files:
  - `wp-cli.phar`
  - `wp-cli.yml`
  - `wp-install.ps1`
- open the `wp-install.ps1` file with a text editor (Visual Studio Code, Notepad++, PowerShell ISE...).
- carefully read all comments and change the script configuration values to fit your local environment (please check the [Configuration](#configuration) section of this file).

## Configuration
Before running the script for the first time, please check the values between these two lines:

```PowerShell
# ====== SCRIPT CONFIGURATION START =============
...
# ====== SCRIPT CONFIGURATION END ===============
```

Most variable names should be self-explanatory, however some of them have a comment on the right.

Check the environment settings first and change them to fit your system. The `$php` variable allows you to select a specific PHP version in case you have multiple versions installed.

Then go ahead with the Wordpress settings: here you can insert the basic settings for the installation, but you can also list which plugins and themes to install or remove.

----------


For further Wordpress customization, please have a look to the code between these two lines:

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

## Usage
**Parameters:**
- `wpFolderName` (mandatory): insert the name of the folder in which the site will be installed (this folder will be created inside the web server root).
- `wpTitle` (mandatory): insert the title of the site.
- `verboseMode` (optional): prints out the commands while they are run.
- `testMode` (optional): if enabled, the script DO NOT runs the commands; useful together with `verboseMode` to just have a preview of the commands that would be run, useless otherwise.

To run `wp-install` open a PowerShell window, move to the script folder and run the script passing values for mandatory parameters.

**Examples:**

Create a new Wordpress instance:

```PowerShell
.\wp-install.ps1 -wpFolderName "wp_test_site" -wpTitle "Testing Wordpress"
```

Create a new Wordpress instance and print the commands while being executed:

```PowerShell
.\wp-install.ps1 -wpFolderName "wp_test_site" -wpTitle "Testing Wordpress" -verboseMode
```

Only print the list of commands that would be executed by the script:

```PowerShell
.\wp-install.ps1 -wpFolderName "wp_test_site" -wpTitle "Testing Wordpress" -verboseMode -testMode
```

## Changelog
### [1.1.0] - 2019-09-21
**Added**

Delete Wordpress `readme.html` file.

### [1.0.1] - 2019-08-25
**Fixed**

Changed the `$serverRootFolderPath` variable default value which should not have a trailing slash.

### [1.0.0] - 2019-08-16
**Added**

Initial script version released.

## License
[MIT](https://choosealicense.com/licenses/mit/)