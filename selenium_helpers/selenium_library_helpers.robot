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
    
Test That Fails With 0.5 Probability
    ${random}       Evaluate    random.uniform(0, 1)    random
    ${fail}         Evaluate    ${random} < 0.5
    Run Keyword If              ${fail}                 Fail    This test is failing randomly
