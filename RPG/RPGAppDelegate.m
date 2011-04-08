//
//  RPGAppDelegate.m
//  RPG
//
//  Created by Jonathan Diehl on 01.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

#import "RPGAppDelegate.h"
#import "PasswordGenerator.h"

#define kWindowAutosaveName @"window"
#define kNormalWindowHeight 378.0
#define kMinimizedWindowHeight 75.0
#define kMinimizedWindowOriginY 232.0

#define kWebsiteURL @"http://hci.rwth-aachen.de/rpg"

NSInteger segmentIndexToLength(NSInteger index) {
	switch(index) {
		case 0: return 6;
		case 1: return 8;
		case 2: return 10;
		case 3: return 12;
		case 4: return 14;
	}
	return 8;
}

NSInteger lengthToSegmentIndex(NSInteger length) {
	switch(length) {
		case 6: return 0;
		case 8: return 1;
		case 10: return 2;
		case 12: return 3;
		case 14: return 4;
	}
	return 1;
}

@implementation RPGAppDelegate

@synthesize hash;
@synthesize window, aboutWindow, mainView, output, lengthControl, passwordGenerator;


#pragma mark IBActions

- (IBAction)openWebsite:(NSButton *)sender;
{
	NSURL *url = [NSURL URLWithString:[sender title]];
	[[NSWorkspace sharedWorkspace] openURL:url];
}

- (IBAction)setPasswordLength:(NSButton *)sender;
{
	passwordGenerator.length = sender.title.intValue;
	[passwordGenerator generate];
}

- (IBAction)copyHash:(id)sender;
{
	NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];

	// copy the output to the paste board
	[pasteboard clearContents];
	[pasteboard writeObjects:[NSArray arrayWithObject:self.hash]];
}

- (IBAction)generate:(id)sender;
{
	[passwordGenerator generate];
}

- (IBAction)generateFromSegment:(NSSegmentedControl *)segmentControl;
{
	passwordGenerator.length = segmentIndexToLength([segmentControl selectedSegment]);
	[passwordGenerator generate];
}

- (IBAction)generateFromMenu:(NSMenuItem *)menuItem;
{
	passwordGenerator.length = [menuItem tag];
	[passwordGenerator generate];

	// update segmented control
	[self.lengthControl setSelectedSegment:lengthToSegmentIndex(self.passwordGenerator.length)];
}


#pragma mark NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// update segmented control
	[self.lengthControl setSelectedSegment:lengthToSegmentIndex(self.passwordGenerator.length)];
	
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
	// disable window frame autosaving while the window is minimized
	[self.window setFrameAutosaveName:@""];
	
	// remove focus from output field to avoid ugly text selection
	[self.window makeFirstResponder:nil];
	
	if(!windowAnimationsEnabled) return;
	
	NSRect rect;
	
	// move main view up
	rect = self.mainView.bounds;
	rect.origin.y = -kMinimizedWindowOriginY;
	self.mainView.bounds = rect;
	
	// change window size
	rect = self.window.frame;
	rect.size.height = kMinimizedWindowHeight;
	rect.origin.y -= kMinimizedWindowHeight-kNormalWindowHeight;
	[self.window setFrame:rect display:YES animate:NO];
}

- (void)applicationWillBecomeActive:(NSNotification *)notification
{
	// focus output field
	[self.window makeFirstResponder:self.output];

	if(!windowAnimationsEnabled) {
		windowAnimationsEnabled = YES;
		return;
	}
	
	NSRect rect;
	
	// change window size
	rect = self.window.frame;
	rect.size.height = kNormalWindowHeight;
	rect.origin.y += kMinimizedWindowHeight-kNormalWindowHeight;
	[self.window setFrame:rect display:YES animate:NO];
	
	// move main view up
	rect = self.mainView.bounds;
	rect.origin.y = 0.0;
	self.mainView.bounds = rect;
	self.mainView.frame = rect;
	
	// enable window frame autosaving
	[self.window setFrameAutosaveName:kWindowAutosaveName];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
	return YES;
}


#pragma mark accessors

- (void)setPassword:(NSString *)thePassword;
{
	if(password != thePassword) {
		[password autorelease];
		password = [thePassword retain];
		self.hash = [passwordGenerator generateHashFromString:password];
	}
}

- (NSString *)password;
{
	return password;
}


#pragma mark NSWindowDelegate

- (void)windowDidResignKey:(NSNotification *)notification;
{
	[self.aboutWindow orderOut:self];
}


#pragma mark PasswordGeneratorDelegate

- (void)passwordGenerator:(PasswordGenerator *)thePasswordGenerator didGeneratePassword:(NSString *)thePassword;
{
	self.password = thePassword;
	[self.window makeFirstResponder:self.output];
}

@end
