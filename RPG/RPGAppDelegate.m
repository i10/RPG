//
//  RPGAppDelegate.m
//  RPG
//
//  Created by Jonathan Diehl on 01.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

#import "RPGAppDelegate.h"
#import "PasswordGenerator.h"

#define kMinimizedWindowHeight 75.0
#define kMinimizedWindowOriginY 162.0

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

@synthesize window, aboutWindow, mainView, lengthControl, output, hash, passwordGenerator;


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
	[pasteboard writeObjects:[NSArray arrayWithObject:self.hash.stringValue]];
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
	[self.window setFrameAutosaveName:@"window"];
	windowHeight = self.window.frame.size.height;
	
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
	// remove focus from output field to avoid ugly text selection
	[self.window makeFirstResponder:nil];
	
	if(!windowAnimationsEnabled) return;
	
	CGRect rect;
	
	// move main view up
	rect = self.mainView.bounds;
	rect.origin.y = -kMinimizedWindowOriginY;
	self.mainView.bounds = rect;
	
	// change window size
	rect = self.window.frame;
	rect.size.height = kMinimizedWindowHeight;
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
	
	CGRect rect;
	
	// change window size
	rect = self.window.frame;
	rect.size.height = windowHeight;
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

- (void)passwordGenerator:(PasswordGenerator *)thePasswordGenerator didGeneratePassword:(NSString *)password;
{
	self.output.stringValue = password;
	self.hash.stringValue = [self.passwordGenerator generateHashFromString:password];
	[self.window makeFirstResponder:self.output];
}

@end
