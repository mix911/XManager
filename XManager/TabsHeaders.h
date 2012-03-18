//
//  TabsHeaders.h
//  XManager
//
//  Created by demo on 10.03.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TabHeader;
@class SidePanel;

@interface TabsHeaders : NSView
{
    IBOutlet SidePanel* panel;
}

-(void) addTab:(NSString*)title;
-(void) deleteTab:(NSUInteger)index;

-(void) selectTab:(NSUInteger)index;
-(NSUInteger) currentTab;

-(NSUInteger) countOfTabs;

-(void) setTitle:(NSUInteger)index :(NSString*)title;

// TODO: must be more clear
-(void) push:(TabHeader*)tab;

@end
