//
//  FileSystemDataSource.h
//  XManager
//
//  Created by demo on 09.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ItemManagerProtocol.h"

//+-----------------------------------------------------------------+
//| Источник данных и делегат таблицы                               |
//+-----------------------------------------------------------------+
@interface DataSourceAndTableViewDelegate : NSObject <NSTableViewDataSource, NSTableViewDelegate> {
    
    id<ItemManagerProtocol>     itemManager;    // Менеджер управления объектами
    NSDateFormatter*            dateFormatter;  // Форматирование даты
    NSMutableArray*             data;           // Данные
}

-(id)           initWithPath:(NSString*)path;

-(bool)         enterToRow:(NSUInteger)row;
-(bool)         goUp;

// FileSystemDataSource
-(NSString*)currentPath;
-(bool)     changeFolder    :(NSString*)folder;
-(void)     setItemManager  :(id<ItemManagerProtocol>)itemManager;
-(void)     invertSelection :(NSInteger)row;
-(void)     updateItemsList;
-(void)     selectedItems   :(NSMutableArray*)selected :(NSInteger)current;

@end
