//
//  GLWorld.m
//  GameSample
//
//  Created by Michael on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GLWorld.h"

@implementation GLWorld

-(id)init
{
	if ((self = [super init]))
	{
		
	}
	return self;
}


+(id)currentWorld
{
	return [[GLWorld alloc] init];
}

@end
