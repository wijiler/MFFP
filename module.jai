#load "3mf.jai";

#scope_module


parser :: struct {
    vertex_data:[] float;
    ptype :: enum u8 {
        P_3MF :: 0;
        P_AP :: 1;
    }

    type:ptype;

}