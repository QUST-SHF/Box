//
//  GLRender.m
//  GameSample
//
//  Created by Michael on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//Classes
#import "GLRender.h"
#import "GLImage.h"
//#import "GLWorld.h"

//C Files
#include "matrixUtil.h"
#include "GLModel.h"

//GLM Stuff
/*
#import "glm.hpp"
#import "type_ptr.hpp"
#import "matrix_transform.hpp"
*/
typedef void (*GLInfoFunction)(GLuint program, 
GLenum pname, 
GLint* params);
typedef void (*GLLogFunction) (GLuint program, 
GLsizei bufsize, 
GLsizei* length, 
GLchar* infolog);

GLfloat posCoords[] = 
{
	-10, 0.0, -10,
	-10, 0.0, 10,
	10, 0.0, 10,
	10, 0.0, -10,
	
};

GLuint elements[] = 
{
	0, 1, 2,
	2, 3, 0
};

GLfloat texCoords[] = 
{
	0, 0,
	0, 10,
	10, 10,
	10, 0
};

#define	checkProgramLog() {GLint logLength;\
glGetProgramiv(program, GL_INFO_LOG_LENGTH, &logLength);\
if (logLength > 0)\
{\
GLchar *log = (GLchar*)malloc(logLength);\
glGetProgramInfoLog(program, logLength, &logLength, log);\
NSLog(@"Program validate log:\n%s\n", log);\
free(log);\
}\
}

#define glErr() GetGLError()


#define vertexShaderName @"world"
#define fragmentShaderName @"world"

#define positionAttrName @"position"
#define texAttrName @"textures"
#define normalAttrName @"normals"

#define mvpUniformName "modelViewProjectionMatrix"
#define diffuseTexture "diffuseTexture"
#define lightPos0 "lightPos0"

@implementation GLRender

#pragma mark Class Initializers

-(id)initWithDefaultFBO:(GLuint)fbo
{
	if ((self = [super init]))
	{
		//world = [[GLWorld alloc] init];
		
		attributes = [[NSMutableArray alloc] init];
		defaultFBOName = fbo;
		
		viewHeight = 100;
		viewWidth = 100;
		
		viewRotationX = 0;
		viewRotationY = 0;
		
		viewPositionX = 0;
		viewPositionY = -1;
		viewPositionZ = -3;
		
		[self initGL];
		
	}
	return self;
}

-(void)initGL
{
	glEnable(GL_DEPTH_TEST);
	glDepthFunc(GL_LESS);
	glEnable(GL_CULL_FACE);
	glClearColor(0, 0, 0, 0);
	glErr();
	[self loadVertexShader:vertexShaderName andFragmentShader:fragmentShaderName];
	glErr();
	[self buildProgram];
	glErr();
	[self initUniformIndexes];
	glErr();
	[self addVertexAttribute:positionAttrName];
	glErr();
	[self addVertexAttribute:texAttrName];
	glErr();
	vao = [self buildVAO];
	glErr();
	[self buildTextures];
	glErr();
	glUseProgram(program);
	glErr();
	GLint unit = 0;
	glUniform1i(samplerLoc, unit);
	glErr();
	[self render];
	glErr();}

-(void)loadVertexShader:(NSString *)vshFileName andFragmentShader:(NSString *)fshFileName
{
	NSString *vshPath = [[NSBundle mainBundle] pathForResource:vshFileName ofType:vshExtension];
	NSString *fshPath = [[NSBundle mainBundle] pathForResource:fshFileName ofType:fshExtension];
	
	
	[self compileShader:vertexShader withFilePath:vshPath shader:&vshShader];
	[self compileShader:fragmentShader withFilePath:fshPath shader:&fshShader];
	
}

-(void)compileShader:(enum ShaderType)type withFilePath:(NSString *)path shader:(GLint *)shader
{
	const GLchar *source = (GLchar *)[[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] UTF8String];
	
	*shader = (type==vertexShader) ? glCreateShader(GL_VERTEX_SHADER) : glCreateShader(GL_FRAGMENT_SHADER);
	glShaderSource(*shader, 1, &source, NULL);
	glCompileShader(*shader);
	
	GLint logLength;
	glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
	if (logLength >0)
	{
		GLchar *info = (GLchar *)malloc(logLength);
		glGetShaderInfoLog(*shader, logLength, &logLength, info);
		NSLog(@"Shader: %s", info);
	}
	
	GLint compiled;
	glGetShaderiv(*shader, GL_COMPILE_STATUS, &compiled);
	if (compiled==GL_FALSE) NSLog (@"Fail");
}

