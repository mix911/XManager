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
    
    SEL pressCopyYesCallback;
    SEL pressMoveYesCallback;
    id  callBackOwner;
    
    enum ECopyMoveDialogType state;
}

-(void) setObj:(id)obj copyCallbackSelector:(SEL)copySel moveCallbackSelector:(SEL)moveSel;

-(void) suggestCopy;
-(void) suggestMove;

-(IBAction) pressYes:(id)sender;
-(IBAction) pressNo:(id)sender;

@end
