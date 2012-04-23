//
//  CopyMoveDialog.m
//  XManager
//
//  Created by demo on 04.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CopyMoveDialog.h"

#include "MacSys.h"

@implementation CopyMoveDialog

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
    switch (state) {
        case COPY_TYPE:
            [callBackOwner performSelector:pressCopyYesCallback];
            break;
            
        case MOVE_TYPE:
            [callBackOwner performSelector:pressMoveYesCallback];
            break;
            
        default:
            break;
    }
    
    [self pressNo:sender];
}

-(IBAction) pressNo:(id)sender
{
    [self close];
}

-(void) setObj:(id)obj copyCallbackSelector:(SEL)copySel moveCallbackSelector:(SEL)moveSel
{
    pressCopyYesCallback = copySel;
    pressMoveYesCallback = moveSel;
    callBackOwner = obj;
}

-(void) keyDown:(NSEvent*)theEvent
{
    unsigned int key = [theEvent keyCode];
    switch (key) {
        case VK_ESC:
            [self pressNo:nil];
            break;
            
        case VK_ENTER:
            if ([self firstResponder] == yesButton)
                [self pressYes:nil];
            else {
                [self pressNo:nil];
            }
            break;
            
        default:
            [super keyDown:theEvent]; 
            break;
    }
}

@end
