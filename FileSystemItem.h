//
//  FileSystemItem.h
//  XManager
//
//  Created by demo on 10.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//+-----------------------------------------------------------------+
//| Идентификатор колонок                                           |
//+-----------------------------------------------------------------+
enum EFileSystemColumnId {
    FS_ICON = 0,
    FS_NAME,
    FS_SIZE,
    FS_DATE,
    FS_TYPE,
    FS_UNDEFINED,
};

@interface FileSystemItem : NSObject {
    NSString*   fullPath;   // Полный путь - используется FileSystemManager для генерации иконок
    NSString*   name;       // Наименование объекта файловой системы
    NSInteger   size;       // Размер, TODO: нужно переделать в байты
    NSDate*     date;       // Дата модификации
    NSString*   type;       // Тип (расширение) файла
    bool        isDir;      // Это каталог? TODO: нужно обдумать символические ссылки
    bool        isSelected; // Выделен ли объект: true - выделен; false - не выделен
}

@property(retain)   NSString*   fullPath;
@property(retain)   NSString*   name;
@property           NSInteger   size;
@property(retain)   NSDate*     date;
@property(retain)   NSString*   type;
@property           bool        isDir;
@property           bool        isSelected;


-(NSComparisonResult) compareByName :(FileSystemItem*)rgh;
-(NSComparisonResult) compareBySize :(FileSystemItem*)rgh;
-(NSComparisonResult) compareByDate :(FileSystemItem*)rgh;
-(NSComparisonResult) compareByType :(FileSystemItem*)rgh;

@end
