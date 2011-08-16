//
//  FtpParams.h
//  XManager
//
//  Created by demo on 15.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FtpParams : NSObject {
    unsigned short  port;
    NSString*       host;
    NSString*       login;
    NSString*       password;
}

@property           unsigned short  port;
@property(retain)   NSString*       host;
@property(retain)   NSString*       login;
@property(retain)   NSString*       password;

@end
