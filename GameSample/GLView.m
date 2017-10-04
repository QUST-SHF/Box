//
//  GLView.m
//  GameSample
//
//  Created by Michael on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GLView.h"


#import "GLRender.h"

NSDate *lastFrame;

@implementation GLView

@synthesize delegate;

- (CVReturn) getFrameForTime:(const CVTimeStamp*)outputTime
{
	// There is no autorelease pool when this method is called 
	// because it will be called from a background thread
	// It's important to create one or you will leak objects
	@autoreleasepool {
		[self drawView];
		//NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastFrame];
		// NSLog (@"Frames: %f", 60/interval);
		lastFrame = [NSDate date];
		return kCVReturnSuccess;

	}
}

// This is the renderer output callback function
static CVReturn MyDisplayLinkCallback(CVDisplayLinkRef displayLink, const CVTimeStamp* now, const CVTimeStamp* outputTime, CVOptionFlags flagsIn, CVOptionFlags* flagsOut, void* displayLinkContext)
{
    CVReturn result = [(__bridge GLView*)displayLinkContext getFrameForTime:outputTime];
    return result;
}

-(void)awakeFromNib
{
	//Creates the Pixel Format and Context
	NSOpenGLPixelFormatAttribute attribute[] = 
	{
		NSOpenGLPFADoubleBuffer,
		NSOpenGLPFADepthSize, 24,
		NSOpenGLPFAColorSize, 24,
		NSOpenGLPFAAlphaSize, 24,
		NSOpenGLPFAAccelerated,
		NSOpenGLPFANoRecovery,
		NSOpenGLPFAOpenGLProfile, NSOpenGLProfileVersion3_2Core,
		0
	};
	
	NSOpenGLPixelFormat *pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attribute];
	NSOpenGLContext *context = [[NSOpenGLContext alloc] initWithFormat:pixelFormat shareContext:nil];
	lastFrame = [NSDate date];
	[self setPixelFormat:pixelFormat];
	[self setOpenGLContext:context];
	
}

-(void)prepareOpenGL
{
	[super prepareOpenGL];
	[[self openGLContext] makeCurrentContext];
	
	//Sync buffer swaps with vertical refresh rate
	GLint swapInt = 1;
	[[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
	
	renderer = [[GLRender alloc] initWithDefaultFBO:0];
	renderer.view = self;
	
	CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
	
	// Set the renderer output callback function
	CVDisplayLinkSetOutputCallback(displayLink, &MyDisplayLinkCallback, (__bridge void *)self);
	
	// Set the display link for the current renderer
	CGLContextObj cglContext = [[self openGLContext] CGLContextObj];
	CGLPixelFormatObj cglPixelFormat = [[self pixelFormat] CGLPixelFormatObj];
	CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink, cglContext, cglPixelFormat);
	
	// Activate the display link
	CVDisplayLinkStart(displayLink);
	
	
}

-(void)reshape
{
	[super reshape];
	
	CGLLockContext([[self openGLContext] CGLContextObj]);
	
	NSRect rect = [self bounds];
	
	[renderer resizeWithWidth:rect.size.width andHeight:rect.size.height];
	
	CGLUnlockContext([[self openGLContext] CGLContextObj]);

	
}


-(void)drawView
{
	[[self openGLContext] makeCurrentContext];
	
	CGLLockContext([[self openGLContext] CGLContextObj]);
	
	[renderer render];
	
	CGLFlushDrawable([[self openGLContext] CGLContextObj]);
	//[[self openGLContext] flushBuffer];
	CGLUnlockContext([[self openGLContext] CGLContextObj]);
}

-(BOOL)acceptsFirstResponder
{
	return YES;
}

-(void)keyDown:(NSEvent *)theEvent
{
	if ([delegate respondsToSelector:@selector(keyDown:)])
	{
		[delegate keyDown:theEvent];
	}
}

-(void)keyUp:(NSEvent *)theEvent
{
	if ([delegate respondsToSelector:@selector(keyUp:)])
	{
		[delegate keyUp:theEvent];
	}
}

@end
