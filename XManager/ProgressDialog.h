//
//  ProgressDialog.h
//  XManager
//
//  Created by demo on 15.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@protocol Process;
@class MessageBoxYesNo;

@interface ProgressDialog : NSPanel {
    NSTimer* timer;
    id<Process> process;
    IBOutlet NSProgressIndicator*   indicator;
    IBOutlet MessageBoxYesNo*       messagebox;
}

-(void) show :(id<Process>)process;
-(BOOL) windowShouldClose:(id)sender;

@end
