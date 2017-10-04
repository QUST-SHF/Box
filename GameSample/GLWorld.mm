//
//  GLWorld.m
//  GameSample
//
//  Created by Michael on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GLWorld.h"
#import <math.h>
#import "time.h"

@implementation GLWorld

@synthesize staticVertices, staticTextures, staticNormals, staticElements, dynamicVertices;

-(id)init
{
	if ((self = [super init]))
	{
        time_t test;
        time(&test);
		isWorldRunning = NO;
		
		gameTime = 0;
		
		//Setting the Player
		player.pos.x = 0;
		player.pos.y = 0;
		player.pos.z = 0;
		
		player.rot.x = 0;
		player.rot.y = 0;
		
		player.movement=MOVE_NONE;
		
		player.propelDirection.x = -1;
		player.propelDirection.y = -1;
		
		player.momentum = 10;
		player.maxMomentum = 20;
		
		player.runSpeed = 4;
		player.maxRunSpeed = 
		
		player.onSurface = YES;
		
		gravity = 3;
		
		//Setting World Time
		lastFrameTime = [NSDate date];
		
	}
	return self;
}

-(void)toggleWorld
{
	isWorldRunning = !isWorldRunning;
}

-(void)updateWorld:(NSTimeInterval)time
{
	if (isWorldRunning)
	{
		NSTimeInterval timeIntervalBetweenFrames = [[NSDate date] timeIntervalSinceDate:lastFrameTime];
		lastFrameTime = [NSDate date];
		if (player.onSurface==YES)
		{
			GLfloat distance = player.runSpeed*timeIntervalBetweenFrames;
			GLint viewTotalRotY = (GLint)(player.rot.y+player.movement)%360;
		
			GLfloat changeX=0;
			GLfloat changeZ=0;
		
			if (viewTotalRotY>=0&&viewTotalRotY<=90)
			{
				changeX = sin(viewTotalRotY)*distance;
				changeZ = cos(viewTotalRotY)*distance;
			}
			else if (viewTotalRotY>=90&&viewTotalRotY<=180)
			{
				changeX = cos(viewTotalRotY)*distance;
				changeZ = -sin(viewTotalRotY)*distance;
			}
			else if (viewTotalRotY>=180&&viewTotalRotY<=270)
			{
				changeX = -sin(viewTotalRotY)*distance;
				changeZ = -cos(viewTotalRotY)*distance;
			}
			else if (viewTotalRotY>=270&&viewTotalRotY<=360)
			{
				changeX = -cos(viewTotalRotY)*distance;
				changeZ = sin(viewTotalRotY)*distance;
			}
		
			player.pos.x+=changeX;
			player.pos.z+=changeZ;
			
			lastFrameTime = [NSDate date];
		}
		else {
			//Idea is to that the momentum affects how much you are affected by the gravity.  The faster you are, the less you drop.  The slower you are, the faster you drop.  
			
			GLfloat changeY = player.momentum*timeIntervalBetweenFrames;
			player.momentum-=gravity*timeIntervalBetweenFrames;
			
			GLfloat yFinal = player.pos.y+changeY;
			if (yFinal)
			{
				
			}
			
		}
	}
}

-(void)keyDown:(NSEvent *)event
{
	NSString *characters;
    characters = [[event charactersIgnoringModifiers] lowercaseString];
	unichar character;
	
	for (int i=0;i<characters.length;i++)
	{
		character = [characters characterAtIndex:i];
		
		switch (character) {
			case 'a':
				if (player.movement==MOVE_FORWARDS||player.movement==MOVE_RIGHTFORWARDS)
					player.movement = MOVE_LEFTFORWARDS;
				else if (player.movement==MOVE_BACKWARDS||player.movement==MOVE_RIGHTBACKWARDS)
					player.movement = MOVE_LEFTBACKWARDS;
				else 
					player.movement = MOVE_LEFT;
				break;
			case 'd':
				if (player.movement==MOVE_FORWARDS||player.movement==MOVE_LEFTFORWARDS)
					player.movement = MOVE_RIGHTFORWARDS;
				else if (player.movement==MOVE_BACKWARDS||player.movement==MOVE_LEFTBACKWARDS)
					player.movement = MOVE_RIGHTBACKWARDS;
				else 
					player.movement = MOVE_RIGHT;
				break;
			case 'w':
				if (player.movement==MOVE_RIGHT||player.movement==MOVE_RIGHTBACKWARDS)
					player.movement = MOVE_RIGHTFORWARDS;
				else if (player.movement==MOVE_LEFT||player.movement==MOVE_LEFTBACKWARDS)
					player.movement = MOVE_LEFTFORWARDS;
				else 
					player.movement = MOVE_FORWARDS;
				
				break;
			case 's':
				if (player.movement==MOVE_LEFT||player.movement==MOVE_LEFTFORWARDS)
					player.movement = MOVE_LEFTBACKWARDS;
				else if (player.movement==MOVE_RIGHT||player.movement==MOVE_RIGHTFORWARDS)
					player.movement = MOVE_RIGHTBACKWARDS;
				else 
					player.movement = MOVE_BACKWARDS;
				break;
			case ' ':
				if (player.onSurface)
				{
					player.onSurface = NO;
					player.propelDirection.x = player.rot.x;
					player.propelDirection.y = player.rot.y;
					player.momentum = 20;
				}
				break;	
			default:
				break;
		}
	}
}

-(void)keyUp:(NSEvent *)event
{
	NSString *characters;
	characters = [[event charactersIgnoringModifiers] lowercaseString];
	unichar character;
	
	for (int i=0;i<characters.length;i++)
	{
		character = [characters characterAtIndex:i];
		
		switch (character) {
			case 'a':
				if (player.movement==MOVE_LEFTFORWARDS)
					player.movement=MOVE_FORWARDS;
				else if (player.movement==MOVE_LEFTBACKWARDS)
					player.movement=MOVE_BACKWARDS;
				else 
					player.movement=MOVE_NONE;
				break;
			case 'd':
				if (player.movement==MOVE_RIGHTFORWARDS)
					player.movement=MOVE_FORWARDS;
				else if (player.movement==MOVE_RIGHTBACKWARDS)
					player.movement=MOVE_BACKWARDS;
				else
					player.movement=MOVE_NONE;
				break;
			case 'w':
				if (player.movement==MOVE_RIGHTFORWARDS)
					player.movement=MOVE_RIGHT;
				else if (player.movement==MOVE_LEFTFORWARDS)
					player.movement=MOVE_LEFT;
				else 
					player.movement=MOVE_NONE;
				break;
			case 's':
				if (player.movement==MOVE_RIGHTBACKWARDS)
					player.movement=MOVE_RIGHT;
				else if (player.movement==MOVE_LEFTBACKWARDS)
					player.movement=MOVE_LEFT;
				else 
					player.movement=MOVE_NONE;
				break;
			default:
				break;
		}
	}
}


@end
