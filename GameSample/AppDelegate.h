//
//  AppDelegate.h
//  GameSample
//
//  Created by Michael on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GLView;

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
	IBOutlet GLView *view;
	
}
@property (assign) IBOutlet NSWindow *window;

@end
