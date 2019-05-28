# Robot Helpers

[Robot Framework](http://robotframework.org/) scripts I utilize at work.

## JSON generator

Creates json files from the Excel columns.

### To run the example

Project includes an example Excel. To run the example:

```bash
cd json_generator
robot json_generator.robot
```

### Excel formatting

Excel must be in a following format:

* row 1: name  of the output files, example: "en-US", "ja-JP"
* column A: json keys
* column B: comments, not included in the output files
* column C onwards: json values
* nested list: key is marked with brackets, for example [Months]. Works also without brackets.
* comments: keys that start with // are not included in the json

### Future considerations

Drop JSONLibrary and ExcelRobot libraries and write keywords directly using Python.

## Selenium Library Helpers

Helper keywords to click nth and last of a kind element on a page. Keywords utilize [Selenium Library](http://robotframework.org/SeleniumLibrary/).
