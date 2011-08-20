//
//  FileManager.h
//  XManager
//
//  Created by demo on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "WindowManagerProtocol.h"
#import "SidePanel.h"
#import "NetworkConnectionDialog.h"
#import "MakeDirDialog.h"
#import "DeleteDialog.h"
#import "MessageBox.h"
//+-----------------------------------------------------------------+
//| Управление главным окном, окном настроек и прочих диалогов      |
//+-----------------------------------------------------------------+
@interface WindowManager : NSObject <WindowManagerProtocol>{    
    IBOutlet    SidePanel*              leftPanel;                  // Левая панель
    IBOutlet    SidePanel*              rightPanel;                 // Правая панель
                SidePanel*              activePanel;                // Активная панель
    IBOutlet    NetworkConnectionDialog* networkConnectionPanel;     // Настройки сетевых соединений (ftp, sftp, s3, ...)
    IBOutlet    NSPanel*                renameDialog;               // Диалог переименования
    IBOutlet    MakeDirDialog*          makeDirDialog;              // Диалог создания каталога
    IBOutlet    MessageBox*             messageBox;                 // Сообдение
    IBOutlet    DeleteDialog*           deleteDialog;               // Диалог удаления
}

-(void) awakeFromNib;
-(bool) loadLastSesstion;

-(SidePanel*) activePanel;

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

// Make dir dialog
-(IBAction) makeDirCancel   :(id)sender;
-(IBAction) makeDirOk       :(id)sender;

// Delete dialog
-(IBAction) deleteItemsNo   :(id)sender;
-(IBAction) deleteItemsYes  :(id)sender;

// Message box
-(IBAction) messageBoxOk    :(id)sender;

// WindowManagerProtocol
-(void) renameItems;
-(void) copyItems;
-(void) moveItems;
-(void) makeDirItems;
-(void) deleleItems;

-(void) setActiveSide:(id)panel;

@end
