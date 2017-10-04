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
#import "GLWorld.h"
#import "GLView.h"
#import "GLLevelParser.h"

//C Files
#include "GLModel.h"
#import "GLLevels.h"
#import <math.h>
#import <sys/timeb.h>

//#define power(x, y) pow(x, y)

//C++ Files
#import <iostream>
#import <stdio.h>
#import <vector>
#import "GLObjLoader.hpp"
#import "GLVBOIndexer.hpp"

#define USE_NORMALS 1
#define USE_TEXTURES 1

#define NSLog //


const int g = 9.8; //Earth's gravity constant

//#define power(x, y) int a=1; for (int i=0;i<y,i++)a*=x; return a;

using namespace glm;


typedef void (*GLInfoFunction)(GLuint program,
GLenum pname,
GLint* params);
typedef void (*GLLogFunction) (GLuint program,
GLsizei bufsize,
GLsizei* length,
GLchar* infolog);




GLuint numLights = 2;

GLfloat lightPositions[] = {10, 10, 10,
    -9, 3, 9,
    5, 5, 5
};
GLfloat ambIntensities[] = {0.6, 0.6, 0.6,
    0, 0, 0,
    0, 0, 0
};

GLfloat specIntensities[] = {0.0, 0.0, 0.0,
    0.0, 0.0, 0.0,
    0.0, 0.0, 0.0
};

GLfloat lightColors[] = {0.7, 0.7, 0.7,
    1, 0.5, 0.2,
    1, 1, 1
};

GLfloat lightPowers[] = {100, 100, 5
};

#define	checkProgramLog() //{GLint logLength;\
glGetProgramiv(program, GL_INFO_LOG_LENGTH, &logLength);\
if (logLength > 0)\
{\
GLchar *log = (GLchar*)malloc(logLength);\
glGetProgramInfoLog(program, logLength, &logLength, log);\
NSLog(@"Program validate log:\n%s\n", log);\
free(log);\
}\
}

#define glErr() //GetGLError()

#undef GetGLError
#define GetGLError() //

#define vertexShaderName @"world"
#define fragmentShaderName @"world"

#define skyboxShaderName @"Skybox"


enum
{
	NORMAL_ATTR = 0,
	TEXTURE_ATTR=2,
	POSITION_ATTR=1,
};

#define mvpUniformName "modelViewProjectionMatrix"
#define floorTexture "floorTex"
#define brickWallTexture "brickTex"
#define lightPos "lightPos"
#define ambientLighting "ambLight"
#define specLighting "specLight"
#define modelMName "modelMatrix"
#define viewMName "viewMatrix"
#define lightColorName "lightColor"
#define lightPowerName "lightPower"
#define xLoc "xLoc"
#define zLoc "zLoc"
#define texNames "textures"

@interface GLRender ()
{
	NSDate *renderStartTime;
    NSDate *lastFrameTime;
    GLfloat yChange;
    GLfloat runSpeed;
    GLfloat dropMomentum;
    GLfloat dropAcceleration;
    GLfloat airStrafeSpeed;
    GLfloat jumpUp;
    vec3 jumpMovement;

    BOOL freeflyMode;
    
    GLfloat *currentLevel;
    GLfloat *currentLevelBoxes;
    GLfloat currentLevelSize;
    GLfloat currentLevelBoxesSize;
    GLfloat *currentLevelBoxesTaken;
    GLuint level;
    GLuint currentLevelTotalBoxes;
    
    BOOL stopTakeInput;
}

-(void)resetLocation;

@end

@implementation GLRender

@synthesize world, view;

#pragma mark Class Initializers

std::vector<unsigned short> indices;
std::vector<vec3> indexed_vertices;
std::vector<vec2> indexed_uvs;
std::vector<vec3> indexed_normals;

-(id)initWithDefaultFBO:(GLuint)fbo
{
	if ((self = [super init]))
	{
        level = 1;
        stopTakeInput = NO;
        
        [self loadNewLevel:level];
        
        std::vector<vec3> vertices;
        std::vector<vec2> uvs;
        std::vector<vec3> normals;
        //loadOBJ(path, vertices, uvs, normals);
        
        //indexVBO(vertices, uvs, normals, indices, indexed_vertices, indexed_uvs, indexed_normals);
        
        
       // yChange = [[NSScreen mainScreen] frame].size.height;
		//world = [[GLWorld alloc] init];
		
		attributes = [[NSMutableArray alloc] init];
		defaultFBOName = fbo;
		
		viewHeight = 200;
		viewWidth = 200;
        
        [self resetLocation];
        
        runSpeed = 5;
        dropMomentum = 0;
        dropAcceleration = 0.5; //x block per second
        airStrafeSpeed = 2;
        
        //Mouse stuff
        sensitivity = 30; //The larger the slower
        limitation = 10;
        
        onFloor = NO;
        onSurface = NO;
        
        freeflyMode = NO; //No gravity + collision
        
        jumpMovement = vec3(0, 0, 0);
        
        jumpUp = 1;
        
        //currentLevelTotalBoxes = 3;
        
        for (int i = 0; i < keySize; i++)
            keyDown[i] = off;
        
		[self initGL];
		
		[world toggleWorld];
	}
	return self;
}

