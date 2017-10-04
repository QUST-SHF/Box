//
//  GLLevelParser.h
//  GameSample
//
//  Created by Michael on 22/10/12.
//
//

#import <Foundation/Foundation.h>
//#import <OpenGL/gl3.h>
#import "glm.hpp"

using namespace glm;

@interface GLLevelParser : NSObject

@property (readwrite, assign, atomic) GLfloat *vertices;
@property (readwrite, assign, atomic) GLfloat *normals;
@property (readwrite, assign, atomic) GLfloat *uvs;
@property (readwrite, assign, atomic) GLuint verticesSize;

-(id)initWithCoords:(GLfloat *)coords withSize:(GLuint)size;

@end
