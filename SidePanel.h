//
//  SidePanel.h
//  XManager
//
//  Created by demo on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

#import "FileSystemItem.h"


@class TableView;
@class MainWindow;
@class TabsHeaders;

@interface SidePanel : NSTabView
{
    int nextTabId;      // Следующая вкладка
    IBOutlet MainWindow*  mainWindow;
    IBOutlet TabsHeaders* tabs;
    enum EFileSystemColumnId order;
}

-(id)   init;
-(void) addTab :(NSString*)path;
-(void) addTab;
-(int)  nextTabId;
-(void) updateContent;
-(NSString*)    currentPath;

-(id) saveSettings;
-(void) loadSettings:(NSDictionary*)settings;


// SidePanelProtocol
-(bool) changeFolder                :(NSString *)folder;
-(bool) enterToRow                  :(NSInteger)row;
-(bool) goUp;
-(void) closeCurrentTab;
-(void) invertSelection             :(NSInteger)row;
-(void) setActive                   :(NSWindow*)window;
-(TableView*)   table;
-(void) switchToNextTab;
-(void) switchToPrevTab;
-(bool) selectedItems               :(NSMutableArray*)selected;
-(void) updateTable;


@end
