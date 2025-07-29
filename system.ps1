Set-StrictMode -Version 'Latest'

# use local:variableName to hide script variables when included with module
# if they are visible to the importing script

function lowercase {
	param (
		[Parameter(ValueFromPipeline=$true)]
		$value
	)
	return $value.toString().toLower()
}

function inspectHashTable ($hash) {
	$hash.GetEnumerator().ForEach({"The value of '$($_.Key)' is: $($_.Value)"})
	# $hash.GetEnumerator() | ForEach-Object {
  #   "The value of '$($_.Key)' is: $($_.Value)"
	# }
}

$os = $IsWindows ? "windows" : $IsLinux	? "linux"	: $IsMacOS ? "mac-os" : $null

$arch = [System.Runtime.InteropServices.RuntimeInformation,mscorlib]::OSArchitecture | lowercase

# $installationTargetToFileExtension = @{
# 	deb = ".deb"
# 	rpm = ".rpm"
# 	usr = ".tar.gz"
# 	macos = ".tar.gz"
# 	windows = ".zip"
# }
# $systemToFileName = @{
# 	linux = @{
# 		x64   = "amd64." + (getLinuxTarget)
# 		arm64 = "arm64." + (getLinuxTarget)
# 	}
# 	macos = @{
# 		x64   = "x86_64.tar.gz"
# 		arm64 = "arm64.tar.gz"
# 	}
# 	windows = @{
# 		x86   = "i386.zip"
# 		x64   = "x86_64.zip"
# 	}
# }
function getLinuxTarget {
	$target = ""

	if (Get-Command "dpkg" -ErrorAction SilentlyContinue) {
		$target = "dpkg"
	} elseif (Get-Command "rpm" -ErrorAction SilentlyContinue) {
		$target = "rpm"
	} else {
		$target = "usr"
	}

	return $target
}
function getTarget ($os, $arch) {
	$extension = ""

	switch ($os) {
		linux {
			$package = ""
			switch (getLinuxTarget) {
				dpkg { $package = ".deb" }
				rpm  { $package = ".rpm" }
				usr  { $package = ".tar.gz" }
			}

			switch ($arch) {
				x64 {
					# linux_amd64.deb
					# linux_amd64.rpm
					# linux_x86_64.tar.gz
					$extension = "{0}_{1}" -f $os, ($package -eq ".tar.gz" ? "x86_64.tar.gz" : ("amd64" + $package))
				}
				arm64 {
					# linux_arm64.deb
					# linux_arm64.rpm
					# linux_arm64.tar.gz
					$extension = "{0}_{1}{2}" -f $os, $arch, $package
				}
			}
		}
		mac-os {
			# mac-os_arm64.tar.gz
			# mac-os_x86_64.tar.gz
			$extension = "{0}_{1}{2}" -f $os, ($arch -eq "x64" ? "x86_64" : $arch), ".tar.gz"
		}
		windows {
			# windows_i386.zip
			# windows_x86_64.zip
			$extension = "{0}_{1}{2}" -f $os, ($arch -eq "x86" ? "i386" : $arch -eq "x64" ? "x86_64" : "unknown"), ".zip"
		}
	}

	return $extension
}

# $fileExtension = $IsLinux ? ($installationTargetToFileExtension[$os][(getLinuxFileExtension)]) : ($IsMacOS) -xor ($IsWindows) ? $installationTargetToFileExtension[$os] : ".tar.gz" # default
# $fileExtension = $installationTargetToFileExtension[($IsLinux ? (getLinuxTarget) : $os)]
$packetName = "stripe"
$version = "1.28.0"

$one = @($packetName, $version, (getTarget $os $arch)) -Join '_'
Write-Host $one
# $one = @($packetName, $version, $os, $systemToFileName[$os][$arch]) -Join '_'
# $oneOutput = "{0}{1}" -f $one, $fileExtension
# Write-Host $oneOutput

# getLinuxFileExtension
# Write-Output "Extension: $fileExtension"

# Write-Host $systemToFileName
# Write-Host $systemToFileName[$os]
# Write-Output $systemToFileName
# Write-Output $systemToFileName[$os]

# inspectHashTable ($installationTargetToFileExtension)
# inspectHashTable ($systemToFileName)
# inspectHashTable ($systemToFileName[$os])

# foreach ($Key in $ASSETS_JSON_MAP.Keys) {
#     "The value of '$Key' is: $($hash[$Key])"
# }