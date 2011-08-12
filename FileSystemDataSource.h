//
//  FileSystemDataSource.h
//  XManager
//
//  Created by demo on 09.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SidePanelProtocol.h"

enum EFileSystemColumnId {
    FS_ICON = 0,
    FS_NAME,
    FS_SIZE,
    FS_DATE,
    FS_TYPE,
    FS_UNDEFINED,
};

@interface FileSystemDataSource : NSObject <NSTableViewDataSource, NSTableViewDelegate> {
    NSFileManager*              fileManager;
    NSDateFormatter*            dateFormatter;
    NSMutableArray*             data;
    NSTableView*                table;
    NSWorkspace*                workspace;
    enum EFileSystemColumnId    order;
    id<SidePanelProtocol>*      sidePanel;
}

// Data source
-(id)           initWithPath:(NSString*)path;
-(NSInteger)    numberOfRowsInTableView:(NSTableView *)tableView;
-(id)           tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
-(void)         enterToRow:(NSInteger)row;
-(void)         goUp;

// Delegate
-(void) tableView:(NSTableView*)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
-(void) tableView:(NSTableView*)tableView didClickTableColumn:(NSTableColumn *)tableColumn;

// FileSystemDataSource
-(void) openFolder:(NSString*)path;
-(void) setTable:(NSTableView*)table;
-(void) setSidePanelProtocol:(id<SidePanelProtocol>*)sidePanel;

@end
