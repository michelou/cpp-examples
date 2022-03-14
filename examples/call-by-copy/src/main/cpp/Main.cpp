// adapted from https://stackoverflow.com/questions/274626/what-is-object-slicing

#include <iostream>

using namespace std;

// Base class
class A {
public:
    A() {}
    A(const A& a) {
        cout << "'A' copy constructor" << endl;
    }
    virtual void run() const { cout << "I am an 'A'" << endl; }
};

// Derived class
class B: public A {
public:
    B():A() {}
    B(const B& a):A(a) {
        cout << "'B' copy constructor" << endl;
    }
    virtual void run() const { cout << "I am a 'B'" << endl; }
};

void g(const A & a) {
    a.run();
}

void h(const A a) {
    a.run();
}

int main() {
    cout << "Call by reference" << endl;
    g(B());
    cout << endl << "Call by copy" << endl;
    h(B());
}
