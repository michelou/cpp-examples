#include <algorithm>
#include <iostream>
#include <string>

int main() {
    auto i{ 0x01B99644 };
    std::string x{ " DFaeeillnor" };
    std::cout << "i=" << i << std::endl;
    std::cout << "x before: " << x << std::endl;
    while (i--) std::next_permutation(x.begin(), x.end());
    std::cout << "x after: " << x;
}
