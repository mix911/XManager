//
//  XManagerAppDelegate.h
//  XManager
//
//  Created by demo on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FileManager.h"

@interface XManagerAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    IBOutlet FileManager* fileManager;
}

@property (assign) IBOutlet NSWindow *window;

@end
