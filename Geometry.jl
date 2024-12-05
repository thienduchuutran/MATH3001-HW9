module Geometry
import Base.==
export Point2D, Circle, Polygon, Point3D, ==


struct Point2D
    x::Real
    y::Real

    # Default constructor
    Point2D() = new(0.0, 0.0)
    """
    Point2D(str::String)

    Create a `Point2D` by parsing a string representation of the form `"(x,y)"` or `"(x, y)"` where `x` and `y`
    can be integers or decimals, with optional spaces around the comma.

    """
    function Point2D(str::String)

        isMatched = match(r"^\(\s*([-+]?\d*\.?\d+)\s*,\s*([-+]?\d*\.?\d+)\s*\)$", str)
        if isMatched === nothing
            throw(ArgumentError("Invalid format. Expected format: \"(x, y)\" where x and y are numbers."))
        end
        # Extract x and y from the matched groups and convert them to numbers
        x = parse(Float64, isMatched.captures[1])
        y = parse(Float64, isMatched.captures[2])
        new(x, y)
    end

    function Point2D(x::Real, y::Real)
        new(x, y)
    end
end

"""
    struct Point3D

A 3D point represented by its `x`, `y`, and `z` coordinates.

# Constructors
 Point3D(x::Real, y::Real, z::Real)`: Creates a point at the specified coordinates.

"""
struct Point3D
    x::Real
    y::Real
    z::Real
end

struct Polygon
    point::Vector{Point2D}
    """
    Polygon(points::Vector{Point2D})
    Polygon(c::Vector{<:Real})
    Polygon(c::Vararg{<:Real})

    Create a `Point2D` by parsing a string representation of the form `"(x,y)"` or `"(x, y)"` where `x` and `y`
    can be integers or decimals, with optional spaces around the comma.

    """
    function Polygon(points::Vector{Point2D})
        if length(points) < 3
            throw(ArgumentError("A polygon must have at least 3 points."))
        end
        new(points)
    end

    function Polygon(c::Vector{<:Real})
        if length(c) % 2 != 0
            throw(ArgumentError("The number of coordinates must be even."))
        end
        points = [Point2D(c[i], c[i+1]) for i in 1:2:length(c)]
        if length(points) < 3
            throw(ArgumentError("A polygon must have at least 3 points."))
        end
        new(points)
    end

    function Polygon(c::Vararg{<:Real})
        Polygon(collect(c))  # Use collect to convert vararg to vector and call the second constructor
    end


    """
    Polygon(str::String)

    Create a polygon from a semicolon-separated string of points. Each point should be in the format `"(x, y)"`.
    This constructor allows spaces around the semicolons, as well as within the points themselves.
    """
    function Polygon(str::String)
        point_strings = split(str, r"\s*;\s*")

        points = [Point2D(String(point_str)) for point_str in point_strings]
        if length(points) < 3
            throw(ArgumentError("A polygon must have at least 3 points."))
        end
        new(points)
    end
end

"""
    distance(p1::Point2D, p2::Point2D)

Compute the Euclidean distance between two `Point2D` objects.

# Returns
- The Euclidean distance as a `Float64`.
"""
function distance(p1::Point2D, p2::Point2D)
    d = sqrt((p1.x - p2.x)^2 + (p1.y - p2.y)^2)
end

"""
    distance(p1::Point3D, p2::Point3D)

Compute the Euclidean distance between two `Point3D` objects.

# Returns
- The Euclidean distance as a `Float64`.
"""
function distance(p1::Point3D, p2::Point3D)
    d = sqrt((p1.x - p2.x)^2 + (p1.y - p2.y)^2 + (p1.z - p2.z)^2)
end

"""
    perimeter(poly::Polygon)

Calculate the perimeter of a `Polygon`.

# Returns
 The perimeter of the Polygon as a `Float64`.
"""
function perimeter(poly::Polygon)
    total_distance = 0.0
    for i in 1:length(poly)
        total_distance += distance(poly[i], poly[mod1(i + 1, length(poly))])    #accessing each vertex of the polygon
    end                                         #mod1(i + 1, length(poly)) wraps back to the first vertex of the polygon when it reaches the last vertex
    return total_distance
