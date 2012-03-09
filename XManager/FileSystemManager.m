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

-(NSMutableArray*)  openFolder      :(NSString*)folder;
-(NSString*)        makePath        :(NSString*)name;
-(bool)             setCurrentPath  :(NSString*)path;

// Определение размера
-(void)             expandNode      :(NSString*)node :(NSMutableArray*)stack :(NSFileManager*)fm;
-(bool)             isLeaf          :(NSString*)node :(NSFileManager*)fm;
-(NSUInteger)       nodeSize        :(NSString*)node :(NSFileManager*)fm;

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

-(NSMutableArray*) openFolder:(NSString *)new_path {
    
    // Сохраним старый путь
    NSString* old_path = [self currentPath];
    
    // Попытаемся сменить директорию
    if ([self setCurrentPath:new_path] == false) {
        return nil;
    }
    
    // Получим список всех папок, файлов и прочих объектов файловой системы
    NSArray* strings = [fileManager contentsOfDirectoryAtPath:new_path error:nil];
    
    // Если ну удалось получить список объектов файловой системы
    if (strings == nil) {
        
        // Востановим старый путь
        [self setCurrentPath:old_path];
        
        // Не получилось
        return nil;
    }
    
    // Создадим пустые данные
    NSMutableArray* data = [[NSMutableArray alloc] init];
    
    // Пустой item
    FileSystemItem* item = nil;
    
    // Если новая папка не является корневой
    if ([new_path isEqualToString:@"/"]==NO) {
        
        // Создадим item
        item = [[FileSystemItem alloc] init];
        
        // Создадим папку ".."
        [item setFullPath   :new_path]; // Полный путь
        [item setName       :@".."];    // Имя ..
        [item setSize       :-1];       // Размера у этой папки нет
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
            size = @"-1";
            type = @"<Dir>";
        }
        else {
            size = [attrs objectForKey:NSFileSize];
            type = [string pathExtension];
        }
        
        [item setName       :string];
        [item setFullPath   :[NSString stringWithFormat:@"%@/%@", new_path, string]];
        [item setIsDir      :is_dir];
        [item setSize       :[size integerValue]];
        [item setDate       :modification_date];
        [item setType       :type];
        
        [data addObject:item];
    }
    
    return data;
}

-(NSString*) makePath:(NSString* )name {
    return [NSString stringWithFormat:@"%@/%@", [self currentPath], name];
}

// TODO: в будущем учесть символические ссылки
-(void) expandNode:(NSString *)node :(NSMutableArray *)stack :(NSFileManager*)fm {
    // Ошибка
    NSError* error = nil;
    
    // Получим детей
    NSArray* children = [fm contentsOfDirectoryAtPath:node error:&error];
    
    // Если произошла ошибка (такое может быть в случае отсутсвии прав)
    if (children == nil || error != nil) {
        return;
    }
    
    // Присоединим полученый массив в конец стека
    for (NSString* child in children) {
        [stack addObject:[NSString stringWithFormat:@"%@/%@", node, child]];
    }
}

-(bool) isLeaf:(NSString *)node :(NSFileManager*)fm {
    // Ошибка
    NSError* error = nil;
    
    // Получим атрибуты
    NSDictionary* attrs = [fm attributesOfItemAtPath:node error:&error];
    
    // Если произошла ошибка
    if (attrs == nil || error != nil) {
        // Возвращая true мы сообщаем, что узел - лист. Тогда при определении размера нужно исходить из того,
        // что узлы для которых нельзя посчитать размер имеют размер 0
        return true;
    }
    
    // Все что не директория - лист
    return ![[attrs objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory];
}

-(NSUInteger) nodeSize:(NSString *)node :(NSFileManager*)fm {
    // Ошибка
    NSError* error = nil;
    
    // Получим атрибуты
    NSDictionary* attrs = [fm attributesOfItemAtPath:node error:&error];
    
    // Если произошла ошибка
    if (attrs == nil || error != nil) {
        return 0;
    }
    
    // Получим строковое представление размера
    NSString* str_size = [attrs objectForKey:NSFileSize];
    
    // Вернем численное представление размера
    return [str_size integerValue];
}

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
//        [self setOrder:FS_NAME];
    }
    return self;
}
-(NSMutableArray*) changeFolder:(NSString*)folder {
    return [self openFolder:folder];
}

-(void) setOrder:(enum EFileSystemColumnId)o {
    order = o;
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


-(void) updateItemsList {
    // Если не получится открыть текущую папку, например её больше нет
    if ([self openFolder:[self currentPath]] == NO) {
        // Откроем папку по умолчанию (в данном случае корневой каталог) TODO: нужно протестировать и обдумать, возможно нужна другая папка
        [self openFolder:@"/"]; 
    }
}

@end