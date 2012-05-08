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

#import "CopyMoveDialog.h"
#import "MakeDirDialog.h"
#import "DeleteDialog.h"
#import "MessageBox.h"

#include "MacSys.h"

@implementation MainWindow

- (id)init 
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) pressCopyYes
{
    NSAlert* alert = [[[NSAlert alloc] init] autorelease];
    [alert setMessageText:@"Copy"];
    [alert runModal];
}

-(void) pressMoveYes
{
    NSAlert* alert = [[[NSAlert alloc] init] autorelease];
    [alert setMessageText:@"Move"];
    [alert runModal];
}

-(void) loadSettings:(NSDictionary*)settings
{    
    if (settings == nil) return;

    NSString* active_tab = [settings objectForKey:@"ActivePanel"];
    
    if (active_tab && [active_tab isEqualToString:@"Right"]) {
        [self setActiveSide:rightPanel];
        [rightPanel setActive:self];
    }
    else {
        [self setActiveSide:leftPanel];
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
            if ([theEvent keyCode] == 48 && ([theEvent modifierFlags] & NSControlKeyMask)) {
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
            [self suggestCopy];
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

-(void) setActiveSide :(id)panel 
{
    activePanel = panel;
}

-(void) insertTab 
{
    if (activePanel == leftPanel) {
        [self setActiveSide:rightPanel];
        [rightPanel setActive:self];
        
    }
    else {
        [self setActiveSide:leftPanel];
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

-(void) suggestCopy
{
    [copyMoveDialog suggestCopy];
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
        [self suggestCopy];
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
}

-(void) doCopy
{
    [MessageBox message:@"Copy"];
}

-(void) doMove
{
    [MessageBox message:@"Move"];
}

-(void) doMakeDir
{
    [MessageBox message:@"Make directory"];
}

-(void) doDelete
{
    [MessageBox message:@"Delete"];
}

@end
