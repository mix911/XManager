//
//  TabsHeaders.m
//  XManager
//
//  Created by demo on 10.03.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TabsHeaders.h"
#import "TabHeader.h"
#import "SidePanel.h"

static const NSUInteger gMaximumCountOfTabs = 4;

@implementation TabsHeaders

-(void) push:(TabHeader*)tab
{
    NSArray* subviews = [self subviews];
    
    for (NSUInteger i = 0; i < [subviews count]; ++i) {
        if ((TabHeader*)[subviews objectAtIndex:i] != tab) {
            [[subviews objectAtIndex:i] setState:NSOnState];
        }
        else {
            [[subviews objectAtIndex:i] setState:NSOffState];
            [panel selectTabViewItemAtIndex:i];
        }
    }
}

-(void) addTab:(NSString*)title
{
    if (tabs == nil) {
        tabs = [[NSMutableArray alloc] init];
    }
    
    NSArray* subviews = [self subviews];
    
    if ([subviews count] >= gMaximumCountOfTabs) {
        return;
    }
    
    float width = [self frame].size.width / gMaximumCountOfTabs;
    float last_header_pos = 0.0f;
    
    TabHeader* last_header = (TabHeader*)[subviews lastObject];
    if (last_header) {
        last_header_pos = [last_header frame].origin.x + [last_header frame].size.width;
    }
    
    // Create tab control
    TabHeader* tab = [[TabHeader alloc] initWithTitle:title 
                                                     :NSMakeRect(last_header_pos, 0.0f, width, [self bounds].size.height) 
                                                     :self];
    
    [tab setAutoresizingMask:NSViewWidthSizable | NSViewMinXMargin | NSViewMaxXMargin];
    
    [self addSubview:tab];
    [tab release];
    
    [tabs addObject:title];
}

-(void) selectTab:(NSUInteger)index
{
    NSArray* subviews = [self subviews];
    
    if (index >= [subviews count]) {
        return;
    }
    
    for (TabHeader* tab in subviews) {
        [tab setState:NSOnState];
    }
    
    [(TabHeader*)[subviews objectAtIndex:index] setState:NSOffState];
}

-(void) deleteCurrentTab
{
    NSUInteger i = [self currentTab];
    
    NSArray* subviews = [[self subviews] copy];
    for (TabHeader* tab in subviews) {
        [tab removeFromSuperview];
    }
    [subviews release];
    
    [tabs removeObjectAtIndex:i];
    NSMutableArray* tabs_copy = [tabs copy];
    [tabs removeAllObjects];
    
    for (NSString* title in tabs_copy) {
        [self addTab:title];
    }
    [tabs_copy release];
}

-(NSUInteger) currentTab
{
    NSArray* subviews = [self subviews];
    
    for (NSUInteger i = 0; i < [subviews count]; ++i) {
        if ([(TabHeader*)[subviews objectAtIndex:i] state] == NSOffState) {
            return i;
        }
    }
    return 0;
}

-(NSUInteger) countOfTabs
{
    return [[self subviews] count];
}

-(void) setTitle:(NSUInteger)index :(NSString *)title
{
    NSArray* subview = [self subviews];
    
    if (index >= [subview count]) {
        return;
    }
    
    [(TabHeader*)[subview objectAtIndex:index] setTitle:title];
    [tabs replaceObjectAtIndex:index withObject:title];
}

@end
