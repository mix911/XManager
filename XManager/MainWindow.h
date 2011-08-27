//
//  MainWindow.h
//  XManager
//
//  Created by demo on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

#import "WindowManager.h"

@interface MainWindow : NSWindow {
    IBOutlet    WindowManager*  windowManager;
}

-(void) sendEvent:(NSEvent *)theEvent;

@end
