#ifndef SHAPE_H
#define SHAPE_H

#include <cmath>

class Shape {
public:
    virtual float area() const = 0;
};

class Circle : public Shape {
private:
    float radius;
public:
    Circle(float r);
    float area() const override;
};

class Rect : public Shape {
private:
    float width, height;
public:
    Rect(float w, float h);
    float area() const override;
};

#endif // SHAPE_H
