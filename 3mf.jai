parse_3mf_as_vertex_data :: (filename:string) -> parser {
    p:x3mp;

    verts:[..] float;
    polys:[..] u64;

    buf:[..] u8;
    // .3mf is a fancy zipped xml lmfao
    uzipped := zip_load(filename);
    //print("%\n",uzipped);
    rels := false;
    // get type data
    {
        zip_extract(*uzipped,"[Content_Types].xml",*buf);


        file:string = to_string(buf.data);
        //print("%\n",file);
        node := xml_parse(file);
        //print("%0%\n",node.first_child.next_sibling.first_child.attributes[0].name,node.first_child.next_sibling.first_child.attributes[0].value);
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
        //print("%\n",relsfile);
        node := xml_parse(relsfile);
        //print("%\n",node.first_child.next_sibling.first_child.attributes[0].name);
        if node.first_child.next_sibling.first_child.attributes[0].name == "Target" {
            model_buf:[..] u8;
            //print("target\n");
            // modelname will start with a / so we need to remove that
            filename:= node.first_child.next_sibling.first_child.attributes[0].value;
            filename.data += 1;
            filename.count -= 1;
            zip_extract(*uzipped,filename,*model_buf);
            modelfile:string = to_string(model_buf.data);
            //print("%\n",modelfile);
            model := xml_parse(modelfile);
            // print("%\n",model.first_child
            // .next_sibling
            // .first_child
            // .next_sibling
            // .first_child
            // .first_child
            // .first_child
            // .first_child);

            vert := model.first_child
            .next_sibling
            .first_child
            .next_sibling
            .first_child
            .first_child
            .first_child;

            firstvert := vert.first_child;
            //print("%\n",firstvert.attributes[0].value);
            // insert first vert positons
            array_add(*verts,string_to_float(firstvert.attributes[0].value));
            array_add(*verts,string_to_float(firstvert.attributes[1].value));
            array_add(*verts,string_to_float(firstvert.attributes[2].value));
            currentvert := firstvert.next_sibling;
            //print("%\n",currentvert);
            // insert rest of the vertexes
            i:int = 1;
            while currentvert.name == "vertex" {
                //print("alright%\n",i);
                array_add(*verts,string_to_float(currentvert.attributes[0].value));
                array_add(*verts,string_to_float(currentvert.attributes[1].value));
                array_add(*verts,string_to_float(currentvert.attributes[2].value));
                currentvert = currentvert.next_sibling;
                if currentvert.next_sibling == null || currentvert.name != "vertex" {
                    break;
                }
            }
            //print("goo\n");

            tris := vert.next_sibling;
            //print("%\n",tris);
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
                if currentvert.next_sibling == null || currentvert.name != "triangle" {
                    break;
                }
            }
        }
        else {
            // TODO Traverse parse tree till we find target attribute
            //print("goose");
        }

    }
    p.triangle_data = polys;
    p.vertex_data = verts;
    zip_free(*uzipped);
    return p;
}

#scope_file
#load "deps/xml/module.jai";
#load "deps/zip/module.jai";
#import "Basic";
x3mp :: struct {
    #as using par:parser;

    type = .P_3MF;

    //vertex_data:[] float;
    triangle_data:[] u64;
}