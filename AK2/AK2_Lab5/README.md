# Laboratory Work №5 on AK-2 KPI Koval Rostislav IO-71

Created a small project with one source file, which receives and analyzes any number
command line options. There also is a correspondence between long and
short form keys, such as --help and -h, are two forms
of the same key.

List of valid keys:
+ -h, --help, getting help;
+ -v, --verbose, enable verbose mode of program;
+ -l, --my_list, list of values;
+ -b, --my_boolean, optional flag;
+ -f, --my_file, saving file;


### Using the project 
`git clone https://github.com/smithros/AK2_Lab5.git`

`cmake ~/AK2_Lab5`

### Commands usage
`./main`

`./main -h`

`./main --help`

`./main --verbose=4`

`./main -v 1`

`./main --my_list=3,4,5,6`

`./main -l 1,2,3,4`

`./main --my_file="some_text"`

`./main -f "some_text"`

`./main --my_boolean=0`

`./main -b=1`

### In case of wrong key
`./main -k --notify`
`./main: invalid option -- 'k'`
`./main: unrecognized option '--notify'`
