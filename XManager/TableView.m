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
        // Initialization code here.
    }
    
    return self;
}

-(void) setSidePanel:(id<SidePanelProtocol>)sp {
    sidePanel = sp;
}

-(void) keyDown:(NSEvent*)event {
    [super keyDown:event];
    
    switch ([event keyCode]) {
        case 0x24:
        {
            NSInteger row = [super selectedRow];
            if ([[super dataSource] enterToRow:row])
                [self reloadData];
        }
            break;
            
        case 0x7E:
            if ([event modifierFlags] & NSCommandKeyMask) {
                if ([[super dataSource] goUp])
                    [self reloadData];
            }
            break;
            
        case 0x11:
            [sidePanel addTabFromCurrent];
            break;
            
        default:
            break;
    }
}

@end
