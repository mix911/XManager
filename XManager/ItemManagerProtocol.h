//
//  ItemManagerProtocol.h
//  XManager
//
//  Created by demo on 16.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FileSystemItem.h"

@protocol ItemManagerProtocol <NSObject>

@required
-(NSMutableArray*)  changeFolder    :(NSString*)folder;
//-(bool)             enterToRow      :(NSInteger)row;
-(void)             setOrder        :(enum EFileSystemColumnId)order;
-(NSMutableArray*)  data;
-(NSString*)        currentPath;
-(NSImage*)         iconForItem :(FileSystemItem*)item;
-(void)             updateItemsList;

-(NSString*)        makeDir         :(NSString*)name;
-(NSString*)        deleteSelected;
-(NSString*)        renameCurrent   :(NSString*)name :(NSInteger)row;
-(NSString*)        copySelected    :(NSString*)dest;
-(NSString*)        moveSelected    :(NSString*)dest;
-(NSUInteger)       determineDirectorySize:(NSString*)path;
-(bool)             canDetermineDirectorySize;

@end
