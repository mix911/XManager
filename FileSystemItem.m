//
//  FileSystemItem.m
//  XManager
//
//  Created by demo on 10.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileSystemItem.h"

@implementation FileSystemItem

- (id)init {
    self = [super init];
    if (self) {
        isSelected = false;
    }
    
    return self;
}

@synthesize fullPath;
@synthesize name;
@synthesize size;
@synthesize date;
@synthesize type;
@synthesize isDir;
@synthesize isSelected;

-(NSComparisonResult) compareByName :(FileSystemItem*)rgh {

    if ([self.name isEqualToString:@".."]) {
        return NSOrderedAscending;
    }
    
    if([rgh.name isEqualToString:@".."]) {
        return NSOrderedDescending;
    }
    
    // Каталог с каталогом или файл с файлом сравниваем по имени
    if ((self.isDir && rgh.isDir) || (!self.isDir && !rgh.isDir)) {
        return [self.name compare:rgh.name];
    }
    
    if (self.isDir) {
        return NSOrderedAscending;
    }
    
    return NSOrderedDescending;
}

-(NSComparisonResult) compareBySize:(FileSystemItem *)rgh {
    if(self.isDir || rgh.isDir)
        return [self compareByName:rgh];
    
    NSInteger ilft = [self.size integerValue];
    NSInteger irgh = [rgh.size  integerValue];
    
    if(ilft < irgh)
        return NSOrderedAscending;
    
    if(ilft > irgh)
        return NSOrderedDescending;
    
    return NSOrderedSame;
}

-(NSComparisonResult) compareByDate:(FileSystemItem *)rgh {
    if(self.isDir || rgh.isDir)
        return [self compareByName:rgh];
    
    return [self.date compare:rgh.date];
}

-(NSComparisonResult) compareByType:(FileSystemItem *)rgh {
    
    if(self.isDir || rgh.isDir)
        return [self compareByName:rgh];
    
    return [self.type compare:rgh.type];
}

@end
