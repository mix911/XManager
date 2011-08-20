//
//  RenameDialog.m
//  XManager
//
//  Created by demo on 20.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RenameDialog.h"

@implementation RenameDialog

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(NSString*) dirName {
    return [folder stringValue];
}

@end
