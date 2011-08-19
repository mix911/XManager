//
//  MakeDirDialog.m
//  XManager
//
//  Created by demo on 19.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MakeDirDialog.h"

@implementation MakeDirDialog

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(NSString*)    dirName {
    return [folder stringValue];
}

@end
