//
//  FileManager.m
//  XManager
//
//  Created by demo on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WindowManager.h"

@interface WindowManager(Private)

-(void)         updateContent;

@end

@implementation WindowManager(Private)

-(void) updateContent {
    [leftPanel  updateContent];
    [rightPanel updateContent];
}

@end

@implementation WindowManager
//+-----------------------------------------------------------------+
//| Загрузка nib архива                                             |
//+-----------------------------------------------------------------+
-(void) awakeFromNib {
    
    // Загрузим родителя
    [super awakeFromNib];
    
    // Если это первый запуск
    if(![self loadLastSesstion]) {
        // Получим текущую дерикторию
//        NSString* cur_dir = [[[NSURL alloc] initWithString:[[NSFileManager defaultManager] currentDirectoryPath]] path];
        
        NSString* cur_dir = @"/Users/demo/QtSDK";
        
        // Установи менеджер окон
        [leftPanel  setWindowManager:self];
        [rightPanel setWindowManager:self];
        
        // Установим директории по умолчанию
        [leftPanel  addTab:cur_dir];
        [rightPanel addTab:cur_dir];
        
        [cur_dir release];
    }
}
//+-----------------------------------------------------------------+
//| Загрузка последней сессии                                       |
//+-----------------------------------------------------------------+
-(bool) loadLastSesstion 
{
    return false;
}

-(SidePanel*) activePanel 
{
    return activePanel;
}

-(void) setActiveSide :(id)panel 
{
    activePanel = panel;
}

-(void) insertTab 
{
    if ([self activePanel] == leftPanel) {
        [self setActiveSide:rightPanel];
        [rightPanel setActive:mainWindow];
    }
    else {
        [self setActiveSide:leftPanel];
        [leftPanel setActive:mainWindow];
    }
}

-(void) switchToNextTab 
{
    [[self activePanel] switchToNextTab];
}

-(void) switchToPrevTab 
{
    [[self activePanel] switchToPrevTab];
}

@end
