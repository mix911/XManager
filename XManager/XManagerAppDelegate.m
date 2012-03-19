//
//  XManagerAppDelegate.m
//  XManager
//
//  Created by demo on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XManagerAppDelegate.h"
#import "MainWindow.h"

@implementation XManagerAppDelegate

@synthesize window;

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{    
}

-(NSApplicationTerminateReply) applicationShouldTerminate:(NSApplication *)sender
{
    [window saveWindowSettings];
    return NSTerminateNow;
}

@end
