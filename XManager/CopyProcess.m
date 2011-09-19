//
//  CopyProcess.m
//  XManager
//
//  Created by demo on 19.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CopyProcess.h"

@interface CopyProcess(Private)

-(bool) isCompleteInner;
+(void) processPlus :(CopyProcess*)this;

@end

@implementation CopyProcess(Private)

-(bool) isCompleteInner {
    return progress >= 1.0 || stop;
}

+(void) processPlus :(CopyProcess*)this {
    [this process];
}

@end

@implementation CopyProcess

- (id)init {
    
    self = [super init];
    
    if (self) {
        progress= 0.0f;
        pause   = false;
        sync    = [[NSLock alloc] init];
    }
    
    return self;
}

-(void) dealloc {
    [timer invalidate];
    [sync release];
    
    [super dealloc];
}

-(void) runProcess {
    progress = 0.0f;
    pause = false;
    
    workerThread = [[NSThread alloc] initWithTarget:[CopyProcess class] selector:@selector(processPlus:) object:self];
    [workerThread start];
}

-(void) process {
    bool endProcess = false;
    
    while (endProcess == false) {
        [sync lock];
        
        [NSThread sleepForTimeInterval:0.1f];
        
        if (pause == false) {
            progress += 0.02;
        }
        
        endProcess = [self isCompleteInner];
        
        [sync unlock];
    }
}

-(double) progress {
    double res = 0.0;
    
    [sync lock];
    
    res = progress;
    
    [sync unlock];
    
    return res;
}

-(bool) isComplete {
    
    bool res = false;
    
    [sync lock];
    
    res = [self isCompleteInner];
    
    [sync unlock];
    
    return res;
}

-(void) stopProcess {
    [sync lock];
    
    progress    = 0.0;
    stop        = true;
    workerThread= nil;
    
    [sync unlock];
}

-(void) pauseProcess {
    
    [sync lock];
    
    pause = true;
    
    [sync unlock];
}

-(void) continueProcess {
    
    [sync lock];
    
    pause = false;
    
    [sync unlock];
}



@end
