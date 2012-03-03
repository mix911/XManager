//
//  FileSystemInputStream.m
//  XManager
//
//  Created by demo on 21.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileSystemInputStream.h"

@implementation FileSystemInputStream

-(bool) open:(NSString *)name {
    return true;
}

-(void) close {
    
}

-(NSInteger) read:(uint8_t *)buffer maxLength:(NSUInteger)len {
    return 0;
}

-(NSInteger) size {
    return 0;
}

@end
