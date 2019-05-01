# Robot Helpers
[Robot Framework](http://robotframework.org/) scripts I utilize at work.

## JSON generator

Creates json files from the excel columns. 

### To run the example

Project includes an example excel. To run the example:

```
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

Write logic using Python/JavaScript and extend Robot Library. Might utilize existing excel to json libraries.
