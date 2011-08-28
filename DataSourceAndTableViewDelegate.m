//
//  FileSystemDataSource.m
//  XManager
//
//  Created by demo on 09.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataSourceAndTableViewDelegate.h"

#import "FileSystemItem.h"

//+-----------------------------------------------------------------+
//| Идентификатор колонок                                           |
//+-----------------------------------------------------------------+
@interface DataSourceAndTableViewDelegate(Private) 

-(enum EFileSystemColumnId) whatColumn:(NSTableColumn*) column;

@end

@implementation DataSourceAndTableViewDelegate(Private)

-(enum EFileSystemColumnId) whatColumn:(NSTableColumn *)column {
    
    // Получим идентификатор колонки TODO: переделать на идентификатор колонки
    NSString* col_id = [column identifier];
    
    if ([col_id hasPrefix:@"Icon"])
        return FS_ICON;
    if ([col_id hasPrefix:@"Name"])
        return FS_NAME;
    if ([col_id hasPrefix:@"Size"])
        return FS_SIZE;
    if ([col_id hasPrefix:@"Date"])
        return FS_DATE;
    if ([col_id hasPrefix:@"Type"])
        return FS_TYPE;
    return FS_UNDEFINED;
}

@end

@implementation DataSourceAndTableViewDelegate

-(id) initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    return self;
}

-(void) dealloc {
    [itemManager release];
}

-(bool) enterToRow:(NSInteger)row {
    
    if ([itemManager enterToRow:row]) {
        
        data = [itemManager data];
        
        [sidePanel setTabHeaderTitle:[[itemManager currentPath] lastPathComponent]];
        
        return true;
    }
    
    return false;
}

-(bool) goUp {
    FileSystemItem* item = [data objectAtIndex:0];
    if ([item.name isEqualToString:@".."]) {
        return [self enterToRow:0];
    }
    return false;
}

-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
    return [data count];
}

-(id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

    // Проверки
    if ([data count] <= row) {
        return nil;
    }
    
    // Получим очередной item
    FileSystemItem* item = [data objectAtIndex:row];
    
    switch ([self whatColumn:tableColumn]) {
        
        case FS_ICON:
            return nil;
        
        case FS_NAME:
            return item.name;
        
        case FS_SIZE:
            return item.size == -1 ? @"--" : [[NSNumber numberWithInteger:item.size] stringValue];
            
        case FS_DATE:
            return  [dateFormatter stringFromDate:item.date];
            
        case FS_TYPE:
            return item.type;
            
        default:
            break;
    }
    
    return @"error";
}

-(void) tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)column row:(NSInteger)row {
    
    // Проверки
    if (row >= [data count]) {
        return;
    }
    
    // Получим очередной item
    FileSystemItem* item = [data objectAtIndex:row];
    
    // Если рисуем статус
    if ([self whatColumn:column] == FS_ICON) {
        // Downcast-им  ячейку
        NSImageCell*    icell   = (NSImageCell*)cell;
                
        // Получим иконку для данного item
        NSImage* icon = [itemManager iconForItem:item];
                
        [icell setImage:icon];
    }
    else {
        if ([cell isHighlighted]) {
            [cell setTextColor:[NSColor blackColor]];
        }
        else {
            if (item.isSelected) {
                [cell setTextColor:[NSColor redColor]];
            }
            else {
                [cell setTextColor:[NSColor blackColor]];
            }
        }
    }
}

-(void) tableView:(NSTableView*)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    [itemManager setOrder:[self whatColumn:tableColumn]];
    [tableView reloadData];
}

-(void) setSidePanelProtocol:(id<SidePanelProtocol>)sp {
    sidePanel = sp;
}

-(NSString*) currentPath {
    return [itemManager currentPath];
}

-(void) setItemManager:(id<ItemManagerProtocol>)im {
    [itemManager release];
    itemManager = [im retain];
    data = [itemManager data];
}

-(void) invertSelection:(NSInteger)row {
    
    // Проверки
    if (row >= [data count]) {
        return;
    }
    
    // Получим item
    FileSystemItem* item = [data objectAtIndex:row];
    
    item.isSelected = !item.isSelected;
}

-(NSString*) makeDir:(NSString *)name {
    return [itemManager makeDir:name];
}

-(NSString*) deleteSelected {
    return [itemManager deleteSelected];
}

-(NSString*) renameCurrent:(NSString *)name :(NSInteger)row{
    return [itemManager renameCurrent:name :row];
}

-(NSString*) copySelected:(NSString *)dest {
    return [itemManager copySelected:dest];
}

-(NSString*) moveSelected:(NSString *)dest {
    return [itemManager moveSelected:dest];
}

-(void) determineDirectorySize:(NSUInteger)row {
    // Проверки
    if (row >= [data count]) {
        return;
    }
    // Получим объект файловой системы
    FileSystemItem* item = [data objectAtIndex:row];
    
    // Получим путь
    NSString* path = [NSString stringWithFormat:@"%@/%@", [itemManager currentPath], item.name];
    
    // Запросим размер директории
    item.size = [itemManager determineDirectorySize:path];
}

-(void) updateItemsList {
    data = nil;
    [itemManager updateItemsList];
    data = [itemManager data];
}

-(bool) changeFolder:(NSString *)folder {
    return [itemManager changeFolder:folder];
}

-(void) selectedItems:(NSMutableArray *)selected {

    // Отчистим входящий массив
    [selected removeAllObjects];
    
    // Пройдемся по всем объектам файловой системы (кроме '..')
    for (int i = 1; i < [data count]; ++i) {
        
        // Получим очередной объект
        FileSystemItem* item = [data objectAtIndex:i];
        
        if (item.isSelected) {
            [selected addObject:[NSNumber numberWithInt:i]];
        }
    }
}

@end
