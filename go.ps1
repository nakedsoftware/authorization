#!/usr/bin/env pwsh

# Copyright 2025 Naked Software, LLC
#
# Version 1.0.0 (May 26, 2025)
#
# This Authorization Service License Agreement ("Agreement") is a legal
# agreement between you ("Licensee") and Naked Software, LLC ("Licensor")
# for the use of the Authorization Service software product ("Software").
# By using the Software, you agree to be bound by the terms of this
# Agreement.
#
# 1. Grant of License
#
# Licensor grants Licensee a non-exclusive, non-transferable,
# non-sublicensable license to use the Software for non-commercial,
# educational, or other non-production purposes. Licensee may not use the
# Software for any commercial purposes without purchasing a commercial
# license from Licensor.
#
# 2. Commercial Use
#
# To use the Software for commercial purposes, Licensee must purchase a
# commercial license from Licensor. A commercial license allows Licensee to
# use the Software in production environments, build their own version, and
# add custom features or bug fixes. Licensee may not sell the Software or
# any derivative works to others.
#
# 3. Derivative Works
#
# Licensee may create derivative works of the Software for their own use,
# provided that they maintain a valid commercial license. Licensee may not
# sell or distribute derivative works to others. Any derivative works must
# include a copy of this Agreement and retain all copyright notices.
#
# 4. Sharing and Contributions
#
# Licensee may share their changes or bug fixes to the Software with
# others, provided that such changes are made freely available and not
# sold. Licensee is encouraged to contribute their bug fixes back to
# Licensor for inclusion in the Software.
#
# 5. Restrictions
#
# Licensee may not:
#
# - Use the Software for any commercial purposes without a valid commercial
#   license.
# - Sell, sublicense, or distribute the Software or any derivative works.
# - Remove or alter any copyright notices or proprietary legends on the
#   Software.
#
# 6. Termination
#
# This Agreement is effective until terminated. Licensor may terminate this
# Agreement at any time if Licensee breaches any of its terms. Upon
# termination, Licensee must cease all use of the Software and destroy all
# copies in their possession.
#
# 7. Disclaimer of Warranty
#
# The Software is provided "as is" without warranty of any kind, express or
# implied, including but not limited to the warranties of merchantability,
# fitness for a particular purpose, and noninfringement. In no event shall
# Licensor be liable for any claim, damages, or other liability, whether in
# an action of contract, tort, or otherwise, arising from, out of, or in
# connection with the Software or the use or other dealings in the
# Software.
#
# 8. Limitation of Liability
#
# In no event shall Licensor be liable for any indirect, incidental,
# special, exemplary, or consequential damages (including, but not limited
# to, procurement of substitute goods or services; loss of use, data, or
# profits; or business interruption) however caused and on any theory of
# liability, whether in contract, strict liability, or tort (including
# negligence or otherwise) arising in any way out of the use of the
# Software, even if advised of the possibility of such damage.
#
# 9. Governing Law
#
# This Agreement shall be governed by and construed in accordance with the
# laws of the jurisdiction in which Licensor is located, without regard to
# its conflict of law principles.
#
# 10. Entire Agreement
#
# This Agreement constitutes the entire agreement between the parties with
# respect to the Software and supersedes all prior or contemporaneous
# understandings regarding such subject matter.
#
# By using the Software, you acknowledge that you have read this Agreement,
# understand it, and agree to be bound by its terms and conditions.

# go.ps1
#
# This program is a command lline utility that supports common commands that
# developers will use when working in the repository.
#
# Usage: pwsh go.ps1 [command] [<args>]

# Check if an argument was provided
if ($args.Count -eq 0) {
    Write-Host "Error: No command specified." -ForegroundColor Red
    Write-Host "Usage: $($MyInvocation.MyCommand.Name) command"
    exit 1
}

# Get the command from the first argument
$command_arg = $args[0]
$executable = "go-$command_arg"

# Create an array with remaining arguments (args[1] and beyond)
$remainingArgs = $args | Select-Object -Skip 1

# Check if a PowerShell script with the command name exists in the scripts/go 
# subdirectory
$localScriptPath = Join-Path -Path "$PSScriptRoot/scripts/go" -ChildPath "$executable.ps1"
if (Test-Path -Path $localScriptPath -PathType Leaf) {
    Write-Host "Executing local ./scripts/go/$executable.ps1..."
    $process = Start-Process -FilePath $localScriptPath -ArgumentList $remainingArgs -NoNewWindow -PassThru -Wait
    exit $process.ExitCode
}

# Check if the executable exists in the bin subdirectory
$localExecutablePath = Join-Path -Path "./scripts/go" -ChildPath $executable
if (Test-Path -Path $localExecutablePath -PathType Leaf) {
    Write-Host "Executing local ./scripts/go/$executable..."
    $process = Start-Process -FilePath $localExecutablePath -ArgumentList $remainingArgs -NoNewWindow -PassThru -Wait
    exit $process.ExitCode
}

# Check if the executable exists in the bin subdirectory with .exe extension
$localExecutablePathExe = Join-Path -Path "./scripts/go" -ChildPath "$executable.exe"
if (Test-Path -Path $localExecutablePathExe -PathType Leaf) {
    Write-Host "Executing local ./scripts/go/$executable.exe..."
    $process = Start-Process -FilePath $localExecutablePathExe -ArgumentList $remainingArgs -NoNewWindow -PassThru -Wait
    exit $process.ExitCode
}

# If not in local bin, check if it exists in PATH
if (Get-Command $executable -ErrorAction SilentlyContinue) {
    Write-Host "Executing $executable from PATH..."
    $process = Start-Process -FilePath $executable -ArgumentList $remainingArgs -NoNewWindow -PassThru -Wait
    exit $process.ExitCode
}

# If not in local bin, check if it exists in PATH with .exe extension
$executableWithExe = "$executable.exe"
if (Get-Command $executableWithExe -ErrorAction SilentlyContinue) {
    Write-Host "Executing $executableWithExe from PATH..."
    $process = Start-Process -FilePath $executableWithExe -ArgumentList $remainingArgs -NoNewWindow -PassThru -Wait
    exit $process.ExitCode
} else {
    Write-Host "Error: Command '$executable' not found or not executable." -ForegroundColor Red
    exit 127
}