-(void)initGL
{
	glEnable(GL_DEPTH_TEST);
    //glDisable(GL_MULTISAMPLE);
    //glDisable(GL_LINE_SMOOTH);
    //glDisable(GL_POLYGON_SMOOTH);
  //  glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
    //glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);
    //glHint(GL_TEXTURE_COMPRESSION_HINT, GL_NICEST);
	//glDepthFunc(GL_LESS);
	glClearColor(0, 0, 0, 0);
	glErr();
    glGenVertexArrays(1, &vao);
	glBindVertexArray(vao);
    [self loadVertexShader:vertexShaderName andFragmentShader:fragmentShaderName withVertexShader:&vshShader andFragmentShader:&fshShader];
    [self loadVertexShader:skyboxShaderName andFragmentShader:skyboxShaderName withVertexShader:&skyboxVshShader andFragmentShader:&skyboxFshShader];
	glErr();
	[self buildProgram];
	glErr();
	[self initUniformIndexes];
	glErr();
	//[self addVertexAttribute:positionAttrName];
	
	glBindAttribLocation(program, NORMAL_ATTR, "normals");
	glBindAttribLocation(program, TEXTURE_ATTR, "textures");
	glBindAttribLocation(program, POSITION_ATTR, "position");
	glErr();
	//[self addVertexAttribute:texAttrName];
	glErr();
	[self buildVAO];
	glErr();
	[self buildTextures];
	glErr();
    textureArray = [self buildTextureArray:[NSArray arrayWithObjects:@"Wall", @"Floor", @"Front", @"Green", @"Top", @"Right", @"Left", @"Back", @"Bottom", nil]];
    
	glUseProgram(program);
	
	glErr();
    
    glBindTexture(GL_TEXTURE_2D_ARRAY, textureArray);
    glUniform1i(textures, 0);
    
	glErr();
	glUniform3fv(lightPosIndex, numLights, lightPositions);
	glErr();
	glUniform3fv(lightColorIndex, numLights, lightColors);
	glErr();
	glUniform3fv(specUni, numLights, specIntensities);
	glUniform3fv(ambUni, numLights, ambIntensities);
	glUniform1fv(lightPowerIndex, numLights, lightPowers);
	glErr();
    
    
    glGenVertexArrays(1, &skyboxVAO);
    glBindVertexArray(skyboxVAO);
    [self buildSkyboxProgram];
    
    skyboxMVP = glGetUniformLocation(skyboxProgram, "modelViewProjectionMatrix");
    skyboxTexUniform = glGetUniformLocation(skyboxProgram, "skyboxTexture");
    
    glBindAttribLocation(skyboxProgram, POSITION_ATTR, "positions");
    glBindAttribLocation(skyboxProgram, TEXTURE_ATTR, "textures");
    
    //[self buildSkyboxVAO];
    
    // skyboxTex = [self buildSkyboxTexture];
    
    
    // glUseProgram(skyboxProgram);
    // glUniform1i(skyboxTexUniform, 0);
    
    glErr();
    glUseProgram(program);
    
    prevMouseLoc = [NSEvent mouseLocation];
    //prevMouseLoc = NSMakePoint(view.window.frame.origin.x+view.window.frame.size.width/2, view.window.frame.origin.y+view.window.frame.size.height/2);
    prevMouseLoc.x = roundf(prevMouseLoc.x);
    prevMouseLoc.y = roundf(prevMouseLoc.y);
    CGEventSourceRef evsrc = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
    CGEventSourceSetLocalEventsSuppressionInterval(evsrc, 0.0);
    CGAssociateMouseAndMouseCursorPosition (0);
    CGWarpMouseCursorPosition(prevMouseLoc);
    CGAssociateMouseAndMouseCursorPosition (1);
    CFRelease(evsrc);
    lastFrameTime = [NSDate date];
	[self render];
    [view window];
	glErr();
}


-(void)loadVertexShader:(NSString *)vshFileName andFragmentShader:(NSString *)fshFileName withVertexShader:(int*)vsh andFragmentShader:(int*)fsh
{
    NSString *vshPath = [[NSBundle mainBundle] pathForResource:vshFileName ofType:vshExtension];
	NSString *fshPath = [[NSBundle mainBundle] pathForResource:fshFileName ofType:fshExtension];
    
	[self compileShader:vertexShader withFilePath:vshPath shader:vsh];
	[self compileShader:fragmentShader withFilePath:fshPath shader:fsh];
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
		//NSLog(@"Shader: %s", info);
        free(info);
	}
	
	GLint compiled;
	glGetShaderiv(*shader, GL_COMPILE_STATUS, &compiled);
	//if (compiled==GL_FALSE)// NSLog (@"Fail");
}

