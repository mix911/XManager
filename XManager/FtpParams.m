//
//  FtpParams.m
//  XManager
//
//  Created by demo on 15.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FtpParams.h"

@implementation FtpParams

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@synthesize port;
@synthesize host;
@synthesize login;
@synthesize password;

@end
