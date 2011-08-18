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

-(TableView*)   table;

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
    
    // Объект url больше не нужен
    [url release];
    
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
    
    // Колонка с иконкой
    NSTableColumn* iconColumn = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithFormat:@"Icon%S", [tab_id cStringUsingEncoding:NSUnicodeStringEncoding]]];
    [[iconColumn headerCell] setStringValue:@""];
    [iconColumn setEditable:NO];
    [iconColumn setDataCell:[[NSImageCell alloc] init]];
    [iconColumn setWidth:20.0f];
    [iconColumn setResizingMask:NSTableColumnNoResizing];
    
    // Имя
    NSTableColumn* nameColumn = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithFormat:@"Name%S", [tab_id cStringUsingEncoding:NSUnicodeStringEncoding]]];
    [[nameColumn headerCell] setStringValue:@"Name"];
    [nameColumn setEditable:NO];
    [nameColumn setResizingMask:NSTableColumnAutoresizingMask | NSTableColumnUserResizingMask];
    
    // Размер
    NSTableColumn* sizeColumn = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithFormat:@"Size%S", [tab_id cStringUsingEncoding:NSUnicodeStringEncoding]]];
    [[sizeColumn headerCell] setStringValue:@"Size"];
    [sizeColumn setEditable:NO];
    [sizeColumn setResizingMask:NSTableColumnUserResizingMask];
    
    // Дата
    NSTableColumn* dateColumn = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithFormat:@"Date%S", [tab_id cStringUsingEncoding:NSUnicodeStringEncoding]]];
    [[dateColumn headerCell] setStringValue:@"Date"];
    [dateColumn setEditable:NO];
    [dateColumn setResizingMask:NSTableColumnUserResizingMask];
    
    // Тип
    NSTableColumn* typeColumn = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithFormat:@"Type%S", [tab_id cStringUsingEncoding:NSUnicodeStringEncoding]]];
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
    
    // Установим ItemManager
    [ds_delegate setItemManager:[[FileSystemManager alloc]initWithPath:path]];
    
    [table setDataSource:ds_delegate];
    // Зададим делегат
    [table setDelegate:ds_delegate];

    // Установим SidePanelProtocol
    [ds_delegate setSidePanelProtocol:self];
}

-(void) changeFolder:(NSString *)folder {
    [[tabView selectedTabViewItem] setLabel:[folder lastPathComponent]];
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

-(void) setFtpDataSource:(FtpParams *)params {
}

@end

@implementation SidePanel(Private)

-(TableView*)   table {
    NSTabViewItem*  tab_item= [tabView selectedTabViewItem];
    NSScrollView*   scroll  = [tab_item view];
    return [scroll documentView];
}

@end
