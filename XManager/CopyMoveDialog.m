//
//  CopyMoveDialog.m
//  XManager
//
//  Created by demo on 04.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CopyMoveDialog.h"

@implementation CopyMoveDialog

@synthesize pressCopyYes;
@synthesize pressMoveYes;

-(void) suggestCopy
{
    state = COPY_TYPE;
    
    [label setStringValue:@"Copy selected files"];
    
    [self setTitle:@"Copy"];
    
    [self makeKeyAndOrderFront:nil];
}

-(void) suggestMove
{
    state = MOVE_TYPE;
    
    [label setStringValue:@"Move selected files?"];
    
    [self setTitle:@"Move"];
    
    [self makeKeyAndOrderFront:nil];
}

-(IBAction) pressYes:(id)sender
{
    [self pressNo:sender];
    
    switch (state) {
        case COPY_TYPE:
            [self pressCopyYes];
            break;
            
        case MOVE_TYPE:
            [self pressMoveYes];
            break;
            
        default:
            break;
    }
}

-(IBAction) pressNo:(id)sender
{
    [self close];
}

@end
