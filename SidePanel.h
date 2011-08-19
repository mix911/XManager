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

// Item operations
-(NSString*)    makeDir         :(NSString*)name;
-(NSString*)    deleteSelected;

// SidePanelProtocol
-(void) changeFolder    :(NSString *)folder;
-(bool) enterToRow      :(NSInteger)row;
-(bool) goUp;
-(void) addTabFromCurrent;
-(void) closeCurrentTab;
-(void) invertSelection :(NSInteger)row;
-(void) postKeyDown     :(NSEvent*)event;
-(void) setActive;


@end
