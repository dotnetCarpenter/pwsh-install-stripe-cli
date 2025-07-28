#!/usr/bin/env pwsh

$GITHUB_RELEASE_JSON_URL = "https://api.github.com/repos/stripe/stripe-cli/releases/latest"
$GITHUB_HEADERS = ${
	"Accept": "application/vnd.github+json"
}

$GITHUB_RESPONSE = Invoke-WebRequest -Uri $GITHUB_RELEASE_JSON_URL -Headers $GITHUB_HEADERS
	| Select-Object -ExpandProperty "Content" # will return a string
	# | Select-Object -Property "Content" # will return an object
	| ConvertFrom-Json # input is a string

Write-Output $GITHUB_RESPONSE
