main :: () {
    l3mf := parse_3mf_as_vertex_data("cylinder.3mf");
    print("%\n",l3mf.vertex_data);
}




#load "module.jai";