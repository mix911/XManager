//
//  TabsHeaders.m
//  XManager
//
//  Created by demo on 10.03.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TabsHeaders.h"
#import "TabHeader.h"

const NSUInteger gMaximumCountOfTabs = 8;

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
    if ([[self subviews] count] >= gMaximumCountOfTabs) {
        return;
    }
    
    float width = [self frame].size.width / gMaximumCountOfTabs;
    float last_header_pos = 0.0f;
    
    TabHeader* last_header = (TabHeader*)[[self subviews] lastObject];
    if (last_header) {
        last_header_pos = [last_header frame].origin.x + [last_header frame].size.width;
    }
    
    // Create tab control
    TabHeader* tab = [[TabHeader alloc] initWithTitle:title :NSMakeRect(last_header_pos, 0.0f, width, [self bounds].size.height)];
    //NSButton* tab = [[NSButton alloc] initWithFrame:NSMakeRect(last_header_pos, 0.0f, width, [self bounds].size.height)];
    
    [tab setAutoresizingMask:NSViewWidthSizable | NSViewMinXMargin | NSViewMaxXMargin];
    
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
