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

-(bool)     openFolder  :(NSString*)folder;
-(void)     sortData;
-(NSString*)makePath    :(NSString*)name;

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
        // Настроим рабочую директорию
        [fileManager changeCurrentDirectoryPath:path];
        
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
    
    NSString* new_path          = nil;                                  // Новый путь
    NSString* current_path      = [fileManager currentDirectoryPath];   // Текущий путь
    NSString* application_dir   = @"/Applications";                     // Путь к приложениям
    
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
    return [fileManager currentDirectoryPath];
}

-(NSImage*) iconForItem:(FileSystemItem*)item {
    return [workspace iconForFile:item.fullPath];
}

-(NSString*)    makeDir:(NSString *)name {
    NSString* path = [NSString stringWithFormat:@"%@/%@", [fileManager currentDirectoryPath], name];
    
    // Объект ошибки
    NSError* error = nil;
    
    // Попытаемся создать каталог
    if ([fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error]) {
        return nil;
    }
    
    return @"Can't create folder";
}

-(NSString*)    deleteSelected {
    
    NSError* error = nil;
    
    // Пройдемся по всем объектам файловой системы
    for (FileSystemItem* item in data) {
        
        // Нас интересуют только выделенные
        if (item.isSelected == NO) {
            continue;
        }
        
        // Путь к объекту
        NSString* path = [self makePath:item.name];
        
        if ([fileManager removeItemAtPath:path error:&error] == NO) {
            NSString* reason= [error localizedFailureReason];
            NSString* desc  = [error localizedDescription];
            
            return [NSString stringWithFormat:@"Can't remove %@", item.name];
        }
    }
    
    return nil;
}

-(void) updateItemsList {
    // Если не получится открыть текущую папку, например её больше нет
    if ([self openFolder:[fileManager currentDirectoryPath]] == NO) {
        // Откроем папку по умолчанию (в данном случае корневок каталог) TODO: нужно протестировать и обдумать, возможно нужна другая папка
        [self openFolder:@"/"]; 
    }
}

@end

@implementation FileSystemManager(Private)

-(bool) openFolder:(NSString *)new_path {
    
    // Сохраним старый путь
    NSString* old_path = [fileManager currentDirectoryPath];
    
    // Попытаемся сменить директорию
    if ([fileManager changeCurrentDirectoryPath:new_path]==NO) {
        
        // Если не получилось, востановим старый путь
        [fileManager changeCurrentDirectoryPath:old_path];
        
        // Не получилось
        return false;
    }
    
    // Получим список всех папок, файлов и прочих объектов файловой системы
    NSArray* strings = [fileManager contentsOfDirectoryAtPath:new_path error:nil];
    
    // Если ну удалось получить список объектов файловой системы
    if (strings == nil) {
        // Востановим старый путь
        [fileManager changeCurrentDirectoryPath:old_path];
        
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
                          
-(NSString*) makePath:(NSString *)name {
    return [NSString stringWithFormat:@"%@/%@", [fileManager currentDirectoryPath], name];
}

@end
