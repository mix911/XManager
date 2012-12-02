//
//  QuestionDialog.m
//  XManager
//
//  Created by demo on 13.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionDialog1.h"

#include "MacSys.h"

@implementation QuestionDialog1

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

+(QuestionDialog1*) createQuestionDialog
{
    NSWindowController* controller = [[NSWindowController alloc] initWithWindowNibName:@"QuestionDialog"];
    QuestionDialog1* dlg = (QuestionDialog1*)[controller window];
    [controller release];
    return dlg;
}

@end
