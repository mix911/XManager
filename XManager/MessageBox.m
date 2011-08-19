//
//  MessageBox.m
//  XManager
//
//  Created by demo on 19.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageBox.h"

@implementation MessageBox

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) setMessage:(NSString *)m {
    [message setStringValue:m];
}

@end
