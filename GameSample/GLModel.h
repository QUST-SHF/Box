//
//  GLModel.h
//  GameSample
//
//  Created by Michael on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef GameSample_GLModel_h
#define GameSample_GLModel_h

#import <OpenGL/gl3.h>

typedef struct modelStruc
{
	GLuint numVertices;
	
	GLubyte *positions;
	GLenum positionType;
	GLuint positionSize;
	GLsizei positionArraySize;
	
	GLubyte *texcoords;
	GLenum texcoordType;
	GLuint texcoordSize;
	GLsizei texcoordArraySize;
	
	GLubyte *normals;
	GLenum normalType;
	GLuint normalSize;
	GLsizei normalArraySize;
	
	GLubyte *elements;
	GLenum elementType;
	GLuint numElements;
	GLsizei elementArraySize;
	
	GLenum primType;
	
} renderModel;

#endif
