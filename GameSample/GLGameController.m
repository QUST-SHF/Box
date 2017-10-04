//
//  GLGameController.m
//  GameSample
//
//  Created by Michael on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GLGameController.h"
#import "GLView.h"
#import "GLRender.h"

#define DEFAULT_FBO 0

@implementation GLGameController

@synthesize gameView, gameRender;

-(id)initWithGameView:(GLView *)view
{
	if ((self = [super init]))
	{
		gameRender = [[GLRender alloc] initWithDefaultFBO:DEFAULT_FBO];
		gameView = view;
	}
	return self;
}

-(void)render
{
	[gameRender render];
}

-(void)resizeWithWidth:(GLint)width andHeight:(GLint)height
{
	[gameRender resizeWithWidth:width andHeight:height];
}

@end
