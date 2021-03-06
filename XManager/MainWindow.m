//
//  MainWindow.m
//  XManager
//
//  Created by demo on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainWindow.h"

#import "SidePanel.h"
#import "TabsHeaders.h"
#import "ConfigManager.h"
#import "FileSystemItem.h"
#import "CopyMoveDialog.h"
#import "MakeDirDialog.h"
#import "DeleteDialog.h"
#import "ProgressDialog.h"
#import "MessageBox.h"
#import "DataSourceAndTableViewDelegate.h"
#import "Task.h"
#import "QuestionDialog.h"

#include "MacSys.h"

@implementation MainWindow


-(void) loadSettings:(NSDictionary*)settings
{    
    if (settings == nil) return;

    NSString* active_tab = [settings objectForKey:@"ActivePanel"];
    
    if (active_tab && [active_tab isEqualToString:@"Right"]) {
        activePanel  = rightPanel;
        deactivePanel= leftPanel;
        [rightPanel setActive:self];
    }
    else {
        activePanel  = leftPanel;
        deactivePanel= rightPanel;
        [leftPanel setActive:self];
    }
    
    [leftPanel  loadSettings:[settings objectForKey:@"LeftPanel"]];
    [rightPanel loadSettings:[settings objectForKey:@"RightPanel"]];
}

-(id) saveSettings
{
    NSMutableDictionary* dict = [[[NSMutableDictionary alloc] init] autorelease];
    
    // Сохраним выбранную панель
    NSString* panel_side = (activePanel == leftPanel ? @"Left" : @"Right");
    [dict setValue:panel_side forKey:@"ActivePanel"];
    
    [dict setValue:[leftPanel  saveSettings] forKey:@"LeftPanel"];
    [dict setValue:[rightPanel saveSettings] forKey:@"RightPanel"];
    
    return dict;
}

//+-----------------------------------------------------------------+
//| Загрузка nib архива                                             |
//+-----------------------------------------------------------------+
-(void) awakeFromNib 
{
    // Загрузим родителя
    [super awakeFromNib];
    
    [ConfigManager load];
        
    [self loadSettings:[ConfigManager getValue:@"MainWindow"]];
}

-(void) sendEvent:(NSEvent*)theEvent 
{
    switch ([theEvent type]) {
            
        case NSKeyDown:
            if ([theEvent keyCode] == VK_TAB && ([theEvent modifierFlags] & NSControlKeyMask)) {
                if ([theEvent modifierFlags] & NSShiftKeyMask) {
                    [self switchToPrevTab];
                }
                else {
                    [self switchToNextTab];
                }
                return;
            }
            [super sendEvent:theEvent];
            break;
                        
        default:
            [super sendEvent:theEvent];
            break;
    }
}

-(void) postKeyDown:(NSEvent*)event
{
    unsigned int key = [event keyCode];
    switch (key) {
        case VK_F2:
            [self doRename];
            break;
            
        case VK_F5:
            [self pressCopy];
            break;
            
        case VK_F6:
            [self suggestMove];
            break;
            
        case VK_F7:
            [self suggestMkDir];
            break;
            
        case VK_F8:
            [self suggestDelete];
            break;
            
        default:
            [super keyDown:event];
            break;
    }
}

-(void) insertTab 
{
    if (activePanel == leftPanel) {
        activePanel   = rightPanel;
        deactivePanel = leftPanel;
        [rightPanel setActive:self];
        
    }
    else {
        activePanel   = leftPanel;
        deactivePanel = rightPanel;
        [leftPanel setActive:self];
    }
}

-(void) switchToNextTab 
{
    [activePanel switchToNextTab];
}

-(void) switchToPrevTab 
{
    [activePanel switchToPrevTab];
}

-(void) saveWindowSettings
{
    [ConfigManager setValue:@"MainWindow" :[self saveSettings]];
    [ConfigManager save];
}

-(NSUInteger) suggestCopy
{
    return [QuestionDialog doModalWithMessage:@"Copy selected files?" parent:self selectedButton:YES];
}

-(void) suggestMove
{
    [copyMoveDialog suggestMove];
}

-(void) suggestMkDir
{
    [makeDirDialog makeKeyAndOrderFront:self];
}

-(void) suggestDelete
{
    [deleteDialog makeKeyAndOrderFront:self];
}

-(IBAction) pressCommandButton:(id)sender
{
    NSButton* btn = (NSButton*)sender;
    
    if ([[btn identifier] isEqualToString:@"IDB_COMMAND_F2"]) {

    }
    else if ([[btn identifier] isEqualToString:@"IDB_COMMAND_F5"]) {
        [self pressCopy];
    }
    else if ([[btn identifier] isEqualToString:@"IDB_COMMAND_F6"]) {
        [self suggestMove];
    }
    else if ([[btn identifier] isEqualToString:@"IDB_COMMAND_F7"]) {
        [self suggestMkDir];
    }
    else if ([[btn identifier] isEqualToString:@"IDB_COMMAND_F8"]) {
        [self suggestDelete];
    }
    else if ([[btn identifier] isEqualToString:@"IDB_COMMAND_F9"]) {
        
    }
}

-(void) doRename
{
    DataSourceAndTableViewDelegate* src = [activePanel dataSource];
    [src doRename];
}

-(void) doCopy
{
    DataSourceAndTableViewDelegate* src = [activePanel dataSource];
    DataSourceAndTableViewDelegate* dst = [deactivePanel dataSource];

    Task* task = [[Task alloc] initWithSrc:src dst:dst];
    
    ProgressDialog* progressDialog = [ProgressDialog createProgressDialog];
    [progressDialog setLevel:NSFloatingWindowLevel];
    
    if ([task isCreated]) {
        [progressDialog runProgressWithTask:task title:@"Copying files"];
    }
    else {
        [MessageBox message:[task errorMessage]];
    }
    
    [task release];
}

-(void) doMove
{
    ProgressDialog* progressDialog = [ProgressDialog createProgressDialog];
    
    [progressDialog setTitle:@"Moving files"];
    [progressDialog makeKeyAndOrderFront:self];
    
    DataSourceAndTableViewDelegate* src = [activePanel dataSource];
    DataSourceAndTableViewDelegate* dst = [deactivePanel dataSource];
    
    [src doMove:dst];
}

-(void) doMakeDir
{
    DataSourceAndTableViewDelegate* src = [activePanel dataSource];
    [src doMakeDir];
}

-(void) doDelete
{
    ProgressDialog* progressDialog = [ProgressDialog createProgressDialog];
    
    [progressDialog setTitle:@"Deleting files"];
    [progressDialog makeKeyAndOrderFront:self];

    
    DataSourceAndTableViewDelegate* src = [activePanel dataSource];
    [src doDelete];
}

-(void) pressCopy
{
    if ([self suggestCopy] == YES) {
        [self doCopy];
    }
}

@end
