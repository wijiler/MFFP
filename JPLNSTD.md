# JPLN standard, easy to parse, informative file format

## Sections

- DATA
  - for specifying model data for simulation, texture, material, pressure, body name, sketch name etc 

## Commands

`@ BODNUM NAME MATERIAL EXTRAS`  
Extras can be used for extra data need for a simulation, it is variadic this helps when designing  
 systems that may not conform to or be easily made in a jpln parser  
`LOC UNIT`  
this specifies a unit of measurement for the DIMENSION type  

- MODEL
  - for specifying how sketches and features are extruded

## Commands

`BE SKETCHNUM AMOUNT`  
Boss extrude  
`EC SKETCHNUM AMOUNT`  
Extrude cut  
`REV SKETCHNUM DEG`  
Revolution  
`LOFT .. BODY/Sketch`  
Loft, is variadic

Other useful commands will be added in the future

- Sketch
  - defines sketches and where they are  

## Commands

`BSK PLANENUM ..SHAPEPRIMITIVE`  
creates a new sketch
`ESK`
defines the end of a sketch

- Plane
  - Defines the planes

## Commands 

`NP ..FACE/AXIS/..REF`