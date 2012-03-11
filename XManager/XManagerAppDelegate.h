//
//  XManagerAppDelegate.h
//  XManager
//
//  Created by demo on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


//////////////////////////////////////////////////////////////////////////////////
// Application delegate
//////////////////////////////////////////////////////////////////////////////////
@interface XManagerAppDelegate : NSObject <NSApplicationDelegate> 
{
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
