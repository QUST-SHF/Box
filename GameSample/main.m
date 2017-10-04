//
//  main.m
//  GameSample
//
//  Created by Michael on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
	@autoreleasepool {
		@try {
			return NSApplicationMain(argc, (const char **)argv);
		}
		@catch (NSException *exception) {
			NSLog (@"Exception: %@", [exception description]);
			exit(EXIT_FAILURE);
		}
	}
	
}
