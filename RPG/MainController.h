//
//  MainController.h
//  RPG
//
//  Created by Jonathan Diehl on 06.01.09.
//  Copyright 2009 Media Computing Group. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MainController : NSObject {
	IBOutlet NSWindow *window;
	IBOutlet NSTextField *result;
	IBOutlet NSPanel *aboutPanel;

	NSUserDefaults *defaults;
}

- (IBAction)generate:(id)sender;
- (IBAction)showAbout:(id)sender;

@end
