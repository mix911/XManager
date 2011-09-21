//
//  FileSystemManager.h
//  XManager
//
//  Created by demo on 16.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ItemManagerProtocol.h"

@interface FileSystemManager : NSObject <ItemManagerProtocol> {
    NSFileManager*  fileManager;
    NSWorkspace*    workspace;
    NSInteger       order;
    NSString*       currentPath;
}

// FileSystemManager's methods
-(id)   initWithPath : (NSString*)path;

// ItemManagerProtocol
-(NSMutableArray*)  data;
//-(bool)             enterToRow  :(NSInteger)row;
-(void)             setOrder    :(enum EFileSystemColumnId)order;
-(NSImage*)         iconForItem :(FileSystemItem*)item;
-(void)             updateItemsList;
-(NSString*)        currentPath;
-(NSMutableArray*)  changeFolder    :(NSString*)folder;


-(NSString*)        makeDir         :(NSString *)name;
-(NSString*)        deleteSelected;
-(NSString*)        renameCurrent   :(NSString*)name    :(NSInteger)row;
-(NSString*)        copySelected    :(NSString*)dest;
-(NSString*)        moveSelected    :(NSString*)dest;
-(NSUInteger)       determineDirectorySize:(NSString*)path;
-(bool)             canDetermineDirectorySize;

@end
