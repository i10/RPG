//
//  HUDButton.h
//  RPG
//
//  Created by Jonathan Diehl on 03.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface HUDButton : NSControl {
	NSView *contentView;
	NSTextField *labelView;
	
	NSColor *strokeColor;
	NSColor *fillColor;
	
	NSInteger state;
@private
}

@property(readonly, nonatomic) NSView *contentView;
@property(readonly, nonatomic) NSTextField *labelView;
@property(retain, nonatomic) NSString *title;

@property(retain, nonatomic) NSColor *strokeColor;
@property(retain, nonatomic) NSColor *fillColor;
@property(retain, nonatomic) NSColor *shadowColor;

@property(assign, nonatomic) NSInteger state;

@end
