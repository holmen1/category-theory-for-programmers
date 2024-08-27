/*
1. Show the isomorphism between Maybe a and Either () a.
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
circ :: Shape -> Float
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


#include <iostream>
#include <cmath>

class Shape {
public:
    virtual ~Shape() = default;
    virtual float area() const = 0;
    virtual float circ() const = 0;
};

class Circle : public Shape {
private:
    float radius;
public:
    Circle(float r) : radius(r) {}
    float area() const override {
        return M_PI * radius * radius;
    }
    float circ() const override {
        return 2.0 * M_PI * radius;
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
    float circ() const override {
        return 2.0 * (width + height);
    }
};

class Square : public Shape {
private:
    float side;
public:
    Square(float s) : side(s) {}
    float area() const override {
        return side * side;
    }
    float circ() const override {
        return 4.0 * side;
    }
};


int main() {
    Shape* shapes[] = {
        new Circle(2.0),
        new Rect(4.0, 3.0),
        new Square(5.0)
    };

    for (Shape* shape : shapes) {
        std::cout << "Area: " << shape->area() << std::endl;
        std::cout << "Cicumference: " << shape->circ() << std::endl;
        delete shape; // Free the allocated memory
    }

    return 0;
}