//
//  TabHeader.h
//  XManager
//
//  Created by demo on 11.03.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TabHeader : NSView
{
    NSButton* button;
}

-(id) initWithTitle:(NSString*)title :(NSRect)rect;

@end
