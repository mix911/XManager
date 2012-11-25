//
//  Task.m
//  XManager
//
//  Created by demo on 11.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Task.h"
#import "DataSourceAndTableViewDelegate.h"

@implementation Task

-(id) initWithSrc:(DataSourceAndTableViewDelegate*)s dst:(DataSourceAndTableViewDelegate*)d
{
    if (self = [super init]) {
        src = s;
        dst = d;
        
        sync     = [[NSLock alloc] init];
        progress = 0.0;
        thread   = nil;
        condition= [[NSCondition alloc] init];
        state    = ETaskStateStop;
    }
    
    return self;
}

-(void) dealloc
{
    [sync release];
    [condition release];
    
    if (thread) {
        [thread release];
    }
    
    [super dealloc];
}

+(Task*) taskCopyWithSrc:(DataSourceAndTableViewDelegate*)src dst:(DataSourceAndTableViewDelegate*)dst
{
    Task* task = (Task*)[[Task alloc] initWithSrc:src dst:dst];
    
    return [task autorelease];
}

-(void) setProgress:(double)p
{
    progress = p;
}

-(void) worker:(id)obj
{
    for (int i = 0; i < 100; ++i) {
        
        
        [condition lock];
        while (state == ETaskStatePause) {
            [condition wait];
        }
        
        [condition unlock];
        
        [NSThread sleepForTimeInterval:0.09];
        
        [sync lock];
        progress = (double)(i + 1);
        [sync unlock];
    }
}

-(void) run
{
    state = ETaskStatePlay;
    
    thread = [[NSThread alloc] initWithTarget:self
                                     selector:@selector(worker:) 
                                       object:self];
    [thread start];
}

-(double) progress
{
    double res = 0.0;
    
    [sync lock];
    res = progress;
    [sync unlock];
    
    return res;
}

-(void) pause
{
    [condition lock];
    state = ETaskStatePause;
    [condition unlock];
}

-(bool) isCreated
{
    return true;
}

-(bool) isComplete
{
    return !(progress < 99.99999);
}

-(NSString*) errorMessage
{
    return @"Not implemented";
}

-(void) start
{
    [condition lock];
    state = ETaskStatePlay;
    [condition unlock];
    
    [condition signal];
}

-(ETaskState) state
{
    ETaskState res;
    [condition lock];
    res = state;
    [condition unlock];
    return res;
}

@end
