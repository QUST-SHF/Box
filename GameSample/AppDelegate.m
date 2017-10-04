//
//  AppDelegate.m
//  GameSample
//
//  Created by Michael on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "GLView.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[self.window setAspectRatio:NSMakeSize(8, 5)];
	[self.window center];
    NSScreen *screen = [NSScreen mainScreen];
    NSRect rect = NSMakeRect(200, 200, 680, 480);
    //NSRect rect = screen.frame;
    
    [self.window setFrame:rect display:YES animate:NO];
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
	return YES;
}

-(void)applicationDidBecomeActive:(NSNotification *)notification
{
    view.active = YES;
}

-(void)applicationDidResignActive:(NSNotification *)notification
{
    view.active = NO;
}


@end
