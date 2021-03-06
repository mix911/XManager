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
#import "MainWindow.h"
#import "TabsHeaders.h"
#import "ConfigManager.h"
#import "FileSystemItem.h"
#import "MessageBox.h"

#include "MacSys.h"


@interface SidePanel(Private)

-(DataSourceAndTableViewDelegate*) currentDataSource;

@end

@implementation SidePanel(Private)

-(DataSourceAndTableViewDelegate*) currentDataSource 
{
    TableView* table = [self table];
    return (DataSourceAndTableViewDelegate*)[table dataSource];
}

-(TableView*) tableByIndex:(NSUInteger)index
{
    NSTabViewItem* tab_item = [self tabViewItemAtIndex:index];
    return [[tab_item view] documentView];
}

@end

@implementation SidePanel

- (id)init 
{
    self = [super init];
    if (self) {
        nextTabId = 0;
    }
    
    return self;
}

-(TableView*) table 
{
    NSTabViewItem* tab_item = [self selectedTabViewItem];
    NSScrollView*   scroll  = [tab_item view];
    return [scroll documentView];
}

-(void) awakeFromNib
{
}

-(void) addTab:(NSString *)path :(enum EFileSystemColumnId)order
{        
    if (path == nil) {
        return;
    }
    
    // Получим текущий для вкладки каталог
    NSString* dir = [path lastPathComponent];
    
    // Сгенерируем идентификатор для вкладки
    NSString* tab_id =  [NSString stringWithFormat:@"%s%i",
                         [[self identifier] cStringUsingEncoding:NSUnicodeStringEncoding], [self nextTabId]];
    
    // Создадим item вкладки
    NSTabViewItem* item = [[NSTabViewItem alloc] initWithIdentifier:tab_id];
    [item setLabel:dir];
    
    // Создадим и настроим scroll view
    NSScrollView* scroll_view = [[NSScrollView alloc] initWithFrame:[self bounds]];
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
    
    [self setFocusRingType:NSFocusRingTypeNone];
    
    // Добавим вкладку
    [self addTabViewItem:item];
    [self selectTabViewItem:item];
    
    // Зададим источник данных
    DataSourceAndTableViewDelegate* ds_delegate = [[DataSourceAndTableViewDelegate alloc] initWithPath:path];
    [ds_delegate sortData:order];
    
    // Менеджер файловой системы
    FileSystemManager* fileSystemManager = [[FileSystemManager alloc] initWithPath:path];
    
    // Установим ItemManager
    [ds_delegate setItemManager:fileSystemManager];
    
    [table setDataSource:ds_delegate];
    // Зададим делегат
    [table setDelegate:[ds_delegate retain]];

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
    
    [tabs addTab:dir];
    [tabs selectTab:[self indexOfTabViewItem:[self selectedTabViewItem]]];
    
    [self setActive:mainWindow];
}

-(void) setTabHeaderTitle:(NSString *)title 
{
    [[self selectedTabViewItem] setLabel:title];
    
    [tabs setTitle:[tabs currentTab] :title];
}

-(int) nextTabId 
{
    return ++nextTabId;
}

-(void) addTab:(enum EFileSystemColumnId)order
{
    TableView* table = [self table];
    
    DataSourceAndTableViewDelegate* ds = (DataSourceAndTableViewDelegate*)[table dataSource];
    NSString* path = [ds currentPath];
    [self addTab:path:order];
}

-(void) closeCurrentTab 
{
    
    // Если осталась только одна вкладка
    if ([[self tabViewItems] count] == 1) {
        return;
    }
    
    // Закроем текущую вкладку
    [self removeTabViewItem:[self selectedTabViewItem]];
    [self setActive:mainWindow];
    [tabs deleteCurrentTab];
    [tabs selectTab:[self indexOfTabViewItem:[self selectedTabViewItem]]];
}

-(bool) enterToRow:(NSInteger)row 
{
    TableView* table = [self table];
    DataSourceAndTableViewDelegate* ds = (DataSourceAndTableViewDelegate*)[table dataSource];
    
    if ([ds enterToRow:row]) {
        [self setTabHeaderTitle:[[ds currentPath] lastPathComponent]];
        return true;
    }
    
    return false;
}

-(bool) goUp 
{
    TableView* table = [self table];
    DataSourceAndTableViewDelegate* ds = (DataSourceAndTableViewDelegate*)[table dataSource];
    return [ds goUp];
}

-(void) invertSelection:(NSInteger)row 
{
    DataSourceAndTableViewDelegate* ds = [self currentDataSource];
    [ds invertSelection:row];
}

