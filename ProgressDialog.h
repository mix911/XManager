//
//  ProgressDialog.h
//  XManager
//
//  Created by demo on 08.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Task;
@class QuestionDialog;

@interface ProgressDialog : NSWindow
{
    IBOutlet NSTextField*           label;
    IBOutlet NSProgressIndicator*   progress;
    IBOutlet NSButton*              stopButton;
    IBOutlet QuestionDialog*        questionDialog;
    
    Task* task;
    NSTimer* timer;
}

-(void) setTask:(Task*)task;
-(IBAction) onStop:(id)sender;

+(ProgressDialog*) createProgressDialog;

@end
