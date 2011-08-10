//
//  FileManager.h
//  XManager
//
//  Created by demo on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "SidePanel.h"

@interface FileManager : NSObject <NSTableViewDataSource> {    
    IBOutlet SidePanel*             leftPanel;
    IBOutlet SidePanel*             rightPanel;
}

-(void) awakeFromNib;
-(bool) loadLastSesstion;

@end
