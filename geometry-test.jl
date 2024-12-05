module testPlayingCards

include("Geometry.jl")
using Test
using .Geometry
import Base.==

# a) tests if Point2D, Point3D and Polygon objects are the same
p1 = Point2D(1.0, 2.0)
p2 = Point2D(1.0, 2.0)
p3 = Point2D(3.0, 4.0)
@test p1 == p2
@test p1 != p3

p3d1 = Point3D(1.0, 2.0, 3.0)
p3d2 = Point3D(1.0, 2.0, 3.0)
p3d3 = Point3D(3.0, 4.0, 5.0)
@test p3d1 == p3d2
@test p3d1 != p3d3

poly1 = Polygon(Point2D(0, 0), Point2D(1, 0), Point2D(0, 1))
poly2 = Polygon(Point2D(0, 0), Point2D(1, 0), Point2D(0, 1))
poly3 = Polygon(Point2D(1, 1), Point2D(2, 1), Point2D(1, 2))
@test poly1 == poly2
@test poly1 != poly3

# b) Test the basic functionality that creating a is actually a Point2D type
@test isa(p1, Point2D)
@test isa(Point2D(3, 4), Point2D)
@test isa(Point2D(3.0, 4), Point2D)
@test isa(Point2D(3, 4.0), Point2D)
@test isa(Point2D("(5.0, -3.0)"), Point2D)

# c) Test that creating a Point2D object using a string makes a Point2D object with the default constructor
p4 = Point2D("(1.5, 2.5)")
p5 = Point2D("(-1.0, 0.0)")
p6 = Point2D("(3.0, -4.5)")
@test p4 == Point2D(1.5, 2.5)
@test p5 == Point2D(-1.0, 0.0)
@test p6 == Point2D(3.0, -4.5)

# d) test if creating a point is actually a Point3D type
@test isa(p3d1, Point3D)
@test isa(Point3D(3, 4, 5), Point3D)
@test isa(Point3D(3.0, 4.5, 5), Point3D)
@test isa(Point3D(3, 4, 5.5), Point3D)

# e) Test if creating a polygon is actually a Polygon type
poly4 = Polygon(Point2D(0, 0), Point2D(2, 0), Point2D(1, 2))
poly5 = Polygon(0, 0, 2, 0, 1, 2)
poly6 = Polygon("(0, 0), (2, 0), (1, 2)")
@test isa(poly4, Polygon)
@test isa(poly5, Polygon)
@test isa(poly6, Polygon)

# f) creating a Polygon using the other constructors creates the same Polygon as the default one
@test poly4 == poly5
@test poly5 == poly6

# g) Test that for new Polygon constructors throw errors for an odd number of numbers passed in
@test_throws ArgumentError Polygon(0, 0, 2, 0)
@test_throws ArgumentError Polygon(0, 0, 1, 1)

# h) Test the distance function between two sets of points with known distances
d1 = Point2D.distance(Point2D(0, 0), Point2D(3, 4))
d2 = Point2D.distance(Point2D(1, 1), Point2D(4, 5))
d3 = Point2D.distance(Point2D(-1, -1), Point2D(2, 2))
@test isapprox(d1, sqrt(25))
@test isapprox(d2, sqrt(25))
@test isapprox(d3, sqrt(18))

# i) Test the perimeter function on three different polygons with known perimeters
triangle = Polygon(0, 0, 3, 0, 0, 4)
rectangle = Polygon(0, 0, 4, 0, 4, 2, 0, 2)
parallelogram = Polygon(0, 0, 3, 0, 4, 2, 1, 2)
@test isapprox(Polygon.perimeter(triangle), 12.0)
@test isapprox(Polygon.perimeter(rectangle), 12.0)
@test isapprox(Polygon.perimeter(parallelogram), 12.0)

# j) test to ensure the area of the same three polygons are correct
@test isapprox(Polygon.area(triangle), 6.0)
@test isapprox(Polygon.area(rectangle), 8.0)
@test isapprox(Polygon.area(parallelogram), 6.0)

@testset "Midpoint caclulations" begin
  @test midpoint(triangle) == Point2D(1/3,1/3)
  @test midpoint(rectangle) == Point2D(0.5,1)
end

end