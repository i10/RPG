//
//  GraphicsHelpers.h
//  RPG
//
//  Created by Jonathan Diehl on 03.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

// scale a CGRect
CGRect scaleRect(CGRect rect, CGFloat left, CGFloat top, CGFloat right, CGFloat bottom);

// create a rounded rect
void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,float ovalHeight);

// convert NSColor to CGColor
CGColorRef CGColorCreateFromNSColor(CGColorSpaceRef colorSpace, NSColor *color);
