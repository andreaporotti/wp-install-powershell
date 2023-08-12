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
- **WordPress** (tested up to version 6.3)
- **WP-CLI** (tested up to version 2.8.1)
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

For further WordPress customization, please have a look to the code between these lines:

```PowerShell
# ====== OPTIONAL WORDPRESS SETTINGS START ======
...
# ====== OPTIONAL WORDPRESS SETTINGS END ========
```

```PowerShell
# ====== OPTIONAL ADMIN SETTINGS START ======
...
# ====== OPTIONAL ADMIN SETTINGS END ========
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
-  a list of plugins to be installed.
-  a list of plugins to be deleted.
-  the theme to be installed.
-  a list of themes to be deleted.

Please check the comments in the file to know more about the existing configuration.

For more details about the WP-CLI configuration file, please take a look at [this page](https://make.wordpress.org/cli/handbook/config/).

## Usage

To run `wp-install` open a PowerShell window, move to the script folder and run the script using the following parameters:

| Parameter    | Mandatory | Description |
|--------------|:---------:|-------------|
|`wpFolderName`| Yes       |The name of the folder in which the site will be installed. The name can contain subfolders. The site folder will be created inside the web server root.|
|`wpTitle`     | Yes       |The site title.|
|`wpUrl`       | No        |The site url. Extra configuration on the webserver is required for a custom url. If missing, the `$baseUrl` variable will be used (`http://localhost/...` by default).|
|`verboseMode` | No        |Print out the commands during the script execution.|
|`testMode`    | No        |Prevent commands to be run. May be useful together with `verboseMode` to preview the full script execution.|

**Examples:**

Create a new WordPress instance with default url:

```PowerShell
.\wp-install.ps1 -wpFolderName "wp_test_site" -wpTitle "Testing WordPress"
```

Create a new WordPress instance in a subfolder and set a custom url:

```PowerShell
.\wp-install.ps1 -wpFolderName "tests\wp_test_site" -wpTitle "Testing WordPress" -wpUrl "http://test-site.local"
```

Create a new WordPress instance and print the commands while being executed:

```PowerShell
.\wp-install.ps1 -wpFolderName "wp_test_site" -wpTitle "Testing WordPress" -verboseMode
```

Run script preventing command execution:

```PowerShell
.\wp-install.ps1 -wpFolderName "wp_test_site" -wpTitle "Testing WordPress" -verboseMode -testMode
```

## Changelog
### [1.6.2] - 2023-04-05
Tested with WordPress 6.2.

**Added**
- Uninstall the "Twenty Twenty Two" theme.
- Define the "development" environment in `wp-config.php`.
- Disable pings from and to blogs in the Discussion settings.

### [1.6.1] - 2022-11-17
This version brings a few changes to improve support with WordPress 6.1.x and WP-CLI 2.7.x.

**Changed**
- Removed the command to clear the blog description (useless since it's already empty in WordPress 6.1).
- Removed the theme "Twenty Twenty" from delete list since it is not bundled with WordPress 6.1.
- Moved `WP_DEBUG` definition back to the `wp-cli.yml` file since WP-CLI 2.7 fixed the duplication issue.

### [1.6.0] - 2022-05-09
**Added**
- Added optional parameter to pass a custom site URL. If not specified, "localhost" will be used. **Please note:** extra configuration on the webserver is required for a custom url.
- Generate a random password for the admin user. The password will be saved to a file in the site folder and also displaed to the terminal. **Please note:** currently the password is not really safe, so change it if you deploy the site.
- Added command to open the site backend at the end of the setup.

**Changed**
- Changed the PHP version used by the script. This is a default value, please modify it according to your environment.
- Modified the default admin username to prevent having an "admin" user, which is not good if the site is going to be deployed.
- Updated the script documentation.

**Fixed**
- Fixed default site url (localhost) when WordPress is installed in a subfolder.
- Removed dots from the folder name, which may cause rewrite rules issues.

### [1.5.0] - 2022-01-30
This version fixes issues with WordPress 5.9 and WP-CLI 2.6.0.

**Added**
- Added command to disable comments.
- Added command to enable comments moderation.
- Added command to disable avatars.
- Added command to use posts excerpt in the feed.
- Added command to disable the welcome screen on the admin dashboard.

**Changed**
- Modified the list of themes to be deleted according to the WP 5.9 default themes.
- Modified the way the WP_DEBUG is enabled, since WP-CLI 2.6.0 does not override the default WP_DEBUG definition.

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