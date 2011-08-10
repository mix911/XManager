//
//  FileSystemDataSource.m
//  XManager
//
//  Created by demo on 09.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileSystemDataSource.h"

@implementation FileSystemDataSource

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(id) initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        fileManager = [[NSFileManager alloc] init];
        [fileManager changeCurrentDirectoryPath:path];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    return self;
}

-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
    return [[fileManager contentsOfDirectoryAtPath:[fileManager currentDirectoryPath] error:nil] count];
}

-(id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

    NSString* column_name = [[tableColumn headerCell] stringValue];
    
    // Получим идентификатор колонки TODO: переделать на идентификатор колонки
    NSString* col_id = [tableColumn identifier];
    
    // Получим имя очередного item
    NSString* item_name = [[fileManager contentsOfDirectoryAtPath:[fileManager currentDirectoryPath] error:nil] objectAtIndex:row];
    
    // Получим атрибуты очередного item
    NSDictionary* attrs = [fileManager attributesOfItemAtPath:item_name error:nil];
    
    if([column_name isEqualToString:@""]){
        return nil;
    }
    else if ([column_name isEqualToString:@"Name"]) {
        return item_name;
    }
    else if([column_name isEqualToString:@"Size"]){
        // Получим тип item
        NSString* item_type = [attrs objectForKey:NSFileType];
        // Если это директория не будем считать её размер TODO: просмотреть другие типы item
        if ([item_type isEqualToString:NSFileTypeDirectory]) {
            return @"--";
        }
        return (NSString*)[attrs objectForKey:NSFileSize];
    }
    else if([column_name isEqualToString:@"Date"]){
        // Получим дату модификации
        NSDate* date = [attrs objectForKey:NSFileModificationDate];
        return  [dateFormatter stringFromDate:date];
    }
    else if([column_name isEqualToString:@"Type"]){
        // Получим тип item
        NSString* item_type = [attrs objectForKey:NSFileType];
        
        // Если это директория
        if ([item_type isEqualToString:NSFileTypeDirectory]) {
            return @"<Dir>";
        }
        return [item_name pathExtension];
    }
    return @"Error";
}

-(void) tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)column row:(NSInteger)row {
    
    // Получим идентификатор колонки TODO: переделать на идентификатор колонки
    NSString* col_id = [column identifier];
    
    // Если рисуем статус
    if ([[[column headerCell ] stringValue] isEqualToString:@""]) {
        
        NSImageCell*    icell   = (NSImageCell*)cell;
        
        // Получим имя очередного item
        NSString* item_name = [[fileManager contentsOfDirectoryAtPath:[fileManager currentDirectoryPath] error:nil] objectAtIndex:row];
        
        // Получим shared workspace
        NSWorkspace* workspace = [NSWorkspace sharedWorkspace];
        
        // Получим иконку для данного item
        NSImage* icon = [workspace iconForFile:[NSString stringWithFormat:@"%@/%@", [fileManager currentDirectoryPath], item_name]];
        
        [icell setImage:icon];
    }
}

@end
