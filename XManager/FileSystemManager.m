//
//  FileSystemManager.m
//  XManager
//
//  Created by demo on 16.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileSystemManager.h"
#import "FileSystemItem.h"

@interface FileSystemManager(Private)

-(bool)     openFolder      :(NSString*)folder;
-(void)     sortData;
-(NSString*)makePath        :(NSString*)name;
-(bool)     setCurrentPath  :(NSString*)path;

@end

@implementation FileSystemManager
//+-----------------------------------------------------------------+
//| Инициализация с указанием пути                                  |
//+-----------------------------------------------------------------+
-(id) initWithPath:(NSString *)path {
    if (self = [super init]) {
        
        // Получим рабочее пространство
        workspace = [NSWorkspace sharedWorkspace];
        
        // Создадим файловый менеджер
        fileManager = [[NSFileManager alloc] init];
        
        // Откроем каталог
        [self openFolder:path];
        
        // Установим порядок по умолчанию
        [self setOrder:FS_NAME];
    }
    return self;
}
//+-----------------------------------------------------------------+
//| Раскрыть ряд: true - данные обновились, false - нет             |
//+-----------------------------------------------------------------+
-(bool) enterToRow:(NSInteger)row {
    // Проверки
    if ([data count] <= row) {
        return false;
    }
    
    // Получим нужный объект файловой системы
    FileSystemItem* item = [data objectAtIndex:row];
    
    NSString* new_path          = nil;                  // Новый путь
    NSString* current_path      = [self currentPath];   // Текущий путь
    NSString* application_dir   = @"/Applications";     // Путь к приложениям
    
    // Если выбранный ряд ведет наверх
    if ([item.name isEqualToString:@".."]) {
        
        // Если текущий путь это корневой каталог
        if ([current_path isEqualToString:@"/"]) {
            return false;
        }
        
        // Проиницализируем новый путь
        new_path = @"";
        
        // Получим компоненты текущего каталога
        NSArray* components = [current_path pathComponents];
        
        // Сформируем новый путь
        for (NSUInteger i = 0; i < [components count] - 1; ++i) {
            new_path = [NSString stringWithFormat:@"%@/%@", new_path, (NSString*)[components objectAtIndex:i]];
        }
    }
    else {
        // Сформируем новый путь
        new_path = [NSString stringWithFormat:@"%@/%@", current_path, item.name];
    }
    
    // Если row - каталог, который не является каталогом приложения
    if (item.isDir && (![current_path isEqualToString:application_dir] || [item.name isEqualToString:@".."])) {
        return [self openFolder:new_path];
    }
    else {
        [workspace openFile:new_path];
        return false;
    }
}

-(NSMutableArray*) data {
    return data;
}

-(void) setOrder:(enum EFileSystemColumnId)o {
    order = o;
    [self sortData];
}

-(NSString*) currentPath {
    if (currentPath) {
        return [NSString stringWithString:currentPath];
    }
    return nil;
}

-(NSImage*) iconForItem:(FileSystemItem*)item {
    return [workspace iconForFile:item.fullPath];
}

-(NSString*)    makeDir:(NSString *)name {
    NSString* path = [NSString stringWithFormat:@"%@/%@", [self currentPath], name];
    
    // Объект ошибки
    NSError* error = nil;
    
    // Попытаемся создать каталог
    if ([fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error]) {
        return nil;
    }
    
    return @"Can't create folder";
}

-(NSString*)    deleteSelected {
    
    NSMutableArray* to_delete   = [[NSMutableArray alloc] init];
    NSInteger       tag         = 0;
    
    // Пройдемся по всем объектам и составим список объектов на удаление
    for (FileSystemItem* item in data) {
        if (item.isSelected && [item.name isEqualToString:@".."] == NO) {
            [to_delete addObject:item.name];
        }
    }
    
    if ([workspace performFileOperation:NSWorkspaceRecycleOperation 
                                 source:[self currentPath] 
                            destination:@"" files:to_delete 
                                    tag:&tag] == NO) {
        [to_delete release];
        return @"Can't perform moving in trash";
    }
    
    [to_delete release];
    return nil;
}

-(NSString*)        renameCurrent   :(NSString*)name :(NSInteger)row{
        
    FileSystemItem* item = [data objectAtIndex:row];
    
    if ([item.name isEqualToString:@".."]) {
        return nil;
    }
    
    NSError* error  = nil;
    
    if ([fileManager moveItemAtPath:[self makePath:item.name] 
                             toPath:[self makePath :name] 
                              error:&error] == NO) {
        return [error localizedFailureReason];
    }
    
    return nil;
}

