//
//  OutputStream.h
//  XManager
//
//  Created by demo on 04.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OutputStream <NSObject>

-(bool)         isExist:(NSString*)fileName;
-(bool)         create:(NSString*)fileName;
-(BOOL)         hasSpaceAvailable;
-(NSInteger)    write:(uint8_t*)buffer maxLength:(NSUInteger)len;
-(void)         close;

@end
