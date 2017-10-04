//
//  GLRender.h
//  GameSample
//
//  Created by Michael on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGL/gl3.h>
#import "GLModel.h"
#import "GLUtil.h"
#import "GLGameViewDelegate.h"



//GLM Stuff
#import "glm.hpp"
#import "type_ptr.hpp"
#import "matrix_transform.hpp"

@class GLImage;
@class GLWorld;
@class GLView;

typedef enum _keys : NSUInteger
{
    d = 0,
    a,
    s,
    w,
    rightArrow,
    leftArrow,
    upArrow,
    downArrow,
    spaceKey,
    shiftKey,
    escKey,
    f, //Free Fly
} keys;

enum
{
    off = 0,
    on = 1,
    earlyOn = 2, //If a user holds "d", then hold "a" and release "a", "d" needs to be restored.
    
};

static int const keySize = 9;

@interface GLRender : NSObject <GLGameViewDelegate>
{
	//View Reference
	GLView *view;
	
	//World Reference
	GLWorld *world;
	
	//Programs and Shaders
	GLint program;
    GLint skyboxProgram;
	GLint vshShader;
	GLint fshShader;
    GLint skyboxVshShader;
    GLint skyboxFshShader;
	
	GLuint defaultFBOName;
	
	//Character Info
	GLfloat viewRotationX;
	GLfloat viewRotationY;
	
	GLfloat viewPositionX;
	GLfloat viewPositionY;
	GLfloat viewPositionZ;
    
    BOOL onSurface;
    BOOL onFloor;
    
    NSDate *lastOnFloor;
	
	GLint viewHeight;
	GLint viewWidth;
	
	//VAO/VBO Identifier
	GLuint vao;
    GLuint skyboxVAO;
	
	//Texture Identifier;
	GLuint floorTex;
	GLuint brickWallTex;
    GLuint textureArray;
    
    GLuint skyboxTex;
    
    //Texture Uniform
    GLuint floorTexUniform;
    GLuint brickWallTexUniform;
	
	//Uniform Indexes
	GLint mvpUniformIndex;
	GLint lightPosIndex;
	GLint samplerLoc;
	GLint ambUni;
	GLint specUni;
	GLint viewMatrixIndex;
	GLint modelMatrixIndex;
	GLint lightColorIndex;
	GLint lightPowerIndex;
    GLint viewXUniform;
    GLint viewZUniform;
    GLint textures;
    
    
    GLint skyboxTexUniform;
    GLint skyboxMVP;
    
    //Buffers
    GLuint normalBuffer;
    GLuint texcoordBufferName;
    GLuint vertexBufferName;
	
    //Models
    renderModel model;
    renderModel dynamicBoxes;
    
	//Matricies

    NSPoint prevMouseLoc;
    GLint sensitivity;
    GLint limitation;
    
    //Keys
    BOOL keyDown[keySize];
    
    GLuint numberOfBoxes;
	
	NSMutableArray *attributes;
}
@property (readwrite, retain) GLView *view;
@property (readwrite, retain) GLWorld *world;

-(id)initWithDefaultFBO:(GLuint)fbo;
-(void)render;
-(void)resizeWithWidth:(GLint)width andHeight:(GLint)height;

//-(GLuint)buildVAO:(renderModel)model;
-(GLuint)buildVAO;
-(void)loadVertexShader:(NSString *)vshFileName andFragmentShader:(NSString *)fshFileName withVertexShader:(int*)vsh andFragmentShader:(int*)fsh;

-(void)compileShader:(enum ShaderType)type withFilePath:(NSString *)path shader:(GLint *)shader;

-(void)buildProgram;

-(GLuint)buildTexture:(GLImage *)image;

-(void)initGL;

-(void)initUniformIndexes;

-(void)addVertexAttribute:(NSString *)attributeName;
-(GLuint)vertexAttribute:(NSString *)attributeName;

-(void)buildTextures;

-(GLint)buildTextureArray:(NSArray*)arrayOfImages;

@end


