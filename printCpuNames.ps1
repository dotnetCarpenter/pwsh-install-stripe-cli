# function ToLower ($string) {
# 	return $string.ToString().ToLower()
# }

[System.Runtime.InteropServices.Architecture,mscorlib].GetEnumNames()
	| ForEach-Object { $_.ToString().ToLower() }

	$arch = [System.Runtime.InteropServices.RuntimeInformation,mscorlib]::OSArchitecture.ToString().ToLower()

	Write-Host "This cpu is a $arch architecture"