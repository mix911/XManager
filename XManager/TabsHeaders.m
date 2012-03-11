//
//  TabsHeaders.m
//  XManager
//
//  Created by demo on 10.03.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TabsHeaders.h"
#import "TabHeader.h"

@implementation TabsHeaders

-(id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) addTab:(NSString*)title
{
    static float last_header_pos = 0.0f;
    
    TabHeader* last_header = (TabHeader*)[[self subviews] lastObject];
    if (last_header) {
        last_header_pos = [last_header frame].origin.x + [last_header frame].size.width;
    }
    
    // Create tab control
    TabHeader* tab = [[TabHeader alloc] initWithTitle:title :NSMakeRect(last_header_pos, 0.0f, 100.0f, [self bounds].size.height)];
    
    [self addSubview:tab];
}

-(void) deleteTab:(NSUInteger)index
{
    
}

-(NSUInteger) currentTab
{
    return 0;
}

@end
