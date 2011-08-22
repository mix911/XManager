//
//  FtpDataSource.h
//  XManager
//
//  Created by demo on 15.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FtpDataSource : NSObject<NSTableViewDataSource, NSTableViewDelegate> {
    
}

// Data source
-(NSInteger)    numberOfRowsInTableView:(NSTableView *)tableView;
-(id)           tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
-(void)         enterToRow:(NSInteger)row;
-(void)         goUp;

@end
