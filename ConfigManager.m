//
//  ConfigManager.m
//  XManager
//
//  Created by demo on 18.03.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfigManager.h"

NSMutableDictionary* dict = nil;

@implementation ConfigManager

+(void) load
{
    if (dict) {
        return;
    }
    
    NSString*               error_desc  = nil;
    NSPropertyListFormat    format      = 0;
    NSString*               plist_file  = @"/Users/demo/Documents/XManager/config.plist";
    
    // Create propertes list data
    NSData* plist_data = [[NSFileManager defaultManager] contentsAtPath:plist_file];
    
    // Create propertes dictionary
    dict = (NSMutableDictionary*)[NSPropertyListSerialization propertyListFromData:plist_data 
                                                                  mutabilityOption:NSPropertyListMutableContainersAndLeaves 
                                                                            format:&format 
                                                                  errorDescription:&error_desc];

}

+(void) save
{
    [dict writeToFile:@"/Users/demo/Documents/XManager/config.plist" atomically:NO];
}

+(void) clear
{
    if (dict) {
        [dict release];
        dict = nil;
    }
}

+(id) getValue:(NSString*)name
{
    return [dict objectForKey:name];
}

+(void) setValue:(NSString *)name :(id)value
{
    [dict setObject:value forKey:name];
}

@end
