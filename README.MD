# MFFP - manufacturing/machinists file format parser

## Native jai parsing for manufacturing file formats

## Planned support

- [x] .3mf (dont fucking use this file format, it is actually so bad)
- [ ] .stp/.step
- [ ] .stl
- [ ] .jsktch

## Design principles

Having simple,fast parsers for various CAD/CAM/CAE file formats  
Being highly compatible with many graphics frameworks/api's and rendering architectures

## Installing

Because all dependency's are locally installed in this repo you do not need to hunt, simply

```sh
git clone --recursive https://github.com/wijiler/MFFP.git
```

## Modular

each file parser is its own useable module, allowing you to seperate only what you need

However I should give authors of all dependencies and resources used to figure out certain file standards by myself (EX. STEP) credit for making my project work  
[tm-zip](https://github.com/Lunatoid/tm_zip)  
[jxml](https://github.com/smari/jai-xml)  
[step-tools](https://www.steptools.com/docs/stpfiles/ap214/index.html)