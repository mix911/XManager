//
//  XManagerAppDelegate.h
//  XManager
//
//  Created by demo on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindow;

//////////////////////////////////////////////////////////////////////////////////
// Application delegate
//////////////////////////////////////////////////////////////////////////////////
@interface XManagerAppDelegate : NSObject <NSApplicationDelegate> 
{
    IBOutlet MainWindow* window;
}

@property (assign) IBOutlet MainWindow *window;

@end
