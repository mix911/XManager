//
//  SidePanel.h
//  XManager
//
//  Created by demo on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>


@class TableView;
@class WindowManager;

@interface SidePanel : NSTabView
{
//    NSTabView*      tabView;        // Вкладки
    int             nextTabId;      // Следующая вкладка
    WindowManager*  windowManager;  // Менеджер окон
}

-(id)   init;
-(void) dealloc;
-(void) addTab :(NSString*)path;
-(void) addTabFromCurrent;
-(int)  nextTabId;
-(void) setWindowManager:(WindowManager*)manager;
-(void) updateContent;
-(NSString*)    currentPath;

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
-(TableView*)   table;
-(void) switchToNextTab;
-(void) switchToPrevTab;
-(bool) selectedItems               :(NSMutableArray*)selected;
-(void) updateTable;

@end
