//
//  GLLevelGenerator.h
//  GameSample
//
//  Created by Michael on 17/10/12.
//
//

#import <Foundation/Foundation.h>

#import "glm.hpp"

using namespace glm;

GLuint size = 1;

GLfloat testVertices[] = {
    //Vertices    //Block ID
    0, 0, 0,      0
};

GLuint blockInfo[1][3] = {
    {
        //Texture Data
        //Sides
        0,
        //Top
        1,
        //Bottom
        2
        
    }
};

@interface GLLevelGenerator : NSObject
{
    GLfloat *vertices;
    GLfloat *normals;
}

-(id)initWithBasicVertices:(GLfloat *)basicVertices arraySize:(GLuint)size;

@end
