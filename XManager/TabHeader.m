//
//  TabHeader.m
//  XManager
//
//  Created by demo on 11.03.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TabHeader.h"
#import "TabsHeaders.h"

@implementation TabHeader

-(void) push:(id)event
{
    [parent push:self];
}

-(id) initWithTitle:(NSString *)title :(NSRect)frame :(TabsHeaders*)par
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
        
        [button setBezelStyle:NSRoundedBezelStyle];
        [button setButtonType:NSOnOffButton];
        
        parent = par;
        
        [button setTarget:self];
        [button setAction:@selector(push:)];
    }
    
    return self;
}

-(void) setState:(NSUInteger)state
{
    [button setState:state];
}

-(NSUInteger) state
{
    return [button state];
}

-(void) setTitle:(NSString *)title
{
    [button setTitle:title];
}

@end
