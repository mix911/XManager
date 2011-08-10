//
//  FileSystemDataSource.h
//  XManager
//
//  Created by demo on 09.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSystemDataSource : NSObject <NSTableViewDataSource, NSTableViewDelegate> {
    NSFileManager*      fileManager;
    NSDateFormatter*    dateFormatter;
    
    NSMutableArray*     data;
}

-(id)           initWithPath:(NSString*)path;
-(NSInteger)    numberOfRowsInTableView:(NSTableView *)tableView;
-(id)           tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

-(void) tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

-(void) openFolder:(NSString*)path;

@end
