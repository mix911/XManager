//
//  MakeDirDialog.h
//  XManager
//
//  Created by demo on 23.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindow;

@interface MakeDirDialog : NSWindow <NSTextFieldDelegate>
{
    IBOutlet NSTextField* directoryField;
    IBOutlet MainWindow*  mainWindow;
    IBOutlet NSButton*    cancelButton;
}

-(NSString*) directory;

@end
