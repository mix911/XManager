//
//  SidePanel.m
//  XManager
//
//  Created by demo on 06.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SidePanel.h"

#import "TableView.h"
#import "DataSourceAndTableViewDelegate.h"

#import "FileSystemManager.h"
#import "FtpManager.h"

@interface SidePanel(Private)

//-(TableView*)   table;
-(DataSourceAndTableViewDelegate*) currentDataSource;

@end

@implementation SidePanel

- (id)init {
    self = [super init];
    if (self) {
        nextTabId = 0;
    }
    
    return self;
}

-(void) dealloc {
    [tabView release];
}

-(void) addTab:(NSString *)path {
    
    // Если tabView ещё не создан, создадим его
    if (tabView==nil) {
        tabView = [[NSTabView alloc] init];
        [self addSubview:tabView];
        [tabView setFrame:[self bounds]];
        [self setAutoresizesSubviews:YES];
        [tabView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    }
    
    // Создадим url
    NSURL* url = [[NSURL alloc] initWithString:path];
    
    // Используя объект url получим текущий для вкладки каталог
    NSString* dir = [url lastPathComponent];
    
    // Сгенерируем идентификатор для вкладки
    NSString* tab_id =  [NSString stringWithFormat:@"%S%i", [[self identifier] cStringUsingEncoding:NSUnicodeStringEncoding], [self nextTabId]];
    
    // Создадим item вкладки
    NSTabViewItem* item = [[NSTabViewItem alloc] initWithIdentifier:tab_id];
    [item setLabel:dir];
    
    
    // Создадим и настроим scroll view
    NSScrollView* scroll_view = [[NSScrollView alloc] initWithFrame:[tabView bounds]];
    [scroll_view setAutohidesScrollers:NO];
    [scroll_view setBorderType:NSBezelBorder];
    [scroll_view setHasVerticalScroller:YES];
    [scroll_view setHasHorizontalScroller:YES];
    
    [item setView:scroll_view];
    
    // Создадим таблицу и настроим таблицу
    TableView* table = [[TableView alloc] init];
    [table setFrame:[[scroll_view contentView] bounds]];
    [table setSidePanel:self];
            
    // Добавим таблицу в scroll view
    [scroll_view setDocumentView:table];
    
    // Иконка
    NSImageCell* icell = [[NSImageCell alloc] init];
    
    // Колонка с иконкой
    NSTableColumn* iconColumn = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithFormat:@"Icon%@", tab_id]];
    [[iconColumn headerCell] setStringValue:@""];
    [iconColumn setEditable:NO];
    [iconColumn setDataCell:icell];
    [iconColumn setWidth:20.0f];
    [iconColumn setResizingMask:NSTableColumnNoResizing];
    
    // Имя
    NSTableColumn* nameColumn = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithFormat:@"Name%@", tab_id]];
    [[nameColumn headerCell] setStringValue:@"Name"];
    [nameColumn setEditable:NO];
    [nameColumn setResizingMask:NSTableColumnAutoresizingMask | NSTableColumnUserResizingMask];
    
    // Размер
    NSTableColumn* sizeColumn = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithFormat:@"Size%@", tab_id]];
    [[sizeColumn headerCell] setStringValue:@"Size"];
    [sizeColumn setEditable:NO];
    [sizeColumn setResizingMask:NSTableColumnUserResizingMask];
    
    // Дата
    NSTableColumn* dateColumn = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithFormat:@"Date%@", tab_id]];
    [[dateColumn headerCell] setStringValue:@"Date"];
    [dateColumn setEditable:NO];
    [dateColumn setResizingMask:NSTableColumnUserResizingMask];
    
    // Тип
    NSTableColumn* typeColumn = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithFormat:@"Type%@", tab_id]];
    [[typeColumn headerCell] setStringValue:@"Type"];
    [typeColumn setEditable:NO];
    [typeColumn setResizingMask:NSTableColumnUserResizingMask];
    
    // Добавим колонки
    [table addTableColumn:iconColumn];
    [table addTableColumn:nameColumn];
    [table addTableColumn:sizeColumn];
    [table addTableColumn:dateColumn];
    [table addTableColumn:typeColumn];
    
    [tabView setFocusRingType:NSFocusRingTypeNone];
    
    // Добавим вкладку
    [tabView addTabViewItem:item];
    [tabView selectTabViewItem:item];
    
    // Зададим источник данных
    DataSourceAndTableViewDelegate* ds_delegate = [[DataSourceAndTableViewDelegate alloc] initWithPath:path];
    
    // Менеджер файловой системы
    FileSystemManager* fileSystemManager = [[FileSystemManager alloc] initWithPath:path];
    
    // Установим ItemManager
    [ds_delegate setItemManager:fileSystemManager];
    
    [table setDataSource:ds_delegate];
    // Зададим делегат
    [table setDelegate:[ds_delegate retain]];

    // Установим SidePanelProtocol
    [ds_delegate setSidePanelProtocol:self];

    [url                release];
    [item               release];
    [ds_delegate        release];
    [table              release];
    [iconColumn         release];
    [nameColumn         release];
    [sizeColumn         release];
    [dateColumn         release];
    [typeColumn         release];
    [scroll_view        release];
    [icell              release];
    [fileSystemManager  release];
}

