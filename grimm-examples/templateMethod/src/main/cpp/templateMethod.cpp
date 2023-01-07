// https://www.modernescpp.com/index.php/the-template-method

#include <iostream>

class Sort{
public:
    virtual void processData() final { // (4)
        readData();             
        sortData();
        writeData();
    }
    virtual ~Sort() = default;
private:
    virtual void readData(){}        // (1)  
    virtual void sortData()= 0;      // (2)
    virtual void writeData(){}       // (3)
};


class QuickSort: public Sort{
    void readData() override {
        std::cout << "readData" << '\n';
    }
    void sortData() override {
        std::cout <<  "sortData" << '\n';
    }
    void writeData() override {
        std::cout << "writeData" << '\n';
    }
};

class BubbleSort: public Sort{
    void sortData() override {
        std::cout <<  "sortData" << '\n';
    }
};


int main(){

    std::cout << '\n';

    QuickSort quick;
    Sort* sort = &quick;          // (5)
    sort->processData();

    std::cout << "\n\n";

    BubbleSort bubble;
    sort = &bubble;               // (6)
    sort->processData();

    std::cout << '\n';
  
}
