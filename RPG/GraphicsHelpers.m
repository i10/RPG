//
//  GraphicsHelpers.c
//  RPG
//
//  Created by Jonathan Diehl on 03.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "GraphicsHelpers.h"

// scale a CGRect
CGRect scaleRect(CGRect rect, CGFloat left, CGFloat top, CGFloat right, CGFloat bottom)
{
	rect.origin.x += left;
	rect.origin.y += bottom;
	rect.size.width -= left+right;
	rect.size.height -= top+bottom;
	return rect;
}

// create a rounded rect
void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,float ovalHeight) 
{ 
	float fw, fh; 
	if (ovalWidth == 0 || ovalHeight == 0) { 
		CGContextAddRect(context, rect); 
		return; 
	} 
	
	CGContextSaveGState(context); 
	CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect)); 
	CGContextScaleCTM(context, ovalWidth, ovalHeight); 
	fw = CGRectGetWidth(rect) / ovalWidth;
	fh = CGRectGetHeight(rect) / ovalHeight; 
	CGContextMoveToPoint(context, fw, fh/2); 
	CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1); 
	CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); 
	CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); 
	CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); 
	CGContextClosePath(context); 
	CGContextRestoreGState(context); 
}

// convert NSColor to CGColor
CGColorRef CGColorCreateFromNSColor(CGColorSpaceRef colorSpace, NSColor *color)
{
	NSColor *deviceColor = [color colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	
	CGFloat components[4];
	[deviceColor getRed: &components[0] green: &components[1] blue:&components[2] alpha: &components[3]];
	
	return CGColorCreate (colorSpace, components);
}