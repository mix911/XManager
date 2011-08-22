//
//  NetworkConnectionPanel.m
//  XManager
//
//  Created by demo on 14.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetworkConnectionDialog.h"

@implementation NetworkConnectionDialog

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(FtpParams*)   ftpParams {
    return [[[FtpParams alloc] init] autorelease];
}

@end
