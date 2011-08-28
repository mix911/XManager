//
//  CopyDialog.m
//  XManager
//
//  Created by demo on 20.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YesNoDialog.h"
#import "WindowManager.h"

@implementation YesNoDialog

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) Show:(enum EYesNoDialogType)t :(id<WindowManagerProtocol>)wm{
    windowManager   = wm;
    type            = t;
    
    switch (type) {
        case MOVE_YES_NO_DIALOG_TYPE:
            [message setStringValue:@"Move selected items"];
            break;
            
        case COPY_YES_NO_DIALOG_TYPE:
            [message setStringValue:@"Copy selected items"];
            
        default:
            break;
    }
    
    windowManager = wm;
    
    [self makeKeyAndOrderFront:self];
}

-(IBAction) pressYes:(id)sender {
    switch (type) {
        case MOVE_YES_NO_DIALOG_TYPE:
            [windowManager pressMoveYes];
            break;
            
        case COPY_YES_NO_DIALOG_TYPE:
            [windowManager pressCopyYes];
            break;
    }
}

-(IBAction) pressNo:(id)sender {
    switch (type) {
        case MOVE_YES_NO_DIALOG_TYPE:
            [windowManager pressMoveNo];
            break;
            
        case COPY_YES_NO_DIALOG_TYPE:
            [windowManager pressMoveYes];
            break;
    }
}

@end
