//
//  FileSystemDataSource.m
//  XManager
//
//  Created by demo on 09.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileSystemDataSource.h"

#import "FileSystemItem.h"

@implementation FileSystemDataSource

-(id) initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        fileManager = [[NSFileManager alloc] init];
        [fileManager changeCurrentDirectoryPath:path];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        [self openFolder :path];
    }
    return self;
}

-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
    return [data count];
}

-(id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

    if ([data count] <= row) {
        return nil;
    }
    
    NSString* column_name = [[tableColumn headerCell] stringValue];
    
    // Получим идентификатор колонки TODO: переделать на идентификатор колонки
    NSString* col_id = [tableColumn identifier];
    
    // Получим очередной item
    FileSystemItem* item = [data objectAtIndex:row];
    
    // Получим имя очередного item
    NSString* item_name = [item name];
    
    // Получим атрибуты очередного item
    NSDictionary* attrs = [fileManager attributesOfItemAtPath:item_name error:nil];
    
    if([column_name isEqualToString:@""]){
        return nil;
    }
    else if ([column_name isEqualToString:@"Name"]) {
        return [item name];
    }
    else if([column_name isEqualToString:@"Size"]){
         // Если это директория не будем считать её размер TODO: просмотреть другие типы item
        if ([item isDir]) {
            return @"--";
        }
        return [item size];
//        // Получим тип item
//        NSString* item_type = [attrs objectForKey:NSFileType];
//        if ([item_type isEqualToString:NSFileTypeDirectory]) {
//            return @"--";
//        }
//        return (NSString*)[attrs objectForKey:NSFileSize];
    }
    else if([column_name isEqualToString:@"Date"]){
        return [item date];
        // Получим дату модификации
//        NSDate* date = [attrs objectForKey:NSFileModificationDate];
//        return  [dateFormatter stringFromDate:date];
    }
    else if([column_name isEqualToString:@"Type"]){
        return [item type];
//        
//        // Получим тип item
//        NSString* item_type = [attrs objectForKey:NSFileType];
//        
//        // Если это директория
//        if ([item_type isEqualToString:NSFileTypeDirectory]) {
//            return @"<Dir>";
//        }
//        return [item_name pathExtension];
    }
    return @"Error";
}

-(void) tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)column row:(NSInteger)row {
    
    // Получим идентификатор колонки TODO: переделать на идентификатор колонки
    NSString* col_id = [column identifier];
    
    // Если рисуем статус
    if ([[[column headerCell ] stringValue] isEqualToString:@""]) {
        // Downcast-им  ячейку
        NSImageCell*    icell   = (NSImageCell*)cell;
        
        // Получим очередной item
        FileSystemItem* item = [data objectAtIndex:row];
        
//        // Получим имя очередного item
//        NSString* item_name = [[fileManager contentsOfDirectoryAtPath:[fileManager currentDirectoryPath] error:nil] objectAtIndex:row];
        
        // Получим shared workspace
        NSWorkspace* workspace = [NSWorkspace sharedWorkspace];
        
        // Получим иконку для данного item
        NSImage* icon = [workspace iconForFile:[item fullPath]];
        
//        // Получим иконку для данного item
//        NSImage* icon = [workspace iconForFile:[NSString stringWithFormat:@"%@/%@", [fileManager currentDirectoryPath], item_name]];
        
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
}

@end
