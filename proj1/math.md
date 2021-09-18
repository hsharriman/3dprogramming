# Project 1 Math Problems
## Question 1: (5 pts) When an angle gets more acute, does the cosine of the angle increase or decrease? Does the sine of the angle increase or decrease?
* Cosine: increases as it approaches 0
* Sine: decreases as it approaches 0

## Question 2: (5 pts) What is the radius of a sphere that snugly fits around a "box" or "cuboid" of dimensions 10x20x50? The box is inside the sphere, but the vertices are touching the sphere.
* Find the diameter of the circle by finding the distance between the 2 farthest vertices in the box. In this case it would be the opposite corners (i.e. front bottom and top back corners).
* Find the diagonal along the short face of the box (10 x 20). `sqrt(100 + 400) = 22.36`
* Use answer from previous step to find the long diagonal through the box = `sqrt(500 + 2500) = 54.77`
* `radius = diameter / 2 = 27.38`

## Question 3: (10 pts) What is the parametric equation of the line that starts at A and goes thru B, where:
```
A = (-2, 1, 3)
B = (4, 3, -2)
```
```
Answer: (bc. P(t) = A + (B-A)t)
P(t) = (-2, 1, 3) + (6, 2, -5)t
```
## Question 3 cont: Suppose a vertex at A is green, and a vertex at B is red, and the colors along the line transition smoothly from red->green. What would the color of a point that is 2/3 along the line be (in RGB)?
```
P(t) = A(1 - t) + Bt
P(2/3) = A(1/3) + B(2/3)
= (0, 255, 0) * 1/3 + (255, 0, 0) * 2/3   // green -> red
= (0, 170, 0) + (85, 0, 0)
= (170, 85, 0)  // color: sort of dirty orange
```