-(void)buildProgram
{
	program = glCreateProgram();
	glAttachShader(program, vshShader);
	glAttachShader(program, fshShader);
	
	glLinkProgram(program);
	
	glValidateProgram(program);
	
	
}


-(void)initUniformIndexes
{
	mvpUniformIndex = glGetUniformLocation(program, mvpUniformName);
	samplerLoc = glGetUniformLocation(program, diffuseTexture);
}

-(GLuint)buildVAO
{
	GLuint vaoName;
	
	renderModel model;
	/*
	 model.numVertices = sizeof(posCoords)/sizeof(GLfloat);
	 model.positions = posCoords;
	 model.positionType = GL_FLOAT;
	 model.positionSize = 3;
	 model.positionArraySize = sizeof(posCoords);
	 model.normals = NULL;
	 model.texcoords = NULL;
	 */
	model.positionType = GL_FLOAT;
	model.positionSize = 3;
	model.positionArraySize = sizeof(posCoords);
	model.positions = (GLubyte *)malloc(model.positionArraySize);
	memcpy(model.positions, posCoords, model.positionArraySize);
	
	model.texcoordType = GL_FLOAT;
	model.texcoordSize = 2;
	model.texcoordArraySize = sizeof(texCoords);
	model.texcoords = (GLubyte *)malloc(model.texcoordArraySize);
	memcpy(model.texcoords, texCoords, model.texcoordArraySize);
	
	//Insert Normals later
	
	model.elementArraySize = sizeof(elements);
	model.elements = (GLubyte *)malloc(model.elementArraySize);
	memcpy(model.elements, elements, model.elementArraySize);
	
	model.primType = GL_TRIANGLES;
	
	model.numElements = sizeof(elements) / sizeof(GLuint);
	model.elementType = GL_UNSIGNED_INT;
	model.numVertices = model.positionArraySize / (model.positionSize * sizeof(GLfloat));
	
	
	GLuint posAttrib = [self vertexAttribute:positionAttrName];
	
	glGenVertexArrays(1, &vaoName);
	glBindVertexArray(vaoName);
	
	GLuint posBuffer;
	
	glGenBuffers(1, &posBuffer);
	glBindBuffer(GL_ARRAY_BUFFER, posBuffer);
	
	
	glBufferData(GL_ARRAY_BUFFER, model.positionArraySize, model.positions, GL_STATIC_DRAW);
	
	
	glEnableVertexAttribArray(posAttrib);
	
	
	GLsizei posTypeSize = GetGLTypeSize(model.positionType);
	
	
	glVertexAttribPointer(posAttrib, model.positionSize, model.positionType, GL_FALSE, model.positionSize*posTypeSize, BUFFER_OFFSET(0));
	
	GLuint elementBuffer;
	
	glGenBuffers(1, &elementBuffer);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, elementBuffer);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(elements), elements, GL_STATIC_DRAW);
	
	/*
	 if (model.normals)
	 {
	 GLuint normalBuffer;
	 
	 glGenBuffers(1, &normalBuffer);
	 glBindBuffer(GL_ARRAY_BUFFER, normalBuffer);
	 
	 glBufferData(GL_ARRAY_BUFFER, model.normalArraySize, model.normals, GL_STATIC_DRAW);
	 
	 glEnableVertexAttribArray(normalAttrib);
	 
	 GLsizei normalTypeSize = GetGLTypeSize(model.normalType);
	 
	 glVertexAttribPointer(normalAttrib, model.normalSize, model.normalType, GL_FALSE, model.normalSize*normalTypeSize, BUFFER_OFFSET(0));
	 }
	 */ 
	if(model.texcoords)
	{
		GLuint texcoordBufferName;
		GLuint texCoordAttrib = [self vertexAttribute:texAttrName];
		
		// Create a VBO to store texcoords
		glGenBuffers(1, &texcoordBufferName);
		glBindBuffer(GL_ARRAY_BUFFER, texcoordBufferName);
		
		// Allocate and load texcoord data into the VBO
		glBufferData(GL_ARRAY_BUFFER, model.texcoordArraySize, model.texcoords, GL_STATIC_DRAW);
		GetGLError();
		// Enable the texcoord attribute for this VAO
		glEnableVertexAttribArray(texCoordAttrib);
		
		// Get the size of the texcoord type so we can set the stride properly
		GLsizei texcoordTypeSize = GetGLTypeSize(model.texcoordType);
		
		// Set up parmeters for texcoord attribute in the VAO including,
		//   size, type, stride, and offset in the currenly bound VAO
		// This also attaches the texcoord VBO to VAO
		glVertexAttribPointer(texCoordAttrib,	// What attibute index will this array feed in the vertex shader (see buildProgram)
							  model.texcoordSize,	// How many elements are there per texture coord?
							  model.texcoordType,	// What is the type of this data in the array?
							  GL_FALSE,				// Do we want to normalize this data (0-1 range for fixed-point types)
							  model.texcoordSize*texcoordTypeSize,//model.texcoordSize*texcoordTypeSize,  // What is the stride (i.e. bytes between texcoords)?
							  BUFFER_OFFSET(0));	// What is the offset in the VBO to the texcoord data?
		GetGLError();
	}
	//*/
	
	return vaoName;
}


