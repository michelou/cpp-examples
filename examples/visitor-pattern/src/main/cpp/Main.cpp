// adapted from https://sourcemaking.com/design_patterns/visitor/cpp/2

#include <iostream>
#include <list>
#include <string>

// 1. Add an accept(Visitor) method to the "element" hierarchy
class Element {
public:
    virtual void accept(class Visitor &v) = 0;
};

class This: public Element {
public:
     /*virtual*/void accept(Visitor &v);
    std::string thiss() {
        return "This";
    }
};

class That: public Element {
public:
     /*virtual*/void accept(Visitor &v);
    std::string that() {
        return "That";
    }
};

class TheOther: public Element {
public:
     /*virtual*/void accept(Visitor &v);
    std::string theOther() {
        return "TheOther";
    }
};

// 2. Create a "visitor" base class w/ a visit() method for every "element" type
class Visitor {
public:
    virtual void visit(This *e) = 0;
    virtual void visit(That *e) = 0;
    virtual void visit(TheOther *e) = 0;
};

/*virtual*/void This::accept(Visitor &v) {
    v.visit(this);
}

/*virtual*/void That::accept(Visitor &v) {
    v.visit(this);
}

/*virtual*/void TheOther::accept(Visitor &v) {
    v.visit(this);
}

// 3. Create a "visitor" derived class for each "operation" to do on "elements"
class UpVisitor: public Visitor {
    /*virtual*/void visit(This *e) {
        std::cout << "do Up on " + e->thiss() << std::endl;
    }
    /*virtual*/void visit(That *e) {
         std::cout << "do Up on " + e->that() << std::endl;
    }
    /*virtual*/void visit(TheOther *e) {
         std::cout << "do Up on " + e->theOther() << std::endl;
    }
};

class DownVisitor: public Visitor {
    /*virtual*/void visit(This *e) {
         std::cout << "do Down on " + e->thiss() << std::endl;
    }
    /*virtual*/void visit(That *e) {
         std::cout << "do Down on " + e->that() << std::endl;
    }
    /*virtual*/void visit(TheOther *e) {
         std::cout << "do Down on " + e->theOther() << std::endl;
    }
};

int main() {
    std::list<Element *> list = {
        new This(), new That(), new TheOther()
    };
    UpVisitor up; // 4. Client creates
    DownVisitor down; //    "visitor" objects
    for (auto elem : list)
    //    and passes each
        elem->accept(up);
    //    to accept() calls
    for (auto elem : list)
        elem->accept(down);
}
