//
//  SidePanel.h
//  XManager
//
//  Created by demo on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

#import "SidePanelProtocol.h"
#import "WindowManagerProtocol.h"

@interface SidePanel : NSView <SidePanelProtocol> {
    NSTabView*                  tabView;        // Вкладки
    int                         nextTabId;      // Следующая вкладка
    id<WindowManagerProtocol>   windowManager;  // Менеджер окон
}

-(id)   init;
-(void) dealloc;
-(void) addTab :(NSString*)path;
-(void) addTabFromCurrent;
-(int)  nextTabId;
-(void) setWindowManager:(id<WindowManagerProtocol>)manager;
-(void) updateContent;
-(NSString*)    currentPath;

// Item operations
-(NSString*)    makeDir             :(NSString*)name;
-(NSString*)    deleteSelected;
-(NSString*)    renameCurrent       :(NSString*)name;
-(NSString*)    copySelected        :(NSArray*)selected :(NSString*)dest;
-(NSString*)    moveSelected        :(NSString*)dest;

// SidePanelProtocol
-(bool) changeFolder                :(NSString *)folder;
-(void) setTabHeaderTitle           :(NSString*)folder;
-(bool) enterToRow                  :(NSInteger)row;
-(bool) goUp;
-(void) addTabFromCurrent;
-(void) closeCurrentTab;
-(void) invertSelection             :(NSInteger)row;
-(void) postKeyDown                 :(NSEvent*)event;
-(void) setActive                   :(NSWindow*)window;
-(NSView*)   table;
-(void) switchToNextTab;
-(void) switchToPrevTab;
-(bool) selectedItems               :(NSMutableArray*)selected;
-(void) determineDirectorySize      :(NSInteger)row;
-(void) updateTable;

@end
