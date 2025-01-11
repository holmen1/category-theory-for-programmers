#include <cmath>

class Shape {
public:
    virtual float area() const = 0;
    virtual float circ() const = 0;
};

class Circle : public Shape {
private:
    float radius;
public:
    Circle(float r);
    float area() const override;
    float circ() const override;
};

class Rect : public Shape {
private:
    float width, height;
public:
    Rect(float w, float h);
    float area() const override;
    float circ() const override;
};

class Square : public Shape {
private:
    float side;
public:
    Square(float s);
    float area() const override;
    float circ() const override;
};
