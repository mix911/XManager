//
//  TableView.m
//  XManager
//
//  Created by demo on 12.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableView.h"

@implementation TableView

- (id)init {
    self = [super init];
    if (self) {
        [self setTarget:self];
        [self setDoubleAction:@selector(doubleClick:)];
        [self setAction:nil];
        [self setAllowsMultipleSelection:YES];
    }
    
    return self;
}

-(void) setSidePanel:(id<SidePanelProtocol>)sp {
    sidePanel = sp;
}

-(void) keyDown:(NSEvent*)event {
    
    [super keyDown:event];
    
    unsigned short key = [event keyCode];
    
    switch ([event keyCode]) {
        // W
        case 0xD:
            [sidePanel closeCurrentTab];
            break;
            
        case 0x24:
        {
            NSInteger row = [super selectedRow];
            if ([sidePanel enterToRow:row]) {
                [self reloadData];
                [self selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
            }
        }
            break;
            
        // Up
        case 0x7E:
            if ([event modifierFlags] & NSCommandKeyMask) {
                if ([sidePanel goUp]) {
                    [self reloadData];
                    [self selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                }
            }
            else if([event modifierFlags] & NSShiftKeyMask) {
//                NSInteger row = [self selectedRow] + 1;
//                    
//                [selectedRows addIndex:row];
//                
//                [self selectRowIndexes:selectedRows byExtendingSelection:NO];
            }
            break;
            
        // Down
        case 0x7D:
            if ([event modifierFlags] & NSShiftKeyMask) {
//                
//                NSInteger row = [self selectedRow] - 1;
//                
//                if (row < 0) {
//                    break;
//                }
//                
//                [selectedRows addIndex:row];
//                
//                [self selectRowIndexes:selectedRows byExtendingSelection:NO];
            }
            break;
            
        case 0x11:
            [sidePanel addTabFromCurrent];
            break;
        
        default:
            break;
    }
}

-(void) doubleClick:(id)sender {
    NSInteger row = [self selectedRow];
    if ([sidePanel enterToRow:row]) {
        [self reloadData];
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    }
}

@end
