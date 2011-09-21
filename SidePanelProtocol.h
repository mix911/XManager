//
//  SidePanelProtocol.h
//  XManager
//
//  Created by demo on 12.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SidePanelProtocol <NSObject>

@required
-(void) setTabHeaderTitle           :(NSString*)title;
-(bool) changeFolder                :(NSString*)folder;
-(bool) enterToRow                  :(NSInteger)row;
-(bool) goUp;
-(void) addTabFromCurrent;
-(void) closeCurrentTab;
-(void) invertSelection             :(NSInteger)row;
-(void) postKeyDown                 :(NSEvent*)event;
-(void) setActive                   :(NSWindow*)window;
-(void) determineDirectorySizeAsync :(NSInteger)row;
-(void) determineDirectorySize      :(NSInteger)row;
-(void) determineDirectorySize;
-(void) updateTable;

@end
