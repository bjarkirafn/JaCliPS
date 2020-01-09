@{
    Path = "jaCliPS.psd1"
    OutputDirectory = "..\bin\jaCliPS"
    Prefix = '.\_PrefixCode.ps1'
    SourceDirectories = 'Classes','Private','Public'
    Symlinks = @{
        Classes = ''
        Private = ''
        Public  = ''
    }
    PublicFilter = 'Public\*.ps1'
    CopyDirectories = @('ModulesToProcess')
    VersionedOutputDirectory = $true
}

