//
//  MakeDirDialog.m
//  XManager
//
//  Created by demo on 23.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MakeDirDialog.h"
#import "MainWindow.h"

#include "MacSys.h"
#include "Switch.h"

#import "MessageBox.h"

@implementation MakeDirDialog

-(IBAction) pressCancel:(id)sender
{
    [MessageBox show:@"Cancel"];
    [self close];
}

-(IBAction) pressOk:(id)sender
{
    [MessageBox show:@"Ok"];
    [self pressCancel:sender];
    [mainWindow doMakeDir];
}

-(IBAction) enterKeyDown:(id)sender
{
    [self pressOk:nil];
}

-(void) keyDown:(NSEvent*)theEvent
{
    unsigned int key = [theEvent keyCode];
    
    switch (key) {
        case VK_ESC:
            [self pressCancel:nil];
            break;
            
        case VK_ENTER:
            if ([self firstResponder] == cancelButton) {
                [self pressCancel:nil];
            }
            else {
                [self pressOk:nil];
            }
            break;
            
        default:
            [super keyDown:theEvent];
            break;
    }
}

-(void) makeKeyAndOrderFront:(id)sender
{
    [directoryField setStringValue:@""];
    [self makeFirstResponder:directoryField];
    [super makeKeyAndOrderFront:sender];
}

-(NSString*) directory
{
    return [directoryField stringValue];
}

-(void) awakeFromNib
{
    [directoryField setDelegate:self];
}

-(BOOL) control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
{
    if (commandSelector == @selector(cancelOperation:)) {
        [self pressCancel:nil];
        return YES;
    }
    
    return NO;
}

@end
