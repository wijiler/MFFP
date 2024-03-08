parse_3mf :: (filename:string) -> x3mp {
    p:x3mp;

    verts:[..] float;
    polys:[..] u32;

    buf:[..] u8;
    // .3mf is a fancy zipped xml lmfao
    uzipped := zip_load(filename);
    rels := false;
    // get type data
    {
        zip_extract(*uzipped,"[Content_Types].xml",*buf);


        file:string = to_string(buf.data);
        node := xml_parse(file);
        if node.first_child.next_sibling.first_child.attributes[0].name == "Extension" && node.first_child.next_sibling.first_child.attributes[0].value == "rels" {
            rels = true;
        }
        else {
            // TODO we need to figure out what to do incase the rels extension isnt enabled
            exit(1);
        }
    }
    if rels {
        relbuf:[..] u8;
        zip_extract(*uzipped,"_rels/.rels",*relbuf);

        relsfile:string = to_string(relbuf.data);
        node := xml_parse(relsfile);
        if node.first_child.next_sibling.first_child.attributes[0].name == "Target" {
            model_buf:[..] u8;
            // modelname will start with a / so we need to remove that
            filename:= node.first_child.next_sibling.first_child.attributes[0].value;
            filename.data += 1;
            filename.count -= 1;
            zip_extract(*uzipped,filename,*model_buf);
            modelfile:string = to_string(model_buf.data);
            model := xml_parse(modelfile);

            vert := model.first_child
            .next_sibling
            .first_child
            .next_sibling
            .first_child
            .first_child
            .first_child;

            firstvert := vert.first_child;
            // insert first vert positons
            array_add(*verts,string_to_float(firstvert.attributes[0].value));
            array_add(*verts,string_to_float(firstvert.attributes[1].value));
            array_add(*verts,string_to_float(firstvert.attributes[2].value));
            currentvert := firstvert.next_sibling;
            // insert rest of the vertexes
            i:int = 1;
            while currentvert.name == "vertex" {
                array_add(*verts,string_to_float(currentvert.attributes[0].value));
                array_add(*verts,string_to_float(currentvert.attributes[1].value));
                array_add(*verts,string_to_float(currentvert.attributes[2].value));
                currentvert = currentvert.next_sibling;
                if currentvert.next_sibling == null || currentvert.name != "vertex" {
                    break;
                }
            }

            tris := model.first_child
            .next_sibling
            .first_child
            .next_sibling
            .first_child
            .first_child
            .first_child
            .next_sibling;
            firsttri := tris.first_child;
            
            array_add(*polys,xx string_to_int(firsttri.attributes[0].value));
            array_add(*polys,xx string_to_int(firsttri.attributes[1].value));
            array_add(*polys,xx string_to_int(firsttri.attributes[2].value));

            currenttri := firsttri.next_sibling;
            while currenttri.name == "triangle" {
                array_add(*polys,xx string_to_int(currenttri.attributes[0].value));
                array_add(*polys,xx string_to_int(currenttri.attributes[1].value));
                array_add(*polys,xx string_to_int(currenttri.attributes[2].value));
                currenttri = currenttri.next_sibling;
                if currenttri.next_sibling == null || currenttri.name != "triangle" {
                    break;
                }
            }
        }
        else {
            // TODO Traverse parse tree till we find target attribute
        }

    }
    p.triangle_data = polys;
    p.vertex_data = verts;
    zip_free(*uzipped);
    return p;
}
x3mp :: struct {
    #as using par:MFFP_parser;

    type = .P_3MF;

    //vertex_data:[] float;
    //triangle_data:[] u64;
}
#scope_file
#load "./deps/xml/module.jai";
#load "./deps/zip/module.jai";
#import "Basic";
