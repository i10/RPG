//
//  DeleteCharactersFromString.m
//  RPG
//
//  Created by Jonathan Diehl on 15.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

#import "NSMutableString+DeleteCharactersFromString.h"


@implementation NSMutableString (DeleteCharactersFromString)

- (void)deleteCharactersFromString:(NSString *)string;
{
	NSUInteger i, j;
	char c;
	NSRange r = NSMakeRange(0, 1);
	for(i = 0; i < [string length]; i++) {
		c = [string characterAtIndex:i];
		for(j = 0; j < [self length]; j++) {
			if([self characterAtIndex:j] == c) {
				r.location = j--;
				[self deleteCharactersInRange:r];
			}
		}
	}
}

@end
