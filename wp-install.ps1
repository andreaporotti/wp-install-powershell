<#
	---------------------------
	| WP-INSTALL (PowerShell) |
	---------------------------

	Description:	a PowerShell script for quick Wordpress installation on local web server
	Version:		1.4.0
	Author:			Andrea Porotti
	URL:			https://github.com/andreaporotti/wp-install-powershell

	*** WARNING ***
		- use this script at your own risk
		- this script is not meant to be run on production environments
		- read comments carefully before running the script
#>

# script parameters
param (
	[Parameter(Mandatory=$true)][string]$wpFolderName,	# the site folder name (mandatory)
	[Parameter(Mandatory=$true)][string]$wpTitle,		# the site title (mandatory)
	[switch]$verboseMode = $false,						# enable this to view the commands executed by the script (optional)
	[switch]$testMode = $false							# enable this to only view the command that the script would run (optional)
)

# ====== FUNCTIONS START ========================
function Get-RandomString {
	Param (
		[int]$length
	)

	# for more details about this line: https://devblogs.microsoft.com/scripting/generate-random-letters-with-powershell/
	$randString = -join ((97..122) | Get-Random -Count $length | % {[char]$_})

	Write-Output $randString
}

function Get-DebugTimestamp {
	Write-Output (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
}
# ====== FUNCTIONS END ==========================

# ====== SCRIPT CONFIGURATION START =============
#	environment settings
#	(change the following values to match your local web server)
$php 					= "D:\laragon\bin\php\php-7.3.7-nts-Win32-VC15-x64\php.exe" 	# path of the PHP executable
$serverRootFolderPath 	= "D:\laragon\www" 												# the folder in which the script will create the site folder (no trailing slash)
$baseUrl 				= "http://localhost" 											# replace localhost with your local IP if you want to view the site from other devices on your network (eg. smartphones)

#	fixed environment settings
#	(the following values should not be changed)
$wpCli 					= ".\wp-cli.phar" 												# wp-cli should be in the script folder
$wpFolderPath 			= "$serverRootFolderPath\$wpFolderName"							# full site folder path
$wpUrl	 				= "$baseUrl/$wpFolderName"										# full site url

#	wordpress settings
#	(change the following values to customize the Wordpress installation)
$wpVersion 				= "latest"														# to install a specific version, please look for the number in this page: https://wordpress.org/download/releases/
$wpLocale 				= "it_IT"														# full list of available languages: https://make.wordpress.org/polyglots/teams/
$wpAdminUser 			= "admin"
$wpAdminPass 			= "admin"
$wpAdminEmail 			= "admin@test.com"
$wpDbHost 				= "127.0.0.1"
$wpDbUser 				= "root"
$wpDbPass 				= ""
$wpDbPrefix				= "$(Get-RandomString -length 3)_"								# a 3 characters long random string
$wpDbName 				= "$wpFolderName" 												# for the sake of simplicity, the database will have the same name of the site folder
# ====== SCRIPT CONFIGURATION END ===============

# init commands list
$commands = @()

# download Wordpress setup and extract the archive to the site folder
$commands += "$php $wpCli core download --path=$wpFolderPath --locale=$wpLocale --version=$wpVersion"

# create Wordpress configuration file
$commands += "$php $wpCli config create --path=$wpFolderPath --locale=$wpLocale --dbname=$wpDbName --dbuser=$wpDbUser --dbpass=$wpDbPass --dbhost=$wpDbHost --dbprefix=$wpDbPrefix"

# enable Wordpress debug
$commands += "$php $wpCli config set WP_DEBUG true --raw --path=$wpFolderPath"

# create the database
$commands += "$php $wpCli db create --path=$wpFolderPath"

# run Wordpress installation
$commands += "$php $wpCli core install --path=$wpFolderPath --url=$wpUrl --title=""$wpTitle"" --admin_user=$wpAdminUser --admin_password=$wpAdminPass --admin_email=$wpAdminEmail"

# ====== OPTIONAL WORDPRESS SETTINGS START ======
#	permalink format (https://wordpress.org/support/article/using-permalinks/)
$commands += "$php $wpCli rewrite structure --path=$wpFolderPath /%year%/%monthnum%/%day%/%postname%/ --hard"
#	site description (insert an empty string to clear the value)
$commands += "$php $wpCli option update --path=$wpFolderPath blogdescription """""
#	prevent search engines to index the site
$commands += "$php $wpCli option update --path=$wpFolderPath blog_public 0"
#	disable avatars in comments
$commands += "$php $wpCli option update --path=$wpFolderPath show_avatars 0"
#	permalink refresh
$commands += "$php $wpCli rewrite flush --path=$wpFolderPath --hard"
# ====== OPTIONAL WORDPRESS SETTINGS END ========

# ====== OPTIONAL ADMIN SETTINGS START ======
#	disable welcome screen
$commands += "$php $wpCli user meta update 1 show_welcome_panel 0 --path=$wpFolderPath"
# ====== OPTIONAL ADMIN SETTINGS END ========

# install and activate plugins
$commands += "$php $wpCli plugin install --path=$wpFolderPath --activate"

# delete plugins
$commands += "$php $wpCli plugin delete --path=$wpFolderPath"

# install and activate themes
$commands += "$php $wpCli theme install --path=$wpFolderPath --activate"

# delete themes
$commands += "$php $wpCli theme delete --path=$wpFolderPath"

# update core, plugins and themes languages 
$commands += "$php $wpCli language core update --path=$wpFolderPath"
$commands += "$php $wpCli language plugin install --all $wpLocale --path=$wpFolderPath"
$commands += "$php $wpCli language plugin update --all --path=$wpFolderPath"
$commands += "$php $wpCli language theme install --all $wpLocale --path=$wpFolderPath"
$commands += "$php $wpCli language theme update --all --path=$wpFolderPath"

# delete the 'readme.html' file (it contains the WP version)
$commands += "del $wpFolderPath\readme.html"

# open the site in the default browser
$commands += "start $wpUrl"

""
Write-Host "($(Get-DebugTimestamp)) Starting Wordpress setup..." -ForegroundColor Green
""

# parse commands list
foreach ($command in $commands) {
    # print command if verbose is enabled
    if($verboseMode) {
        Write-Host $command -ForegroundColor Yellow
    }

	# run command if test mode is not enabled
	if(-Not $testMode) {
		cmd /c $command
	}

    ""
}

Write-Host "($(Get-DebugTimestamp)) Wordpress setup complete!" -ForegroundColor Green
""