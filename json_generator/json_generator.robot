*** Settings ****

Documentation   Script creates .json files from Excel
...     
...             To run the example test.xlxs: robot js_file_generator.robot
...
...             Excel must be in a following format:
...             * row 1: name of the output files, example: "en-US", "ja-JP"
...             * column A: json keys
...             * column B: comments, not included in the output files
...             * column C onwards: json values
...             * nested list: key is marked with brackets, for example [Months]
...             * comments: keys that start with // are not included in the json

Library         Collections
Library         OperatingSystem
Library         String
Library         ExcelRobot      # to install: pip install robotframework-excel --upgrade
Library         JSONLibrary     # to install: pip install -U robotframework-jsonlibrary
Library         JsonHelper.py

Task Setup      Open Excel   ${EXCEL}

*** Variables ***

${EXCEL}        ${CURDIR}/test/test.xlsx
${SHEET}        Sheet1
${FOLDER_JSON}  ./generated


*** Tasks ***

Generate Json From Excel
    Read Values And Create JSON File For Each Column
    Test Generator Script


*** Keywords ***

Read Values And Create JSON File For Each Column
    ${keys}=                Get Column Values As List       0
    ${column_count}         Get Column Count                ${SHEET}
        FOR  ${index}  IN RANGE  2  ${column_count}
            ${values}           Get Column Values As List   ${index}
            ${dictionary}       Make Custom Dictionary      ${keys}         ${values}
            ${language}         Read Cell Data              ${SHEET}        ${index}   0
            Create File         ${language}                 ${dictionary}
        END

Make Custom Dictionary
    [Arguments]  ${keys}  ${values}
    ${dictionary}       Create Dictionary
    ${length}           Get Length  ${keys}
    FOR    ${i}    IN RANGE    1    ${length}
        #Do not add comments
        ${is_comment}   Run Keyword And Return Status   Should Start With  ${keys}[${i}]  //
        Continue For Loop If            ${is_comment}
        #Remove brackets from Key
        ${key_to_add}                   Strip String  ${keys}[${i}]   characters=[]
        Add Value To Custom Dictionary  ${dictionary}   ${key_to_add}   ${values}[${i}]
    END
    [Return]  ${dictionary}

Create File    
    [Arguments]  ${language}  ${dictionary}
    ${json_string}          Evaluate    json.dumps(${dictionary}, indent=4, ensure_ascii=False).encode('utf8')    json                  
    Create Binary File      ${FOLDER_JSON}/${language}.json     ${json_string}

Get Column Values As List
    [Arguments]     ${column}
    ${keys}         Create List
    ${rows}         Get Row Count   ${SHEET}
    FOR  ${index}  IN RANGE  ${rows}
        ${data}             Read Cell Data  ${SHEET}  ${column}  ${index}
        Append To List      ${keys}  ${data}
    END
    [Return]                ${keys}

Test Generator Script
    [Documentation]     Runs Json Generator
    ...                 Compares file test/vi-VN_original.json to the generated file           
    Read Values And Create JSON File For Each Column
    ${original_json}    Load Json From File    ./test/vi-VN_original.json
    ${generated_json}   Load JSON From File     ./${FOLDER_JSON}/vi-VN.json
    Dictionaries Should Be Equal                ${original_json}    ${generated_json} 