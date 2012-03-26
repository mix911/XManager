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
-(NSImage*)         iconForItem :(FileSystemItem*)item;
-(void)             updateItemsList;
-(NSString*)        currentPath;
-(NSMutableArray*)  changeFolder    :(NSString*)folder;

@end
