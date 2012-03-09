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

//+-----------------------------------------------------------------+
//| Управление главным окном, окном настроек и прочих диалогов      |
//+-----------------------------------------------------------------+
@interface WindowManager : NSObject 
{
    IBOutlet    SidePanel*                  leftPanel;              // Левая панель
    IBOutlet    SidePanel*                  rightPanel;             // Правая панель
                SidePanel*                  activePanel;            // Активная панель
    IBOutlet    NSWindow*                   mainWindow;             // Главное окно
}

-(void) awakeFromNib;

-(bool) loadLastSesstion;

-(SidePanel*) activePanel;

-(void) insertTab;
-(void) setActiveSide:(id)panel;
-(void) switchToNextTab;
-(void) switchToPrevTab;

@end
