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

@implementation ProgressDialog

-(void) awakeFromNib
{
    self.delegate = self;
}

-(BOOL) windowShouldClose:(id)sender
{
    ETaskState state = [task state];
    
    [task pause];
    
    [questionDialog setMessage:@"Stop copy?"];
    
    [[NSApplication sharedApplication] beginSheet:questionDialog
                                   modalForWindow:self
                                    modalDelegate:nil
                                   didEndSelector:nil
                                      contextInfo:nil];
    
    NSUInteger res = [[NSApplication sharedApplication] runModalForWindow:questionDialog];
    
    [[NSApplication sharedApplication] endSheet:questionDialog];
    [questionDialog orderOut:nil];
    
    if (res == YES) {
        [self close];
        return YES;
    }
    
    
    if (state == ETaskStatePlay) {
        [task start];
    }
    
    return NO;
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
    task = [t retain];

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
