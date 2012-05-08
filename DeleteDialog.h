//
//  DeleteDialog.h
//  XManager
//
//  Created by demo on 08.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindow;

@interface DeleteDialog : NSWindow
{
    IBOutlet NSButton*   cancelButton;
    IBOutlet MainWindow* mainWindow;
}

@end
