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

Curve2d :: (points: .. curvePoint2d) -> [] Vector2 {
    assert(points.count >= 2,"Too little nurbs controlpoints");
    knots: [] float = NewArray(points.count + 3 + 1,float);
    degree := 3;
    vecs:[..] Vector2;
    fill_knots(*knots);

    for point:points {
	    array_add(*vecs,lpoint); // TODO: update code, this is unneeded ex. vecs = ..points;
    }


    first := vecs[0];
    last := vecs[vecs.count - 1];
    step := (last - first) / Resolution;
    i: int = 0;
    for 0..Resolution - 1 {
        cstep := (step * cast(float)it);
        line := first + cstep;
        basis := deboors(Resolution, degree,i,points[i].weight,knots,line);
        print("%\n",basis);
        // NURBS curve function
        line *= abs((((basis * points[i].weight * points[i].pos) /  (basis * points[i].weight)) - basis * line));
        i += 1;

        ifx i > points.count - 2 then i = 1;
        ifx line.x == 0/1 then line.x = 0;
        ifx line.y == 0/1 then line.y = 0;
        line.x = clamp(line.x, first.x,last.x);
        line.y = clamp(line.y,first.y,last.y) ;
        // remove artifacts from clamping
        if abs(line.y) >= abs(last.y) && abs(line.x) != abs(last.x) || abs(line.x) >= abs(last.x) && abs(line.y) != abs(last.y) then continue; else array_add(*vecs,line);
        
    }

    return vecs;
}



curvePoint2d :: struct {
    weight:float;
    pos:Vector2 = .{0,0};
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


divide_line :: (a:Vector2,b:Vector2) {
    step := a / Resolution;
    dir := b - a;
    stepdir := normalize(step * dir);
}


fill_knots :: (knots:*[] float) {
    i := 0.0;

    // for 0..knots.count - 1 {
    //     knots[it] = i;
    //     i += 1;
    //     if it == 1 { knots[it] = xx 0; i = 1; };
    // }
    knots.* = .[0,0,0,0,1,1,1,1];
}


#import "Basic";
#import "Math";
