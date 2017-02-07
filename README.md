# Win10HiddenPackages

A script for deleting hidden packages in windows 10.

## Installation

1. Download "deleteHiddenPackages.ps1".
2. Open the Powershell as Administrator.
3. Run "Set-ExecutionPolicy Unrestricted".
4. Run the "deleteHiddenPackages.ps1" script.

## Usage

This script has 2 optional parameters
```
.\deleteHiddenPackages.ps1 [-name string] [-list]
    name: substring of a packagename
    list: use to list all matching packages without deleting them
```

### Example

Show all packages
```
.\deleteHiddenPackages.ps1 -list
```
Show all packages with Edge as substring
```
.\deleteHiddenPackages.ps1 -list -name Edge
```
Remove all packages with Edge as substring
```
.\deleteHiddenPackages.ps1 -name Edge
```

# Warning
If wrongly used this script can render your Windows installation unuseable.

**DO NOT DELETE PACKAGES WITHOUT KNOWING THEIR PURPOSE!!**
