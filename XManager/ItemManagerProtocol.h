//
//  ItemManagerProtocol.h
//  XManager
//
//  Created by demo on 16.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "FileSystemItem.h"

@protocol ItemManagerProtocol <NSObject>

@required
-(bool)             enterToRow  :(NSInteger)row;
-(void)             setOrder    :(enum EFileSystemColumnId)order;
-(NSMutableArray*)  data;
-(NSString*)        currentPath;
-(NSImage*)         iconForItem :(FileSystemItem*)item;

@end
