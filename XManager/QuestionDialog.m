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
            
        default:
            [super keyDown:theEvent];
    }
}

-(void) makeKeyAndOrderFront:(id)sender
{
    [super makeKeyAndOrderFront:sender];
    
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
