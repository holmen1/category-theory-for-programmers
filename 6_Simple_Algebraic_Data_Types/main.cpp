#include <iostream>
#include "shape.h"

int main() {
    Shape* shapes[] = {
        new Circle(5.0),
        new Rect(4.0, 6.0),
        new Square(5.0)
    };

    for (Shape* shape : shapes) {
        std::cout << "Area: " << shape->area() << std::endl;
        std::cout << "Circumference: " << shape->circ() << std::endl;
    }
    return 0;
}
