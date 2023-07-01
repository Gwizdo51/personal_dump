function confirmation_prompt {
    param(
        [string] $Question = 'Are you sure you want to perform this action?',
        [hashtable] $ChoicesTable,
        [int] $DefaultChoice = 0
    )
    $title = 'Confirm'
    $choices = $ChoicesTable.Keys | sort | % {New-Object -TypeName Management.Automation.Host.ChoiceDescription $ChoicesTable[$_][0], $ChoicesTable[$_][1]}
    $Host.UI.PromptForChoice($title, $question, $choices, $DefaultChoice)
}

function default_confirmation_prompt {
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
