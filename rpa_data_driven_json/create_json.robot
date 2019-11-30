*** Settings ***

Documentation   Data Driven Task that gets list and true/false as variable,
...             can perfom some keyword for lists
...             and outputs JSON of all lists as Environment variable.
...             NOTE: When used in real-life, replace commented part in the
...             Keywod "Do Stuff For List" with actual-keyword that does something.

Library         Collections
Library         OperatingSystem
Library         json

Suite Teardown  Generate JSON

Task Template   Do Stuff For List

*** Variables ***

&{RESULTS_LIST}

@{CANINE}           Dog
@{DINOSAUR}         Mayasaura  Stegosaurus  Triceratops  Pteranodon

*** Tasks ***       EXTINCT     ANIMALS 
Mammals             ${false}    @{CANINE}
Dinosaur            ${true}     @{DINOSAUR}

*** Keywords ***

Do Stuff For List
    [Arguments]  ${extinct}  @{animals}
    ${temp_dict}                Create Dictionary
    #Some Keyword That Uses Variables From Arguments (Original lists can be modified here)
    Set To Dictionary           ${temp_dict}        extinct=${extinct}      species=@{animals}
    Set To Dictionary           ${RESULTS_LIST}     ${TEST_NAME}=${temp_dict}  

Generate JSON
    ${result}                   json.dumps          ${RESULTS_LIST}
    Log To Console              ${RESULTS_LIST}
    Set Environment Variable    json_result         ${result}