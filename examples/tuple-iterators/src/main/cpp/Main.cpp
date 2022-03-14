// adapted from https://stackoverflow.com/questions/8511035/sequence-zip-function-for-c11

#include <iostream>
#include <list>
#include <string>
#include <utility>
#include <vector>
#include <tuple>

namespace pair_iterators {

    template<typename T1, typename T2>
    std::pair<T1, T2> operator++(std::pair<T1, T2>& it) {
        ++it.first;
        ++it.second;
        return it;
    }
}

namespace tuple_iterators {

    // you might want to make this generic (via param pack)
    template<typename T1, typename T2, typename T3>
    auto operator++(std::tuple<T1, T2, T3>& it) {
        ++( std::get<0>( it ) );
        ++( std::get<1>( it ) );
        ++( std::get<2>( it ) );
        return it;
    }

    template<typename T1, typename T2, typename T3>
    auto operator*(const std::tuple<T1, T2, T3>& it) {
        return std::tie( *( std::get<0>( it ) ),
                         *( std::get<1>( it ) ),
                         *( std::get<2>( it ) ) );
    }

    // needed due to ADL-only lookup
    template<typename... Args>
    struct tuple_c {
        std::tuple<Args...> containers;
    };

    template<typename... Args>
    auto tie_c( const Args&... args ) {
        tuple_c<Args...> ret = { std::tie(args...) };
        return ret;
    }

    template<typename T1, typename T2, typename T3>
    auto begin( const tuple_c<T1, T2, T3>& c ) {
        return std::make_tuple( std::get<0>( c.containers ).begin(),
                                std::get<1>( c.containers ).begin(),
                                std::get<2>( c.containers ).begin() );
    }

    template<typename T1, typename T2, typename T3>
    auto end( const tuple_c<T1, T2, T3>& c ) {
        return std::make_tuple( std::get<0>( c.containers ).end(),
                                std::get<1>( c.containers ).end(),
                                std::get<2>( c.containers ).end() );
    }

    // implement cbegin(), cend() as needed
}

class Tree {
public:
    Tree(int pos): pos(pos) { }
    int pos;
    friend std::ostream& operator<<(std::ostream& out, const Tree& tree);
//private:
    Tree(const Tree& other) { } // copy constructor
    Tree& operator =(const Tree& other) { return *this; } // assign operator
};
std::ostream& operator<<(std::ostream& out, const Tree& tree){
    out << "Tree";
    return out;
}

class Bad: public Tree { // default: private
public:
    Bad(int pos = -1): Tree(pos) { }
    Bad& operator =(const Tree& tree) { return *this; }
    // Bad(const Bad &that) {}
};

void test_pairs() {
    using namespace pair_iterators;

    Tree tree = (Tree) Bad(-1);

    std::vector<double> ds = { 0.0, 0.1, 0.2 };
    std::vector<int   > is = {   1,   2,   3 };
    std::vector<Tree> ts = { tree, tree, tree };

    std::cout << "classical, iterator-style using pairs" << std::endl;
    for (auto its  = std::make_pair(ds.begin(), is.begin()),
              end  = std::make_pair(ds.end(),   is.end()  ); its != end; ++its )
    {
        std::cout << "1. " << *(its.first) + *(its.second) << " " << std::endl;
    }
    
    std::cout << "classical, iterator-style using pairs" << std::endl;
    for (auto its  = std::make_pair(ts.begin(), is.begin()),
              end  = std::make_pair(ts.end(),   is.end()  ); its != end; ++its )
    {
        std::cout << "1. " << *(its.first) << " " << *(its.second) << " " << std::endl;
    }
}

void test_tuples() {
    using namespace tuple_iterators;
    
    std::vector<double> ds = { 0.0, 0.1, 0.2 };
    std::vector<int   > is = {   1,   2,   3 };
    std::vector<char  > cs = { 'a', 'b', 'c' };

    std::cout << "classical, iterator-style using tuples" << std::endl;
    for (auto its  = std::make_tuple(ds.begin(), is.begin(), cs.begin()),
              end  = std::make_tuple(ds.end(),   is.end(),   cs.end()  ); its != end; ++its ) {
        std::cout << "2. " << *(std::get<0>(its)) + *(std::get<1>(its)) << " "
                           << *(std::get<2>(its)) << " " << std::endl;
    }

    std::cout << "range for using tuples with vectors" << std::endl;
    for (const auto& d_i_c : tie_c( ds, is, cs ) ) {
        std::cout << "3. " << std::get<0>(d_i_c) + std::get<1>(d_i_c) << " "
                           << std::get<2>(d_i_c) << " " << std::endl;
    }

    //////////////////////////////////////////////////////////////

    std::list<std::string> xs = { "a", "b", "c" };
    std::list<std::string> ys = { "x", "y", "z" };
    std::list<int>         zs = { 111, 222, 333 };

    std::cout << "range for using tuples with lists" << std::endl;
    for (const auto& x_y_z : tie_c(xs, ys, zs) ) {
        std::cout << "3. " << std::get<0>(x_y_z) + std::get<1>(x_y_z) << " "
                           << std::get<2>(x_y_z) << " " << std::endl;
    }
}

int main() {
    test_pairs();
    test_tuples();
}