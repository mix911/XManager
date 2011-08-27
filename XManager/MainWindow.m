//
//  MainWindow.m
//  XManager
//
//  Created by demo on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainWindow.h"

@interface MainWindow(Private)

-(void) switchToNextTab;
-(void) switchToPrevTab;

@end

@implementation MainWindow(Private)

-(void) switchToNextTab {
    [windowManager switchToNextTab];
}

-(void) switchToPrevTab {
    [windowManager switchToPrevTab];
}

@end

@implementation MainWindow

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) sendEvent:(NSEvent*)theEvent {
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

@end
