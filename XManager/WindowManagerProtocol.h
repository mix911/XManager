//
//  WindowManagerProtocol.h
//  XManager
//
//  Created by demo on 19.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WindowManagerProtocol <NSObject>

@required
-(void) renameItems;
-(void) copyItems;
-(void) moveItems;
-(void) makeDirItems;
-(void) deleteItems;
-(void) insertTab;

-(void) setActiveSide:(id)panel;

-(void) pressMoveYes;
-(void) pressCopyYes;
-(void) pressMoveNo;
-(void) pressCopyNo;

@end
