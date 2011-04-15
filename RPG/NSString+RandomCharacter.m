//
//  randomCharacter.m
//  RPG
//
//  Created by Jonathan Diehl on 15.04.11.
//  Copyright 2011 RWTH. All rights reserved.
//

#import "NSString+RandomCharacter.h"


@implementation NSString (RandomCharacter)

- (char)randomCharacter;
{
	NSUInteger i = random() % [self length];
	return [self characterAtIndex:i];
}

@end
