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
-(void) deleleItems;

-(void) setActiveSide:(id)panel;

@end