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
string toUpper_(string s) {
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

vector<string> toWords_(string s) {
    return words(s);
}


// We want to modify the functions toUpper and toWords so that they
// piggyback a message string on top of their regular return values.
// We will “embellish” the return values of these functions. Let’s do it
// in a generic way by defining a template Writer that encapsulates a pair
// whose first component is a value of arbitrary type A and the second
// component is a string:

template<class A>
using Writer = std::pair<A, string>;

// Here are the embellished functions:
Writer<string> toUpper(string s) {
    string result;
    int (*toupperp)(int) = &toupper;
    transform(begin(s), end(s), back_inserter(result), toupperp);
    return make_pair(result, "toUpper ");
}

Writer<vector<string>> toWords(string s) {
    return make_pair(words(s), "toWords ");
}

// We want to compose these two functions into another embellished
// function that uppercases a string and splits it into words, all the while
// producing a log of those actions. Here’s how we may do it:
Writer<vector<string>> process(string s) {
    auto p1 = toUpper(s);
    auto p2 = toWords(p1.first);
    return std::make_pair(p2.first, p1.second + p2.second);
}



int main() {
    string text = "hello world";
    auto result = process(text);
    std::cout << "Result: ";
    for (auto& word : result.first) {
        std::cout << word << " ";
    }
    std::cout << "\nLog: " << result.second << std::endl;

    return 0;
}
// Result: HELLO WORLD 
// Log: toUpper toWords 
