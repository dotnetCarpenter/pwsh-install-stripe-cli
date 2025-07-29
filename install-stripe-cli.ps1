#!/usr/bin/env pwsh

Set-StrictMode -Version 'Latest'

$OS = $IsWindows ? "Windows" : $IsLinux	? "Linux"	: $IsMacOS ? "MacOS" : $null

$GITHUB_HEADERS = ${
	"Accept": "application/vnd.github+json",
	"X-GitHub-Api-Version": "2022-11-28"
}
$GITHUB_RELEASE_URL = "https://api.github.com/repos/stripe/stripe-cli/releases/latest"
# $GITHUB_RELEASE_ASSETS_URL = "https://api.github.com/repos/stripe/stripe-cli/releases/assets"#/ASSET_ID
# [IO.Path]::DirectorySeparatorChar
# Write-Output is stdout
# Write-Error is stderr

function Get-Assets {
	param (
		$Uri, $Headers
	)

	$Output = Invoke-WebRequest -Uri $Uri -Headers $Headers
		| Select-Object -ExpandProperty "Content" # will return a string
		# | Select-Object -Property "Content" # will return an object
		| ConvertFrom-Json # input is a string
		| Select-Object -ExpandProperty "assets"

	return $Output
}

#----------------------------------------- MAIN -----------------------------------------

$GITHUB_STRIPE_ASSETS = Get-Assets -Uri $GITHUB_RELEASE_URL -Headers $GITHUB_HEADERS
Write-Output $GITHUB_STRIPE_ASSETS

# name
# ----
# stripe-linux-checksums.txt
# stripe-mac-checksums.txt
# stripe-windows-checksums.txt
# stripe_1.28.0_linux_amd64.deb
# stripe_1.28.0_linux_amd64.rpm
# stripe_1.28.0_linux_arm64.deb
# stripe_1.28.0_linux_arm64.rpm
# stripe_1.28.0_linux_arm64.tar.gz
# stripe_1.28.0_linux_x86_64.tar.gz
# stripe_1.28.0_mac-os_arm64.tar.gz
# stripe_1.28.0_mac-os_x86_64.tar.gz
# stripe_1.28.0_windows_i386.zip
# stripe_1.28.0_windows_x86_64.zip
