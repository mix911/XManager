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
    NSMutableArray* data;
    NSInteger       order;
}

// FileSystemManager's methods
-(id)   initWithPath : (NSString*)path;

// ItemManagerProtocol
-(NSMutableArray*)  data;
-(NSString*)        currentPath;
-(bool)             enterToRow  :(NSInteger)row;
-(void)             setOrder    :(enum EFileSystemColumnId)order;
-(NSImage*)         iconForItem :(FileSystemItem*)item;
-(void)             updateItemsList;

-(NSString*)        makeDir         :(NSString *)name;
-(NSString*)        deleteSelected;

@end
