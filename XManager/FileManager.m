//
//  FileManager.m
//  XManager
//
//  Created by demo on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager
//+-----------------------------------------------------------------+
//| Конструктор по умолчанию                                        |
//+-----------------------------------------------------------------+
- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
//+-----------------------------------------------------------------+
//| Загрузка nib архива                                             |
//+-----------------------------------------------------------------+
-(void) awakeFromNib {
    
    [super awakeFromNib];
    
    // Если это первый запуск
    if(![self loadLastSesstion]) {
        // Получим текущую дерикторию
        NSString* cur_dir = [[[NSURL alloc] initWithString:[[NSFileManager defaultManager] currentDirectoryPath]] path];
        
        cur_dir = @"/Users/demo/QtSDK";
        
        // Установим директории по умолчанию
        [leftPanel  addTab:cur_dir :@"Left"];
        [rightPanel addTab:cur_dir :@"Right"];
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
    
}
//+-----------------------------------------------------------------+
//| Нажатие F5 - Copy                                               |
//+-----------------------------------------------------------------+
-(IBAction) pushCopy:(id)sender {
    
}
//+-----------------------------------------------------------------+
//| Нажатие F6 - Move                                               |
//+-----------------------------------------------------------------+
-(IBAction) pushMove:(id)sender {
    
}
//+-----------------------------------------------------------------+
//| Нажатие F7 - MkDir                                              |
//+-----------------------------------------------------------------+
-(IBAction) pushMkDir:(id)sender {
    
}
//+-----------------------------------------------------------------+
//| Нажатие F8 - Delete                                             |
//+-----------------------------------------------------------------+
-(IBAction) pushDelete:(id)sender {
    
}

@end
