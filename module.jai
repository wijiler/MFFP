#load "3mf.jai";
#load "stp.jai";
#load "jpln.jai";
MFFP_parser :: struct {
    triangle_data:[] u32; // INDICES
    vertex_data:[] float;
    ptype :: enum u8 {
        P_3MF :: 0;
        P_AP214 :: 1;
        P_AP203 :: 2;
        P_JPLN :: 3;
    }

    type:ptype;

}


