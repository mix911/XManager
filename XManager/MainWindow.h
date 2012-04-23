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
@class CopyMoveDialog;
@class MakeDirDialog;

@interface MainWindow : NSWindow 
{    
    IBOutlet SidePanel*      leftPanel;     // Left panel
    IBOutlet SidePanel*      rightPanel;    // Right panel
    IBOutlet TabsHeaders*    leftTabs;      // Tabs headers of left panel
    IBOutlet TabsHeaders*    rightTabs;     // Tabs headers of right panel
    IBOutlet CopyMoveDialog* copyMoveDialog;// Copy or move suggestion dialog
    IBOutlet MakeDirDialog*  makeDirDialog; // Make director suggestion dialog
    
    SidePanel*      activePanel;            // Active panel
}

-(void) sendEvent:(NSEvent*)theEvent;

-(void) insertTab;
-(void) setActiveSide:(id)panel;
-(void) switchToNextTab;
-(void) switchToPrevTab;

-(void) postKeyDown:(NSEvent *)event;

-(void) saveWindowSettings;

-(IBAction) pressCommandButton:(id)sender;

@end
