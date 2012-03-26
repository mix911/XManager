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
    
//    NSString* cur_dir = @"/Users/demo/QtSDK";
    
//    // Установим директории по умолчанию
//    [leftPanel  addTab:cur_dir];
//    [rightPanel addTab:cur_dir];
    
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

-(void) postKeyDown:(NSEvent *)event
{
    [super keyDown:event];
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

@end
