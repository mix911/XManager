//
//  TableView.m
//  XManager
//
//  Created by demo on 12.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableView.h"
#import "SidePanel.h"

#include "MacSys.h"

@implementation TableView

- (id)init {
    self = [super init];
    if (self) {
        [self setTarget:self];
        [self setDoubleAction:@selector(doubleClick:)];
        [self setAction:nil];
    }
    
    return self;
}

-(void) setSidePanel:(SidePanel*)sp {
    sidePanel = sp;
}

-(void) keyDown:(NSEvent*)event {

    unsigned short key = [event keyCode];
    
    switch (key) {
            
        case VK_ENTER:
        {
            NSInteger row = [super selectedRow];
            if ([sidePanel enterToRow:row]) {
                [self reloadData];
                [self selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
            }
        }
            return;
            
        case VK_ARROR_UP:
            if ([event modifierFlags] & NSCommandKeyMask) {
                if ([sidePanel goUp]) {
                    [self reloadData];
                }
            }
            else if([event modifierFlags] & NSShiftKeyMask) {
                NSInteger row = [self selectedRow];
                
                [sidePanel invertSelection:row];
            }
            break;
            
        case VK_ARROR_DOWN:
            if ([event modifierFlags] & NSShiftKeyMask) {
                
                NSInteger row = [self selectedRow];
                
                [sidePanel invertSelection:row];
            }
            break;
    }
    
    [super keyDown :event];
}

-(void) doubleClick:(id)sender {
    NSInteger row = [self selectedRow];
    if ([sidePanel enterToRow:row]) {
        [self reloadData];
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    }
}

-(BOOL) becomeFirstResponder {
    [self selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    [sidePanel setActive:nil];
    return [super becomeFirstResponder];
}

@end
