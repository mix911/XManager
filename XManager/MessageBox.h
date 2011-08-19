//
//  MessageBox.h
//  XManager
//
//  Created by demo on 19.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface MessageBox : NSPanel {
    IBOutlet    NSTextField*    message;
}

-(void) setMessage :(NSString*)message;

@end
