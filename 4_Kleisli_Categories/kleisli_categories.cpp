#include <iostream>
#include <string>
#include <utility>
#include <vector>
#include <algorithm> // For std::transform
#include <iterator>  // For std::back_inserter
#include <cctype>    // For std::isspace, std::toupper

using std::string;
using std::vector;

// Pure functions, logging example

string logger;
bool impure_negate(bool b) {
    logger += "Not so! ";
    return !b;
}

//Fortunately for us, it’s possible to make this function pure. You just
//have to pass the log explicitly, in and out:
std::pair<bool, string> negate(bool b, string logger) {
    return make_pair(!b, logger + "Not so! ");
}

// However, considering the cumulative nature of the log,
// you’d have to memoize all possible histories that can lead to a given
// call.
// We still want the function to produce a string, but
// we’d like to unburden it from producing a log. So here’s the compro-
// mise solution:
std::pair<bool, string> negate2(bool b) {
    return std::make_pair(!b, "Not so! ");
}

// The idea is that the log will be aggregated between function calls.
// To see how this can be done, let’s switch to a slightly more realistic
// example. We have one function from string to string that turns lower
// case characters to upper case:
string toUpper(string s) {
    string result;
    int (*toupperp)(int) = &toupper; // toupper is overloaded
    transform(begin(s), end(s), back_inserter(result), toupperp);
return result;
}

// and another that splits a string into a vector of strings, breaking it on
// whitespace boundaries:

//The actual work is done in the auxiliary function words:
vector<string> words(string s) {
    vector<string> result{""};
    for (auto i = begin(s); i != end(s); ++i)
    {
    if (isspace(*i))
    result.push_back("");
    else
    result.back() += *i;
    }
    return result;
}

vector<string> toWords(string s) {
    return words(s);
}



int main() {
    string text = "hello world";
    vector<string> words = toWords(text);
    for (const auto& word : words) {
        std::cout << word << std::endl;
    }

    string upperText = toUpper(text);
    std::cout << upperText << std::endl;

    return 0;

    return 0;
}
