#include "shape.h"

// Circle implementation
Circle::Circle(float r) : radius(r) {}

float Circle::area() const {
    return M_PI * radius * radius;
}

// Rect implementation
Rect::Rect(float w, float h) : width(w), height(h) {}

float Rect::area() const {
    return width * height;
}
