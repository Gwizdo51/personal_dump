# Helper functions to request user confirmation

function Confirmation-Prompt {
    param(
        [string] $Question = 'Are you sure you want to perform this action?',
        [hashtable] $ChoicesTable,
        [int] $DefaultChoice = 0
    )
    $choices = $ChoicesTable.Keys | sort | % {New-Object -TypeName Management.Automation.Host.ChoiceDescription $ChoicesTable[$_][0], $ChoicesTable[$_][1]}
    $Host.UI.PromptForChoice('Confirm', $question, $choices, $DefaultChoice)
}

function Default-Confirmation-Prompt {
    param([string]$QuestionNewLine)
    $Question = 'Are you sure you want to perform this action?'
    if ($QuestionNewLine) {$Question = $Question + "`n" + $QuestionNewLine}
    $choices_table = @{
        0 = '&Yes', 'Continue with only the next step of the operation.';
        1 = 'Yes to &All', 'Continue with all the steps of the operation.';
        2 = '&No', 'Skip this operation and proceed with the next operation.';
        3 = 'No to A&ll', 'Skip this operation and all subsequent operations.';
        4 = '&Suspend', 'Pause the current pipeline and return to the command prompt. Type "exit" to resume the pipeline.'
    }
    confirmation_prompt -Question $Question -ChoicesTable $choices_table
}

function ShouldProcess-Yes-No {
    param(
        $PSCmdlet,
        [switch] $Confirm,
        [string] $ConfirmImpact,
        [string] $ConfirmQuestion,
        [switch] $WhatIf,
        [string] $WhatIfMessage
    )
    # low = 0 (confirm every step)
    # medium = 1
    # high = 2
    # None = 3 (bypass every confirmation)
    # Write-Host 'ShouldProcess-Yes-No $ConfirmPreference:' $ConfirmPreference
    switch ($ConfirmPreference) {
        'Low' {$ConfirmPreference_int = 0}
        'Medium' {$ConfirmPreference_int = 1}
        'High' {$ConfirmPreference_int = 2}
        'None' {$ConfirmPreference_int = 3}
    }
    switch ($ConfirmImpact) {
        'Low' {$ConfirmImpact_int = 0}
        'Medium' {$ConfirmImpact_int = 1}
        'High' {$ConfirmImpact_int = 2}
    }
    $should_confirm = $($ConfirmImpact_int -ge $ConfirmPreference_int)
    # Write-Host $should_confirm
    if ($WhatIf) {
        $user_answer = $False
        $PSCmdlet.WriteInformation("What if: ${WhatIfMessage}", '')
    }
    elseif ($Confirm -or $should_confirm) {
        $user_answer = $PSCmdlet.ShouldContinue("${ConfirmQuestion}", '')
    }
    else {
        $user_answer = $True
        # Write the WhatIf message as a verbose message
        $PSCmdlet.WriteVerbose($WhatIfMessage)
    }
    return $user_answer
}
