//
//  Singleton.m
//  Surfing Diary
//
//  Created by Andrew Newman on 6/2/11.
//  Copyright 2011 LightenUp!Enterprises, LLC. All rights reserved.
//

#import "Singleton.h"


@implementation Singleton

@synthesize newrownumber;

static Singleton* _sharedSingleton = nil;

+ (Singleton*)sharedSingleton {
	
	@synchronized([Singleton class]) {
		if(!_sharedSingleton)
			[[self alloc] init];
		
		return _sharedSingleton;
	}
	return nil;
}


+ (id) alloc {
	@synchronized ([Singleton class]) {
		NSAssert(_sharedSingleton == nil, @"Attempted to allocate a second instance of a Singleton.");
		_sharedSingleton = [super alloc];
		return _sharedSingleton;
	}
	
	return nil;
}

-(id) init {
	
	self = [super init];
	
	if (self != nil) {
	} 
	return self;
}


- (NSUInteger) getnewrownumber {
	return newrownumber;
}

- (void) setnewrownumber:(NSUInteger)value {
	newrownumber = value;
}

@end
