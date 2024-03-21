#scope_export

parse_jpln :: (file:string) {

}

#scope_file
jplModel :: struct {
    #as using s: MFFP_parser;

    type = .P_JPLN;
}

Point :: Vector2;
Vec1 :: bool;

Plane :: struct {
    name:string;
    verts:[4] Point;
}

Dimensions :: struct {
    from:Point;
    to:Point;
    length:U128;
}

Shape_Primitive :: struct {
    stype :: enum u8 {
        Spline :: 0;
        Circle :: 1;
        Rect   :: 2;
      PolyLine :: 3;
    }
    type:stype;
}
Rect :: struct {
    #as using s : Shape_Primitive;
    type = .Rect;
    points:[4] Point;
}

PolyLine :: struct {
    #as using s : Shape_Primitive;
    type = .PolyLine;
    from:Point;
    to:Point;
    next:*PolyLine;
}

Sketch :: struct {
    plane:Plane;
    shapes:Shape_Primitive;
    dimensions:Dimensions;
}


#import "Math";
#import "Basic";