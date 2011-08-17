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
    NSString*   fullPath;   // А нужно ли оно ????
    NSString*   name;
    NSString*   size;
    NSString*   date;
    NSDate*     dateDate;
    NSString*   type;
    bool        isDir;
}

@property(retain)   NSString*   fullPath;
@property(retain)   NSString*   name;
@property(retain)   NSString*   size;
@property(retain)   NSString*   date;
@property(retain)   NSString*   type;
@property           bool        isDir;
@property(retain)   NSDate*     dateDate;

-(NSComparisonResult) compareByName :(FileSystemItem*)rgh;
-(NSComparisonResult) compareBySize :(FileSystemItem*)rgh;
-(NSComparisonResult) compareByDate :(FileSystemItem*)rgh;
-(NSComparisonResult) compareByType :(FileSystemItem*)rgh;

@end
