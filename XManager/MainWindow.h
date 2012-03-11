//
//  MainWindow.h
//  XManager
//
//  Created by demo on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@class SidePanel;
@class TabsHeaders;

@interface MainWindow : NSWindow 
{    
    IBOutlet SidePanel*      leftPanel;              // Left panel
    IBOutlet SidePanel*      rightPanel;             // Right panel
    IBOutlet TabsHeaders*    leftTabs;               // Tabs headers of left panel
    IBOutlet TabsHeaders*    rightTabs;              // Tabs headers of right panel
    
    SidePanel*      activePanel;            // Active panel
}

-(void) sendEvent:(NSEvent*)theEvent;

-(void) insertTab;
-(void) setActiveSide:(id)panel;
-(void) switchToNextTab;
-(void) switchToPrevTab;

-(void) postKeyDown:(NSEvent *)event;


@end
