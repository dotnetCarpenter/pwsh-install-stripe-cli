#!/usr/bin/env pwsh

$GITHUB_HEADERS = ${
	"Accept": "application/vnd.github+json",
	"X-GitHub-Api-Version": "2022-11-28"
}
$GITHUB_RELEASE_URL = "https://api.github.com/repos/stripe/stripe-cli/releases/latest"
# $GITHUB_RELEASE_ASSETS_URL = "https://api.github.com/repos/stripe/stripe-cli/releases/assets"#/ASSET_ID

$GITHUB_STRIPE_ASSETS = Invoke-WebRequest -Uri $GITHUB_RELEASE_URL -Headers $GITHUB_HEADERS
	| Select-Object -ExpandProperty "Content" # will return a string
	# | Select-Object -Property "Content" # will return an object
	| ConvertFrom-Json # input is a string
	| Select-Object -ExpandProperty "assets"

Write-Output $GITHUB_STRIPE_ASSETS
# Write-Output "Release ID: $GITHUB_RELEASE_ID"

# Invoke-WebRequest -Uri "$GITHUB_RELEASE_ASSETS_URL/$GITHUB_RELEASE_ID" -Headers $GITHUB_HEADERS

