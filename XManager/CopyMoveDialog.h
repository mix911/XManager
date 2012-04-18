//
//  CopyMoveDialog.h
//  XManager
//
//  Created by demo on 04.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

enum ECopyMoveDialogType
{
    COPY_TYPE,
    MOVE_TYPE,
};

@interface CopyMoveDialog : NSWindow
{
    IBOutlet NSTextField* label;
    
    SEL pressCopyYes;
    SEL pressMoveYes;
    
    enum ECopyMoveDialogType state;
}

@property (readwrite) SEL pressCopyYes;
@property (readwrite) SEL pressMoveYes;

-(void) suggestCopy;
-(void) suggestMove;

-(IBAction) pressYes:(id)sender;
-(IBAction) pressNo:(id)sender;

@end
