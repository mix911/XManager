//
//  FileSystemDataSource.h
//  XManager
//
//  Created by demo on 09.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SidePanelProtocol.h"
#import "FileSystemManager.h"
#import "FtpManager.h"

//+-----------------------------------------------------------------+
//| Источник данных и делегат таблицы                               |
//+-----------------------------------------------------------------+
@interface FileSystemDataSource : NSObject <NSTableViewDataSource, NSTableViewDelegate> {
    
    FileSystemManager*      fileSystemManager;
    FtpManager*             ftpManager;
    
    
    NSFileManager*              fileManager;    // Управление файлами
    NSDateFormatter*            dateFormatter;  // Форматирование даты
    NSMutableArray*             data;           // Данные
    NSTableView*                table;          // Таблица
    NSWorkspace*                workspace;      // Workspace
    NSInteger                   order;          // Порядок файлов
    id<SidePanelProtocol>       sidePanel;      // Панель содержащая таблицу
}

-(id)           initWithPath:(NSString*)path;

// Data source
-(NSInteger)    numberOfRowsInTableView:(NSTableView *)tableView;
-(id)           tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
-(void)         enterToRow:(NSInteger)row;
-(void)         goUp;

// Delegate
-(void) tableView:(NSTableView*)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
-(void) tableView:(NSTableView*)tableView didClickTableColumn:(NSTableColumn *)tableColumn;

// FileSystemDataSource
-(void)     openFolder:(NSString*)path;
-(void)     setTable:(NSTableView*)table;
-(void)     setSidePanelProtocol:(id<SidePanelProtocol>)sidePanel;
-(NSString*)currentPath;

@end
