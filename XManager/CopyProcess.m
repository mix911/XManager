//
//  CopyProcess.m
//  XManager
//
//  Created by demo on 19.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CopyProcess.h"

@interface CopyProcess(Private)

-(void) onTimer;

@end

@implementation CopyProcess(Private)

-(void) onTimer {
    if ([self isComplete]) {
        [timer invalidate];
        return;
    }
    
    if (pause == false) {
        progress += 0.1;
    }
}

@end

@implementation CopyProcess

- (id)init {
    
    self = [super init];
    
    if (self) {
        progress= 0.0f;
        timer   = nil;
        pause   = false;
    }
    
    return self;
}

-(void) dealloc {
    [timer invalidate];
    
    [super dealloc];
}

-(void) runProcess {
    progress = 0.0f;
    pause = false;
    
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(onTimer)
                                           userInfo:nil
                                            repeats:YES];
}

-(double) progress {
    return progress;
}

-(bool) isComplete {
    return progress >= 1.0;
}

-(void) stopProcess {
    [timer invalidate];
    timer = nil;
    progress = 0.0;
}

-(void) pauseProcess {
    pause = true;
}

-(void) continueProcess {
    pause = false;
}



@end
