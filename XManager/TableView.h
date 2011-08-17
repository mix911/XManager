//
//  TableView.h
//  XManager
//
//  Created by demo on 12.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

#import "SidePanelProtocol.h"

@interface TableView : NSTableView {
    id<SidePanelProtocol>   sidePanel;
}

-(id)   init;
-(void) setSidePanel:(id<SidePanelProtocol>)sidePanel;
-(void) keyDown     :(NSEvent*)event;
-(void) doubleClick :(id)sender;

@end
