//
//  FileManager.h
//  XManager
//
//  Created by demo on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "SidePanel.h"

@class TabsHeaders;

//+-----------------------------------------------------------------+
//| Управление главным окном, окном настроек и прочих диалогов      |
//+-----------------------------------------------------------------+
@interface WindowManager : NSObject 
{
    IBOutlet    SidePanel*      leftPanel;              // Left panel
    IBOutlet    SidePanel*      rightPanel;             // Right panel
                SidePanel*      activePanel;            // Active panel
    IBOutlet    NSWindow*       mainWindow;             // MainWindow
    IBOutlet    TabsHeaders*    leftTabs;               // Tabs headers of left panel
    IBOutlet    TabsHeaders*    rightTabs;              // Tabs headers of right panel
}

-(void) awakeFromNib;

-(bool) loadLastSesstion;

-(SidePanel*) activePanel;

-(void) insertTab;
-(void) setActiveSide:(id)panel;
-(void) switchToNextTab;
-(void) switchToPrevTab;

-(void) postKeyDown:(NSEvent *)event;

@end
