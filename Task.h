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

@interface Task : NSObject
{
    DataSourceAndTableViewDelegate* src;
    DataSourceAndTableViewDelegate* dst;
    
    NSLock* sync;
    double progress;
    NSThread* thread;
}

-(id) initWithSrc:(DataSourceAndTableViewDelegate*)s dst:(DataSourceAndTableViewDelegate*)d;

-(void) run;
-(double) progress;

-(bool) isCreated;
-(bool) isComplete;
-(NSString*) errorMessage;

@end
