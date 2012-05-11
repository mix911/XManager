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
    }
    
    return self;
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

-(void) worker:(id)this
{
    for (int i = 0; i < 100; ++i) {

        [NSThread sleepForTimeInterval:0.03];
        
        [sync lock];
        progress = (double)(i + 1);
        [sync unlock];
    }
}

-(void) run
{
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

@end
