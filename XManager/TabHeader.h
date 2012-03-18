//
//  TabHeader.h
//  XManager
//
//  Created by demo on 11.03.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TabsHeaders;

@interface TabHeader : NSView
{
    NSButton* button;
    TabsHeaders* parent;
}

-(id) initWithTitle:(NSString*)title :(NSRect)rect :(TabsHeaders*)parent;
-(void) setTitle:(NSString*)title;

-(void) setState:(NSUInteger)state;
-(NSUInteger) state;

@end
