//
//  CopyDialog.h
//  XManager
//
//  Created by demo on 20.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

#import "WindowManagerProtocol.h"

enum EYesNoDialogType {
    MOVE_YES_NO_DIALOG_TYPE,
    COPY_YES_NO_DIALOG_TYPE,
};

@interface YesNoDialog : NSPanel {
    IBOutlet    NSTextField*                message;
                id<WindowManagerProtocol>   windowManager;
    enum        EYesNoDialogType            type;
}

-(void)     Show    :(enum EYesNoDialogType)type :(id<WindowManagerProtocol>)windowManager;
-(IBAction) pressYes:(id)sender;
-(IBAction) pressNo :(id)sender;

@end
