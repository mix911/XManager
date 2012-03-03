//
//  InputStream.h
//  XManager
//
//  Created by demo on 04.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InputStream <NSObject>

-(bool)         open:(NSString*)name;
-(void)         close;
-(NSInteger)    read:(uint8_t*)buffer maxLength:(NSUInteger)len;
-(NSInteger)    size;

@end
