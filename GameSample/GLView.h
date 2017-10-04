//
//  GLView.h
//  GameSample
//
//  Created by Michael on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GLGameViewDelegate.h"
#import <QuartzCore/CVDisplayLink.h>


@class GLRender;

@interface GLView : NSOpenGLView
{
	CVDisplayLinkRef displayLink;
	
	id<GLGameViewDelegate> delegate;
	GLRender *renderer;
    
    BOOL active;
}

@property (readwrite, retain) id<GLGameViewDelegate> delegate;
@property (readwrite, assign) BOOL active;

-(void)drawView;

@end
