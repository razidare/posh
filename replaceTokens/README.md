# Replace tokenized variables in a script with the context values of those variables

## How to run
``` .\replaceTokens.ps1 -filePath .\test.yml```

## Process
The start and end tokens can be customized through the optional parameters `leftPattern` and `rightPattern`
Variables are inherited from the ENV: and Variable providers

Setup:
```
$value = "abcd"
$value2 = "defg"
```

Input:
```
#comment1
#comment2#{}#
variable=value
var=#{value}#
anotherVariable=$_
variable2=#{value2}#
```

Result:
```
#comment1
#comment2#{}#
variable=value
var=#{abcd}#
anotherVariable=$_
variable2=#{defg}#
```