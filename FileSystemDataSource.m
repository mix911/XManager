//
//  FileSystemDataSource.m
//  XManager
//
//  Created by demo on 09.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileSystemDataSource.h"

#import "FileSystemItem.h"

@interface FileSystemDataSource(Private)

-(enum EFileSystemColumnId) whatColumn:(NSTableColumn*) column;
-(void)                     sortData;

@end

@implementation FileSystemDataSource

-(id) initWithPath:(NSString *)path {
    self = [super init];
    if (self) {

        order = FS_NAME;
        
        workspace = [NSWorkspace sharedWorkspace];
        
        fileManager = [[NSFileManager alloc] init];
        [fileManager changeCurrentDirectoryPath:path];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        [self openFolder :path];
    }
    return self;
}

-(void) enterToRow:(NSInteger)row {
    if (row >= [data count]) {
        return;
    }
    
    FileSystemItem* item = [data objectAtIndex:row];
    
    NSString* new_path = nil;
    if ([item.name isEqualToString:@".."]) {
        new_path = @"";
        NSArray* components = [[fileManager currentDirectoryPath] pathComponents];
        
        for (NSUInteger i = 0; i < [components count] - 1; ++i) {
            new_path = [NSString stringWithFormat:@"%@/%@", new_path, (NSString*)[components objectAtIndex:i]];
        }
    }
    else {
        new_path = [NSString stringWithFormat:@"%@/%@", [fileManager currentDirectoryPath], item.name];
    }
    
    if (item.isDir) {
        
        [self openFolder:new_path];
        
        [table reloadData];
    }
    else {
        [workspace openFile:new_path];
    }
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
            return item.date;
            
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
        
        // Получим shared workspace
        NSWorkspace* workspace = [NSWorkspace sharedWorkspace];
        
        // Получим иконку для данного item
        NSImage* icon = [workspace iconForFile:[item fullPath]];
                
        [icell setImage:icon];
    }
}

-(void) openFolder:(NSString *)path {
    
    [fileManager changeCurrentDirectoryPath:path];
    
    data = [[NSMutableArray alloc] init];
    
    NSArray* strings = [fileManager contentsOfDirectoryAtPath:path error:nil];
    
    FileSystemItem* item = [[FileSystemItem alloc] init];
    
    [item setFullPath   :path];
    [item setName       :@".."];
    [item setSize       :@"--"];
    [item setDate       :@"Date"];
    [item setType       :@"<Dir>"];
    [item setIsDir      :YES];
    
    [data addObject:item];
    
    for(NSString* string in strings) {
        item = [[FileSystemItem alloc] init];
        
        NSDictionary* attrs = [fileManager attributesOfItemAtPath:string error:nil];
        
        NSString* item_type = [attrs objectForKey:NSFileType];
        
        bool is_dir = [item_type isEqualToString:NSFileTypeDirectory];
        
        NSDate* modification_date = [attrs objectForKey:NSFileModificationDate];
        
        NSString* size = nil;
        NSString* type = nil;
        
        if (is_dir) {
            size = @"--";
            type = @"<Dir>";
        }
        else {
            size = [attrs objectForKey:NSFileSize];
            type = [string pathExtension];
        }
        
        [item setName       :string];
        [item setFullPath   :[NSString stringWithFormat:@"%@/%@", path, string]];
        [item setIsDir      :is_dir];
        [item setSize       :size];
        [item setDate       :[dateFormatter stringFromDate:modification_date]];
        [item setType       :type];
        
        [data addObject:item];
    }
    
    [self sortData];
}

-(void) tableView:(NSTableView*)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    order = [self whatColumn:tableColumn];
    [self sortData];
}

-(void) setTable:(NSTableView *)t {
    table = t;
}

@end

@implementation FileSystemDataSource(Private)

-(enum EFileSystemColumnId) whatColumn:(NSTableColumn *)column {
    NSString* column_name = [[column headerCell] stringValue];
    
    // Получим идентификатор колонки TODO: переделать на идентификатор колонки
    NSString* col_id = [column identifier];
    
    if([column_name isEqualToString:@""])
        return FS_ICON;
    else if([column_name isEqualToString:@"Name"])
        return FS_NAME;
    else if([column_name isEqualToString:@"Size"])
        return FS_SIZE;
    else if([column_name isEqualToString:@"Date"])
        return FS_DATE;
    else if([column_name isEqualToString:@"Type"])
        return FS_TYPE;
    return FS_UNDEFINED;
}

-(void) sortData {
    switch (order) {
        case FS_ICON:
            break;
            
        case FS_NAME:
            [data sortUsingSelector:@selector(compareByName:)];
            break;
            
        case FS_SIZE:
            [data sortUsingSelector:@selector(compareBySize:)];
            break;
            
        case FS_DATE:
            [data sortUsingSelector:@selector(compareByDate:)];
            break;
            
        case FS_TYPE:
            [data sortUsingSelector:@selector(compareByType:)];
            break;
            
        default:
            break;
    }
    
    [table reloadData];

}

@end
