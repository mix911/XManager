//
//  QuestionDialog.h
//  XManager
//
//  Created by demo on 13.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface QuestionDialog1 : NSWindow
{
    IBOutlet NSTextField*   label;
    IBOutlet NSButton*      btnYes;
    IBOutlet NSButton*      btnNo;
}

-(void) setMessage:(NSString*)message;

+(QuestionDialog1*) createQuestionDialog;

@end
