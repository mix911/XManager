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

-(NSUInteger) suggestWithLabel:(NSString*)l title:(NSString*)t
{
    [label setStringValue:l];
    [self setTitle:t];
    
    [self makeFirstResponder:yesButton];
    
    [[NSApplication sharedApplication] beginSheet:self
                                   modalForWindow:mainWindow
                                    modalDelegate:nil
                                   didEndSelector:nil
                                      contextInfo:nil];
    
    NSUInteger res = [[NSApplication sharedApplication] runModalForWindow:self];
    
    [[NSApplication sharedApplication] endSheet:self];
    [self orderOut:nil];
    
    return res;
}

-(NSUInteger) suggestCopy
{
    return [self suggestWithLabel:@"Copy selected files?" title:@"Copy"];
}

-(NSUInteger) suggestMove
{
    return [self suggestWithLabel:@"Move selected files?" title:@"Move"];
}

-(IBAction) pressYes:(id)sender
{
    [[NSApplication sharedApplication] stopModalWithCode:YES];
}

-(IBAction) pressNo:(id)sender
{
    [[NSApplication sharedApplication] stopModalWithCode:YES];
}

-(void) keyDown:(NSEvent*)theEvent
{
    unsigned int key = [theEvent keyCode];
    
    switch (key) {
            
        case VK_ENTER:
            if ([self firstResponder] == yesButton) {
                [self pressYes:nil];
            }
            else {
                [self pressNo:nil];
            }
            [self makeFirstResponder:yesButton];
            break;
            
        default:
            [super keyDown:theEvent]; 
            break;
    }
}

@end
