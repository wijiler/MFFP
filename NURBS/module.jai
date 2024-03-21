// Curve :: (points: .. curvePoint) -> [] Vector4 {
//     assert(points.count >= 2,"Too little nurbs controlpoints");
//     knots: [] float = NewArray(points.count + 3 + 1,float);
//     degree := 3;
//     vecs:[..] Vector4;
//     fill_knots(knots);
//     print("%\n",knots);
//     for point:points {
//         if it_index + 1 >= points.count then break;

//         //print("%\n",basis);
//         start := (point.pos) ;
//         end := (points[it_index + 1].pos);
//         step:Vector4 = (end - start) / Resolution;
//         basis := deboors(knots.count + 2,degree,it_index,point.weight,knots,point.pos);
//         for 0..Resolution - 1 {
//             step2 := (start / Resolution) + (step * cast(float) it);
//             array_add(*vecs,step2 * basis);
//         }
//     }
//     return vecs;
// }

Curve2d :: (knots: [] float,points: .. curvePoint2d) -> [] Vector2 {
    assert(points.count >= 2,"Too little nurbs controlpoints");

    degree := 3;
    vecs:[..] Vector2;


    first := points[0].pos;
    last := points[points.count - 1].pos;
    step := (last - first) / Resolution;
    for 0..Resolution - 1 {
        cstep := (step * cast(float)it);
        line := first + cstep;
        i: int = 0;
        closest := points[0].pos;

        for point:points {
            if abs(closest.x - line.x) > abs(point.pos.x - line.x) || abs(closest.y - line.y) > abs(point.pos.y - line.y) && it_index != 0 && it_index != points.count - 1 {
                 closest = point.pos;
                 i = it_index;
            }
        }
    
        basis := deboors(Resolution, degree,i,points[i].weight,knots,line);
        print("%\n",points[i].pos);
        // NURBS curve function
        line *= ((((basis * points[i].weight * points[i].pos) /  (basis * points[i].weight)) - basis * line));
        // remove NAN
        ifx line.x == 0/1 then line.x = 0;
        ifx line.y == 0/1 then line.y = 0;
        // make sure shit dont go crazy
        if abs(line.y) >= abs(last.y) && abs(line.x) != abs(last.x) || abs(line.x) >= abs(last.x) && abs(line.y) != abs(last.y) then continue; else array_add(*vecs,line);
    }
    


    return vecs;
}

Curve3d :: (knots: [] float,points: .. curvePoint3d) -> [] Vector4 {
    assert(points.count >= 2,"Too little nurbs controlpoints");

    degree := 3;
    vecs:[..] Vector4;


    first := points[0].pos;
    last := points[points.count - 1].pos;
    step := (last - first) / Resolution;
    for 0..Resolution - 1 {
        cstep := (step * cast(float)it);
        line := first + cstep;
        i: int = 0;
        closest := points[1].pos;

        for point:points {
            if it_index == 0 || it_index == points.count - 1 then it_index += 1;
            if abs(closest.x - line.x) > abs(point.pos.x - line.x) || abs(closest.y - line.y) > abs(point.pos.y - line.y) {
                 closest = point.pos;
                 i = clamp(it_index,1,points.count - 2);
            }
        }
    
        basis := deboors(Resolution, degree,i,points[i].weight,knots,line);
        print("%\n",points[i].pos);
        // NURBS curve function
        line *= ((((basis * points[i].weight * points[i].pos) /  (basis * points[i].weight)) - basis * line));
        // remove NAN
        ifx line.x == 0/1 then line.x = 0;
        ifx line.y == 0/1 then line.y = 0;
        ifx line.z == 0/1 then line.z = 0;
        ifx line.w == 0/1 then line.w = 0;
        // make sure shit dont go crazy
        if abs(line.y) >= abs(last.y) && abs(line.x) != abs(last.x) || abs(line.x) >= abs(last.x) && abs(line.y) != abs(last.y) then continue; else array_add(*vecs,line * points[i].weight);
    }
    


    return vecs;
}

curvePoint2d :: struct {
    weight:float;
    pos:Vector2 = .{0,0};
}
curvePoint3d :: struct {
    weight:float;
    pos:Vector4 = .{0,0,0,0};
}
Resolution :: 250;

#scope_file



deboors :: (k: int, degree: int, i: int, x: float, knots: [] float, ctrlpoint: Vector2) -> Vector2 {

    if k == 0 || i == knots.count - 1 || i + degree + 1 - k then return ctrlpoint;
    else {
    alpha := (x - knots[i]) / (knots[i + degree + 1 - k] - knots[i]);
    return (deboors(k - 1, degree, i - 1, x, knots, ctrlpoint)) * (alpha) + deboors(k - 1, degree, i, x, knots, ctrlpoint) * alpha;
    }
}

deboors :: (k: int, degree: int, i: int, x: float, knots: [] float, ctrlpoint: Vector4) -> Vector4 {

    if k == 0 || i == knots.count - 1 || i + degree + 1 - k then return ctrlpoint;
    else {
    alpha := (x - knots[i]) / (knots[i + degree + 1 - k] - knots[i]);
    return (deboors(k - 1, degree, i - 1, x, knots, ctrlpoint)) * (alpha) + deboors(k - 1, degree, i, x, knots, ctrlpoint) * alpha;
    }
}


#import "Basic";
#import "Math";
