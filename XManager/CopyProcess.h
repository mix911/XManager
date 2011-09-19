//
//  CopyProcess.h
//  XManager
//
//  Created by demo on 19.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Process.h"

@interface CopyProcess : NSObject<Process> {
    float       progress;
    NSTimer*    timer;
    bool        pause;
}

-(id)       init;
-(void)     dealloc;

// Process protocol
-(double)   progress;
-(bool)     isComplete;
-(void)     stopProcess;
-(void)     pauseProcess;
-(void)     continueProcess;
-(void)     runProcess;

@end
