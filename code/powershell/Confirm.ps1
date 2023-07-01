# $title = 'Confirm'
# $question = "Are you sure you want to perform this action?`nPerforming the operation `"Remove File`" on target `"D:\code\personal_dump\code\powershell\lol.txt`"."
# # $choices = '&Yes', '&No'
# $choice_yes = New-Object -TypeName Management.Automation.Host.ChoiceDescription '&Yes', 'Continue with only the next step of the operation.'
# $choice_yesall = New-Object -TypeName Management.Automation.Host.ChoiceDescription 'Yes to &All', 'Continue with all the steps of the operation.'
# $choice_no = New-Object -TypeName Management.Automation.Host.ChoiceDescription '&No', 'Skip this operation and proceed with the next operation.'
# $choice_noall = New-Object -TypeName Management.Automation.Host.ChoiceDescription 'No to A&ll', 'Skip this operation and all subsequent operations.'
# $choice_suspend = New-Object -TypeName Management.Automation.Host.ChoiceDescription '&Suspend', 'Pause the current pipeline and return to the command prompt. Type "exit" to resume the pipeline.'
# $choices = $choice_yes, $choice_yesall, $choice_no, $choice_noall, $choice_suspend
# $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
# $decision

function default_confirmation_prompt {
    param([string]$question_new_line)
    $title = 'Confirm'
    $question = 'Are you sure you want to perform this action?'
    if ($question_new_line) {$question = $question + "`n" + $question_new_line}
    $choice_yes = New-Object -TypeName Management.Automation.Host.ChoiceDescription '&Yes', 'Continue with only the next step of the operation.'
    $choice_yesall = New-Object -TypeName Management.Automation.Host.ChoiceDescription 'Yes to &All', 'Continue with all the steps of the operation.'
    $choice_no = New-Object -TypeName Management.Automation.Host.ChoiceDescription '&No', 'Skip this operation and proceed with the next operation.'
    $choice_noall = New-Object -TypeName Management.Automation.Host.ChoiceDescription 'No to A&ll', 'Skip this operation and all subsequent operations.'
    $choice_suspend = New-Object -TypeName Management.Automation.Host.ChoiceDescription '&Suspend', 'Pause the current pipeline and return to the command prompt. Type "exit" to resume the pipeline.'
    $choices = $choice_yes, $choice_yesall, $choice_no, $choice_noall, $choice_suspend
    $Host.UI.PromptForChoice($title, $question, $choices, 0)
}

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
