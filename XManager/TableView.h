//
//  TableView.h
//  XManager
//
//  Created by demo on 12.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@class SidePanel;

@interface TableView : NSTableView 
{
    SidePanel*          sidePanel;
    NSMutableIndexSet*  selectedRows;
}

-(id)   init;
-(void) setSidePanel    :(SidePanel*)sidePanel;
-(void) keyDown         :(NSEvent*)event;
-(void) doubleClick     :(id)sender;
-(BOOL) becomeFirstResponder;

@end
