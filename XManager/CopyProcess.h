//
//  CopyProcess.h
//  XManager
//
//  Created by demo on 19.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Process.h"

@protocol InputStream;
@protocol OutputStream;

@interface CopyProcess : NSObject<Process> {
    float       progress;
    bool        pause;
    bool        stop;
    NSLock*     sync;
    NSThread*   workerThread;
    
    NSUInteger  fullSize;
    NSUInteger  done;
    NSArray*    selected;
    NSFileManager* fileManager;
    id<InputStream>     inputStream;
    id<OutputStream>    outputStream;
    NSString*           srcPath;
    NSString*           dstPath;
    bool                isComplete;
}

-(id)       init;
-(void)     dealloc;

// Process protocol
-(double)   progress;
-(bool)     isComplete;
-(void)     stopProcess;
-(void)     pauseProcess;
-(void)     continueProcess;
-(void)     runProcess:(NSArray*)selected;

@end
