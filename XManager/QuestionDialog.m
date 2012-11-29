//
//  QuestionDialog.m
//  XManager
//
//  Created by demo on 13.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionDialog.h"

#include "MacSys.h"

@implementation QuestionDialog

-(void) dealloc
{
    [super dealloc];
}

-(void) keyDown:(NSEvent *)theEvent
{
    unsigned int key = [theEvent keyCode];
    
    switch (key) {
        case VK_ENTER:
            if ([self firstResponder] == btnYes) {
                [self pressYes:nil];
                [self makeFirstResponder:btnYes];
            }
            else {
                [self pressNo:nil];
                [self makeFirstResponder:btnYes];
            }
            break;
            
        case VK_ESC:
            [self close];
            break;
            
        default:
            [super keyDown:theEvent];
    }
}

-(void) setMessage:(NSString *)message
{
    [label setStringValue:message];
}

-(IBAction) pressYes:(id)sender
{
    [[NSApplication sharedApplication] stopModalWithCode:YES];
}

-(IBAction) pressNo:(id)sender
{
    [[NSApplication sharedApplication] stopModalWithCode:NO];
}

@end
