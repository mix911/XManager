//
//  FileSystemDataSource.m
//  XManager
//
//  Created by demo on 09.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataSourceAndTableViewDelegate.h"

#import "SidePanel.h"
#import "FileSystemItem.h"

@interface DataSourceObj : NSObject {
@public
    DataSourceAndTableViewDelegate* this;
    NSUInteger                      row;
    NSString*                       key;
}

-(id)                               initWithAttrs :(DataSourceAndTableViewDelegate*)this :(NSUInteger)row :(NSString*)key;
-(DataSourceAndTableViewDelegate*)  this;
-(NSUInteger)                       row;
-(NSString*)                        key;

@end

@interface Task : NSObject {
    NSTimer*                        timer;
    NSThread*                       thread;
    DataSourceAndTableViewDelegate* dataSource;
    bool                            isReady;
}

-(id)   initWithDataSource :(DataSourceAndTableViewDelegate*)ds;

-(void) runTask :(DataSourceObj*)obj;
-(void) runTimer:(NSString*)key;
-(void) stopTimer;
-(void) stopTask;

@property   bool    isReady;

@end

@implementation Task

-(id) initWithDataSource :(DataSourceAndTableViewDelegate*)ds {
    if (self = [super init]) {
        
        dataSource  = ds;
        timer       = nil;
        isReady     = false;
        
    }
    return self;
}

-(void) runTask:(DataSourceObj *)obj {
    self.isReady = false;
    [self runTimer :[obj key]];
    
    thread = [[NSThread alloc] initWithTarget:[DataSourceAndTableViewDelegate class]
                                     selector:@selector(determineDirectorySizeAsync:) 
                                       object:obj];
    [thread start];
}

-(void) runTimer :(NSString*)key {
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:dataSource
                                           selector:@selector(onTaskTimer:)
                                           userInfo:key
                                            repeats:YES];
}

-(void) stopTimer {
    [timer invalidate];
    timer = nil;
}

-(void) stopTask {
    [thread cancel];
}

@synthesize isReady;

@end

@implementation DataSourceObj

-(id) initWithAttrs :(DataSourceAndTableViewDelegate*)t :(NSUInteger)r :(NSString*)k {
    if (self = [super init]) {
        this        = t;
        row         = r;
        key         = k;
        
        [key retain];
    }
    return self;
}

-(DataSourceAndTableViewDelegate*) this {
    return this;
}

-(NSUInteger) row {
    return row;
}

-(NSString*) key {
    return key;
}

@end

//+-----------------------------------------------------------------+
//| Идентификатор колонок                                           |
//+-----------------------------------------------------------------+
@interface DataSourceAndTableViewDelegate(Private) 

-(enum EFileSystemColumnId) whatColumn:(NSTableColumn*) column;
-(void)                     stopAllTasks;
-(void)                     onTaskTimer :(NSTimer*)timer;

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

-(void) stopAllTasks {
    [sync lock];
    
    for (Task* task in [tasks objectEnumerator]) {
        [task stopTimer];
    }
    
    [tasks removeAllObjects];
    
    [sync unlock];
}

-(void) onTaskTimer:(NSTimer*)timer {
    
    NSString* task_key = [timer userInfo];
    
    bool is_ready = false;
    
    [sync lock];
    
    Task* task = [tasks objectForKey:task_key];
    
    if (task) {
        if (task.isReady) {
            is_ready = true;
            
            [task stopTimer];
            
            [tasks removeObjectForKey:task_key];
        }
    }
    else {
        is_ready = true;
    }
    
    [sync unlock];
    
    if (is_ready) {
        [sidePanel updateTable];
    }
}

@end

@implementation DataSourceAndTableViewDelegate

-(id) initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        tasks = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) dealloc {
    [itemManager release];
}

// TODO: поискать способ read/write lock

