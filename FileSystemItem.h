//
//  FileSystemItem.h
//  XManager
//
//  Created by demo on 10.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSystemItem : NSObject {
    NSString*   fullPath;
    NSString*   name;
    NSString*   size;
    NSString*   date;
    NSString*   type;
    bool        isDir;
}

@property(retain)   NSString*   fullPath;
@property(retain)   NSString*   name;
@property(retain)   NSString*   size;
@property(retain)   NSString*   date;
@property(retain)   NSString*   type;
@property           bool        isDir;

-(NSComparisonResult) compareByName :(FileSystemItem*)rgh;
-(NSComparisonResult) compareBySize :(FileSystemItem*)rgh;
-(NSComparisonResult) compareByDate :(FileSystemItem*)rgh;
-(NSComparisonResult) compareByType :(FileSystemItem*)rgh;

@end
