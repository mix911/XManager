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
    
    NSString* new_path          = nil;
    NSString* current_path      = [fileManager currentDirectoryPath];
    NSString* application_dir   = @"/Applications";
    
    if ([item.name isEqualToString:@".."]) {
        
        if ([current_path isEqualToString:@"/"]) {
            return;
        }
        
        new_path = @"";
        NSArray* components = [[fileManager currentDirectoryPath] pathComponents];
        
        for (NSUInteger i = 0; i < [components count] - 1; ++i) {
            new_path = [NSString stringWithFormat:@"%@/%@", new_path, (NSString*)[components objectAtIndex:i]];
        }
    }
    else {
        new_path = [NSString stringWithFormat:@"%@/%@", [fileManager currentDirectoryPath], item.name];
    }
    
    if (item.isDir && (![current_path isEqualToString:application_dir] || [item.name isEqualToString:@".."])) {
        
        [self openFolder:new_path];
        
        [table reloadData];
    }
    else {
        [workspace openFile:new_path];
    }
}

-(void) goUp {
    FileSystemItem* item = [data objectAtIndex:0];
    if ([item.name isEqualToString:@".."]) {
        [self enterToRow:0];
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
        
        // Получим иконку для данного item
        NSImage* icon = [workspace iconForFile:[item fullPath]];
                
        [icell setImage:icon];
    }
}

-(void) openFolder:(NSString *)path {
    
    NSString* old_path = [fileManager currentDirectoryPath];
    
    if ([fileManager changeCurrentDirectoryPath:path]==NO) {
        [fileManager changeCurrentDirectoryPath:old_path];
        return;
    }
    
    NSArray* strings = [fileManager contentsOfDirectoryAtPath:path error:nil];
    
    if (strings == nil) {
        [fileManager changeCurrentDirectoryPath:old_path];
        return;
    }
    
    data = [[NSMutableArray alloc] init];
    
    FileSystemItem* item = nil;
    
    if (![path isEqualToString:@"//"]) {
        item = [[FileSystemItem alloc] init];
        
        [item setFullPath   :path];
        [item setName       :@".."];
        [item setSize       :@"--"];
        [item setDate       :@"Date"];
        [item setType       :@"<Dir>"];
        [item setIsDir      :YES];
        
        [data addObject:item];
    }
    
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
    
    [sidePanel changeFolder:[path lastPathComponent]];
}

-(void) tableView:(NSTableView*)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    order = [self whatColumn:tableColumn];
    [self sortData];
}

-(void) setTable:(NSTableView *)t {
    table = t;
}

-(void) setSidePanelProtocol:(id<SidePanelProtocol>)sp {
    sidePanel = sp;
}

-(NSString*) currentPath {
    return [fileManager currentDirectoryPath];
}

@end

@implementation FileSystemDataSource(Private)

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
