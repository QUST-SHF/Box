//
//  GLGameViewDelegate.h
//  GameSample
//
//  Created by Michael on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GLGameViewDelegate <NSObject>

@optional

-(void)keyDown:(NSEvent *)event;
-(void)keyUp:(NSEvent *)event;


@end
