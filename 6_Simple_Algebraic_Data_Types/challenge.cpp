/* 1. Show the isomorphism between Maybe a and Either () a.
2. Here’s a sum type defined in Haskell:
data Shape = Circle Float
| Rect Float Float
When we want to define a function like area that acts on a Shape,
we do it by pattern matching on the two constructors:
area :: Shape -> Float
area (Circle r) = pi * r * r
area (Rect d h) = d * h
Implement Shape in C++ or Java as an interface and create two
classes: Circle and Rect. Implement area as a virtual function.
3. Continuing with the previous example: We can easily add a new
function circ that calculates the circumference of a Shape. We
can do it without touching the definition of Shape:
90circ :: Shape -> Float
circ (Circle r) = 2.0 * pi * r
circ (Rect d h) = 2.0 * (d + h)
Add circ to your C++ or Java implementation. What parts of the
original code did you have to touch?
4. Continuing further: Add a new shape, Square, to Shape and make
all the necessary updates. What code did you have to touch in
Haskell vs. C++ or Java? (Even if you’re not a Haskell program-
mer, the modifications should be pretty obvious.)
5. Show that a + a = 2 * a holds for types (up to isomorphism).
Remember that 2 corresponds to Bool, according to our transla-
tion table. */

// Challenge 6.2
#include <iostream>
#include <cmath>

class Shape {
public:
    virtual ~Shape() = default;
    virtual float area() const = 0;
};

class Circle : public Shape {
private:
    float radius;
public:
    Circle(float r) : radius(r) {}
    float area() const override {
        return M_PI * radius * radius;
    }
};

class Rect : public Shape {
private:
    float width, height;
public:
    Rect(float w, float h) : width(w), height(h) {}
    float area() const override {
        return width * height;
    }
};


int main() {
    Shape* shapes[] = {
        new Circle(2.0),
        new Rect(4.0, 3.0)
    };

    for (Shape* shape : shapes) {
        std::cout << "Area: " << shape->area() << std::endl;
        delete shape;
    }

    return 0;
}