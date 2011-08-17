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
}

-(id)           initWithPath:(NSString*)path;

// Data source
-(NSInteger)    numberOfRowsInTableView:(NSTableView *)tableView;
-(id)           tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
-(bool)         enterToRow:(NSInteger)row;
-(bool)         goUp;

// Delegate
-(void) tableView:(NSTableView*)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
-(void) tableView:(NSTableView*)tableView didClickTableColumn:(NSTableColumn *)tableColumn;

// FileSystemDataSource
-(void)     setSidePanelProtocol:(id<SidePanelProtocol>)sidePanel;
-(NSString*)currentPath;

-(void)     setItemManager  :(id<ItemManagerProtocol>)itemManager;

@end
