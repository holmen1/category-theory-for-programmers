#include <iostream>
#include "shape.h"

int main() {
    Circle circle(5.0);
    Rect rect(4.0, 6.0);

    std::cout << "Circle area: " << circle.area() << std::endl;
    std::cout << "Rectangle area: " << rect.area() << std::endl;

    return 0;
}
