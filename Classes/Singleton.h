//
//  Singleton.h
//  Surfing Diary
//
//  Created by Andrew Newman on 6/2/11.
//  Copyright 2011 LightenUp!Enterprises, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Singleton : NSObject {
	NSUInteger newrownumber;
	
}
@property (nonatomic, assign) NSUInteger newrownumber;

+ (Singleton*) sharedSingleton;

- (NSUInteger) getnewrownumber;

- (void) setnewrownumber:(NSUInteger)value;


@end
