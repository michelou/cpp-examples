#include<iostream>

using namespace std;

namespace problem {

class Person { //class Person
public:
    Person(int x) { cout << "Person::Person(int) called" << endl; }
};
 
class Father : public Person { //class Father inherits Person
public:
    Father(int x):Person(x) {
       cout << "Father::Father(int) called" << endl;
    }
};
 
class Mother : public Person { //class Mother inherits Person
public:
    Mother(int x):Person(x) {
        cout << "Mother::Mother(int) called" << endl;
    }
};
 
class Child : public Father, public Mother { //Child inherits Father and Mother
public:
    Child(int x):Mother(x), Father(x) {
        cout << "Child::Child(int) called" << endl;
    }
};
 
int main() {
    Child child(30);
    return 0;
}

}
