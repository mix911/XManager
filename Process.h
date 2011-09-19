//
//  Process.h
//  XManager
//
//  Created by demo on 19.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Process <NSObject>

-(float)    progress;
-(bool)     isComplete;
-(void)     stopProcess;
-(void)     pauseProcess;
-(void)     continueProcess;

@end
