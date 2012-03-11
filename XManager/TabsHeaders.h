//
//  TabsHeaders.h
//  XManager
//
//  Created by demo on 10.03.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TabsHeaders : NSView
{
    NSMutableArray* tabs;
}

-(void) addTab:(NSString*)title;
-(void) deleteTab:(NSUInteger)index;

-(void) selectTab:(NSUInteger)index;
-(NSUInteger) currentTab;

-(NSUInteger) countOfTabs;


@end
