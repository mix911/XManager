//
//  ProgressDialog.m
//  XManager
//
//  Created by demo on 15.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProgressDialog.h"

#import "WindowManager.h"
#import "MessageBoxYesNo.h"

@interface ProgressDialog(Private)

-(void) onTimer;

@end

@implementation ProgressDialog(Private)

-(void) onTimer {
    if ([process isComplete]) {
        [self close];
    }
    else {
        [indicator startAnimation:self];
        double val = 100.0f * [process progress];
        [indicator setDoubleValue:val];
        [indicator stopAnimation:self];
    }
}

@end

@implementation ProgressDialog

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) show:(id<Process>)p {
        
    process = p;
    
    [indicator setMinValue:0.0];    
    [indicator setMaxValue:100.0];
    [indicator setDoubleValue:0.0];
    
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
//    [[NSApplication sharedApplication] runModalForWindow:self];
    [self makeKeyAndOrderFront:self];
}

-(BOOL) windowShouldClose:(id)sender {
    
    if ([process isComplete]) {
        return YES;
    }

    [process pauseProcess];
    
    if ([messagebox doModal :@"Hello?" :@"XManager"]) {
        [timer invalidate];
        timer = nil;
        [process stopProcess];
        [[NSApplication sharedApplication] stopModal];
        return YES;
    }
    
    [process continueProcess];
    return NO;
}

@end
