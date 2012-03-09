//
//  FileSystemDataSource.h
//  XManager
//
//  Created by demo on 09.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ItemManagerProtocol.h"

@class SidePanel;

//+-----------------------------------------------------------------+
//| Источник данных и делегат таблицы                               |
//+-----------------------------------------------------------------+
@interface DataSourceAndTableViewDelegate : NSObject <NSTableViewDataSource, NSTableViewDelegate> {
    
    id<ItemManagerProtocol>     itemManager;    // Менеджер управления объектами
    NSDateFormatter*            dateFormatter;  // Форматирование даты
    NSMutableArray*             data;           // Данные
    SidePanel*                  sidePanel;      // Панель содержащая таблицу
    NSLock*                     sync;           // Синхронизация данных
    NSMutableDictionary*        tasks;          // Задачи
}

-(id)           initWithPath:(NSString*)path;
-(void)         dealloc;

// Data source
-(NSInteger)    numberOfRowsInTableView:(NSTableView *)tableView;
-(id)           tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
-(bool)         enterToRow:(NSUInteger)row;
-(bool)         goUp;

// Delegate
-(void) tableView:(NSTableView*)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
-(void) tableView:(NSTableView*)tableView didClickTableColumn:(NSTableColumn *)tableColumn;

// FileSystemDataSource
-(void)     setSidePanelProtocol:(SidePanel*)sidePanel;
-(NSString*)currentPath;
-(bool)     changeFolder    :(NSString*)folder;
-(void)     setItemManager  :(id<ItemManagerProtocol>)itemManager;
-(void)     invertSelection :(NSInteger)row;
-(void)     updateItemsList;
-(void)     selectedItems   :(NSMutableArray*)selected :(NSInteger)current;

@end
