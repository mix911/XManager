//
//  FileSystemOutputStream.m
//  XManager
//
//  Created by demo on 06.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileSystemOutputStream.h"

@implementation FileSystemOutputStream

-(bool) isExist:(NSString *)fileName {
    return true;
}

-(bool) create:(NSString *)fileName {
    return true;
}

-(BOOL) hasSpaceAvailable {
    return YES;
}

-(NSInteger) write:(uint8_t *)buffer maxLength:(NSUInteger)len {
    return 0;
}

-(void) close {
    
}

@end
