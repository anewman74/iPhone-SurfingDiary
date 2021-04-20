//
//  Surfing_JournalAppDelegate.m
//  Surfing Diary
//
//  Created by Andrew Newman on 6/2/11.
//  Copyright 2011 LightenUp!Enterprises, LLC. All rights reserved.
//

#import "Surfing_JournalAppDelegate.h"
#import "SurfingNavController.h"

@implementation Surfing_JournalAppDelegate

@synthesize window;
@synthesize rootController;
@synthesize surfingNavController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
    // Override point for customization after application launch
	
	[window addSubview:rootController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
	[rootController release];
	[surfingNavController release];
    [super dealloc];
}


@end
