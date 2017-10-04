//
//  GLWorld.h
//  GameSample
//
//  Created by Michael on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGL/gl3.h>
#import "GLGameViewDelegate.h"

#import "glm.hpp"


@class GLRender;
@class GLView;


//Lets say that 1 OpenGL unit will be 1 meter
//So our units will be measured in meters
//Speed used here will be meters per second

enum 
{
	MOVE_NONE = -1,
	MOVE_FORWARDS = 0,
	MOVE_RIGHTFORWARDS = 45,
	MOVE_RIGHT = 90,
	MOVE_RIGHTBACKWARDS = 135,
	MOVE_BACKWARDS = 180,
	MOVE_LEFTBACKWARDS = 225,
	MOVE_LEFT = 270,
	MOVE_LEFTFORWARDS = 315
};
/*
enum
{
	MOVE_FORWARDS=0,
	MOVE_BACKWARDS=180
};

enum 
{
	MOVE_RIGHT = 90,
	MOVE_LEFT = 270
};
*/
typedef struct
{
	glm::vec3 pos;
	glm::vec2 rot;
	
	GLshort movement;
	

	BOOL onSurface;
	BOOL onGround;
	
	//Should speed up to a maximum speed of 10/s
	//Jump Stuff
	glm::vec2 propelDirection;
	GLfloat momentum;
	GLfloat maxMomentum;
	
	GLfloat ySpeed;
	
	//Run Stuff
	GLfloat runSpeed;
	GLfloat maxRunSpeed;

	
} Player;

typedef struct
{
    
} Object;

@class GLLevel;

@interface GLWorld : NSObject <GLGameViewDelegate>
{
	BOOL isWorldRunning;
	
	GLRender *render;
	GLView *view;
	
	GLfloat *staticVertices;
	GLfloat *staticTextures;
	GLfloat *staticNormals;
	GLfloat *staticElements;
	
	GLfloat *dynamicVertices;
	GLfloat *dynamicTextures;
	GLfloat *dynamicNormals;
	GLfloat *dynamicElements;
	
	NSTimeInterval gameTime;
	
	NSDate *lastFrameTime;
	
	Player player;
	
	GLuint gravity;
	
}

@property (readwrite, assign, atomic) GLfloat *staticVertices;
@property (readwrite, assign, atomic) GLfloat *staticTextures;
@property (readwrite, assign, atomic) GLfloat *staticNormals;
@property (readwrite, assign, atomic) GLfloat *staticElements;

@property (readwrite, assign, atomic) GLfloat *dynamicVertices;

-(void)toggleWorld;
-(void)updateWorld:(NSTimeInterval)time;
-(void)gravityAffect:(NSTimeInterval)time;

-(id)initWithLevel:(GLLevel*)level;

@end
