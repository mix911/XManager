//
//  FileSystemInputStream.h
//  XManager
//
//  Created by demo on 21.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InputStream.h"

@interface FileSystemInputStream : NSObject<InputStream>

-(bool)         open:(NSString *)name;
-(void)         close;
-(NSInteger)    read:(uint8_t *)buffer maxLength:(NSUInteger)len;
-(NSInteger)    size;

@end
