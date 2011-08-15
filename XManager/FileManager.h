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
#import "NetworkConnectionPanel.h"

@interface FileManager : NSObject <NSTableViewDataSource> {    
    IBOutlet SidePanel*                 leftPanel;
    IBOutlet SidePanel*                 rightPanel;
    IBOutlet NetworkConnectionPanel*    networkConnectionPanel;
}

-(void) awakeFromNib;
-(bool) loadLastSesstion;

// Bottom command buttons
-(IBAction) pushRename  :(id)sender;
-(IBAction) pushCopy    :(id)sender;
-(IBAction) pushMove    :(id)sender;
-(IBAction) pushMkDir   :(id)sender;
-(IBAction) pushDelete  :(id)sender;

// Top command buttons
-(IBAction) pushFtp     :(id)sender;

// Network connection dialog
-(IBAction) networkConnectionCancel :(id)sender;
-(IBAction) networkConnectionOk     :(id)sender;

@end
