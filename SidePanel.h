//
//  SidePanel.h
//  XManager
//
//  Created by demo on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface SidePanel : NSView {
    NSTabView*  tabView;    // Вкладки
    int         nextTabId;  // Следующая вкладка
}

-(id)       init;
-(void)     dealloc;
-(void)     addTab :(NSString*)path :(NSString*)side;
-(int)      nextTabId;

@end
