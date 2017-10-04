//
//  GLLevelParser.m
//  GameSample
//
//  Created by Michael on 22/10/12.
//
//

#import "GLLevelParser.h"
#define SIDES_1 0
#define SIDES_2 1
#define SIDES_3 2
#define SIDES_4 3
#define TOP 4
#define BOTTOM 5


GLuint size = 1;

GLfloat testVertices[] = {
    //Vertices    //Block ID
    0, 0, 0,      0
};

GLuint blockInfo[3][6] = {//@"Wall", @"Floor", @"Front", @"Green", @"Top", @"Right", @"Left", @"Back", @"Bottom"
    //Mini cubes start from 1 (Change Later)
    {
        //Texture Data
        //Sides
        0,
        0,
        0,
        0,
        //Top
        1,
        //Bottom
        0
        
    },
    //Mini Cubes (for blocks)
    {
        //Sides
        3,
        3,
        3,
        3,
        //Top
        3,
        //Bottom
        3
    },
    //Skybox
    {
        //Sides
        2,
        6,
        7,
        5,
        //Top
        4,
        //Bottom
        8
    }
};



@implementation GLLevelParser

@synthesize vertices, normals, uvs, verticesSize;

-(id)initWithCoords:(GLfloat *)coords withSize:(GLuint)size
{
    if ((self = [super init]))
    {
        //Debug purposes
        vertices = (GLfloat *)calloc(size*6*3*6, sizeof(GLfloat));
        normals = (GLfloat *)calloc(size*6*3*6, sizeof(GLfloat));
        uvs = (GLfloat *)calloc(size*6*3*6, sizeof(GLfloat));
        
        
        for (int i=0;i<size;i++)
        {
            if (coords[i*4+3] < 1)
            {
            //Front
                vertices[i*108] = coords[i*4]-0.5;
                vertices[i*108+1] = coords[i*4+1]-0.5;
                vertices[i*108+2] = coords[i*4+2]-0.5;
            
                vertices[i*108+3] = coords[i*4+0]-0.5;
                vertices[i*108+4] = coords[i*4+1]+0.5;
                vertices[i*108+5] = coords[i*4+2]-0.5;
            
                vertices[i*108+6] = coords[i*4+0]+0.5;
                vertices[i*108+7] = coords[i*4+1]-0.5;
                vertices[i*108+8] = coords[i*4+2]-0.5;
            
                vertices[i*108+9] = coords[i*4]+0.5;
                vertices[i*108+10] = coords[i*4+1]+0.5;
                vertices[i*108+11] = coords[i*4+2]-0.5;
            
                vertices[i*108+12] = coords[i*4]-0.5;
                vertices[i*108+13] = coords[i*4+1]+0.5;
                vertices[i*108+14] = coords[i*4+2]-0.5;
            
                vertices[i*108+15] = coords[i*4]+0.5;
                vertices[i*108+16] = coords[i*4+1]-0.5;
                vertices[i*108+17] = coords[i*4+2]-0.5;
            
                //Right
                vertices[i*108+18] = coords[i*4+0]+0.5;
                vertices[i*108+19] = coords[i*4+1]-0.5;
                vertices[i*108+20] = coords[i*4+2]-0.5;
            
                vertices[i*108+21] = coords[i*4+0]+0.5;
                vertices[i*108+22] = coords[i*4+1]+0.5;
                vertices[i*108+23] = coords[i*4+2]-0.5;
            
                vertices[i*108+24] = coords[i*4+0]+0.5;
                vertices[i*108+25] = coords[i*4+1]-0.5;
                vertices[i*108+26] = coords[i*4+2]+0.5;
            
                vertices[i*108+27] = coords[i*4+0]+0.5;
                vertices[i*108+28] = coords[i*4+1]+0.5;
                vertices[i*108+29] = coords[i*4+2]+0.5;
            
                vertices[i*108+30] = coords[i*4+0]+0.5;
                vertices[i*108+31] = coords[i*4+1]+0.5;
                vertices[i*108+32] = coords[i*4+2]-0.5;
            
                vertices[i*108+33] = coords[i*4+0]+0.5;
                vertices[i*108+34] = coords[i*4+1]-0.5;
                vertices[i*108+35] = coords[i*4+2]+0.5;
            
                //Back
                vertices[i*108+36] = coords[i*4+0]+0.5;
                vertices[i*108+37] = coords[i*4+1]-0.5;
                vertices[i*108+38] = coords[i*4+2]+0.5;
            
                vertices[i*108+39] = coords[i*4+0]+0.5;
                vertices[i*108+40] = coords[i*4+1]+0.5;
                vertices[i*108+41] = coords[i*4+2]+0.5;
            
                vertices[i*108+42] = coords[i*4+0]-0.5;
                vertices[i*108+43] = coords[i*4+1]-0.5;
                vertices[i*108+44] = coords[i*4+2]+0.5;
    
                vertices[i*108+45] = coords[i*4+0]-0.5;
                vertices[i*108+46] = coords[i*4+1]+0.5;
                vertices[i*108+47] = coords[i*4+2]+0.5;
            
                vertices[i*108+48] = coords[i*4+0]+0.5;
                vertices[i*108+49] = coords[i*4+1]+0.5;
                vertices[i*108+50] = coords[i*4+2]+0.5;
            
                vertices[i*108+51] = coords[i*4+0]-0.5;
                vertices[i*108+52] = coords[i*4+1]-0.5;
                vertices[i*108+53] = coords[i*4+2]+0.5;
            
                //Left
                vertices[i*108+54] = coords[i*4+0]-0.5;
                vertices[i*108+55] = coords[i*4+1]-0.5;
                vertices[i*108+56] = coords[i*4+2]+0.5;
            
                vertices[i*108+57] = coords[i*4+0]-0.5;
                vertices[i*108+58] = coords[i*4+1]+0.5;
                vertices[i*108+59] = coords[i*4+2]+0.5;
            
                vertices[i*108+60] = coords[i*4+0]-0.5;
                vertices[i*108+61] = coords[i*4+1]-0.5;
                vertices[i*108+62] = coords[i*4+2]-0.5;
            
                vertices[i*108+63] = coords[i*4+0]-0.5;
                vertices[i*108+64] = coords[i*4+1]+0.5;
                vertices[i*108+65] = coords[i*4+2]-0.5;
            
                vertices[i*108+66] = coords[i*4+0]-0.5;
                vertices[i*108+67] = coords[i*4+1]+0.5;
                vertices[i*108+68] = coords[i*4+2]+0.5;
            
                vertices[i*108+69] = coords[i*4+0]-0.5;
                vertices[i*108+70] = coords[i*4+1]-0.5;
                vertices[i*108+71] = coords[i*4+2]-0.5;
            
                //Top
                vertices[i*108+72] = coords[i*4+0]-0.5;
                vertices[i*108+73] = coords[i*4+1]+0.5;
                vertices[i*108+74] = coords[i*4+2]-0.5;
            
                vertices[i*108+75] = coords[i*4+0]-0.5;
                vertices[i*108+76] = coords[i*4+1]+0.5;
                vertices[i*108+77] = coords[i*4+2]+0.5;
            
                vertices[i*108+78] = coords[i*4+0]+0.5;
                vertices[i*108+79] = coords[i*4+1]+0.5;
                vertices[i*108+80] = coords[i*4+2]-0.5;
            
                vertices[i*108+81] = coords[i*4+0]+0.5;
                vertices[i*108+82] = coords[i*4+1]+0.5;
                vertices[i*108+83] = coords[i*4+2]+0.5;
            
                vertices[i*108+84] = coords[i*4+0]-0.5;
                vertices[i*108+85] = coords[i*4+1]+0.5;
                vertices[i*108+86] = coords[i*4+2]+0.5;
            
                vertices[i*108+87] = coords[i*4+0]+0.5;
                vertices[i*108+88] = coords[i*4+1]+0.5;
                vertices[i*108+89] = coords[i*4+2]-0.5;
            
                //Bottom
                vertices[i*108+90] = coords[i*4+0]-0.5;
                vertices[i*108+91] = coords[i*4+1]-0.5;
                vertices[i*108+92] = coords[i*4+2]+0.5;
            
                vertices[i*108+93] = coords[i*4+0]-0.5;
                vertices[i*108+94] = coords[i*4+1]-0.5;
                vertices[i*108+95] = coords[i*4+2]-0.5;
            
                vertices[i*108+96] = coords[i*4+0]+0.5;
                vertices[i*108+97] = coords[i*4+1]-0.5;
                vertices[i*108+98] = coords[i*4+2]+0.5;
            
                vertices[i*108+99] = coords[i*4+0]+0.5;
                vertices[i*108+100] = coords[i*4+1]-0.5;
                vertices[i*108+101] = coords[i*4+2]-0.5;
            
                vertices[i*108+102] = coords[i*4+0]-0.5;
                vertices[i*108+103] = coords[i*4+1]-0.5;
                vertices[i*108+104] = coords[i*4+2]-0.5;
            
                vertices[i*108+105] = coords[i*4+0]+0.5;
                vertices[i*108+106] = coords[i*4+1]-0.5;
                vertices[i*108+107] = coords[i*4+2]+0.5;
            }
            else if (coords[i*4+3]==2) //Skybox
            {
                vertices[i*108] = coords[i*4]-100;
                vertices[i*108+1] = coords[i*4+1]-100;
                vertices[i*108+2] = coords[i*4+2]-100;
                
                vertices[i*108+3] = coords[i*4+0]-100;
                vertices[i*108+4] = coords[i*4+1]+100;
                vertices[i*108+5] = coords[i*4+2]-100;
                
                vertices[i*108+6] = coords[i*4+0]+100;
                vertices[i*108+7] = coords[i*4+1]-100;
                vertices[i*108+8] = coords[i*4+2]-100;
                
                vertices[i*108+9] = coords[i*4]+100;
                vertices[i*108+10] = coords[i*4+1]+100;
                vertices[i*108+11] = coords[i*4+2]-100;
                
                vertices[i*108+12] = coords[i*4]-100;
                vertices[i*108+13] = coords[i*4+1]+100;
                vertices[i*108+14] = coords[i*4+2]-100;
                
                vertices[i*108+15] = coords[i*4]+100;
                vertices[i*108+16] = coords[i*4+1]-100;
                vertices[i*108+17] = coords[i*4+2]-100;
                
                //Right
                vertices[i*108+18] = coords[i*4+0]+100;
                vertices[i*108+19] = coords[i*4+1]-100;
                vertices[i*108+20] = coords[i*4+2]-100;
                
                vertices[i*108+21] = coords[i*4+0]+100;
                vertices[i*108+22] = coords[i*4+1]+100;
                vertices[i*108+23] = coords[i*4+2]-100;
                
                vertices[i*108+24] = coords[i*4+0]+100;
                vertices[i*108+25] = coords[i*4+1]-100;
                vertices[i*108+26] = coords[i*4+2]+100;
                
                vertices[i*108+27] = coords[i*4+0]+100;
                vertices[i*108+28] = coords[i*4+1]+100;
                vertices[i*108+29] = coords[i*4+2]+100;
                
                vertices[i*108+30] = coords[i*4+0]+100;
                vertices[i*108+31] = coords[i*4+1]+100;
                vertices[i*108+32] = coords[i*4+2]-100;
                
                vertices[i*108+33] = coords[i*4+0]+100;
                vertices[i*108+34] = coords[i*4+1]-100;
                vertices[i*108+35] = coords[i*4+2]+100;
                
                //Back
                vertices[i*108+36] = coords[i*4+0]+100;
                vertices[i*108+37] = coords[i*4+1]-100;
                vertices[i*108+38] = coords[i*4+2]+100;
                
                vertices[i*108+39] = coords[i*4+0]+100;
                vertices[i*108+40] = coords[i*4+1]+100;
                vertices[i*108+41] = coords[i*4+2]+100;
                
                vertices[i*108+42] = coords[i*4+0]-100;
                vertices[i*108+43] = coords[i*4+1]-100;
                vertices[i*108+44] = coords[i*4+2]+100;
                
                vertices[i*108+45] = coords[i*4+0]-100;
                vertices[i*108+46] = coords[i*4+1]+100;
                vertices[i*108+47] = coords[i*4+2]+100;
                
                vertices[i*108+48] = coords[i*4+0]+100;
                vertices[i*108+49] = coords[i*4+1]+100;
                vertices[i*108+50] = coords[i*4+2]+100;
                
                vertices[i*108+51] = coords[i*4+0]-100;
                vertices[i*108+52] = coords[i*4+1]-100;
                vertices[i*108+53] = coords[i*4+2]+100;
                
                //Left
                vertices[i*108+54] = coords[i*4+0]-100;
                vertices[i*108+55] = coords[i*4+1]-100;
                vertices[i*108+56] = coords[i*4+2]+100;
                
                vertices[i*108+57] = coords[i*4+0]-100;
                vertices[i*108+58] = coords[i*4+1]+100;
                vertices[i*108+59] = coords[i*4+2]+100;
                
                vertices[i*108+60] = coords[i*4+0]-100;
                vertices[i*108+61] = coords[i*4+1]-100;
                vertices[i*108+62] = coords[i*4+2]-100;
                
                vertices[i*108+63] = coords[i*4+0]-100;
                vertices[i*108+64] = coords[i*4+1]+100;
                vertices[i*108+65] = coords[i*4+2]-100;
                
                vertices[i*108+66] = coords[i*4+0]-100;
                vertices[i*108+67] = coords[i*4+1]+100;
                vertices[i*108+68] = coords[i*4+2]+100;
                
                vertices[i*108+69] = coords[i*4+0]-100;
                vertices[i*108+70] = coords[i*4+1]-100;
                vertices[i*108+71] = coords[i*4+2]-100;
                
                //Top
                vertices[i*108+72] = coords[i*4+0]-100;
                vertices[i*108+73] = coords[i*4+1]+100;
                vertices[i*108+74] = coords[i*4+2]-100;
                
                vertices[i*108+75] = coords[i*4+0]-100;
                vertices[i*108+76] = coords[i*4+1]+100;
                vertices[i*108+77] = coords[i*4+2]+100;
                
                vertices[i*108+78] = coords[i*4+0]+100;
                vertices[i*108+79] = coords[i*4+1]+100;
                vertices[i*108+80] = coords[i*4+2]-100;
                
                vertices[i*108+81] = coords[i*4+0]+100;
                vertices[i*108+82] = coords[i*4+1]+100;
                vertices[i*108+83] = coords[i*4+2]+100;
                
                vertices[i*108+84] = coords[i*4+0]-100;
                vertices[i*108+85] = coords[i*4+1]+100;
                vertices[i*108+86] = coords[i*4+2]+100;
                
                vertices[i*108+87] = coords[i*4+0]+100;
                vertices[i*108+88] = coords[i*4+1]+100;
                vertices[i*108+89] = coords[i*4+2]-100;
                
                //Bottom
                vertices[i*108+90] = coords[i*4+0]-100;
                vertices[i*108+91] = coords[i*4+1]-100;
                vertices[i*108+92] = coords[i*4+2]+100;
                
                vertices[i*108+93] = coords[i*4+0]-100;
                vertices[i*108+94] = coords[i*4+1]-100;
                vertices[i*108+95] = coords[i*4+2]-100;
                
                vertices[i*108+96] = coords[i*4+0]+100;
                vertices[i*108+97] = coords[i*4+1]-100;
                vertices[i*108+98] = coords[i*4+2]+100;
                
                vertices[i*108+99] = coords[i*4+0]+100;
                vertices[i*108+100] = coords[i*4+1]-100;
                vertices[i*108+101] = coords[i*4+2]-100;
                
                vertices[i*108+102] = coords[i*4+0]-100;
                vertices[i*108+103] = coords[i*4+1]-100;
                vertices[i*108+104] = coords[i*4+2]-100;
                
                vertices[i*108+105] = coords[i*4+0]+100;
                vertices[i*108+106] = coords[i*4+1]-100;
                vertices[i*108+107] = coords[i*4+2]+100;
            }
            else
            {
                //Front
                vertices[i*108] = coords[i*4]-0.2;
                vertices[i*108+1] = coords[i*4+1]-0.2;
                vertices[i*108+2] = coords[i*4+2]-0.2;
                
                vertices[i*108+3] = coords[i*4+0]-0.2;
                vertices[i*108+4] = coords[i*4+1]+0.2;
                vertices[i*108+5] = coords[i*4+2]-0.2;
                
                vertices[i*108+6] = coords[i*4+0]+0.2;
                vertices[i*108+7] = coords[i*4+1]-0.2;
                vertices[i*108+8] = coords[i*4+2]-0.2;
                
                vertices[i*108+9] = coords[i*4]+0.2;
                vertices[i*108+10] = coords[i*4+1]+0.2;
                vertices[i*108+11] = coords[i*4+2]-0.2;
                
                vertices[i*108+12] = coords[i*4]-0.2;
                vertices[i*108+13] = coords[i*4+1]+0.2;
                vertices[i*108+14] = coords[i*4+2]-0.2;
                
                vertices[i*108+15] = coords[i*4]+0.2;
                vertices[i*108+16] = coords[i*4+1]-0.2;
                vertices[i*108+17] = coords[i*4+2]-0.2;
                
                //Right
                vertices[i*108+18] = coords[i*4+0]+0.2;
                vertices[i*108+19] = coords[i*4+1]-0.2;
                vertices[i*108+20] = coords[i*4+2]-0.2;
                
                vertices[i*108+21] = coords[i*4+0]+0.2;
                vertices[i*108+22] = coords[i*4+1]+0.2;
                vertices[i*108+23] = coords[i*4+2]-0.2;
                
                vertices[i*108+24] = coords[i*4+0]+0.2;
                vertices[i*108+25] = coords[i*4+1]-0.2;
                vertices[i*108+26] = coords[i*4+2]+0.2;
                
                vertices[i*108+27] = coords[i*4+0]+0.2;
                vertices[i*108+28] = coords[i*4+1]+0.2;
                vertices[i*108+29] = coords[i*4+2]+0.2;
                
                vertices[i*108+30] = coords[i*4+0]+0.2;
                vertices[i*108+31] = coords[i*4+1]+0.2;
                vertices[i*108+32] = coords[i*4+2]-0.2;
                
                vertices[i*108+33] = coords[i*4+0]+0.2;
                vertices[i*108+34] = coords[i*4+1]-0.2;
                vertices[i*108+35] = coords[i*4+2]+0.2;
                
                //Back
                vertices[i*108+36] = coords[i*4+0]+0.2;
                vertices[i*108+37] = coords[i*4+1]-0.2;
                vertices[i*108+38] = coords[i*4+2]+0.2;
                
                vertices[i*108+39] = coords[i*4+0]+0.2;
                vertices[i*108+40] = coords[i*4+1]+0.2;
                vertices[i*108+41] = coords[i*4+2]+0.2;
                
                vertices[i*108+42] = coords[i*4+0]-0.2;
                vertices[i*108+43] = coords[i*4+1]-0.2;
                vertices[i*108+44] = coords[i*4+2]+0.2;
                
                vertices[i*108+45] = coords[i*4+0]-0.2;
                vertices[i*108+46] = coords[i*4+1]+0.2;
                vertices[i*108+47] = coords[i*4+2]+0.2;
                
                vertices[i*108+48] = coords[i*4+0]+0.2;
                vertices[i*108+49] = coords[i*4+1]+0.2;
                vertices[i*108+50] = coords[i*4+2]+0.2;
                
                vertices[i*108+51] = coords[i*4+0]-0.2;
                vertices[i*108+52] = coords[i*4+1]-0.2;
                vertices[i*108+53] = coords[i*4+2]+0.2;
                
                //Left
                vertices[i*108+54] = coords[i*4+0]-0.2;
                vertices[i*108+55] = coords[i*4+1]-0.2;
                vertices[i*108+56] = coords[i*4+2]+0.2;
                
                vertices[i*108+57] = coords[i*4+0]-0.2;
                vertices[i*108+58] = coords[i*4+1]+0.2;
                vertices[i*108+59] = coords[i*4+2]+0.2;
                
                vertices[i*108+60] = coords[i*4+0]-0.2;
                vertices[i*108+61] = coords[i*4+1]-0.2;
                vertices[i*108+62] = coords[i*4+2]-0.2;
                
                vertices[i*108+63] = coords[i*4+0]-0.2;
                vertices[i*108+64] = coords[i*4+1]+0.2;
                vertices[i*108+65] = coords[i*4+2]-0.2;
                
                vertices[i*108+66] = coords[i*4+0]-0.2;
                vertices[i*108+67] = coords[i*4+1]+0.2;
                vertices[i*108+68] = coords[i*4+2]+0.2;
                
                vertices[i*108+69] = coords[i*4+0]-0.2;
                vertices[i*108+70] = coords[i*4+1]-0.2;
                vertices[i*108+71] = coords[i*4+2]-0.2;
                
                //Top
                vertices[i*108+72] = coords[i*4+0]-0.2;
                vertices[i*108+73] = coords[i*4+1]+0.2;
                vertices[i*108+74] = coords[i*4+2]-0.2;
                
                vertices[i*108+75] = coords[i*4+0]-0.2;
                vertices[i*108+76] = coords[i*4+1]+0.2;
                vertices[i*108+77] = coords[i*4+2]+0.2;
                
                vertices[i*108+78] = coords[i*4+0]+0.2;
                vertices[i*108+79] = coords[i*4+1]+0.2;
                vertices[i*108+80] = coords[i*4+2]-0.2;
                
                vertices[i*108+81] = coords[i*4+0]+0.2;
                vertices[i*108+82] = coords[i*4+1]+0.2;
                vertices[i*108+83] = coords[i*4+2]+0.2;
                
                vertices[i*108+84] = coords[i*4+0]-0.2;
                vertices[i*108+85] = coords[i*4+1]+0.2;
                vertices[i*108+86] = coords[i*4+2]+0.2;
                
                vertices[i*108+87] = coords[i*4+0]+0.2;
                vertices[i*108+88] = coords[i*4+1]+0.2;
                vertices[i*108+89] = coords[i*4+2]-0.2;
                
                //Bottom
                vertices[i*108+90] = coords[i*4+0]-0.2;
                vertices[i*108+91] = coords[i*4+1]-0.2;
                vertices[i*108+92] = coords[i*4+2]+0.2;
                
                vertices[i*108+93] = coords[i*4+0]-0.2;
                vertices[i*108+94] = coords[i*4+1]-0.2;
                vertices[i*108+95] = coords[i*4+2]-0.2;
                
                vertices[i*108+96] = coords[i*4+0]+0.2;
                vertices[i*108+97] = coords[i*4+1]-0.2;
                vertices[i*108+98] = coords[i*4+2]+0.2;
                
                vertices[i*108+99] = coords[i*4+0]+0.2;
                vertices[i*108+100] = coords[i*4+1]-0.2;
                vertices[i*108+101] = coords[i*4+2]-0.2;
                
                vertices[i*108+102] = coords[i*4+0]-0.2;
                vertices[i*108+103] = coords[i*4+1]-0.2;
                vertices[i*108+104] = coords[i*4+2]-0.2;
                
                vertices[i*108+105] = coords[i*4+0]+0.2;
                vertices[i*108+106] = coords[i*4+1]-0.2;
                vertices[i*108+107] = coords[i*4+2]+0.2;
            }
        }
        
        
        //Num of Cubes + 6 sides per cube
        for (int i=0;i<(size*6*2);i++)
        {
            vec3 p1 = vec3(vertices[i*9], vertices[i*9+1], vertices[i*9+2]);
            vec3 p2 = vec3(vertices[i*9+3], vertices[i*9+4], vertices[i*9+5]);
            vec3 p3 = vec3(vertices[i*9+6], vertices[i*9+7], vertices[i*9+8]);
            
            vec3 v1 = p2 - p1;
            vec3 v2 = p3 - p1;
            vec3 normal = cross(v1, v2);
            
            normal = normalize(normal);
            
            normals[i*9] = fabs(normal.x);
            normals[i*9+1] = fabs(normal.y);
            normals[i*9+2] = fabs(normal.z);
            

            normals[i*9+3] = fabs(normal.x);
            normals[i*9+4] = fabs(normal.y);
            normals[i*9+5] = fabs(normal.z);
            
            normals[i*9+6] = fabs(normal.x);
            normals[i*9+7] = fabs(normal.y);
            normals[i*9+8] = fabs(normal.z);
        }
        
        for (int x=0;x<size;x++)
        {
            int cubeInfo = coords[x*4+3];
          //  NSLog (@"CubeInfo: %i", cubeInfo);
            //Front, Right, Back, Left, Top, Bottom
                for (int i=0;i<6;i++)
                {
                    int texture=i;
                    
                  //  NSLog (@"Test");
                   // NSLog (@"X: %i  i; %i  Final: %i", x, i, i*18+x*108);
                    uvs[x*108+i*18] = 1;
                    uvs[x*108+i*18+1] = 1;
                    uvs[x*108+i*18+2] = blockInfo[cubeInfo][texture];
                    
                    uvs[x*108+i*18+3] = 1;
                    uvs[x*108+i*18+4] = 0;
                    uvs[x*108+i*18+5] = blockInfo[cubeInfo][texture];
                    
                    uvs[x*108+i*18+6] = 0;
                    uvs[x*108+i*18+7] = 1;
                    uvs[x*108+i*18+8] = blockInfo[cubeInfo][texture];
                    
                    uvs[x*108+i*18+9] = 0;
                    uvs[x*108+i*18+10] = 0;
                    uvs[x*108+i*18+11] = blockInfo[cubeInfo][texture];
                    
                    uvs[x*108+i*18+12] = 1;
                    uvs[x*108+i*18+13] = 0;
                    uvs[x*108+i*18+14] = blockInfo[cubeInfo][texture];
                    
                    uvs[x*108+i*18+15] = 0;
                    uvs[x*108+i*18+16] = 1;
                    uvs[x*108+i*18+17] = blockInfo[cubeInfo][texture];
                    
                }
        }
        /*
        NSLog (@"Vertices");
        for (int i=0;i<size*6*6;i++)
        {
            NSLog (@"X: %f  Y:  %f  Z: %f", vertices[i*3], vertices[i*3+1], vertices[i*3+2]);
        }
        NSLog (@"Normal Vectors");
        for (int i=0;i<size*6*6;i++)
        {
            NSLog (@"X: %f  Y: %f  Z: %f", normals[i*3], normals[i*3+1], normals[i*3+2]);
        }
        NSLog (@"Texture Coords UV");
        for (int i=0;i<size*6*6;i++)
        {
            NSLog (@"S: %f  T: %f  P: %f", uvs[i*3], uvs[i*3+1], uvs[i*3+2]);
        }
*/
        verticesSize = 3*6*6*size;
    }
    return self;
}

@end
