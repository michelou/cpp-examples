// adapted from https://blog.invivoo.com/decouverte-du-cplusplus-et-stdmove/

#include <chrono>    // std:chrono
#include <iostream>  // std::cout
#include <string>    // std::string
#include <vector>    // std::vector

class Basket {

public:
    Basket() {}

    Basket(const Basket& secondBasket) : objectIds_(secondBasket.objectIds_) {
        std::cout << "Copy Constructor" << std::endl;
    }

    Basket(Basket&& secondBasket) : objectIds_(secondBasket.objectIds_) {
        std::cout << "Move Constructor" << std::endl;
    }

    void addObjectId(const std::string& objectId) {
        objectIds_.push_back(objectId);
    }
    /*
    void toString() {
        for (size_t i=0; i < objectIds_.size(); ++i) {
            std::cout << objectIds_[i] << std::endl;
        }
    }*/
    friend std::ostream& operator <<(std::ostream& out, const Basket& basket);

    std::vector<std::string> objectIds_;
};

std::ostream& operator <<(std::ostream& out, const Basket& basket) {
    out << "Basket(";
    int i = 0;
    for (auto const& id : basket.objectIds_) {
        if (i > 0) out << (", ");
        out << id;
        i += 1;
    }
    out << ")";
    return out;
}

int bench() {
    Basket myOriginalBasket;
    for (size_t i = 0; i < 1000000; ++i) {
        myOriginalBasket.addObjectId("ID123");
    }

    {
        auto start = std::chrono::high_resolution_clock::now();
        Basket myNewBasket(myOriginalBasket);
        auto end = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double> elapsed = end - start;
        std::cout << "First duration: " << elapsed.count() << " s" << std::endl;
    }

    {
        auto start = std::chrono::high_resolution_clock::now();
        Basket myNewBasket(std::move(myOriginalBasket));
        auto end = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double> elapsed = end - start;
        std::cout << "Second duration: " << elapsed.count() << " s" << std::endl;
    }
    return 0;
}

int main() {
    Basket myOriginalBasket;
    myOriginalBasket.addObjectId("1");
    myOriginalBasket.addObjectId("2");
    myOriginalBasket.addObjectId("3");
    // myOriginalBasket.toString();
    std::cout << myOriginalBasket << std::endl;

    std::cout << "###########################" << std::endl;

    Basket myNewBasket(myOriginalBasket);
    // myNewBasket.toString();
    std::cout << myNewBasket << std::endl;

    std::cout << "###########################" << std::endl;

    Basket myNewBasket2(std::move(myOriginalBasket));
    // myNewBasket2.toString();
    std::cout << myNewBasket2 << std::endl;

    std::cout << "###########################" << std::endl;

    bench();

    return 0;
}
