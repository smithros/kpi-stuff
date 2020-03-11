#include <iostream>
#include <getopt.h>
#include <string.h>
#include <stdlib.h>

using namespace std;

struct globalArgs_t {
    int verbose;
    int my_list[4];
    int my_boolean;
    string my_file;
} glob_arguments;

static const char *optString = "v:l:b:f:h?";

static const struct option longOpts[] = {
        { "verbose", required_argument, nullptr, 'v'},
        { "help", no_argument, nullptr, 'h'},
        { "my_list", optional_argument, nullptr, 'l'},
        { "my_boolean", optional_argument, nullptr, 'b'},
	{ "my_file", optional_argument, nullptr, 'f'},
        {nullptr, no_argument, nullptr, 0}
};

void display_usage()
{
    puts("List of valid keys: "
            "\nArguments:
	    "\nverbose - enable verbose mode of program; "
            "\nhelp - display help "
	    "\nmy_list - list of values "
            "\nmy_boolean - optional flag "
	    "\nmy_file - file to save the result");
    exit ( EXIT_FAILURE );
}

void display_args()
{
    cout << "glob_arguments.verbose = " << glob_arguments.verbose << endl;
    cout << "glob_arguments.my_list = " << glob_arguments.my_list[0] << ", " <<
                                      glob_arguments.my_list[1] << ", " <<
                                      glob_arguments.my_list[2] << ", " <<
                                      glob_arguments.my_list[3] << "." << endl;
    cout << "glob_arguments.my_boolean = " << glob_arguments.my_boolean << endl;
    cout << "glob_arguments.my_file = " << glob_arguments.my_file << endl;
}

int main( int argc, char *argv[] )
{
    int opt = 0;
    int longIndex = 0;

    glob_arguments.verbose = 2;
    glob_arguments.my_list[0] = 1;
    glob_arguments.my_list[1] = 2;
    glob_arguments.my_list[2] = 3;
    glob_arguments.my_list[3] = 4;
    glob_arguments.my_boolean = 1;
    glob_arguments.my_file = "text.txt";

    int counter = 0;

    opt = getopt_long( argc, argv, optString, longOpts, &longIndex );
    //vlbfh?
    while( opt != -1 ) {

        switch( opt ) {
            case 'v':
                glob_arguments.verbose = atoi(optarg);
                break;

            case 'l':
		glob_arguments.my_list[0] = optarg[0] - '0';
                glob_arguments.my_list[1] = optarg[2] - '0';
                glob_arguments.my_list[2] = optarg[4] - '0';
                glob_arguments.my_list[3] = optarg[6] - '0';
                break;

            case 'b':
                glob_arguments.my_boolean = atoi(optarg);
                break;

            case 'f':
                glob_arguments.my_file = optarg;
                break;

	    case 'h':
                display_usage();
                break;

            case '?':
                break;

            default:
                break;
        }

        opt = getopt_long( argc, argv, optString, longOpts, &longIndex );
    }

    if ( glob_arguments.verbose <= 1 or glob_arguments.verbose >= 5 ){
        cout << "verbose is out of range" << endl;
        return EXIT_FAILURE;
    }

    display_args();

    return EXIT_SUCCESS;
}
