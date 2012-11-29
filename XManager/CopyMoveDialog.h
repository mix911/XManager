//
//  CopyMoveDialog.h
//  XManager
//
//  Created by demo on 04.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindow;

enum ECopyMoveDialogType
{
    COPY_TYPE,
    MOVE_TYPE,
};

@interface CopyMoveDialog : NSPanel
{
    IBOutlet NSTextField* label;
    IBOutlet NSButton*    yesButton;
    IBOutlet NSButton*    noButton;
    IBOutlet MainWindow*  mainWindow;
        
    enum ECopyMoveDialogType state;
}

-(NSUInteger) suggestCopy;
-(NSUInteger) suggestMove;

@end
