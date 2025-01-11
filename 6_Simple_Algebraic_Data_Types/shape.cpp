#include "shape.h"

Circle::Circle(float r) : radius(r) {}

float Circle::area() const {
    return M_PI * radius * radius;
}

float Circle::circ() const {
    return 2.0 * M_PI * radius;
}

Rect::Rect(float w, float h) : width(w), height(h) {}

float Rect::area() const {
    return width * height;
}

float Rect::circ() const {
    return 2.0 * (width + height);
}

Square::Square(float s) : side(s) {}

float Square::area() const {
    return side * side;
}

float Square::circ() const {
    return 4.0 * side;
}
