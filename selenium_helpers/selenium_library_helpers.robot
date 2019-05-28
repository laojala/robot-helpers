*** Settings ***
Library     SeleniumLibrary

*** Keywords ***

Get Number Of Elements On A Page
    [arguments]     ${element} 
    @{elements}     Get Webelements     ${element}
    ${length}       Get Length          ${elements}
    Log             ${length}

Wait And Click NN Element On A Page
    [arguments]     ${element}          ${nn}
    Wait Until Page Contains Element    ${element}
    @{elements}     Get Webelements     ${element}
    Click Element                       @{elements}[${nn}]

Wait And Click Last Element On A Page
    [arguments]     ${element}
    Wait Until Page Contains Element    ${element}
    @{elements}     Get Webelements     ${element}
    ${last}         Get Length          ${elements}
    ${index}        Evaluate            ${last} - 1
    Click Element                       @{elements}[${index}]