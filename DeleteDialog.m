//
//  DeleteDialog.m
//  XManager
//
//  Created by demo on 08.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DeleteDialog.h"

#import "MessageBox.h"

#include "MacSys.h"

@implementation DeleteDialog

-(IBAction) pressCancel:(id)sender
{
    [MessageBox show:@"Cancel"];
    [self close];
}

-(IBAction) pressOk:(id)sender
{
    [MessageBox show:@"Ok"];
    [self close];
}

-(void) keyDown:(NSEvent *)theEvent
{
    unsigned key = [theEvent keyCode];
    
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
    [self makeFirstResponder:cancelButton];
    [super makeKeyAndOrderFront:sender];
}

@end
