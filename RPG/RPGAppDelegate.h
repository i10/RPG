//
//  RPGAppDelegate.h
//  RPG
//
//  Created by Jonathan Diehl on 01.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PasswordGenerator.h"

@interface RPGAppDelegate : NSObject <NSApplicationDelegate> {
	NSString *password;
	NSString *hash;
@private
	NSWindow *window;
	NSWindow *aboutWindow;
	NSView *mainView;
	NSTextField *output;
	NSSegmentedControl *lengthControl;
	PasswordGenerator *passwordGenerator;
	BOOL windowAnimationsEnabled;
}

@property(retain) NSString *password;
@property(retain) NSString *hash;

@property(assign) IBOutlet NSWindow *window;
@property(assign) IBOutlet NSWindow *aboutWindow;
@property(assign) IBOutlet NSView *mainView;
@property(assign) IBOutlet NSSegmentedControl *lengthControl;
@property(assign) IBOutlet NSTextField *output;
@property(retain) IBOutlet PasswordGenerator *passwordGenerator;

- (IBAction)generate:(id)sender;
- (IBAction)generateAndCopy:(id)sender;
- (IBAction)generateFromMenu:(NSMenuItem *)menuItem;
- (IBAction)copyHash:(id)sender;
- (IBAction)openWebsite:(id)sender;

@end
