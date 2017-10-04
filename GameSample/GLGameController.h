//
//  GLGameController.h
//  GameSample
//
//  Created by Michael on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GLView;
@class GLRender;

@interface GLGameController : NSObject
{
	GLView *gameView;
	GLRender *gameRender;
}

@property (readwrite, atomic, retain) GLView *gameView;
@property (readwrite, atomic, retain) GLRender *gameRender;

-(id)initWithGameView:(GLView *)view;

-(void)render;
-(void)resizeWithWidth:(GLint)width andHeight:(GLint)height;

@end
