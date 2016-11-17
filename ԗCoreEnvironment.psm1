<#ԗ#
.LICENSE
    ԗCoreEnvironment - The set of useful PowerShell functions
    Copyright © 2016 Aleksey Moskalyov a.k.a. kRaVeda

    This program is free software: you can redistribute it and/or modify it under the terms of the 
    GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, 
    or (at your option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
    without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
    See the GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License along with this program. 
    If not, see http://www.gnu.org/licenses/.

    As well You can find source code of this program and the license text on these link: https://github.com/kRaVeda/--core-environment
.SYNOPSIS
    Name: ԗCoreEnvironment.psm1
    Solution: ԗCoreEnvironment
    Author: Aleksey Moskalyov a.k.a. kRaVeda <kraveda@yandex.ru, kraveda@gmail.com>
    GUID: acc18b44-18eb-4360-a7ef-348339eb0ef3
    Invented: 2016-11-15 15:34 +03:00
    Version: 1.0.0.15-internal
    Released: 2016-11-17 22:48 +03:00
.LINK
    https://github.com/kRaVeda/--core-environment
#>
#requires -Version 4.0

[datetime]$s?launchedAt = [datetime]::Now;
[string]$c?TimestampPattern = 'yyyy\-MM\-dd\THH\:mm\:ss.fffffffK';
$s?content  = [regex]::Match( 
    $MyInvocation.MyCommand.ScriptBlock.StartPosition.Content, 
    '\<\#(?:.(?!\#\>))*?\.SYNOPSIS((?:.(?!\.[A-Z]+|\#\>))*)(?:.(?!\#\>))*?.?\#\>',
    [Text.RegularExpressions.RegexOptions]::Singleline
).Groups[1].Value;
$t?pattern  = '[\r\n]+\s*{0}\s*\:\s*([^\s\r\n]+)\s*(?:[\r\n]+|\#)';
$s?Name     = [regex]::Match($s?content, $t?pattern -f 'Name').Groups[1].Value;
$s?Solution = [regex]::Match($s?content, $t?pattern -f 'Solution').Groups[1].Value;
$s?FullName = '{0}/{1}' -f $s?Solution, $s?Name;
'[{0}] Module "{1}" is loading...' -f $s?launchedAt.ToString($c?TimestampPattern), $s?FullName | Write-Debug;
try
{
    #region /* Import Function Declarations */
    $v?functionsToExport = [string[]]@(
        'Get-RuntimeErrorInfo'
    );
    $v?functionsToExport.ForEach{
        . $('{0}\@functions\{1}.ps1' -f $PSScriptRoot, $PSItem);
    };
    #endregion /import function declarations/
}
catch
{
    [Management.Automation.ErrorRecord]$r?error = 
        if ( $PSItem -is [Management.Automation.ErrorRecord] )
        {
            $PSItem;
        }
        elseif ( $PSItem -is [Exception] )
        {
            $PSItem.ErrorRecord;
        }
    ;
    $r?errorInfo = [PSCustomObject]@{};
    if ( $r?error.Exception -and $r?error.Exception.Message )
    { 
        $r?errorInfo.PSObject.Properties.Add([psnoteproperty]::new('Exception', $r?error.Exception.Message)); 
    };
    if ( $r?error.CategoryInfo )
    { 
        if ( $r?error.CategoryInfo.Reason )
        {
            $r?errorInfo.PSObject.Properties.Add([psnoteproperty]::new('Reason', $r?error.CategoryInfo.Reason)); 
        }
        if ( $r?error.CategoryInfo.TargetName )
        {
            $r?errorInfo.PSObject.Properties.Add([psnoteproperty]::new('Target', $(
                $(if($r?error.CategoryInfo.TargetType){'[{0}] ' -f $r?error.CategoryInfo.TargetType}) +
                $r?error.CategoryInfo.TargetName
            )));
        }
    };
    if ( $r?error.InvocationInfo )
    { 
        if ( $r?error.InvocationInfo.ScriptName )
        {
            $r?errorInfo.PSObject.Properties.Add([psnoteproperty]::new('Script', $r?error.InvocationInfo.ScriptName)); 
            if ( $r?error.InvocationInfo.ScriptLineNumber )
            {
                $r?errorInfo.PSObject.Properties.Add([psnoteproperty]::new('Line', $r?error.InvocationInfo.ScriptLineNumber)); 
            };
            if ( $r?error.InvocationInfo.OffsetInLine )
            {
                $r?errorInfo.PSObject.Properties.Add([psnoteproperty]::new('Offset', $r?error.InvocationInfo.OffsetInLine)); 
            };
        };
    };
        
    Write-Error -Exception $PSItem -RecommendedAction 'Troubleshoot module!';
}
finally
{
    Export-ModuleMember -Function $v?functionsToExport -Cmdlet @() -Variable @() -Alias @();
    [datetime]$s?finishedAt = [datetime]::Now;
    '[{0}] Module "{1}" ...loading finished {{2}}' -f @(
        $s?finishedAt.ToString($c?TimestampPattern), $s?FullName, $($s?finishedAt - $s?launchedAt).ToString()
    ) | Write-Debug;
}

# SIG # Begin signature block
# MIIdPwYJKoZIhvcNAQcCoIIdMDCCHSwCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUzAGn8bEregkYnvk5++cGvLRY
# a1igghgQMIIFHDCCA4SgAwIBAgIBAjANBgkqhkiG9w0BAQwFADBcMQswCQYDVQQG
# EwJSVTEpMCcGA1UECgwgQWxla3NleSBNb3NrYWx5b3YgYS5rLmEuIGtSYVZlZGEx
# DDAKBgNVBAsMA1BLSTEUMBIGA1UEAwwLVGhlIFJvb3QgQ0EwHhcNMTYxMTA4MTAz
# ODMxWhcNNDcxMDI4MTAzODMxWjBgMQswCQYDVQQGEwJSVTEpMCcGA1UECgwgQWxl
# a3NleSBNb3NrYWx5b3YgYS5rLmEuIGtSYVZlZGExDDAKBgNVBAsMA1BLSTEYMBYG
# A1UEAwwPVGhlIFNvZnR3YXJlIENBMIIBojANBgkqhkiG9w0BAQEFAAOCAY8AMIIB
# igKCAYEA3RSeZr+MnwFsUCionIm/lE5k7xU9M0eP0/WbXtWnts/TK+ggJ4I1NSkk
# YFfAIL5RT6rreXCH6dUJVperf8JPr//bI2Qzz8SX8GCT1+5qAKsh2qUV0Q9FDlKO
# KpxDPnP8A0OLZu3MsGZiE08PiChD0teFwNQtmdjF4jtskhyH2DjBGEWwwI9Pm3h4
# yTk8OOFmqbpJDBymzEXbucVcxpfovv/RrA9noM8hsH87qZHHnV9ywAVca4BIwWMg
# Zs7p0vYMRns2yRoIm5dSk2CqmNJ0zrUcOT0LdRCJ6anzRbQ4vaXMsKIGl8Qu2vH9
# FVbJb2nwF9ef3nrR+wYzk1Wj/fZ+yZrQ8WoaFPSsSIKXDNSJ5tJ+IgVxd9V4FS6h
# nLSjX9dd4jhjh/yxzFeVp1cf4gbgVuhUxjbXJHZyLNlBbH4LE7HB9KeusXrVnRaB
# BFWKjPxSorrIVNcconko6KTPc2Ca1LcZi1MSeAbto9JF55PXniRTjZPpBLTmp8Kb
# aKWOpitrAgMBAAGjgeQwgeEwDgYDVR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYB
# Af8CAQAwHQYDVR0OBBYEFNBWgXwYAZFJTA6A9Q5zfV6K5yLoMB8GA1UdIwQYMBaA
# FA5qIgGRwm8XjZbfrI/FTKLS+gYVMEIGCCsGAQUFBwEBBDYwNDAyBggrBgEFBQcw
# AoYmaHR0cDovL2tyYXZlZGEucHJvL3BraS90aGUtcm9vdC1jYS5jZXIwNwYDVR0f
# BDAwLjAsoCqgKIYmaHR0cDovL2tyYXZlZGEucHJvL3BraS90aGUtcm9vdC1jYS5j
# cmwwDQYJKoZIhvcNAQEMBQADggGBAKzUTmAblljuS7Tivs189ticVH+1qAc7MRwS
# IsnJvW5G/mp9BKmEmUE68Tk/w+Y5kaalw8N13QhCrvDXbiaEts2WtKTEi3Yp7g6a
# ywUw4zqKgiylbjcTB96eDV8hmYjTARtpXHRkk6vWiap/Rt2q1KO9JusRpMEtFUXf
# UH4R2G2G/+oCedrwcJnRKLDgLbAwNklFno8oxXF5JnvLjOGOHFOkNkPyYrXLbMp4
# ADHqW/Yf1l2M+nnmKY1gx/M27ZFR0f7GMVhYCfhA47VleyPTqu4cPwBSLImX/sFx
# 7DMzKfD7pgo40DDG2Mx97NFcdLhgvRIq4jJtDfHExNngMtLrrEiD5NZSKOqbJur3
# JzT1rU8YzEu215oqj1vTq0y7hkdiG2T6YWevPujVHRNWJpi8Wd8nr7l7EmO0SfDW
# NhKP5nxXCra1zq2+g0//e0DuDETugYgKFPOFyZe4bKD94yOKaEa237/bZ1HDJCcs
# ekkh12a/ULY+oDsAMOBCFX1UrJ2F4DCCBa0wggQVoAMCAQICAQQwDQYJKoZIhvcN
# AQEMBQAwYDELMAkGA1UEBhMCUlUxKTAnBgNVBAoMIEFsZWtzZXkgTW9za2FseW92
# IGEuay5hLiBrUmFWZWRhMQwwCgYDVQQLDANQS0kxGDAWBgNVBAMMD1RoZSBTb2Z0
# d2FyZSBDQTAeFw0xNjExMDgxNzEwMjZaFw00NzEwMjgxNzEwMjZaMIGiMQswCQYD
# VQQGEwJSVTEWMBQGA1UECAwNTW9zY293IFJlZ2lvbjETMBEGA1UEBwwKQmFsYXNo
# aWtoYTEpMCcGA1UECgwgQWxla3NleSBNb3NrYWx5b3YgYS5rLmEuIGtSYVZlZGEx
# EDAOBgNVBAsMB0RldlRlYW0xKTAnBgNVBAMMIEFsZWtzZXkgTW9za2FseW92IGEu
# ay5hLiBrUmFWZWRhMIIBojANBgkqhkiG9w0BAQEFAAOCAY8AMIIBigKCAYEAoWQl
# 40L+PmPjwEwnk3YckDjH8ATSzDvpnNIXDHHtf4lWGK6Al01OC7fh2h1Uh9Z8BbBp
# B78Cp47zklU3PuLQI9rf6gvWl4Lk1opK/Kl38byhMEmpdV0GldqPjToPIxnLL/4S
# xBvny8OiiqYy6wdqcU8PIC74ZocnssN9wcCrxFYR4luYTZilxYV4ksne7+HpfvXw
# qKsTaWlHFVuef24qdTINL0hixawJLv7ZcAlqkQRVPfMr+zQ5YiQvEZcn9JjRXBTc
# HA0PZVWztqgo8qIowOD3c1E0MrdsIGv1cUvOQm7qgJuzrg7acLEPD653PuT9baC0
# CbHVpNkjULB/MBN0HDsRtT3o/JMh2YVYepRRAG7xHUzt+dM2jxFv2rUbUg8mIJ4d
# qKTcqtTUckbXTmUqRu9PQqaNVGWoHs6AlHde36KvyRFBTPWR6SMkDINDrG9sGmbx
# +5wtBeDrER2+Eb9rfJvZJCb7lTYDPL1q5tti83C65el1mQgP1KMkd2KVH4W7AgMB
# AAGjggEtMIIBKTAOBgNVHQ8BAf8EBAMCB4AwCQYDVR0TBAIwADAWBgNVHSUBAf8E
# DDAKBggrBgEFBQcDAzAdBgNVHQ4EFgQUUg0NRtKT9OZvnvRm1XDKPg5dOpwwHwYD
# VR0jBBgwFoAU0FaBfBgBkUlMDoD1DnN9XornIugwRgYIKwYBBQUHAQEEOjA4MDYG
# CCsGAQUFBzAChipodHRwOi8va3JhdmVkYS5wcm8vcGtpL3RoZS1zb2Z0d2FyZS1j
# YS5jZXIwOwYDVR0fBDQwMjAwoC6gLIYqaHR0cDovL2tyYXZlZGEucHJvL3BraS90
# aGUtc29mdHdhcmUtY2EuY3JsMC8GA1UdEQQoMCaBEWtyYXZlZGFAeWFuZGV4LnJ1
# gRFrcmF2ZWRhQGdtYWlsLmNvbTANBgkqhkiG9w0BAQwFAAOCAYEAtPe94y7obbYa
# WNXrjypwRD4Q11FG3n4X6tMxmFQW1p+whXi6NtpWvbY2HSPy6v1Kp+yNmpUYrVUD
# rO/V2SboDOAR0Kcesdqfswi+NtS9wYFv0QnOJF764G0ooO/Mlr8m2z1VhQZVSj1x
# /9H/MT+7adrbrT85XjLk8IgkTGRKm3Um1V9Z7TcscNNY1Gc3SDrBLJ+Ny9b68GGg
# eE06sHSh61iZh051J9dSVa+zBjUYhx9OCFkyPRXBcX3i43EFyWIhJ0xHzddo02Mc
# QAasJ+vnJM5atiIhV9zrPHVNC58D1gs4uE/LlUlmbuM++3ZBg/yb/c01r58FNM3c
# IyrfQZpD2qhNkficF9VyPIKHrad2he2EbAG0JkHwPueQR5xj5xxp/9sQMPVr+RRL
# tB0PtMxh0QSBDtivI72IMvaQG63+EKNllwCBRmvv/ZoNRxbbOFOOmZki+vrKGozQ
# gDWOngnXyX4Qt6H+tB/rjXiM2tpcZpM0DS2t1w5NB0Tolw0fvacAMIIGajCCBVKg
# AwIBAgIQAwGaAjr/WLFr1tXq5hfwZjANBgkqhkiG9w0BAQUFADBiMQswCQYDVQQG
# EwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNl
# cnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBBc3N1cmVkIElEIENBLTEwHhcNMTQx
# MDIyMDAwMDAwWhcNMjQxMDIyMDAwMDAwWjBHMQswCQYDVQQGEwJVUzERMA8GA1UE
# ChMIRGlnaUNlcnQxJTAjBgNVBAMTHERpZ2lDZXJ0IFRpbWVzdGFtcCBSZXNwb25k
# ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCjZF38fLPggjXg4PbG
# KuZJdTvMbuBTqZ8fZFnmfGt/a4ydVfiS457VWmNbAklQ2YPOb2bu3cuF6V+l+dSH
# dIhEOxnJ5fWRn8YUOawk6qhLLJGJzF4o9GS2ULf1ErNzlgpno75hn67z/RJ4dQ6m
# WxT9RSOOhkRVfRiGBYxVh3lIRvfKDo2n3k5f4qi2LVkCYYhhchhoubh87ubnNC8x
# d4EwH7s2AY3vJ+P3mvBMMWSN4+v6GYeofs/sjAw2W3rBerh4x8kGLkYQyI3oBGDb
# vHN0+k7Y/qpA8bLOcEaD6dpAoVk62RUJV5lWMJPzyWHM0AjMa+xiQpGsAsDvpPCJ
# EY93AgMBAAGjggM1MIIDMTAOBgNVHQ8BAf8EBAMCB4AwDAYDVR0TAQH/BAIwADAW
# BgNVHSUBAf8EDDAKBggrBgEFBQcDCDCCAb8GA1UdIASCAbYwggGyMIIBoQYJYIZI
# AYb9bAcBMIIBkjAoBggrBgEFBQcCARYcaHR0cHM6Ly93d3cuZGlnaWNlcnQuY29t
# L0NQUzCCAWQGCCsGAQUFBwICMIIBVh6CAVIAQQBuAHkAIAB1AHMAZQAgAG8AZgAg
# AHQAaABpAHMAIABDAGUAcgB0AGkAZgBpAGMAYQB0AGUAIABjAG8AbgBzAHQAaQB0
# AHUAdABlAHMAIABhAGMAYwBlAHAAdABhAG4AYwBlACAAbwBmACAAdABoAGUAIABE
# AGkAZwBpAEMAZQByAHQAIABDAFAALwBDAFAAUwAgAGEAbgBkACAAdABoAGUAIABS
# AGUAbAB5AGkAbgBnACAAUABhAHIAdAB5ACAAQQBnAHIAZQBlAG0AZQBuAHQAIAB3
# AGgAaQBjAGgAIABsAGkAbQBpAHQAIABsAGkAYQBiAGkAbABpAHQAeQAgAGEAbgBk
# ACAAYQByAGUAIABpAG4AYwBvAHIAcABvAHIAYQB0AGUAZAAgAGgAZQByAGUAaQBu
# ACAAYgB5ACAAcgBlAGYAZQByAGUAbgBjAGUALjALBglghkgBhv1sAxUwHwYDVR0j
# BBgwFoAUFQASKxOYspkH7R7for5XDStnAs0wHQYDVR0OBBYEFGFaTSS2STKdSip5
# GoNL9B6Jwcp9MH0GA1UdHwR2MHQwOKA2oDSGMmh0dHA6Ly9jcmwzLmRpZ2ljZXJ0
# LmNvbS9EaWdpQ2VydEFzc3VyZWRJRENBLTEuY3JsMDigNqA0hjJodHRwOi8vY3Js
# NC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURDQS0xLmNybDB3BggrBgEF
# BQcBAQRrMGkwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBB
# BggrBgEFBQcwAoY1aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
# QXNzdXJlZElEQ0EtMS5jcnQwDQYJKoZIhvcNAQEFBQADggEBAJ0lfhszTbImgVyb
# hs4jIA+Ah+WI//+x1GosMe06FxlxF82pG7xaFjkAneNshORaQPveBgGMN/qbsZ0k
# fv4gpFetW7easGAm6mlXIV00Lx9xsIOUGQVrNZAQoHuXx/Y/5+IRQaa9YtnwJz04
# HShvOlIJ8OxwYtNiS7Dgc6aSwNOOMdgv420XEwbu5AO2FKvzj0OncZ0h3RTKFV2S
# Qdr5D4HRmXQNJsQOfxu19aDxxncGKBXp2JPlVRbwuwqrHNtcSCdmyKOLChzlldqu
# xC5ZoGHd2vNtomHpigtt7BIYvfdVVEADkitrwlHCCkivsNRu4PQUCjob4489yq9q
# jXvc2EQwggbNMIIFtaADAgECAhAG/fkDlgOt6gAK6z8nu7obMA0GCSqGSIb3DQEB
# BQUAMGUxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNV
# BAsTEHd3dy5kaWdpY2VydC5jb20xJDAiBgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQg
# SUQgUm9vdCBDQTAeFw0wNjExMTAwMDAwMDBaFw0yMTExMTAwMDAwMDBaMGIxCzAJ
# BgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5k
# aWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IEFzc3VyZWQgSUQgQ0EtMTCC
# ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOiCLZn5ysJClaWAc0Bw0p5W
# VFypxNJBBo/JM/xNRZFcgZ/tLJz4FlnfnrUkFcKYubR3SdyJxArar8tea+2tsHEx
# 6886QAxGTZPsi3o2CAOrDDT+GEmC/sfHMUiAfB6iD5IOUMnGh+s2P9gww/+m9/ui
# zW9zI/6sVgWQ8DIhFonGcIj5BZd9o8dD3QLoOz3tsUGj7T++25VIxO4es/K8DCuZ
# 0MZdEkKB4YNugnM/JksUkK5ZZgrEjb7SzgaurYRvSISbT0C58Uzyr5j79s5AXVz2
# qPEvr+yJIvJrGGWxwXOt1/HYzx4KdFxCuGh+t9V3CidWfA9ipD8yFGCV/QcEogkC
# AwEAAaOCA3owggN2MA4GA1UdDwEB/wQEAwIBhjA7BgNVHSUENDAyBggrBgEFBQcD
# AQYIKwYBBQUHAwIGCCsGAQUFBwMDBggrBgEFBQcDBAYIKwYBBQUHAwgwggHSBgNV
# HSAEggHJMIIBxTCCAbQGCmCGSAGG/WwAAQQwggGkMDoGCCsGAQUFBwIBFi5odHRw
# Oi8vd3d3LmRpZ2ljZXJ0LmNvbS9zc2wtY3BzLXJlcG9zaXRvcnkuaHRtMIIBZAYI
# KwYBBQUHAgIwggFWHoIBUgBBAG4AeQAgAHUAcwBlACAAbwBmACAAdABoAGkAcwAg
# AEMAZQByAHQAaQBmAGkAYwBhAHQAZQAgAGMAbwBuAHMAdABpAHQAdQB0AGUAcwAg
# AGEAYwBjAGUAcAB0AGEAbgBjAGUAIABvAGYAIAB0AGgAZQAgAEQAaQBnAGkAQwBl
# AHIAdAAgAEMAUAAvAEMAUABTACAAYQBuAGQAIAB0AGgAZQAgAFIAZQBsAHkAaQBu
# AGcAIABQAGEAcgB0AHkAIABBAGcAcgBlAGUAbQBlAG4AdAAgAHcAaABpAGMAaAAg
# AGwAaQBtAGkAdAAgAGwAaQBhAGIAaQBsAGkAdAB5ACAAYQBuAGQAIABhAHIAZQAg
# AGkAbgBjAG8AcgBwAG8AcgBhAHQAZQBkACAAaABlAHIAZQBpAG4AIABiAHkAIABy
# AGUAZgBlAHIAZQBuAGMAZQAuMAsGCWCGSAGG/WwDFTASBgNVHRMBAf8ECDAGAQH/
# AgEAMHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGln
# aWNlcnQuY29tMEMGCCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5j
# b20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3J0MIGBBgNVHR8EejB4MDqgOKA2
# hjRodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290
# Q0EuY3JsMDqgOKA2hjRodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRB
# c3N1cmVkSURSb290Q0EuY3JsMB0GA1UdDgQWBBQVABIrE5iymQftHt+ivlcNK2cC
# zTAfBgNVHSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823IDzANBgkqhkiG9w0BAQUF
# AAOCAQEARlA+ybcoJKc4HbZbKa9Sz1LpMUerVlx71Q0LQbPv7HUfdDjyslxhopyV
# w1Dkgrkj0bo6hnKtOHisdV0XFzRyR4WUVtHruzaEd8wkpfMEGVWp5+Pnq2LN+4st
# kMLA0rWUvV5PsQXSDj0aqRRbpoYxYqioM+SbOafE9c4deHaUJXPkKqvPnHZL7V/C
# SxbkS3BMAIke/MV5vEwSV/5f4R68Al2o/vsHOE8Nxl2RuQ9nRc3Wg+3nkg2NsWmM
# T/tZ4CMP0qquAHzunEIOz5HXJ7cW7g/DvXwKoO4sCFWFIrjrGBpN/CohrUkxg0eV
# d3HcsRtLSxwQnHcUwZ1PL1qVCCkQJjGCBJkwggSVAgEBMGUwYDELMAkGA1UEBhMC
# UlUxKTAnBgNVBAoMIEFsZWtzZXkgTW9za2FseW92IGEuay5hLiBrUmFWZWRhMQww
# CgYDVQQLDANQS0kxGDAWBgNVBAMMD1RoZSBTb2Z0d2FyZSBDQQIBBDAJBgUrDgMC
# GgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYK
# KwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG
# 9w0BCQQxFgQURSsYgBtYu7lR8SqfWd9/jkx128AwDQYJKoZIhvcNAQEBBQAEggGA
# KacgVpu8u2Du69UZrrPgPQachgEixwE5Xbyl//kRv8jB+pQtq1KuDzNVtG7TeDGw
# G5xUlwG7hMw8eA345cGvPhOxegeD0efms3h8K5V5oL2C+kVRBVQWbIDXpWCo4yk6
# Vfe8xHPsBjGk4vfVIRulIdv+mATfYti7o17WGMN4l2P7S6uWfagzhqbN7vXOaLNe
# hvBjecVeuOV5Jd4MNaVDgnvT2te3gHn8peOFul88TIJkmfzD9bfJCAtpcLzUt/OC
# YhCSTupWa8uP2/rmhkmTi7ySNrsrD31wOE/bl0b3sgWQrFJ+d2+aVgyyNIFu3E7P
# RW73zmyvTZkDkPFYnGPsJRqVFjM82O4qR2Lt8OV0NO6KbLiaTn5otZOoVFGAHbNw
# wIoWnbBH0Ov72RfV3UEoLplLeRfZ8RujAKJe18439HIQ/2MdJt99J+8gKJs4ixMT
# D/IPm/JFqkyOYgMLwrAoREVXqO7ReTiRSYA4xqH3o740WYngxHpNv5eITQ2SHQnA
# oYICDzCCAgsGCSqGSIb3DQEJBjGCAfwwggH4AgEBMHYwYjELMAkGA1UEBhMCVVMx
# FTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNv
# bTEhMB8GA1UEAxMYRGlnaUNlcnQgQXNzdXJlZCBJRCBDQS0xAhADAZoCOv9YsWvW
# 1ermF/BmMAkGBSsOAwIaBQCgXTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
# CSqGSIb3DQEJBTEPFw0xNjExMTcxOTQ4MjFaMCMGCSqGSIb3DQEJBDEWBBRljqYi
# GrIGCt4tbSxWGkxx85JfDjANBgkqhkiG9w0BAQEFAASCAQBYkZI8AapS60coX3r7
# r4Dc0I5BGrFzPj8HvoPGs6NDL3R9zbCBM3zKdHJttzB35cfdHi9eaM0/9hdnNB9K
# 51nZ48Wb1pseHPBVTQTF64wVqRJztC/2TXFrJ4M8s9p6spJJdV7BHP/H4GsJTokR
# Gf6R0yaw6J6Mg0SeOtOgaCGr2ZsATN44O4RHwjBwfVWFE0ngHOPCXMrZ9DWfrJeF
# zlNhIsviT+v0N+nVBNn/kg685C9KJ+C4VUjoOMw2NgI086mu2DTm7qNmERqjED5F
# HvES9LrKic7jcQeM65f9nR7htmcOWWJ05uoON41sZQAMKflBAHj/u6iQYdmcb2E1
# e43G
# SIG # End signature block
