//
//  FtpDataSource.m
//  XManager
//
//  Created by demo on 15.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FtpDataSource.h"

@implementation FtpDataSource

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
    return 4;
}

-(id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return @"Hello";
}

-(void) enterToRow:(NSInteger)row {
    
}

-(void) goUp {
    
}

@end
