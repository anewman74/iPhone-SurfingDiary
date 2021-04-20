    //
//  AboutViewController.m
//  Surfing Diary
//
//  Created by Andrew Newman on 6/2/11.
//  Copyright 2011 LightenUp!Enterprises, LLC. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController

-(IBAction) url {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.lightenupenterprises.com"]];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {	
	[[UIApplication sharedApplication] setIdleTimerDisabled: YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)dealloc {
    [super dealloc];
}


@end