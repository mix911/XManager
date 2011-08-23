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
        //[self setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
    }
    
    return self;
}

-(void) setSidePanel:(id<SidePanelProtocol>)sp {
    sidePanel = sp;
}

-(void) keyDown:(NSEvent*)event {
    
//    unsigned short key = [event keyCode];
    
    switch ([event keyCode]) {
            
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
                }
            }
            else if([event modifierFlags] & NSShiftKeyMask) {
                NSInteger row = [self selectedRow];
                
                [sidePanel invertSelection:row];
            }
            break;
            
        // Down
        case 0x7D:
            if ([event modifierFlags] & NSShiftKeyMask) {
                
                NSInteger row = [self selectedRow];
                
                [sidePanel invertSelection:row];
            }
            break;
            
        // Tab
        case 48:
            // Если был зажат Control то все как обычно
            if ([event modifierFlags] & NSControlKeyMask) {
                break;
            }
            // Обрабатываем сами
            [sidePanel postKeyDown:event];
            return;
                    
        default:
            break;
    }
    
    [super      keyDown     :event];
    [sidePanel  postKeyDown :event];
}

-(void) doubleClick:(id)sender {
    NSInteger row = [self selectedRow];
    if ([sidePanel enterToRow:row]) {
        [self reloadData];
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    }
}

-(void) drawRect:(NSRect)dirtyRect {
    // Нарисуемся
    [super drawRect:dirtyRect];
}

-(BOOL) becomeFirstResponder {
    [self selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    [sidePanel setActive];
    return [super becomeFirstResponder];
}

@end
