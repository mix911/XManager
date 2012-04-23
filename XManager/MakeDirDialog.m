//
//  MakeDirDialog.m
//  XManager
//
//  Created by demo on 23.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MakeDirDialog.h"

#include "MacSys.h"

@implementation MakeDirDialog

-(IBAction) pressCancel:(id)sender
{
    [self close];
}

-(IBAction) pressOk:(id)sender
{
    [self pressCancel:sender];
}

-(void) keyDown:(NSEvent *)theEvent
{
    unsigned int key = [theEvent keyCode];
    
    switch (key) {
        case VK_ESC:
            [self pressCancel:nil];
            break;
            
        default:
            break;
    }
}

@end
