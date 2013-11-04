// Creates an empty map, with the world a simple ground (pavement) tile
// _width = argument0  (default = 256)
// _height= argument1  (default = 256)
// _depth = argument2  (default = 10)
// _gridcachesize = argument3 (default = 32)  
// _sidebase = argument4  (default = 0)
// _topbase = argument5  (default = 0)
// _pavement = argument6 (default = 0)  (adds on topbase later)
// _tilesize = argument7 (default = 64)
// _tileborder = argument8 (default = 70)

var _width,_height, _depth; 

_width = 256;
_height = 256;
_depth = 10;
_sidebase = 0;
_topbase = 0;
_tilesize = 64;
_tileborder = 70;
_pavement = 0;
_gridcachesize = 32;

var c = argument_count;
if( c>0 ) _width = argument[0];
if( c>1 ) _height = argument[1];
if( c>2 ) _depth = argument[2];
if( c>3 ) _gridcachesize = argument[3];
if( c>4 ) _sidebase = argument[4];
if( c>5 ) _topbase = argument[5];
if( c>6 ) _pavement = argument[6];
if( c>7 ) _tilesize = argument[7];
if( c>8 ) _tileborder = argument[8];




MapWidth = _width;
MapHeight = _height;
MapDepth = _depth;
SideBase = _sidebase;              // base of all SIDE tiles
TopBase = _topbase;                // base of all TOP tiles
TileSize = _tilesize;              // pixel size of all tiles
TileBorder = _tileborder;          // size or tile + surrounding border
PavementTile = _pavement;          // simple pavement tile
GridCacheSize = _gridcachesize;    // Size of a cache block

show_debug_message("w="+string(MapWidth)+", h="+string(MapHeight)+", d="+string(MapDepth)+", sb="+string(SideBase)+
                    ", tb="+string(TopBase)+", ts="+string(TileSize)+", tb="+string(TileBorder));

// First create the empty mesh cache
Cache = ds_grid_create(MapWidth,MapHeight);             // Mesh cache
Map = ds_grid_create(MapWidth,MapHeight);               // actual grid of arrays used for the map
RefCount = 0;
RefCount[0]=0;
RefCount[1]=0;
RefCount[2]=0;
RefMax=2;
for(var yy=0;yy<MapHeight;yy++){
    for(var xx=0;xx<MapWidth;xx++){
        var a=0;

        a[0]=1;        
        RefCount[1]++;
        for(var aa=1;aa<MapDepth;aa++){
            a[aa] = 0;
            RefCount[0]++;
        }
        ds_grid_set(Map,xx,yy,a);
        ds_grid_set(Cache,xx,yy,-1);                     // clear cache entry
    }
}
// Create the block info (set to 0 to reset the array)
block_info=0;

// block/cube 0 reserved for "empty"
var info = 0;
info[0] =  0;      // block flags (32bits)
info[1] = -1;      // left
info[2] = -1;      // right
info[3] = -1;      // top
info[4] = -1;      // bottom
info[5] = -1;      // lid
info[6] = -1;      // behind (usually hidden)
block_info[0]=info;
    
info=0;            // reset array pointer
info[0] =  0;      // block flags (32bits)
info[1] = -1;      // left
info[2] = -1;      // right
info[3] = -1;      // top
info[4] = -1;      // bottom
info[5] = _pavement; // lid
info[6] = -1;      // behind (usually hidden)
block_info[1]=info;
    

info=0;            // reset array pointer
info[0] =  0;      // block flags (32bits)
info[1] = 1;      // left
info[2] = 1;      // right
info[3] = 1;      // top
info[4] = 1;      // bottom
info[5] = _pavement+1; // lid
info[6] = -1;      // behind (usually hidden)
block_info[2]=info;
    

a=0;
a[0]=2;
a[1]=2;
a[2]=2;
a[3]=2;
a[4]=2;
a[5]=2;
RefCount[2]=6;
for(var aa=6;aa<MapDepth;aa++){
    a[aa]=0;
    RefCount[0]++;
}
ds_grid_set(Map,0,0,a);

