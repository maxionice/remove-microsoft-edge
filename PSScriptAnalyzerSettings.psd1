@{
    # Fail the build on warnings and errors.
    Severity = @('Warning', 'Error')

    # Write-Host is intentional here: this is an interactive CLI tool whose
    # colour-coded console output (Write-EdgeLog) and the double-click entry
    # script are meant for a human at the console, not the pipeline.
    ExcludeRules = @(
        'PSAvoidUsingWriteHost'
    )
}
