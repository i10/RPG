//
//  MultiButtonView.m
//  RPG
//
//  Created by Jonathan Diehl on 03.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

#import "HUDButton.h"
#import "GraphicsHelpers.h"

#define kFillColor 0.8
#define kStrokeColor 0.6
#define kTextColor 0.0
#define kShadowColor 0.2
#define kShadowBlur 1.0
#define kShadowSize 4.0

@interface HUDButton ()
- (void)drawOffStateInRect:(CGRect)dirtyRect context:(CGContextRef)context;
- (void)drawOnStateInRect:(CGRect)dirtyRect context:(CGContextRef)context;
@end

@implementation HUDButton

@synthesize contentView;
@synthesize strokeColor, fillColor, shadowColor;


#pragma mark events

- (void)mouseDown:(NSEvent *)theEvent;
{
	self.state = NSOnState;
}

- (void)mouseUp:(NSEvent *)theEvent;
{
	self.state = NSOffState;
}

#pragma mark accessors

// set title -> update label
- (void)setTitle:(NSString *)title;
{
	// create an attributed string for formatting
	NSMutableAttributedString *mutTitle = [[NSMutableAttributedString alloc] initWithString:title];
	
	// format the attributed string
	NSRange range = NSMakeRange(0, [title length]);
	[mutTitle setAlignment:NSCenterTextAlignment range:range];
	
	// configure label view
	self.labelView.attributedStringValue = mutTitle;
}

// return text from label
- (NSString *)title;
{
	return self.labelView.stringValue;
}

// lazily load the label view
- (NSTextField *)labelView;
{
	if(!labelView) {
		NSView *view = self.contentView;
		CGRect rect = view.bounds;
		rect.origin.y += 1.0;
		labelView = [[NSTextField alloc] initWithFrame:rect];
		[labelView setEditable:NO];
		[labelView setSelectable:NO];
		[labelView setBackgroundColor:self.fillColor];
		[labelView setBordered:NO];
		[labelView setTextColor:[NSColor colorWithDeviceWhite:kTextColor alpha:1.0]];
		[view addSubview:labelView];
	}
	return labelView;
}

- (void)setState:(NSInteger)theState;
{
	state = theState;
	
	// adjust the content view position
	CGFloat h2 = self.bounds.size.height/2.0;
	CGRect rect = self.contentView.frame;
	switch(state) {
		case NSOnState:
			rect.origin = CGPointMake(h2+kShadowSize, 1.0);
			break;
		case NSOffState:
			rect.origin = CGPointMake(h2, 1.0+kShadowSize);
			break;
	}

	self.contentView.frame = rect;
	[self setNeedsDisplay];
}

- (NSInteger)state;
{
	return state;
}

#pragma mark NSView

// init
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		
		// default colors
		self.fillColor = [NSColor colorWithDeviceWhite:kFillColor alpha:1.0];
		self.strokeColor = [NSColor colorWithDeviceWhite:kStrokeColor alpha:1.0];
		self.shadowColor = [NSColor colorWithDeviceWhite:kShadowColor alpha:1.0];
		
		// create the content view
		CGFloat h = self.bounds.size.height;
		CGFloat h2 = h/2.0;
		CGRect rect = scaleRect(self.bounds, h2 , 1.0, h+kShadowSize+1.0, kShadowSize+1.0);
		contentView = [[NSView alloc] initWithFrame:rect];
		[self addSubview:contentView];
    }
    
    return self;
}

// cleanup
- (void)dealloc
{
	[labelView release];
	[contentView release];
    [super dealloc];
}

// draw
- (void)drawRect:(NSRect)dirtyRect
{
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	
	// draw outline
	if(self.state == NSOnState) {
		[self drawOnStateInRect:dirtyRect context:context];
	}
	
	else if(self.state == NSOffState) {
		[self drawOffStateInRect:dirtyRect context:context];
	}
}


#pragma mark private methods

// draw the button outline
- (void)drawOffStateInRect:(CGRect)dirtyRect context:(CGContextRef)context;
{
	// scale the outline rect to allow shadow and line drawing
	CGFloat h2 = self.bounds.size.height/2.0 - 2.0;
	CGRect outlineRect = scaleRect(self.bounds, 0.5, 0.5, kShadowSize+0.5, kShadowSize+0.5);

	// draw a rounded rect
	addRoundedRectToPath(context, outlineRect, h2, h2);
	
	// configure brushes
	[self.fillColor setFill];
	[self.strokeColor setStroke];
	
	// save the state before applying shadow
	CGContextSaveGState(context);
	
	// create shadow
	if(self.shadowColor) {
		CGColorRef shadowColorRef = CGColorCreateFromNSColor(CGColorSpaceCreateDeviceRGB(), self.shadowColor);
		CGContextSetShadowWithColor(context, CGSizeMake(kShadowSize, -kShadowSize), kShadowBlur, shadowColorRef);
	}
	
	// fill
	CGContextDrawPath(context, kCGPathFill);
	
	// restore state before applying shadow and stroke
	// otherwise, the stroke will also get a shadow
	CGContextRestoreGState(context);
	CGContextDrawPath(context, kCGPathStroke);
}

- (void)drawOnStateInRect:(CGRect)dirtyRect context:(CGContextRef)context;
{
	// scale the outline rect to allow shadow and line drawing
	CGFloat h2 = self.bounds.size.height/2.0 - 2.0;
	CGRect outlineRect = scaleRect(self.bounds, kShadowSize+0.5, kShadowSize+0.5, 0.5, 0.5);
	
	// draw a rounded rect
	addRoundedRectToPath(context, outlineRect, h2, h2);
	
	// configure brushes
	[self.fillColor setFill];
	[self.strokeColor setStroke];
	
	// fill
	CGContextDrawPath(context, kCGPathFillStroke);
}

@end
