parse_ap214 :: (filename:string) -> ap214 {
    curve := Curve2d(.[0,0,0,0,1,1,1,1],.{1,.{-4,-4,}},.{1,.{-2,4,}},.{1,.{2,-4,}},.{1,.{4,4,}});
    cstring:String_Builder;
    init_string_builder(*cstring);
    append(*cstring,"[");
    for pos:curve {
        thing := sprint("%,",pos);
        replace_chars(thing,"{",#char "(");
        replace_chars(thing,"}",#char ")");
        append(*cstring,thing);
    }
    append(*cstring,"]");
    write_entire_file("coords.txt",builder_to_string(*cstring));

    file := read_entire_file(filename);
    row:int = 0;
    col:int = 0;
    file_peek :: (amount:int) -> u8 #expand {
        return file[`it + amount];
    }
    dist_till_next :: () -> int #expand {
        for `it..file.count - 1 {
            if file[it] == #char ";" then return it;
        }
        print("could not find next instruction E0001 RUNOFF_INSTRUCTION");
        exit(1);
    }
    
    dist_till_args :: () -> int,int #expand {
        st,end:int = 0;
        for `it..file.count - 1 {
            if file[it] == #char "(" then st = it;
            if file[it] == #char ")" then end = it;
        }
        return st,end;
    }
    kwds:[..] keyword;
    current_state:string;
    for 0..file.count - 1 {
        ckwd:keyword = .{};
        if file[it]=={

            case #char "H";
            if file_peek(1) ==  #char "E" && file_peek(2)== #char"A" { ckwd = .{"",.HEADER,.{xx row,xx col}}; current_state = "Header";};
            
            case #char "E";
            if file_peek(1) == #char "N" then ckwd = .{current_state,.ENDSEC,.{xx row, xx col}};
            
            case #char "F";
            if file_peek(1) == #char "I" {
                argsst,argsend := dist_till_args();
                args := slice(file,argsst + 1,argsend - 1);
                name := slice(file,it + 5,argsst - 1);
                type:KEYWRD;
                if name== {
                    case "DESCRIPTION"; type = .FILE_DESC;
                    case "NAME"; type = .FILE_NAME;
                    case "SCHEMA"; type = .FILE_SCHEMA;
                }
                ckwd = .{args,type,.{xx row, xx col}};
            }
            case #char ";"; row = 0; col = 0;
            case;;
        }
        array_add(*kwds,ckwd);
        it += dist_till_next();
    }
}




#scope_file


object :: struct {
    number:u64;
    instruction:string;
}

keyword :: struct {
    data:string;
    type: KEYWRD;
    pos: Vector2;
}

KEYWRD :: enum u8 {
    HEADER :: 255;
    ENDSEC :: 254;
    FILE_DESC :: 253;
    FILE_NAME :: 252;
    FILE_SCHEMA :: 251;
}

ap214 :: struct {
    #as using s: MFFP_parser;
    type = .P_AP214;

    object_name:string;
    author_email:string;
}
#import "File";
#import "String";
#load "NURBS/module.jai";
#import "Math";