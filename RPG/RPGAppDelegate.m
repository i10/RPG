//
//  RPGAppDelegate.m
//  RPG
//
//  Created by Jonathan Diehl on 01.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

#import "RPGAppDelegate.h"
#import "PasswordGenerator.h"

#define kMinimizedDeltaSize 245.0

@implementation RPGAppDelegate

@synthesize window, aboutWindow, mainView, output, passwordGenerator;


#pragma mark IBActions

- (IBAction)setPasswordLength:(NSButton *)sender;
{
	passwordGenerator.length = sender.title.intValue;
	[passwordGenerator generate];
}

- (IBAction)copyOutput:(id)sender;
{
	NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];

	// copy the output to the paste board
	[pasteboard clearContents];
	[pasteboard writeObjects:[NSArray arrayWithObject:self.output.stringValue]];
}

- (IBAction)generate:(id)sender;
{
	[passwordGenerator generate];
}

- (IBAction)generate6:(id)sender;
{
	passwordGenerator.length = 6;
	[passwordGenerator generate];
}

- (IBAction)generate8:(id)sender;
{
	passwordGenerator.length = 8;
	[passwordGenerator generate];
}

- (IBAction)generate12:(id)sender;
{
	passwordGenerator.length = 12;
	[passwordGenerator generate];
}

- (IBAction)generate24:(id)sender;
{
	passwordGenerator.length = 24;
	[passwordGenerator generate];
}

- (IBAction)generate32:(id)sender;
{
	passwordGenerator.length = 32;
	[passwordGenerator generate];
}


#pragma mark NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// init randomizer
	srandom((int)time(0));
	
	[self.window setFrameAutosaveName:@"window"];
	// generate password
	[passwordGenerator generate];
}

- (void)applicationWillTerminate:(NSNotification *)notification;
{
	windowAnimationsEnabled = NO;
	[passwordGenerator save];
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
	if(!windowAnimationsEnabled) return;
	
	CGRect rect;
	
	// move main view up
	rect = self.mainView.bounds;
	rect.origin.y = -kMinimizedDeltaSize;
	self.mainView.bounds = rect;
	
	// change window size
	rect = self.window.frame;
	rect.size.height -= kMinimizedDeltaSize;
	[self.window setFrame:rect display:YES animate:NO];
}

- (void)applicationWillBecomeActive:(NSNotification *)notification
{
	if(!windowAnimationsEnabled) {
		windowAnimationsEnabled = YES;
		return;
	}
	
	CGRect rect;
	
	// change window size
	rect = self.window.frame;
	rect.size.height += kMinimizedDeltaSize;
	[self.window setFrame:rect display:YES animate:NO];
	
	// move main view up
	rect = self.mainView.bounds;
	rect.origin.y = 0.0;
	self.mainView.bounds = rect;
	self.mainView.frame = rect;
	
}


#pragma mark NSWindowDelegate

- (void)windowDidResignKey:(NSNotification *)notification;
{
	[self.aboutWindow orderOut:self];
}


#pragma mark PasswordGeneratorDelegate

- (void)passwordGenerator:(PasswordGenerator *)passwordGenerator didGeneratePassword:(NSString *)password;
{
	self.output.stringValue = password;
	[self.output becomeFirstResponder];
}

@end
