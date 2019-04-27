*** Settings ****

Documentation   Script creates .json files from Excel
...     
...             To run the example test.xlxs: robot js_file_generator.robot
...
...             Excel must have following formatting:
...                 * row 1: name for output file, example: "en-US"
...                 * column A: json keys
...                 * column B: comments, not included in json
...                 * column C onwards: json values
...                 * nested list: key is marked with [], example [Months]
...                 * comments: keys that start with // not included in the json

Library         Collections
Library         OperatingSystem
Library         String
Library         ExcelRobot  # to install: pip install robotframework-excel --upgrade


Test Setup      Open Excel   ${EXCEL}

*** Variables ***

${EXCEL}        ${CURDIR}/test/test.xlsx
${SHEET}        Sheet1
${FOLDER_JSON}  ./created


*** Tasks ***

Generate Json From Excel
    ${keys}=                Get Column Values       0
    ${column_count}         Get Column Count        ${SHEET}
    FOR  ${index}  IN RANGE  2  ${column_count}
        ${values}           Get Column Values       ${index}
        ${dictionary}       Make Custom Dictionary  ${keys}         ${values}
        ${language}         Read Cell Data          ${SHEET}        ${index}   0
        Create File         ${language}             ${dictionary}
    END

*** Keywords ***
    
Create File    
    [Arguments]     ${language}  ${dictionary}
    ${json_string}          Evaluate    json.dumps(${dictionary}, indent=4, ensure_ascii=False).encode('utf8')    json                  
    Create Binary File      ${FOLDER_JSON}/${language}.json     ${json_string}

Get Column Values
    [Arguments]     ${column}
    ${keys}=        Create List
    ${rows}=        Get Row Count   ${SHEET}
    FOR  ${index}  IN RANGE  ${rows}
        ${data}=                    Read Cell Data  ${SHEET}  ${column}  ${index}
        Append To List      ${keys}  ${data}
    END
    [Return]                ${keys}

Make Custom Dictionary
    [Arguments]  ${keys}  ${values}
    ${dictionary}       Create Dictionary
    ${nested_keys}      Create List
    ${length}           Get Length  ${keys}
    FOR    ${i}    IN RANGE    1    ${length}
        #exclude comments rows
        ${is_comment}   Run Keyword And Return Status       Should Start With  ${keys}[${i}]  //
        Continue For Loop If    ${is_comment}
        #handle Nested Arrays
        ${is_nested}    Run Keyword And Return Status       Should Start With  ${keys}[${i}]  [
        ${nested_key}   Run Keyword If  ${is_nested}        Strip String  ${keys}[${i}]   characters=[]
        ${nested_key_already_handled}       Run Keyword And Return Status   List Should Contain Value   ${nested_keys}  ${nested_key}
        Continue For Loop If                ${nested_key_already_handled}
        Run Keyword If  ${is_nested}        Append To List                  ${nested_keys}      ${nested_key}
        Run Keyword If  ${is_nested}        Add Nested Key To The Dictionary    ${keys}  ${values}  ${nested_key}  ${dictionary}
        #If not comment or nested Array, set to dictionary
        Run Keyword Unless  ${is_nested}    Set To Dictionary   ${dictionary}    ${keys}[${i}]=${values}[${i}]
    END
    [Return]    ${dictionary} 

Add Nested Key To The Dictionary
    [Arguments]     ${keys}  ${values}  ${nested_key}   ${dictionary}
    ${list}                 Create List
    ${first_occurence}      Get Index From List         ${keys}     [${nested_key}]
    ${match_count}          Get Count      ${keys}      [${nested_key}]
    FOR  ${i}  IN RANGE     ${first_occurence}          ${first_occurence}+${match_count} 
        Append To List      ${list}   ${values}[${i}]
    END
    Set To Dictionary       ${dictionary}               ${nested_key}=${list}