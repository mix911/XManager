//
//  FileSystemItem.m
//  XManager
//
//  Created by demo on 10.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileSystemItem.h"

@implementation FileSystemItem

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@synthesize fullPath;
@synthesize name;
@synthesize size;
@synthesize date;
@synthesize type;
@synthesize isDir;

@end