-(bool) enterToRow:(NSUInteger)row {
    
    // Остановим все потоки
    [self stopAllTasks];
    
    // Поумолчанию установим неуспешное выполнение
    bool res = false;
    
    [sync lock];
    
    // Если ряд валидный
    if (row < [data count]) {
        
        // Получим нужный объект файловой системы
        FileSystemItem* item = [data objectAtIndex:row];

        // Путь
        NSString* new_path      = nil;
        NSString* current_path  = [itemManager currentPath];
        NSString* application_dir   = @"/Applications";     // Путь к приложениям

        
        // Если это путь "наверх"
        if ([item.name isEqualToString:@".."]) {
            // Если текущий путь это корневой каталог
            if ([current_path isEqualToString:@"/"]) {
                [sync unlock];
                return false;
            }
            
            // Проинициализируем новый путь
            new_path = @"";
            
            //Получим компоненты текущего каталога
            NSArray* components = [current_path pathComponents];
            
            // Сформируем новый путь
            for (NSUInteger i = 1; i < [components count] - 1; ++i) {
                new_path = [NSString stringWithFormat:@"%@/%@", new_path, (NSString*)[components objectAtIndex:i]];
            }
            
            // Если каталог пустой, поднимся в корень
            if ([new_path isEqualToString:@""]) {
                new_path = @"/";
            }
        }
        else {
            // Сформируем новый путь
            if ([current_path isEqualToString:@"/"]) {
                new_path = [NSString stringWithFormat:@"/%@", item.name];
            }
            else {
                new_path = [NSString stringWithFormat:@"%@/%@", current_path, item.name];
            }
        }
        
        if (item.isDir && (![current_path isEqualToString:application_dir] || [item.name isEqualToString:@".."])) {
        
            // Получим данные и сохраним во временном объекте
            NSMutableArray* tmp_data = [itemManager changeFolder:new_path];
        
            // Если данные удалось получить
            if (tmp_data != nil) {
            
                // Удалим старые данные
                [data release];
            
                // Обновим данные
                data = tmp_data;
            
                // Обновим заголовок
                [sidePanel setTabHeaderTitle:[[itemManager currentPath] lastPathComponent]];
            
                // Установим успешное выполнение
                res = true;
            }
        }
        else {
            [[NSWorkspace sharedWorkspace] openFile:new_path];
        }
    }
    [sync unlock];
    
    return res;
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
            if (item.size < 0) {
                return @"--";
            }
            else if (item.size < 1000) {
                return [NSString stringWithFormat:@"%i B", item.size];
            }
            else if (item.size < 1000000) {
                return [NSString stringWithFormat:@"%i KB", item.size / 1000];
            }
            else if (item.size < 1000000000) {
                return [NSString stringWithFormat:@"%i MB", item.size / 1000000];
            } else {
                return [NSString stringWithFormat:@"%i GB", item.size / 1000000000];
            }
            
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
            if (item.isSelected) {
                [cell setTextColor:[NSColor redColor]];
            }
            else {
                [cell setTextColor:[NSColor blackColor]];
            }
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

-(void) setSidePanelProtocol:(SidePanel*)sp {
    sidePanel = sp;
}

-(NSString*) currentPath {
    return [itemManager currentPath];
}

-(void) setItemManager:(id<ItemManagerProtocol>)im {
    [itemManager release];
    itemManager = [im retain];
    data = [itemManager changeFolder:[itemManager currentPath]];
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

-(void) updateItemsList {
    data = nil;
    [itemManager updateItemsList];
}

-(bool) changeFolder:(NSString *)folder {
    return [itemManager changeFolder:folder];
}

-(void) selectedItems:(NSMutableArray *)selected :(NSInteger)current {

    // Отчистим входящий массив
    [selected removeAllObjects];
    
    // Пройдемся по всем объектам файловой системы (кроме '..')
    for (NSInteger i = 1; i < [data count]; ++i) {
        
        // Получим очередной объект
        FileSystemItem* item = [data objectAtIndex:i];
        
        if (item.isSelected) {
            [selected addObject:[NSNumber numberWithLong:i]];
        }
    }
    
    // Если не выделен не один объект
    if ([selected count] == 0) {
        
        // Если текущий объект находится в диапазоне данных
        if (current < [data count]) {
            
            // Получим текущий объект
            FileSystemItem* item = [data objectAtIndex:current];
            
            if ([item.name isEqualToString:@".."] == NO) {
                [selected addObject:[NSNumber numberWithLong:current]];
            }
        }
    }
}

@end