-(void)buildProgram
{
    glErr();
	program = glCreateProgram();
    glErr();
	glAttachShader(program, vshShader);
    glErr();
	glAttachShader(program, fshShader);
	glErr();
	glLinkProgram(program);
	
	glValidateProgram(program);
    
    // glUseProgram(program);
    checkProgramLog();
}

-(void)buildSkyboxProgram
{
    skyboxProgram = glCreateProgram();
    glAttachShader(skyboxProgram, skyboxVshShader);
    glAttachShader(skyboxProgram, skyboxFshShader);
    glLinkProgram(skyboxProgram);
    glValidateProgram(skyboxProgram);
    //glUseProgram(skyboxProgram);
    checkProgramLog();
}


-(void)initUniformIndexes
{
	mvpUniformIndex = glGetUniformLocation(program, mvpUniformName);
	floorTexUniform = glGetUniformLocation(program, floorTexture);
	brickWallTexUniform = glGetUniformLocation(program, brickWallTexture);
	lightPosIndex = glGetUniformLocation(program, lightPos);
	ambUni = glGetUniformLocation(program, ambientLighting);
	specUni = glGetUniformLocation(program, specLighting);
	viewMatrixIndex = glGetUniformLocation(program, viewMName);
	modelMatrixIndex = glGetUniformLocation(program, modelMName);
	lightColorIndex = glGetUniformLocation(program, lightColorName);
	lightPowerIndex = glGetUniformLocation(program, lightPowerName);
    viewXUniform = glGetUniformLocation(program, xLoc);
    viewZUniform = glGetUniformLocation(program, zLoc);
    textures = glGetUniformLocation(program, texNames);
	glErr();
	
	
}

