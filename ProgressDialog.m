//
//  ProgressDialog.m
//  XManager
//
//  Created by demo on 08.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProgressDialog.h"
#import "Task.h"

@implementation ProgressDialog

-(void) onTimer:(id)obj
{
    double val = [task progress];
    
    [progress setDoubleValue:val];
    [progress stopAnimation:self];
    
    if ([task isComplete]) {
        [self close];
    }
}

-(void) setTask:(Task*)t
{
    task = [t retain];
}

-(void) makeKeyAndOrderFront:(id)sender
{
    [progress setDoubleValue:0.0];
    
    [task run];
    
    [super makeKeyAndOrderFront:sender];
    
    [progress startAnimation:self];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                             target:self
                                           selector:@selector(onTimer:)
                                           userInfo:nil
                                            repeats:YES];
}

@end