-(void) setTabHeaderTitle:(NSString *)title {
    [[tabView selectedTabViewItem] setLabel:title];
}

-(int) nextTabId {
    return ++nextTabId;
}

-(void) addTabFromCurrent {
    TableView* table = [self table];
    
    DataSourceAndTableViewDelegate* ds = (DataSourceAndTableViewDelegate*)[table dataSource];
    NSString* path = [ds currentPath];
    [self addTab:path];
}

-(void) closeCurrentTab {
    
    // Если осталась только одна вкладка
    if ([[tabView tabViewItems] count] == 1) {
        return;
    }
    
    // Закроем текущую вкладку
    [tabView removeTabViewItem:[tabView selectedTabViewItem]];
}

-(bool) enterToRow:(NSInteger)row {
    TableView* table = [self table];
    DataSourceAndTableViewDelegate* ds = (DataSourceAndTableViewDelegate*)[table dataSource];
    return [ds enterToRow:row];
}

-(bool) goUp {
    TableView* table = [self table];
    DataSourceAndTableViewDelegate* ds = (DataSourceAndTableViewDelegate*)[table dataSource];
    return [ds goUp];
}

-(void) invertSelection:(NSInteger)row {
    DataSourceAndTableViewDelegate* ds = [self currentDataSource];
    [ds invertSelection:row];
}

-(void) postKeyDown:(NSEvent *)event {
    
    switch ([event keyCode]) {
            
        case 0xD:   // W
            
            if ([event modifierFlags] & NSCommandKeyMask) {
                [self closeCurrentTab];
            }
            break;
            
        case 0x11:  // T
            
            if ([event modifierFlags] & NSCommandKeyMask) {
                [self addTabFromCurrent];
            }
            break;
            
        case 120:   // F2
            [windowManager renameItems];
            break;
            
        case 96:    // F5
            [windowManager copyItems];
            break;
            
        case 97:    // F6
            [windowManager moveItems];
            break;
            
        case 98:    // F7
            [windowManager makeDirItems];
            break;
            
        case 100:   // F8
            [windowManager deleleItems];
            break;
            
        case 48:    // Tab - мы сдесь только когда не зажат контрол TODO: добавить вывод в лог
            [windowManager insertTab];
            break;
            
        default:
            break;
    }
}

-(void) setActive {
    [windowManager setActiveSide:self];
}

-(void) setWindowManager:(id<WindowManagerProtocol>)manager {
    windowManager = manager;
}

-(void) updateContent {
    for (NSTabViewItem* item in [tabView tabViewItems]) {

        // Получим NSScrollView
        NSScrollView* scroll_view = [item view];
        
        // Получим таблицу
        TableView* table = [scroll_view documentView];
        
        // Получим источник данных
        DataSourceAndTableViewDelegate* ds = (DataSourceAndTableViewDelegate*)[table dataSource];
        
        // Обновим данные
        [ds updateItemsList];
        
        // Обновим таблицу
        [table reloadData];
    }
}

-(NSString*) makeDir:(NSString *)name {
    return [[self currentDataSource] makeDir:name];
}

-(NSString*) deleteSelected {
    return [[self currentDataSource] deleteSelected];
}

-(NSString*) renameCurrent:(NSString*)name {
    return [[self currentDataSource] renameCurrent:name :[[self table] selectedRow]];
}

-(NSString*) copySelected:(NSString *)dest {
    return [[self currentDataSource] copySelected:dest];
}

-(NSString*) moveSelected:(NSString *)dest {
    return [[self currentDataSource] moveSelected:dest];
}

-(NSString*) currentPath {
    return [[self currentDataSource] currentPath];
}

-(bool) changeFolder:(NSString *)folder {
    [self setTabHeaderTitle:[folder lastPathComponent]];
    return [[self currentDataSource] changeFolder:folder];
}

-(TableView*)   table {
    NSTabViewItem*  tab_item= [tabView selectedTabViewItem];
    NSScrollView*   scroll  = [tab_item view];
    return [scroll documentView];
}

@end

@implementation SidePanel(Private)

-(DataSourceAndTableViewDelegate*) currentDataSource {
    TableView* table = [self table];
    return (DataSourceAndTableViewDelegate*)[table dataSource];
}

//-(TableView*)   table {
//    NSTabViewItem*  tab_item= [tabView selectedTabViewItem];
//    NSScrollView*   scroll  = [tab_item view];
//    return [scroll documentView];
//}

@end