-(void) keyDown:(NSEvent *)event
{
    TableView* table = nil;
    switch ([event keyCode]) {
            
        case VK_TAB:
            [mainWindow insertTab];
            return;
            
        case VK_SPACE:
            return;
            
        case VK_ENTER:
            table = [self table];
            if ([self enterToRow:[table selectedRow]]) {
                [table reloadData];
                [table selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
            }
            return;
            
        case VK_W:
            if ([event modifierFlags] & NSCommandKeyMask) {
                [self closeCurrentTab];
            }
            return;
            
        case VK_T:
            if ([event modifierFlags] & NSCommandKeyMask) {
                if ([tabs countOfTabs] < 4) {
                    [self addTab:((DataSourceAndTableViewDelegate*)[[self table] dataSource]).order];
                }
            }
            return;
            
        default:
            [mainWindow postKeyDown:event];
            return;
    }
    
    [super keyDown:event];
}

-(void) setActive :(NSWindow*)window
{
    [window makeFirstResponder:[self table]];
}

-(void) updateContent 
{
    for (NSTabViewItem* item in [self tabViewItems]) {

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
-(NSString*) currentPath {
    return [[self currentDataSource] currentPath];
}

-(bool) changeFolder:(NSString *)folder {
    [self setTabHeaderTitle:[folder lastPathComponent]];
    return [[self currentDataSource] changeFolder:folder];
}

-(void) switchToNextTab 
{
    if ([self indexOfTabViewItem:[self selectedTabViewItem]] == [self numberOfTabViewItems] - 1) {
        [self selectFirstTabViewItem:self];
        [tabs selectTab:0];
    }
    else {
        [self selectNextTabViewItem:self];
        [tabs selectTab:[tabs currentTab] + 1];
    }
}

-(void) switchToPrevTab 
{
    if ([self indexOfTabViewItem:[self selectedTabViewItem]] == 0) {
        [self selectLastTabViewItem:self];
        [tabs selectTab:[tabs countOfTabs] - 1];
    }
    else {
        [self selectPreviousTabViewItem:self];
        [tabs selectTab:[tabs currentTab] - 1];
    }
}

-(bool) selectedItems:(NSMutableArray*)selected 
{
    if (selected == nil) {
        return false;
    }
    
    // Отчистим входящий массив
    [selected removeAllObjects];
    
    // Получим источник данных
    DataSourceAndTableViewDelegate* ds = [self currentDataSource];
    
    // Получим таблицу
    TableView* table = [self table];
    
    // Получим выделенные объекты
    [ds selectedItems:selected :[table selectedRow]];
    
    return [selected count] != 0;
}

-(void) updateTable 
{
    [[self table] reloadData];
}

-(id) saveSettings
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray* tabs_arr = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < [self numberOfTabViewItems]; ++i) {
        
        TableView* table = [self tableByIndex:i];
        DataSourceAndTableViewDelegate* ds = (DataSourceAndTableViewDelegate*)[table dataSource];
        
        NSMutableDictionary* tab_dict = [[NSMutableDictionary alloc] init];
        
        NSString* path = [ds currentPath];
        
        [tab_dict setValue:path  forKey:@"Path"];
        [tab_dict setValue:[NSNumber numberWithInt:[ds order]] forKey:@"Order"];
        
        [tabs_arr addObject:tab_dict];
        [tab_dict release];
    }
    
    [dict setValue:tabs_arr forKey:@"Tabs"];
    
    [tabs_arr release];
    
    [dict setValue:[NSNumber numberWithUnsignedInteger:[tabs currentTab]] forKey:@"SelectedTab"];
    
    return [dict autorelease];
}

-(void) loadSettings:(NSDictionary*)settings
{
    if (settings == nil) return;
    
    NSArray* all_tabs = [settings objectForKey:@"Tabs"];
    
    if (all_tabs && [all_tabs count] != 0) {
        
        for (NSDictionary* dict in all_tabs) {
            
            enum EFileSystemColumnId order = FS_NAME;
            NSNumber* number = [dict objectForKey:@"Order"];
            
            if (number) {
                order = (enum EFileSystemColumnId)[number intValue];
            }
            
            [self addTab:[dict objectForKey:@"Path"]:order];
        }
        
        NSNumber* selected_tab = [settings objectForKey:@"SelectedTab"];
        if (selected_tab) {
            [self selectTabViewItemAtIndex:[selected_tab unsignedIntegerValue]];
            [tabs selectTab:[selected_tab unsignedIntegerValue]];
        }
    }
    else {        
        // Установим директории по умолчанию
        [self  addTab:@"/Users/demo/QtSDK":FS_NAME];
    }
}

-(DataSourceAndTableViewDelegate*) dataSource
{
    return [self currentDataSource];
}

@end