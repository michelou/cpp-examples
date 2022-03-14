#include <iostream>
#include <string>

class Base2;
class Derived2;

//////////////////////////////////////////////////////////////////////////////
// Base classes

class Base1 {
public:
    virtual void function1(Base2* b2);
    virtual void function2(Derived2* d2);

    friend std::ostream& operator<<(std::ostream &os, const Base1 &b1) {
        return os << "Base1" << std::endl;
    }
};

class Base2 {
public:
    friend std::ostream& operator<<(std::ostream &os, const Base2 &b2) {
        return os << "Base2" << std::endl;
    }
};

//////////////////////////////////////////////////////////////////////////////
// Derived classes

class Derived1: public Base1 {
public:
    virtual void function1(Base2* b2);
    virtual void function2(Derived2* d2);

    friend std::ostream& operator<<(std::ostream &os, const Derived1 &d1) {
        return os << "Derived1" << std::endl;
    }
};

class Derived2: public Base2 {
public:
    friend std::ostream& operator<<(std::ostream &os, const Derived2 &d2) {
        return os << "Derived2" << std::endl;
    }
};

//////////////////////////////////////////////////////////////////////////////
// Method implementations

void Base1::function1(Base2* b2)  {
    std::cout << "Base1::function1: " << (*b2) << std::endl;
}

void Base1::function2(Derived2* d2) {
    std::cout << "Base1::function2: " << (*d2) << std::endl;
}

void Derived1::function1(Base2* b2) {
    std::cout << "Derived1::function1: " << (*b2) << std::endl;
}

void Derived1::function2(Derived2* d2) {
    std::cout << "Derived1::function2: " << (*d2) << std::endl;
}

//////////////////////////////////////////////////////////////////////////////
// Main

int main() {
    Derived1* d = new Derived1;
    Base2* b = new Derived2;
    
    d->function1(b);  // Derived1::function1: Derived2

    return 0;
}
