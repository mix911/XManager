//
//  Task.h
//  XManager
//
//  Created by demo on 11.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ItemManagerProtocol;
@class DataSourceAndTableViewDelegate;

typedef enum _ETaskState {
    ETaskStateStop,
    ETaskStatePlay,
    ETaskStatePause
} ETaskState;

@interface Task : NSObject
{
    DataSourceAndTableViewDelegate* src;
    DataSourceAndTableViewDelegate* dst;
    
    NSLock*         sync;
    double          progress;
    NSThread*       thread;
    NSCondition*    condition;
    ETaskState      state;
}

-(id) initWithSrc:(DataSourceAndTableViewDelegate*)s dst:(DataSourceAndTableViewDelegate*)d;

-(void) run;
-(double) progress;
-(void) pause;
-(void) start;

-(bool) isCreated;
-(bool) isComplete;
-(NSString*) errorMessage;

-(ETaskState) state;

@end
