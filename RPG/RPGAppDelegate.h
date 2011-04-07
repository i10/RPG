//
//  RPGAppDelegate.h
//  RPG
//
//  Created by Jonathan Diehl on 01.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PasswordGenerator.h"

@interface RPGAppDelegate : NSObject <NSApplicationDelegate, PasswordGeneratorDelegate> {
@private
	NSWindow *window;
	NSWindow *aboutWindow;
	NSView *mainView;
	NSSegmentedControl *lengthControl;
	NSTextField *output;
	NSTextField *hash;
	PasswordGenerator *passwordGenerator;
	BOOL windowAnimationsEnabled;
	
	CGFloat windowHeight;
}

@property(assign) IBOutlet NSWindow *window;
@property(assign) IBOutlet NSWindow *aboutWindow;
@property(assign) IBOutlet NSView *mainView;
@property(assign) IBOutlet NSSegmentedControl *lengthControl;
@property(assign) IBOutlet NSTextField *output;
@property(assign) IBOutlet NSTextField *hash;
@property(assign) IBOutlet PasswordGenerator *passwordGenerator;

- (IBAction)generate:(id)sender;
- (IBAction)generateFromMenu:(NSMenuItem *)menuItem;

- (IBAction)copyHash:(id)sender;

@end
