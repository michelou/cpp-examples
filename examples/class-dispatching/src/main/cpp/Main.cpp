// adapted from https://stackoverflow.com/questions/42942753/c-derived-classes-and-polymorphic-dispatching

#include <iostream>
#include <string>

class Base {
public:
    std::string baseName;

    Base(const std::string& bn): baseName(bn) {}

    virtual void doIt() {
        std::cout << baseName;
    }
};

class Derived : public Base {
public:
    std::string dName;

    Derived(const std::string& bn, const std::string& dn):
        Base(bn), dName(dn) {}

    void doIt() override {
        Base::doIt();
        std::cout << " " << dName;
    }
};

class Derived1 : public Derived {
public:
    int x = 10;

    Derived1(const std::string& bn, const std::string& dn):
        Derived(bn, "Dervied1"+dn) {}

    int getX() const { return x; }

    void doIt() override {
        Derived::doIt();
        std::cout << " " << getX() << std::endl; 
    }
};

class Derived2 : public Derived {
public:
    int y = 20;

    Derived2(const std::string& bn, const std::string& dn):
        Derived(bn, "Derived2"+dn) {}

    int getY() const { return y; }

    void doIt() override {
        Derived::doIt();
        std::cout << " " << getY() << std::endl; 
    }
};

void func(Base& b) {
    b.doIt();
}

int main(void) {
    Derived1 d1("Base", "foo");
    func(d1);
    Derived2 d2("Base", "foo");
    func(d2);
}
