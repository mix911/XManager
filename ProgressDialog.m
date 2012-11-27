//
//  ProgressDialog.m
//  XManager
//
//  Created by demo on 08.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProgressDialog.h"
#import "Task.h"
#import "MessageBox.h"
#import "QuestionDialog.h"

@interface ProgressDialogDelegate : NSObject<NSWindowDelegate>
{
    Task* task;
    QuestionDialog* questionDialog;
    ProgressDialog* progressDialog;
}

-(id) initWithQuestionDialog:(QuestionDialog*)qdlg :(ProgressDialog*)pdlg;
-(BOOL) windowShouldClose:(id)sender;
-(void) setTask:(Task*)task;

@end

@implementation ProgressDialogDelegate

-(id) initWithQuestionDialog:(QuestionDialog*)qdlg :(ProgressDialog*)pdlg;
{
    if (self = [super init]) {
        questionDialog = [qdlg retain];
        progressDialog = [pdlg retain];
    }
    
    return self;
}

-(BOOL) windowShouldClose:(id)sender
{
    ETaskState state = [task state];
    
    [task pause];
    
    [questionDialog setMessage:@"Stop copy?"];
    
    [[NSApplication sharedApplication] beginSheet:questionDialog
                                   modalForWindow:progressDialog
                                    modalDelegate:nil
                                   didEndSelector:nil
                                      contextInfo:nil];
    
    NSUInteger res = [[NSApplication sharedApplication] runModalForWindow:questionDialog];
    
    [[NSApplication sharedApplication] endSheet:questionDialog];
    [questionDialog orderOut:nil];
    
    if (res == YES) {
        [progressDialog close];
        return YES;
    }
    
    
    if (state == ETaskStatePlay) {
        [task start];
    }
    
    return NO;
}

-(void) setTask:(Task *)t
{
    task = t;
}

-(void) dealloc
{
    [questionDialog release];
    [progressDialog release];
    [task release];
    [super dealloc];
}

@end

@implementation ProgressDialog

-(void) awakeFromNib
{
    delegate =[[ProgressDialogDelegate alloc] initWithQuestionDialog:questionDialog:self];
    [self setDelegate:[delegate retain]];
}

+(ProgressDialog*) createProgressDialog
{
    NSWindowController* controller = [[NSWindowController alloc] initWithWindowNibName:@"ProgressDialog"];
    ProgressDialog* progress = (ProgressDialog*)[controller window];
    [controller release];
    return progress;
}

-(void) dealloc
{
    [delegate release];
    [super dealloc];
}

-(void) runProgressWithTask:(Task *)t title:(NSString *)title
{
    [self setTitle:title];
    [self setTask:t];

    [progress setDoubleValue:0.0];
    [progress startAnimation:self];
    
    [task run];

    timer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                             target:self
                                           selector:@selector(onTimer:)
                                           userInfo:nil
                                            repeats:YES];
    
    [stopButton setTitle:@"Stop"];
    
    [super makeKeyAndOrderFront:self];
}

-(void) onTimer:(id)obj
{
    double val = [task progress];
    
    [progress setDoubleValue:val];
    [progress stopAnimation:self];
    
    if ([task isComplete]) {
        [self close];
    }
}

-(void) setTask:(Task*)t
{
    task = [t retain];
    [(ProgressDialogDelegate*)[self delegate] setTask:task];
}

-(IBAction) onStop:(id)sender
{
    NSString* title = [stopButton title];
    
    if ([title isEqualToString:@"Stop"]) {
        [task pause];
        [stopButton setTitle:@"Start"];
    }
    else {
        [task start];
        [stopButton setTitle:@"Stop"];
    }
}

@end
