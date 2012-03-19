//
//  ConfigManager.h
//  XManager
//
//  Created by demo on 18.03.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigManager : NSObject

+(void) load;
+(void) save;
+(void) clear;
+(id)   getValue:(NSString*)name;
+(void) setValue:(NSString*)name:(id)value;

@end
