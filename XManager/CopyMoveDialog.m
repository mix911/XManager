//
//  CopyMoveDialog.m
//  XManager
//
//  Created by demo on 04.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CopyMoveDialog.h"

#import "MainWindow.h"

#include "MacSys.h"

@implementation CopyMoveDialog

-(void) suggestCopy
{
    state = COPY_TYPE;
    
    [label setStringValue:@"Copy selected files"];
    
    [self setTitle:@"Copy"];
        
    [self makeFirstResponder:yesButton];
    [self makeKeyAndOrderFront:nil];
}

-(void) suggestMove
{
    state = MOVE_TYPE;
    
    [label setStringValue:@"Move selected files?"];
    
    [self setTitle:@"Move"];
    
    [self makeFirstResponder:yesButton];
    [self makeKeyAndOrderFront:nil];
}

-(IBAction) pressYes:(id)sender
{
    switch (state) {
        case COPY_TYPE:
            [mainWindow doCopy];
            break;
            
        case MOVE_TYPE:
            [mainWindow doMove];
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

-(void) keyDown:(NSEvent*)theEvent
{
    unsigned int key = [theEvent keyCode];
    switch (key) {
        case VK_ESC:
            [self pressNo:nil];
            break;
            
        case VK_ENTER:
            if ([self firstResponder] == yesButton) {
                [self pressYes:nil];
                [self makeFirstResponder:yesButton];
            }
            else {
                [self pressNo:nil];
                [self makeFirstResponder:yesButton];
            }
            break;
            
        default:
            [super keyDown:theEvent]; 
            break;
    }
}

@end
