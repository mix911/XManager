//
//  Stack.m
//  XManager
//
//  Created by demo on 21.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Stack.h"

@implementation Stack

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(bool) isEmpty {
    return [array count] == 0;
}

-(void) push:(id)obj {
    [array addObject:obj];
}

-(void) pushArray:(NSArray *)a {
    [array addObjectsFromArray:a];
}

-(id) pop {
    id res = [array lastObject];
    [array removeLastObject];
    return res;
}

@end
