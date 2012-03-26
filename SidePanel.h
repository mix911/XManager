//
//  SidePanel.h
//  XManager
//
//  Created by demo on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>


@class TableView;
@class MainWindow;
@class TabsHeaders;

@interface SidePanel : NSTabView
{
    int nextTabId;      // Следующая вкладка
    IBOutlet MainWindow*  mainWindow;
    IBOutlet TabsHeaders* tabs;
}

-(id)   init;

-(id) saveSettings;
-(void) loadSettings:(NSDictionary*)settings;


-(bool) enterToRow                  :(NSInteger)row;
-(bool) goUp;
-(void) invertSelection             :(NSInteger)row;
-(void) setActive                   :(NSWindow*)window;
-(TableView*)   table;
-(void) switchToNextTab;
-(void) switchToPrevTab;

@end
