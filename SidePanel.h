//
//  SidePanel.h
//  XManager
//
//  Created by demo on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

#import "SidePanelProtocol.h"
#import "FtpParams.h"

@interface SidePanel : NSView <SidePanelProtocol> {
    NSTabView*  tabView;    // Вкладки
    NSString*   side;       // Сторона, может быть Left или Right
    int         nextTabId;  // Следующая вкладка
}

-(id)       init;
-(void)     dealloc;
-(void)     addTab :(NSString*)path;
-(void)     addTabFromCurrent;
-(int)      nextTabId;
-(void)     setSide :(NSString*)side;
-(void)     setFtpDataSource :(FtpParams*)params;

// SidePanelProtocol
-(void)     changeFolder:(NSString *)folder;
-(void)     addTabFromCurrent;


@end