-(GLuint)buildVAO
{
    
    GLLevelParser *test = [[GLLevelParser alloc] initWithCoords:currentLevel withSize:currentLevelSize/4];
    GLLevelParser *dynamicVertices = [[GLLevelParser alloc] initWithCoords:currentLevelBoxes withSize:currentLevelBoxesSize/4];
    //CGFloat position [view frame].size.width;
    
    model.positionSize = 3;
    model.positionType = GL_FLOAT;
    model.positionArraySize = test.verticesSize*sizeof(GLfloat);
    model.positions = (GLubyte*)malloc(model.positionArraySize);
    memcpy(model.positions, test.vertices, model.positionArraySize);
    
    
    model.normalType = GL_FLOAT;
    model.normalSize = 3;
    model.normalArraySize = test.verticesSize * sizeof(GLfloat);
    model.normals = (GLubyte *)malloc(model.normalArraySize);
    memcpy(model.normals, test.normals, model.normalArraySize);
    
    
    model.texcoordType = GL_FLOAT;
    model.texcoordSize = 3;
    model.texcoordArraySize = test.verticesSize * sizeof(GLfloat);
    model.texcoords = (GLubyte*)malloc(model.texcoordArraySize);
    memcpy(model.texcoords, test.uvs, model.texcoordArraySize);
    
    
    dynamicBoxes.positionSize = 3;
    dynamicBoxes.positionType = GL_FLOAT;
    dynamicBoxes.positionArraySize = dynamicVertices.verticesSize*sizeof(GLfloat);
    dynamicBoxes.positions = (GLubyte*)malloc(dynamicBoxes.positionArraySize);
    memcpy(dynamicBoxes.positions, dynamicVertices.vertices, dynamicBoxes.positionArraySize);
    
    dynamicBoxes.normalType = GL_FLOAT;
    dynamicBoxes.normalSize = 3;
    dynamicBoxes.normalArraySize = dynamicVertices.verticesSize * sizeof(GLfloat);
    dynamicBoxes.normals = (GLubyte *)malloc(dynamicBoxes.normalArraySize);
    memcpy(dynamicBoxes.normals, dynamicVertices.normals, dynamicBoxes.normalArraySize);
    
    dynamicBoxes.texcoordType = GL_FLOAT;
    dynamicBoxes.texcoordSize = 3;
    dynamicBoxes.texcoordArraySize = dynamicVertices.verticesSize * sizeof(GLfloat);
    dynamicBoxes.texcoords = (GLubyte*)malloc(dynamicBoxes.texcoordArraySize);
    memcpy(dynamicBoxes.texcoords, dynamicVertices.uvs, dynamicBoxes.texcoordArraySize);
    
    
    /*
     model.texcoordType = GL_FLOAT;
     model.texcoordSize = 3;
     */
	GetGLError();
    glBindVertexArray(vao);
	if (USE_NORMALS)
	{
		//GLuint normalBuffer;
        if (!normalBuffer)
            glGenBuffers(1, &normalBuffer);
		GetGLError();
		glBindBuffer(GL_ARRAY_BUFFER, normalBuffer);
		GetGLError();
		glBufferData(GL_ARRAY_BUFFER, model.normalArraySize+dynamicBoxes.normalArraySize, model.normals, GL_STATIC_DRAW);
        glBufferSubData(GL_ARRAY_BUFFER, model.normalArraySize, dynamicBoxes.normalArraySize, dynamicBoxes.normals);
		GetGLError();
		glEnableVertexAttribArray(NORMAL_ATTR);
		GetGLError();
		glVertexAttribPointer(NORMAL_ATTR, model.normalSize, model.normalType, GL_FALSE,0, (void*)0);
		GetGLError();
	}
	GetGLError();
	if (USE_TEXTURES)
	{
		//GLuint texcoordBufferName;
        if (!texcoordBufferName)
            glGenBuffers(1, &texcoordBufferName);
		glBindBuffer(GL_ARRAY_BUFFER, texcoordBufferName);
		glBufferData(GL_ARRAY_BUFFER, model.texcoordArraySize+dynamicBoxes.texcoordArraySize, model.texcoords,		GL_STATIC_DRAW);
        glBufferSubData(GL_ARRAY_BUFFER, model.texcoordArraySize, dynamicBoxes.texcoordArraySize, dynamicBoxes.texcoords);
		glEnableVertexAttribArray(TEXTURE_ATTR);
		glVertexAttribPointer(TEXTURE_ATTR, model.texcoordSize, model.texcoordType, GL_FALSE, 0, (void*)0);
	}
	GetGLError();
	//GLuint vertexBufferName;
	if (!vertexBufferName)
        glGenBuffers(1, &vertexBufferName);
	glBindBuffer(GL_ARRAY_BUFFER, vertexBufferName);
	glBufferData(GL_ARRAY_BUFFER, model.positionArraySize+dynamicBoxes.positionArraySize, model.positions, GL_STATIC_DRAW);
    glBufferSubData(GL_ARRAY_BUFFER, model.positionArraySize, dynamicBoxes.positionArraySize, dynamicBoxes.positions);
	glEnableVertexAttribArray(POSITION_ATTR);
	glVertexAttribPointer(POSITION_ATTR, model.positionSize, model.positionType, GL_FALSE, 0, (void*)0);
    free(model.positions);
	glErr();
	return -1;
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
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, image.width, image.height, 0, GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV, image.data);
	glGenerateMipmap(GL_TEXTURE_2D);
	
	return texture;
}

-(void)buildTextures
{
    floorTex = [self buildTexture:[GLImage imageWithImageName:@"Floor" shouldFlip:NO]];
	brickWallTex = [self buildTexture:[GLImage imageWithImageName:@"Wall" shouldFlip:NO]];
}