-(NSString*)        copySelected    :(NSString*)dest {
    // Получим директорию источник
    NSString* src = [self currentPath];
    
    // Если источник и назначение равны ничего не делаем
    if ([src isEqualToString:dest]) {
        return nil;
    }
    
    // Если имеется .. пропустим этот объект
    NSUInteger first_index = [((FileSystemItem*)[data objectAtIndex:0]).name isEqualToString:@".."] ? 1 : 0;
    
    // Выбранные объекты
    NSMutableArray* selected = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = first_index; i < [data count]; ++i) {
        
        // Получим очередной объект
        FileSystemItem* item = [data objectAtIndex:i];
        
        // Если объект выбран
        if (item.isSelected) {
            [selected addObject:item.name];
        }
    }
    
    NSInteger tag = 0;
    
    if ([workspace performFileOperation:NSWorkspaceCopyOperation source:src
                            destination:dest 
                                  files:selected 
                                    tag:&tag] == NO) {
        [selected release];
        return [[NSString stringWithString: @"Can't perform coping selected items"] retain];
    }
    
    [selected release];
    
    return nil;
}
//----------------------------------------------------------------
// Перемещение
//----------------------------------------------------------------
-(NSString*)        moveSelected    :(NSString*)dest {
    
    // Получим директорию источник
    NSString* src = [self currentPath];
    
    // Если источник и назначение равны ничего не делаем
    if ([src isEqualToString:dest]) {
        return nil;
    }
    
    // Если имеется .. пропустим этот объект
    NSUInteger first_index = [((FileSystemItem*)[data objectAtIndex:0]).name isEqualToString:@".."] ? 1 : 0;
    
    // Выбранные объекты
    NSMutableArray* selected = [[NSMutableArray alloc] init];
    
    // Пройдемся по всем объектам файловой системы и составим список выбранных
    for (NSUInteger i = first_index; i < [data count]; ++i) {

        // Получим очередной объект файловой системы
        FileSystemItem* item = [data objectAtIndex:i];
        
        if (item.isSelected) {
            [selected addObject:item.name];
        }
    }
    
    NSInteger tag = 0;
    
    if ([workspace performFileOperation:NSWorkspaceMoveOperation 
                                 source:src 
                            destination:dest 
                                  files:selected 
                                    tag:&tag] == NO) {
        [selected release];
        return @"Can't perform moving selected files/direcoties";
    }
    
    [selected release];
    return nil;
}


-(void) updateItemsList {
    // Если не получится открыть текущую папку, например её больше нет
    if ([self openFolder:[self currentPath]] == NO) {
        // Откроем папку по умолчанию (в данном случае корневок каталог) TODO: нужно протестировать и обдумать, возможно нужна другая папка
        [self openFolder:@"/"]; 
    }
}

@end

@implementation FileSystemManager(Private)

-(bool) setCurrentPath:(NSString *)path {

    // Сохраним текущий каталог
    NSString* old_path = [self currentPath];
    
    // Если пусть удалось установить
    if ([fileManager changeCurrentDirectoryPath:path]) {
        currentPath = [NSString stringWithString:path];
        return true;
    }
    
    // Востановим старый путь
    [fileManager changeCurrentDirectoryPath:old_path];
    
    return false;
}

-(bool) openFolder:(NSString *)new_path {
    
    // Сохраним старый путь
    NSString* old_path = [self currentPath];
    
    // Попытаемся сменить директорию
    if ([self setCurrentPath:new_path] == false) {
        return false;
    }
    
    // Получим список всех папок, файлов и прочих объектов файловой системы
    NSArray* strings = [fileManager contentsOfDirectoryAtPath:new_path error:nil];
    
    // Если ну удалось получить список объектов файловой системы
    if (strings == nil) {
        
        // Востановим старый путь
        [self setCurrentPath:old_path];
        
        // Не получилось
        return false;
    }
    
    // Удалим старые данные
    [data release];
    
    // Создадим контейнер для новых данных
    data = [[NSMutableArray alloc] init];
    
    // Пустой item
    FileSystemItem* item = nil;
    
    // Если новая папка не является корневой
    if ([new_path isEqualToString:@"//"]==NO) {
        
        // Создадим item
        item = [[FileSystemItem alloc] init];
        
        // Создадим папку ".."
        [item setFullPath   :new_path]; // Полный путь
        [item setName       :@".."];    // Имя ..
        [item setSize       :@"--"];    // Размера у этой папки нет
        [item setDate       :nil];      // Даты у этой папки нет
        [item setType       :@"<Dir>"]; // Это папка
        [item setIsDir      :YES];      // Это папка
        
        // Добавим item
        [data addObject:item];
    }
    
    // Для каждой строки
    for(NSString* string in strings) {

        // Создадим новый item
        item = [[FileSystemItem alloc] init];
        
        // Получим атрибуты очередного объекта файловой системы
        NSDictionary* attrs = [fileManager attributesOfItemAtPath:string error:nil];
        
        // Определим тип объекта
        NSString* item_type = [attrs objectForKey:NSFileType];
        
        // Это каталог?
        bool is_dir = [item_type isEqualToString:NSFileTypeDirectory];
        
        // Получим дату модификации
        NSDate* modification_date = [attrs objectForKey:NSFileModificationDate];
        
        // Пустые size и type
        NSString* size = nil;
        NSString* type = nil;
        
        // Если чередной объект - каталог
        if (is_dir) {
            size = @"--";
            type = @"<Dir>";
        }
        else {
            size = [attrs objectForKey:NSFileSize];
            type = [string pathExtension];
        }
        
        [item setName       :string];
        [item setFullPath   :[NSString stringWithFormat:@"%@/%@", new_path, string]];
        [item setIsDir      :is_dir];
        [item setSize       :size];
        [item setDate       :modification_date];
        [item setType       :type];
        
        [data addObject:item];
    }
    
    [self sortData];
    
    return true;
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
}
                          
-(NSString*) makePath:(NSString* )name {
    return [NSString stringWithFormat:@"%@/%@", [self currentPath], name];
}

@end
