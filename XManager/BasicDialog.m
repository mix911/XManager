//
//  BasicDialog.m
//  XManager
//
//  Created by demo on 13.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BasicDialog.h"

#include "MacSys.h"

@implementation BasicDialog

-(void) keyDown:(NSEvent *)theEvent
{
    unsigned int key = [theEvent keyCode];
    
    switch (key) {
        case VK_ESC:
            [self close];
            break;
            
        default:
            [super keyDown:theEvent];
    }
}

@end
