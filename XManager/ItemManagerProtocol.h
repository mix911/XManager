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
-(void)             setOrder        :(enum EFileSystemColumnId)order;
-(NSImage*)         iconForItem :(FileSystemItem*)item;
-(void)             updateItemsList;
-(NSString*)        currentPath;
-(NSMutableArray*)  changeFolder    :(NSString*)folder;

@end
