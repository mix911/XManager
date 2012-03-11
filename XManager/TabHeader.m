//
//  TabHeader.m
//  XManager
//
//  Created by demo on 11.03.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TabHeader.h"

@implementation TabHeader

-(id) initWithTitle:(NSString *)title :(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        button = [[NSButton alloc] initWithFrame:[self bounds]];
        [button setTitle:title];
        
        [self addSubview:button];
        [self setAutoresizesSubviews:YES];
        [button setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        
        [button setHidden:NO];
        [self setHidden:NO];
    }
    
    return self;
}

@end