-(GLuint)buildTexture:(GLImage *)image
{
	GLuint texture;
	
	glGenTextures(1, &texture);
	glBindTexture(GL_TEXTURE_2D, texture);
	
	glPixelStorei(GL_UNPACK_ROW_LENGTH, image.width);
	glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
	
	
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
	
	//glTexImage2D(GL_TEXTURE_2D, 0, image.format, image.width, image.height, 0, image.format, image.type, image.data);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, image.width, image.height, 0, GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV, image.data);
	glGenerateMipmap(GL_TEXTURE_2D);
	
	return texture;
}

#pragma mark Render

-(void)render
{
	
	GLfloat modelView[16], projection[16];
	GLfloat mvp[16];
	
	

	glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
	
	glUseProgram(program);
	
	//glm::mat4 projectionMatrix;
	
	
	
	mtxLoadPerspective(projection, 45, (GLfloat)viewWidth/(GLfloat)viewHeight,0.1,10000);
	
	mtxLoadTranslate(modelView, viewPositionX, viewPositionY, viewPositionZ);
	mtxRotateXApply(modelView, viewRotationX);
	mtxRotateYApply(modelView, viewRotationY);
	
	mtxMultiply(mvp, projection, modelView);
	
	glUniformMatrix4fv(mvpUniformIndex, 1, GL_FALSE, mvp);
	
	glBindTexture(GL_TEXTURE_2D, floorTex);
	
	glBindVertexArray(vao);
	
	glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
	glErr();
}

-(void)resizeWithWidth:(GLint)width andHeight:(GLint)height
{
	glViewport(0, 0, width, height);
	viewHeight = height;
	viewWidth = width;
}



#pragma mark Shader Attributes Methods


-(void)addVertexAttribute:(NSString *)attributeName
{
	if (![attributes containsObject:attributeName])
	{
		[attributes addObject:attributeName];
		glBindAttribLocation(program, (GLint)[attributes indexOfObject:attributeName], [attributeName UTF8String]);
	}
}

-(GLuint)vertexAttribute:(NSString *)attributeName
{
	return (GLuint)[attributes indexOfObject:attributeName];
}


- (NSString *)logForOpenGLObject:(GLuint)object 
                    infoCallback:(GLInfoFunction)infoFunc 
                         logFunc:(GLLogFunction)logFunc
{
    GLint logLength = 0, charsWritten = 0;
    
    infoFunc(object, GL_INFO_LOG_LENGTH, &logLength);    
    if (logLength < 1)
        return nil;
    
    char *logBytes = (char*)malloc(logLength);
    logFunc(object, logLength, &charsWritten, logBytes);
    NSString *log = [[NSString alloc] initWithBytes:logBytes 
											 length:logLength 
										   encoding:NSUTF8StringEncoding];
    free(logBytes);
    return log;
}

-(void)buildTextures
{
	floorTex = [self buildTexture:[GLImage imageWithImageName:@"floor" shouldFlip:NO]];
	
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, floorTex);
}

@end
