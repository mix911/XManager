//
//  FileSystemDataSource.h
//  XManager
//
//  Created by demo on 09.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SidePanelProtocol.h"
#import "ItemManagerProtocol.h"

//+-----------------------------------------------------------------+
//| Источник данных и делегат таблицы                               |
//+-----------------------------------------------------------------+
@interface DataSourceAndTableViewDelegate : NSObject <NSTableViewDataSource, NSTableViewDelegate> {
    
    id<ItemManagerProtocol>     itemManager;    // Менеджер управления объектами
    NSDateFormatter*            dateFormatter;  // Форматирование даты
    NSMutableArray*             data;           // Данные
    id<SidePanelProtocol>       sidePanel;      // Панель содержащая таблицу
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

// Items operations
-(NSString*)    makeDir        :(NSString*)name;
-(NSString*)    deleteSelected;
-(NSString*)    renameCurrent  :(NSString*)name :(NSInteger)row;
-(NSString*)    copySelected   :(NSString*)dest;
-(NSString*)    moveSelected   :(NSString*)dest;
-(void)         runDetermineDirectorySize:(NSUInteger)row;
+(void)         determineDirectorySize:(id)row;

// Delegate
-(void) tableView:(NSTableView*)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
-(void) tableView:(NSTableView*)tableView didClickTableColumn:(NSTableColumn *)tableColumn;

// FileSystemDataSource
-(void)     setSidePanelProtocol:(id<SidePanelProtocol>)sidePanel;
-(NSString*)currentPath;
-(bool)     changeFolder    :(NSString*)folder;
-(void)     setItemManager  :(id<ItemManagerProtocol>)itemManager;
-(void)     invertSelection :(NSInteger)row;
-(void)     updateItemsList;
-(void)     selectedItems   :(NSMutableArray*)selected;

@end
