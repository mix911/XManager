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

@implementation DataSourceAndTableViewDelegate

-(id) initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    return self;
}

-(bool) enterToRow:(NSInteger)row {
    
    if ([itemManager enterToRow:row]) {
        
        data = [itemManager data];
        
        [sidePanel changeFolder:[itemManager currentPath]];
        
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
            return item.size;
            
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
    
    // Если рисуем статус
    if ([self whatColumn:column] == FS_ICON) {
        // Downcast-им  ячейку
        NSImageCell*    icell   = (NSImageCell*)cell;
        
        // Получим очередной item
        FileSystemItem* item = [data objectAtIndex:row];
        
        // Получим иконку для данного item
        NSImage* icon = [itemManager iconForItem:item];
                
        [icell setImage:icon];
    }
}
-(void) tableView:(NSTableView*)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    [itemManager setOrder:[self whatColumn:tableColumn]];
}

-(void) setTable:(NSTableView *)t {
    table = t;
}

-(void) setSidePanelProtocol:(id<SidePanelProtocol>)sp {
    sidePanel = sp;
}

-(NSString*) currentPath {
    return [itemManager currentPath];
}

-(void) setItemManager:(id<ItemManagerProtocol>)im {
    [itemManager release];
    itemManager = im;
    data = [itemManager data];
}

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
