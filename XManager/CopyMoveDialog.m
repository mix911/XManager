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

-(NSUInteger) suggestWithState:(enum ECopyMoveDialogType)s label:(NSString*)l title:(NSString*)t
{
    state = s;
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
    return [self suggestWithState:COPY_TYPE label:@"Copy selected files?" title:@"Copy"];
}

-(NSUInteger) suggestMove
{
    return [self suggestWithState:MOVE_TYPE label:@"Move selected files?" title:@"Move"];
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
    [[NSApplication sharedApplication] stopModal];
    [self close];
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
