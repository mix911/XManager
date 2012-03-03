//
//  FileManager.m
//  XManager
//
//  Created by demo on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WindowManager.h"

#import "CopyProcess.h"
#import "DetermineDirectorySizeProcess.h"

@interface WindowManager(Private)

-(void)         messageBox:(NSString*)message;
-(void)         updateContent;
-(id<Process>)  runCopyProcess:(NSArray*)selected :(NSUInteger)fullSize;

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

-(id<Process>) runCopyProcess :(NSArray*)selected :(NSUInteger)fullSize{
    
    if ([selected count] > 0) {
        CopyProcess* copy_process = [[CopyProcess alloc] init];
        [process release];
        process = copy_process;
        [copy_process runProcess:selected :fullSize];
    }
    
    [selected release];
    
    return process;
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
    [self deleteItems];
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

-(void) deleteItems {
    [deleteDialog makeKeyAndOrderFront:self];
}

-(void) determineDirectorySize:(NSInteger)row {
    
    SidePanel* active = [self activePanel];
    
    if ([active canDetermineDirectorySize]) {
        [active determineDirectorySize:row];
    }
}

-(void) determineDirectorySize {
    if ([[self activePanel] canDetermineDirectorySize]) {
        
        // Получим выделенные ряды
        NSMutableArray* selected = [[NSMutableArray alloc] init];
        [[self activePanel] selectedItems:selected];
        
        for (NSNumber* item in selected) {
            [[self activePanel] determineDirectorySize:[item longValue]];
        }
        
        [selected release];
    }
}

-(IBAction) makeDirCancel:(id)sender {
    [makeDirDialog close];
}

-(IBAction) makeDirOk:(id)sender {
    // Закроем окно
    [self makeDirCancel:sender];
}

-(void) setActiveSide :(id)panel {
    activePanel = panel;
}

-(void) insertTab {
    if ([self activePanel] == leftPanel) {
        [self setActiveSide:rightPanel];
        [rightPanel setActive:mainWindow];
    }
    else {
        [self setActiveSide:leftPanel];
        [leftPanel setActive:mainWindow];
    }
}

-(void) switchToNextTab {
    [[self activePanel] switchToNextTab];
}

-(void) switchToPrevTab {
    [[self activePanel] switchToPrevTab];
}

-(IBAction) deleteItemsNo:(id)sender {
    [deleteDialog close];
}

-(IBAction) deleteItemsYes:(id)sender {
    // Закроем диалог
    [self deleteItemsNo:sender];
}

-(IBAction) renameNo:(id)sender {
    [renameDialog close];
}

-(IBAction) renameYes:(id)sender {
    
    // Закроем диалог
    [self renameNo:sender];
    
    // Переименуем текущий объект
    NSString* error =  [[self activePanel] renameCurrent:[renameDialog dirName]];
    
    // Если не получилось
    if (error) {
        [self messageBox:error];
    }
    
    // Обновим содержимое
    [self updateContent];
}

-(IBAction) copyNo:(id)sender {
    [copyDialog close];
}

-(IBAction) copyYes:(id)sender {
    [self copyNo:sender];
}

-(IBAction) moveNo:(id)sender {
    [moveDialog close];
}

-(IBAction) moveYes:(id)sender {
    
    // Закроем диалог
    [self moveNo:sender];
}

-(IBAction) messageBoxOk:(id)sender {
    [messageBox close];
}

-(IBAction) pushToHomeFolder:(id)sender {
    SidePanel* active = [self activePanel];

    [active changeFolder:NSHomeDirectory()];
    [active updateContent];
}

-(IBAction) pushToDesktopFolder:(id)sender {
    SidePanel* active = [self activePanel];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDirectory, YES);
    
    [active changeFolder:[paths objectAtIndex:0]];
    [active updateContent];
}

-(IBAction) pushToAppsFolder:(id)sender {
    SidePanel* active = [self activePanel];
    
    [active changeFolder:@"/Applications"];
    [active updateContent];
}

-(IBAction) pushToDocumentsFolder:(id)sender {
    SidePanel* active = [self activePanel];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
    
    [active changeFolder:[paths objectAtIndex:0]];
    [active updateContent];
}

-(IBAction) pushToUtilitesFolder:(id)sender {
    SidePanel* active = [self activePanel];
    
    [active changeFolder:@"/Applications/Utilities"];
    [active updateContent];
}

-(IBAction) pushToNetworkFolder:(id)sender {
    SidePanel* active = [self activePanel];
    
    [active changeFolder:@"/Network"];
    [active updateContent];
}

-(void) pressMoveYes {
    [self moveYes:self];
}
-(void) pressCopyYes {
    [self copyYes:self];
}

-(void) pressMoveNo {
    
}

-(void) pressCopyNo {
    
}

@end
