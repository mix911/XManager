//
//  FileManager.m
//  XManager
//
//  Created by demo on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WindowManager.h"

@interface WindowManager(Private)

-(void) messageBox:(NSString*)message;
-(void) updateContent;

@end

@implementation WindowManager(Private)

-(void) messageBox:(NSString *)message {
    [messageBox makeKeyAndOrderFront:self];
    [messageBox setMessage:message];
}

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
        NSString* cur_dir = [[[NSURL alloc] initWithString:[[NSFileManager defaultManager] currentDirectoryPath]] path];
        
        cur_dir = @"/Users/demo/QtSDK";
        
        // Установи менеджер окон
        [leftPanel  setWindowManager:self];
        [rightPanel setWindowManager:self];
        
        // Установим директории по умолчанию
        [leftPanel  addTab:cur_dir];
        [rightPanel addTab:cur_dir];
    }
    
}
//+-----------------------------------------------------------------+
//| Загрузка последней сессии                                       |
//+-----------------------------------------------------------------+
-(bool) loadLastSesstion {
    return false;
}
//+-----------------------------------------------------------------+
//| Нажатие F2 - Rename                                             |
//+-----------------------------------------------------------------+
-(IBAction) pushRename:(id)sender {
    [self renameItems];
}
//+-----------------------------------------------------------------+
//| Нажатие F5 - Copy                                               |
//+-----------------------------------------------------------------+
-(IBAction) pushCopy:(id)sender {
    [self copyItems];
}
//+-----------------------------------------------------------------+
//| Нажатие F6 - Move                                               |
//+-----------------------------------------------------------------+
-(IBAction) pushMove:(id)sender {
    [self moveItems];
}
//+-----------------------------------------------------------------+
//| Нажатие F7 - MkDir                                              |
//+-----------------------------------------------------------------+
-(IBAction) pushMkDir:(id)sender {
    [self makeDirItems];
}
//+-----------------------------------------------------------------+
//| Нажатие F8 - Delete                                             |
//+-----------------------------------------------------------------+
-(IBAction) pushDelete:(id)sender {
    [self deleleItems];
}
//+-----------------------------------------------------------------+
//| Нажание на соединение с ftp                                     |
//+-----------------------------------------------------------------+
-(IBAction) pushFtp:(id)sender {
    [networkConnectionPanel makeKeyAndOrderFront:self];
}

-(IBAction) networkConnectionCancel:(id)sender {
    [networkConnectionPanel close];
}

-(IBAction) networkConnectionOk:(id)sender {

    // Закроем окно
    [self networkConnectionCancel:sender];
}

-(SidePanel*) activePanel {
    return activePanel;
}

-(void) renameItems {
    [renameDialog makeKeyAndOrderFront:self];
}

-(void) copyItems {
    [copyDialog makeKeyAndOrderFront:self];
}

-(void) moveItems {
    [moveDialog makeKeyAndOrderFront:self];
}

-(void) makeDirItems {
    [makeDirDialog makeKeyAndOrderFront:self];
}

-(void) deleleItems {
    [deleteDialog makeKeyAndOrderFront:self];
}

-(IBAction) makeDirCancel:(id)sender {
    [makeDirDialog close];
}

-(IBAction) makeDirOk:(id)sender {
    // Закроем окно
    [self makeDirCancel:sender];
    
    // Получим имя создаваемого каталога
    NSString* dir_name = [makeDirDialog dirName];
    
    // Если имя не было указано
    if ([dir_name isEqualToString:@""]) {
        return;
    }
    
    // Получим активную панель
    SidePanel* active = [self activePanel];
    
    // Попытаемся создать каталог
    NSString* error = [active makeDir:dir_name];

    // Если произошла ошибка
    if (error) {
        [self messageBox:error];
    }
    
    // Обновим содержимое
    [self updateContent];
}

-(void) setActiveSide :(id)panel {
    activePanel = panel;
}

-(IBAction) deleteItemsNo:(id)sender {
    [deleteDialog close];
}

-(IBAction) deleteItemsYes:(id)sender {
    // Закроем диалог
    [self deleteItemsNo:sender];
    
    // Удалим все что выделено в активной панели
    NSString* error = [activePanel deleteSelected];
    
    // Если не получилось
    if (error) {
        [self messageBox:error];
    }

    // Обновим содержимое
    [self updateContent];
}

-(IBAction) messageBoxOk:(id)sender {
    [messageBox close];
}
@end
