//
//  MainWindow.m
//  XManager
//
//  Created by demo on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainWindow.h"

#import "SidePanel.h"
#import "TabsHeaders.h"

#include "MacSys.h"

@implementation MainWindow

- (id)init 
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

//+-----------------------------------------------------------------+
//| Загрузка nib архива                                             |
//+-----------------------------------------------------------------+
-(void) awakeFromNib 
{
    
    // Загрузим родителя
    [super awakeFromNib];
    
    NSString* cur_dir = @"/Users/demo/QtSDK";
    
    // Установим директории по умолчанию
    [leftPanel  addTab:cur_dir];
    [rightPanel addTab:cur_dir];
    
    [cur_dir release];
}

-(void) sendEvent:(NSEvent*)theEvent 
{
    switch ([theEvent type]) {
            
        case NSKeyDown:
            if ([theEvent keyCode] == 48 && ([theEvent modifierFlags] & NSControlKeyMask)) {
                if ([theEvent modifierFlags] & NSShiftKeyMask) {
                    [self switchToPrevTab];
                }
                else {
                    [self switchToNextTab];
                }
                return;
            }
            [super sendEvent:theEvent];
            break;
                        
        default:
            [super sendEvent:theEvent];
            break;
    }
}

-(void) postKeyDown:(NSEvent *)event
{
    switch ([event keyCode]) {
            
        case VK_W:
            return;
            
        default:
            break;
    }
    
    [super keyDown:event];
}

-(void) setActiveSide :(id)panel 
{
    activePanel = panel;
}

-(void) insertTab 
{
    if (activePanel == leftPanel) {
        [self setActiveSide:rightPanel];
        [rightPanel setActive:self];
        
    }
    else {
        [self setActiveSide:leftPanel];
        [leftPanel setActive:self];
    }
}

-(void) switchToNextTab 
{
    [activePanel switchToNextTab];
}

-(void) switchToPrevTab 
{
    [activePanel switchToPrevTab];
}

@end