-(GLint)buildTextureArray:(NSArray *)arrayOfImages
{
    if (arrayOfImages.count == 0) assert("GLRender 508: Null array");
    
    GLImage *sample = [GLImage imageWithImageName:[arrayOfImages objectAtIndex:0] shouldFlip:NO];
    int width = sample.width, height = sample.height;
    
    GLsizei count = (GLsizei)arrayOfImages.count;
    
    glErr();
    
    GLuint texture3D;
    glGenTextures(1, &texture3D);
    glBindTexture(GL_TEXTURE_2D_ARRAY, texture3D);
    
    glTexParameteri(GL_TEXTURE_2D_ARRAY,GL_TEXTURE_MIN_FILTER, GL_NEAREST); //Always set reasonable texture parameters
    glErr();
    glTexParameteri(GL_TEXTURE_2D_ARRAY,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glErr();
    glTexParameteri(GL_TEXTURE_2D_ARRAY,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D_ARRAY,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
    
    
    for (int a = 0;a<1;a++)
    {
        glTexImage3D(GL_TEXTURE_2D_ARRAY, a, GL_RGBA8, width/twoPower(a), height/twoPower(a), count, 0, GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV, NULL);
        glErr();
        int i=0;
        for (NSString *name in arrayOfImages)
        {
            GLImage *image = [GLImage imageWithImageName:name shouldFlip:NO mipmapLevel:1];
           //NSLog (@"Width: %i", image.width);
            glTexSubImage3D(GL_TEXTURE_2D_ARRAY, a, 0, 0, i, image.width, image.height, 1, GL_BGRA, GL_UNSIGNED_BYTE, image.data);
            glErr();
            i++;
        }
    }
    //free(images);
    return texture3D;
}

int twoPower(int x)
{
    int a = 1;
    for (int i=0;i<x;i++)
        a*=2;
    return a;
}

-(GLint)buildSkyboxTexture
{
    GLImage *skybox = [GLImage imageWithImageName:@"Skybox" shouldFlip:NO mipmapLevel:1];
    
    GLuint skyboxTexture;
    glGenTextures(1, &skyboxTexture);
    glBindTexture(GL_TEXTURE_2D, skyboxTexture);
    
    glPixelStorei(GL_UNPACK_ROW_LENGTH, skybox.width);
	glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, skybox.width, skybox.height, 0, GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV, skybox.data);
    glErr();
    
    return skyboxTexture;
}

#pragma mark Render

BOOL checkCollision(GLint wall, GLfloat moving)
{
    return (wall+0.52>=moving && moving>=wall-0.52) ? YES : NO;
}

-(void)render
{
    NSTimeInterval lastFrameInterval = [[NSDate date] timeIntervalSinceDate:lastFrameTime];
   // NSLog (@"Last Frame Interval: %f", lastFrameInterval);
    lastFrameTime = [NSDate date];
    
    GLfloat xStrafe = 0, zStrafe=0;
    
    
    if (view.active)
    {
        CGEventRef ourEvent = CGEventCreate(NULL);
        CGPoint currentPoint = CGEventGetLocation(ourEvent);
        
        
        // NSPoint currentPoint = [NSEvent mouseLocation];
        currentPoint.x = roundf(currentPoint.x);
        currentPoint.y = roundf(currentPoint.y);
        
        GLfloat yDiff = (currentPoint.x - prevMouseLoc.x);
        GLfloat xDiff = (currentPoint.y - prevMouseLoc.y);
        
        
        
        if (xDiff>=1 || xDiff <= -1 || yDiff <= -1 || yDiff >= 1)
        {
           // NSLog (@"XDiff:%f YDiff:%f", xDiff, yDiff);
            viewRotationX+=(xDiff<0) ? -((xDiff*xDiff/sensitivity)>limitation ? limitation: (xDiff*xDiff/sensitivity)) : ((xDiff*xDiff/sensitivity)>limitation ? limitation: (xDiff*xDiff/sensitivity));
            viewRotationY+=(yDiff<0) ? -((yDiff*yDiff/sensitivity) > limitation ? limitation : (yDiff*yDiff/sensitivity)) : ((yDiff*yDiff/sensitivity) > limitation ? limitation: (yDiff*yDiff/sensitivity));
            
            
            while (viewRotationX<0)
                viewRotationX+=360;
            while (viewRotationX>360)
                viewRotationX -= 360;
            while (viewRotationY<0)
                viewRotationY+=360;
            while (viewRotationY > 360)
                viewRotationY-=360;
            
            if (viewRotationX<270&&viewRotationX>180)
                viewRotationX = 270;
            else if (viewRotationX>90&&viewRotationX<=180)
                viewRotationX = 90;
            
            //Solution found here: http://lists.libsdl.org/pipermail/commits-libsdl.org/2012-January/005292.html
            CGEventSourceRef evsrc = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
            CGEventSourceSetLocalEventsSuppressionInterval(evsrc, 0.0);
            CGAssociateMouseAndMouseCursorPosition (0);
            CGWarpMouseCursorPosition(prevMouseLoc);
            CGAssociateMouseAndMouseCursorPosition (1);
            
        }
        
        if (keyDown[w] != off || keyDown[a] != off || keyDown[s] != off || keyDown[d] != off)
        {
            GLfloat angle = viewRotationY;
            
            if (keyDown[d] == on && keyDown[w] == on)
                angle-=45;
            if (keyDown[d] == on && (keyDown[w] != on || keyDown[s] != on ))
                angle+=90;
            if (keyDown[d] == on && keyDown[s] == on)
                angle-=135;
            if (keyDown[s] == on && (keyDown[a] != on || keyDown[d] != on))
                angle+=180;
            if (keyDown[a] == on && keyDown[s] == on)
                angle-=225;
            if (keyDown[a] == on && (keyDown[w] != on || keyDown[s] != on))
                angle+=270;
            if (keyDown[a] == on && keyDown[w] == on)
                angle-=305;
            
            while (angle < 0)
                angle+=360;
            while (angle > 360)
                angle -= 360;
            while (angle < 0)
                angle += 360;
            while (angle > 360)
                angle-=360;
            
            GLfloat originalAngle = angle;
            if (angle >= 0 && 90 > angle)
                angle = 90 - angle;
            else if (angle >= 90 && 180 > angle)
                angle -= 90;
            else if (angle >= 180 && 270 > angle)
                angle = 270 - angle;
            else if (angle >= 270 && 360 > angle)
                angle -= 270;
            // NSLog (@"2: %f", angle);
            
            xStrafe = cos(angle*pi/180)*lastFrameInterval*runSpeed;
            zStrafe = sin(angle*pi/180)*lastFrameInterval*runSpeed;
            
            if (originalAngle > 90 && 180 >= originalAngle)
                zStrafe = -zStrafe;
            if (originalAngle > 180 && 270 >= originalAngle)
            {   xStrafe = -xStrafe; zStrafe = -zStrafe;}
            if (originalAngle > 270 && 360 >= originalAngle)
                xStrafe = -xStrafe;
            
            if (jumpMovement.y > 0)
            {
                viewPositionY-=jumpMovement.y;
                jumpMovement.y-=5*lastFrameInterval;
            }
            
            if (keyDown[spaceKey])
            {
               // viewPositionY-=0.5;
            }
            
            //NSLog (@"2");
        }
    }
    if (!freeflyMode)
    {
        dropMomentum += dropAcceleration * lastFrameInterval;
        
        GLfloat currentViewPositionXf = -(viewPositionX-xStrafe);
        GLfloat currentViewPositionZf = -(viewPositionZ+zStrafe);
        GLfloat currentViewPositionYf = -(viewPositionY+dropMomentum);
        
        GLint currentViewPositionX = -round(viewPositionX - xStrafe);
        GLint currentViewPositionZ = -round(viewPositionZ + zStrafe);
        GLint currentViewPositionY = -round(viewPositionY + dropMomentum);
        
       // NSLog (@"X: %i  Y: %i  Z: %i ", currentViewPositionX, currentViewPositionY, currentViewPositionZ);
        
        if (onFloor&&keyDown[spaceKey])
        {
           //dropMomentum-=0.15;
        }
        
        for (int i=0;i<currentLevelSize/4;i++)
        {
            if ((checkCollision(currentLevel[i*4+1], currentViewPositionYf) || checkCollision(currentLevel[i*4+1], currentViewPositionYf) || checkCollision(currentLevel[i*4+1], currentViewPositionYf+1)) && checkCollision(currentLevel[i*4], currentViewPositionXf) && checkCollision(currentLevel[i*4+2], currentViewPositionZf) && !(currentLevel[i*4+3] >= 1))
            
            //if (/*(currentLevel[i*4+1] == currentViewPositionY-2 || currentLevel[i*4+1]==currentViewPositionY-1)*/ currentLevel[i*4+1]==currentViewPositionY-1 && currentLevel[i*4] == currentViewPositionX && currentLevel[i*4+2] == currentViewPositionZ && !(currentLevel[i*4+3] >= 1))
            
            {
           //     NSLog (@"OnFloor");
                onFloor = YES;
                break;
            }
            else{
                onFloor = NO;
            }
        }
        
        if (onFloor==YES)
        {
            dropMomentum = 0;
        }
        else
        {
            viewPositionY += dropMomentum;
            if (viewPositionY > 20)
                [self loadNewLevel:level];
        }
        
        //NSLog (@"X: %i Y: %i Z: %i", currentViewPositionX, currentViewPositionY, currentViewPositionZ);
        BOOL collided = NO;
        for (int i=0;i<currentLevelSize/4;i++)
        {
            if (currentLevel[i*4+1] == currentViewPositionY && currentLevel[i*4] == currentViewPositionX && currentLevel[i*4+2] == currentViewPositionZ)
            {
                //NSLog (@"Collided");
                if (currentLevel[i*4+3] >= 1)
                {
                    
                }
                else{
                    collided = YES;
                    
                }
            }
        }
        if (!collided)
        {
            viewPositionX -= xStrafe;
            viewPositionZ += zStrafe;
        }
        else
        {
            NSLog (@"Collided");
            //viewPositionX += xStrafe;
            //viewPositionZ -= zStrafe;
        }
      //  NSLog (@"X: %i  Y: %i  Z: %i  X: %f Y: %f  Z: %f", currentViewPositionX, currentViewPositionY, currentViewPositionZ, viewPositionX, viewPositionY, viewPositionZ);
        
        
        for (int i=0;i<currentLevelBoxesSize/4;i++)
        {
            if (currentLevelBoxes[i*4+1] == currentViewPositionY && currentLevelBoxes[i*4] == currentViewPositionX && currentLevelBoxes[i*4+2] == currentViewPositionZ && currentLevelBoxes[i*4+3] >= 1 && currentLevelBoxesTaken[i]==0)
            {
                //NSLog (@"%f", currentLevelBoxes[i*4+1]);
                currentLevelBoxesTaken[i] = 1;
                glBindBuffer(GL_ARRAY_BUFFER, vertexBufferName);
                
                GLfloat *empty = (GLfloat*)calloc(108, 4);
                glBufferSubData(GL_ARRAY_BUFFER, model.positionArraySize+i*108*4, 108*4, empty);
                glBindBuffer(GL_ARRAY_BUFFER, normalBuffer);
                glBufferSubData(GL_ARRAY_BUFFER, model.normalArraySize+i*108*4, 108*4, empty);
                glBindBuffer(GL_ARRAY_BUFFER, texcoordBufferName);
                glBufferSubData(GL_ARRAY_BUFFER, model.texcoordArraySize+i*108*4, 108*4, empty);
                free(empty);
                currentLevelTotalBoxes--;
                //Got all the boxes!
                if (currentLevelTotalBoxes==0)
                {
                    NSLog (@"You Win");
                    //[[NSSound soundNamed:@"Cheer"] play];
                    stopTakeInput = YES;
                    level++;
                    [self performSelector:@selector(loadNewLevel:) withObject:nil afterDelay:3];
                    
                }
                else
                {
                    [[NSSound soundNamed:@"Blow"] play];
                }
            }
        }
    }
    else{
        viewPositionX -= xStrafe;
        viewPositionZ += zStrafe;
    }
    viewPositionY-=1;
    glUseProgram(program);
    glBindVertexArray(vao);
	
	glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    mat4 projectionMatrix = perspective(50.0f, (GLfloat)viewWidth/(GLfloat)viewHeight, 0.0001f, 3000.0f);
    
    mat4 viewRotateX = rotate(mat4(1.0), (float)viewRotationX, vec3(1, 0, 0));
    mat4 viewMatrix = rotate(viewRotateX, (float)viewRotationY, vec3(0, 1, 0));
	mat4 viewTranslate = translate(viewMatrix, vec3(viewPositionX, viewPositionY, viewPositionZ));
    //mat4 scaleMatrix = scale(mat4(1), vec3(0.1, 0.1, 0.1));
	mat4 modelMatrix = mat4(1);
    
	mat4 mvpMatrix = projectionMatrix * viewTranslate * modelMatrix;//* scaleMatrix;
	
	glUniformMatrix4fv(mvpUniformIndex, 1, GL_FALSE, value_ptr(mvpMatrix));
	glUniformMatrix4fv(viewMatrixIndex, 1, GL_FALSE, value_ptr(viewMatrix));
	glUniformMatrix4fv(modelMatrixIndex, 1, GL_FALSE, value_ptr(modelMatrix));
	
    glUniform1f(viewXUniform, viewPositionX);
    glUniform1f(viewZUniform, viewPositionZ);
    
	glBindTexture(GL_TEXTURE_2D, floorTex);
	//glBindTexture(GL_TEXTURE_2D, brickWallTex);
	
	glErr();
  	//glDrawElements(GL_TRIANGLES, 54, GL_UNSIGNED_INT, 0);
    glDrawArrays(GL_TRIANGLES, 0, 36*currentLevelSize/4+36*currentLevelBoxesSize/4);
    viewPositionY+=1;
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

-(BOOL)noMovement
{
    return (!keyDown[d]&&!keyDown[s]&&!keyDown[d]&&!keyDown[w]) ? YES : NO;
}

-(void)keyDown:(NSEvent *)event
{
    if (!stopTakeInput)
    {
        NSString *characters = [event charactersIgnoringModifiers];
        //NSLog (@"KeyDown: %@", characters);
        unichar character = [characters characterAtIndex:0];
        switch (character) {
            case 'd':
                keyDown[d] = YES;
                if (keyDown[a])
                    keyDown[a] = NO;
                break;
            case 'a':
                keyDown[a] = YES;
                if (keyDown[d])
                    keyDown[d] = NO;
                break;
            case 'w':
                keyDown[w] = YES;
                if (keyDown[s])
                    keyDown[s] = NO;
                break;
            case 's':
                keyDown[s] = YES;
                if (keyDown[w])
                    keyDown[w] = NO;
                break;
            case NSRightArrowFunctionKey:
                keyDown[rightArrow] = YES;
                break;
            case NSLeftArrowFunctionKey:
                keyDown[leftArrow] = YES;
                break;
            case NSUpArrowFunctionKey:
                keyDown[upArrow] = YES;
                break;
            case NSDownArrowFunctionKey:
                keyDown[downArrow] = YES;
                break;
            case 'f':
               // freeflyMode = !freeflyMode;
                //dropMomentum = 0;
                break;
            case ' ':
                
                if (freeflyMode)
                    viewPositionY-=0.5;
                else
                {
                    if (onFloor)
                        dropMomentum = -0.2;
                }
                 
                keyDown[spaceKey] = YES;
                break;
            case '/':
                viewPositionY+=0.1;
                break;
            case 'r':
            {
            
            }
                break;
            default:
                break;
        }
    }
}

-(void)keyUp:(NSEvent *)event
{
        NSString *characters = [event charactersIgnoringModifiers];
        unichar character = [characters characterAtIndex:0];
        switch (character) {
            case 'd':
                if (keyDown[a]==earlyOn&&keyDown[d]==on)
                    keyDown[a] = on;
                keyDown[d] = NO;
                break;
            case 'a':
                if (keyDown[d]==earlyOn&&keyDown[a]==on)
                    keyDown[d] = on;
                keyDown[a] = NO;
                break;
            case 'w':
                if (keyDown[s] == earlyOn && keyDown[w]==on)
                    keyDown[s] = on;
                keyDown[w] = NO;
                break;
            case 's':
                if (keyDown[w] == earlyOn && keyDown[s]==on)
                    keyDown[w] = on;
                keyDown[s] = NO;
                break;
            case ' ':
            /*
                if (onFloor)
                {
                float angle = viewRotationX;
                angle  = 360 - angle;
                if (0 < angle && angle < 90)
                {
                //float upSpeed = jumpUp;
                // float forwardSpeed = cosf(angle)*jumpUp;
                // jumpMovement = vec3(0, upSpeed, 0);
                }
                }
                */
                keyDown[spaceKey] = NO;
                break;
            
            case NSRightArrowFunctionKey:
                keyDown[rightArrow] = NO;
                break;
            case NSLeftArrowFunctionKey:
                keyDown[leftArrow] = NO;
                break;
            case NSUpArrowFunctionKey:
                keyDown[upArrow] = NO;
                break;
            case NSDownArrowFunctionKey:
                keyDown[downArrow] = NO;
                break;
            default:
                break;
            
        }
}

-(void)resetLocation
{
    viewRotationX = 0;
    viewRotationY = 0;
    
    viewPositionX = -5;
    viewPositionY = -10;
    viewPositionZ = -5;
}

-(void)loadNewLevel:(GLuint)newLevel
{
    switch (level) {
        case 1:
            currentLevel = levelOne;
            currentLevelSize = levelOneSize;
            currentLevelBoxes = levelOneBoxes;
            currentLevelBoxesSize = levelOneBoxesSize;
            currentLevelBoxesTaken = levelOneBoxesTaken;
            currentLevelTotalBoxes = levelOneNumBoxes;
            [self buildVAO];
            [self resetLocation];
            break;
        case 2:
            currentLevel = levelTwo;
            currentLevelSize = levelTwoSize;
            currentLevelBoxes = levelTwoBoxes;
            currentLevelBoxesSize = levelTwoBoxesSize;
            currentLevelBoxesTaken = levelTwoBoxesTaken;
            currentLevelTotalBoxes = levelTwoNumBoxes;
            [self buildVAO];
            [self resetLocation];
            stopTakeInput = NO;
            
            break;
        case 3:
            currentLevel = levelThree;
            currentLevelSize = levelThreeSize;
            currentLevelBoxes = levelThreeBoxes;
            currentLevelBoxesSize = levelThreeBoxesSize;
            currentLevelBoxesTaken = levelThreeBoxesTaken;
            currentLevelTotalBoxes = levelThreeNumBoxes;
            [self buildVAO];
            [self resetLocation];
            stopTakeInput = NO;
            break;
        case 4:
            currentLevel = levelFour;
            currentLevelSize = levelFourSize;
            currentLevelBoxes = levelFourBoxes;
            currentLevelBoxesSize = levelFourBoxesSize;
            currentLevelBoxesTaken = levelFourBoxesTaken;
            currentLevelTotalBoxes = levelFourNumBoxes;
            [self buildVAO];
            [self resetLocation];
            stopTakeInput = NO;
            break;
        case 5:
            currentLevel = levelFive;
            currentLevelSize = levelFiveSize;
            currentLevelBoxes = levelFiveBoxes;
            currentLevelBoxesSize = levelFiveBoxesSize;
            currentLevelBoxesTaken = levelFiveBoxesTaken;
            currentLevelTotalBoxes = levelFiveNumBoxes;
            [self buildVAO];
            [self resetLocation];
            stopTakeInput = NO;
            break;
        case 6:
            currentLevel = levelSix;
            currentLevelSize = levelSixSize;
            currentLevelBoxes = levelSixBoxes;
            currentLevelBoxesSize = levelSixBoxesSize;
            currentLevelBoxesTaken = levelSixBoxesTaken;
            currentLevelTotalBoxes = levelSixNumBoxes;
            [self buildVAO];
            [self resetLocation];
            stopTakeInput = NO;
            break;
        default:
            break;
    }
    [self resetBlocks];
}

-(void)resetBlocks
{
    for (int i=0;i<currentLevelTotalBoxes;i++)
    {
        currentLevelBoxesTaken[i]=0;
    }
}

@end