end

"""
    isRectangular(poly::Polygon)

Checking if a Polygon object is rectangular.

# Returns
 True if a Polygon object is rectangular, false otherwise.
"""
function isRectangular(poly::Polygon)
    if length(poly) != 4
        return false
    end
    d1 = distance(poly[1], poly[3])
    d2 = distance(poly[2], poly[4])
    return isapprox(d1, d2)
end

"""
    area(c::Polygon)

Calculate the area of a `Polygon`.

# Returns
 The area of the Polygon as a `Float64`.
"""
function area(poly::Polygon)
    n = length(poly)
    sum1 = 0.0
    sum2 = 0.0
    for i in 1:n
        x1, y1 = poly[i]
        x2, y2 = poly[mod1(i + 1, n)]   #getting the next element in the list, and when we are at the last index, it wraps back up
        sum1 += x1 * y2
        sum2 += y1 * x2
    end
    return 0.5 * abs(sum1 - sum2)
end

"""
    struct Circle

A circle defined by its center (`Point2D`) and radius.
"""
struct Circle
    center::Point2D
    radius::Real


    function Circle(center::Point2D, radius::Real)
        if radius <= 0
            error("Radius must be a positive real number")
        end
        return new(center, radius)

    end

    function Circle(radius::Real)
        return Circle(Point2D(0, 0), radius)
    end

    function Circle(center::Point2D)
        return Circle(center, 1.0)
    end

    Circle() = Circle(Point2D(0, 0), 1.0)

end

"""
    area(c::Circle)

Calculate the area of a `Circle`.

# Returns
 The area of the circle as a `Float64`.
"""
function area(c::Circle)
    return π * c.radius^2
end

"""
    perimeter(c::Circle)

Calculate the circumference of a `Circle`.

# Returns
 The circumference as a `Float64`.
"""
function perimeter(c::Circle)
    return 2 * π * c.radius
end

"""
    ==(p1::Point2D, p2::Point2D)

Check if two `Point2D` objects are equal by comparing their `x` and `y` coordinates.

# Returns
`true` if `p1` and `p2` have the same coordinates, otherwise `false`.
"""
function ==(p1::Point2D, p2::Point2D)
    return p1.x == p2.x && p1.y == p2.y
end

"""
    ==(p1::Point3D, p2::Point3D)

Check if two `Point3D` objects are equal by comparing their `x`, `y` and `z` coordinates.

# Returns
`true` if `p1` and `p2` have the same coordinates, otherwise `false`.
"""
function ==(p1::Point3D, p2::Point3D)
    return p1.x == p2.x && p1.y == p2.y && p1.z == p2.z
end

"""
    ==(p1::Polygon, p2::Polygon)

Check if two `Polygon` objects are equal by comparing their points.

# Returns
`true` if `poly1` and `poly2` have the same coordinates, otherwise `false`.
"""
function ==(poly1::Polygon, poly2::Polygon)
    return poly1.point == poly2.point
end

"""
    ==(p1::Point2D, p2::Point2D)

Check if two `Point2D` objects are the same type.

# Returns
`true` if `p1` and `p2` have the same type, otherwise `false`.
"""
function ==(p1::Point2D, p2::Point2D)
    return typeof(p1) === typeof(p2)
end

function Base.show(io::IO, p::Point2D)
    print(io, "(", p.x, ", ", p.y, ")")
end

function Base.show(io::IO, p::Point3D)
    print(io, "(", p.x, ", ", p.y, ")")
end

function Base.show(io::IO, poly::Polygon)
    points_str = join([string(p) for p in poly.point], ", ")
    print(io, "Polygon: ", points_str)
end

"""
```
midpoint(p::Polyon)
```
calculates the midpoint of the polygon.
"""
midpoint(p::Polygon) = Point2D(mean(map(pt -> pt.x, p.points)), mean(map(pt -> pt.y, p.points)))

end