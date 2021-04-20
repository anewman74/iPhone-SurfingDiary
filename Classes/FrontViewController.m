    //
//  FrontViewController.m
//  Surfing Diary
//
//  Created by Andrew Newman on 6/2/11.
//  Copyright 2011 LightenUp!Enterprises, LLC. All rights reserved.
//

#import "FrontViewController.h"
#import "Surfing_JournalAppDelegate.h"
#import "SelectionViewController.h"


@implementation FrontViewController

@synthesize selectionViewController;


-(IBAction) start {
	
	if (self.selectionViewController == nil)
	{
		SelectionViewController *aDetail = [[SelectionViewController alloc] initWithNibName: @"SelectionView" bundle:[NSBundle mainBundle]];
		self.selectionViewController = aDetail;
		[aDetail release];
	}
	
	Surfing_JournalAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.surfingNavController pushViewController:selectionViewController animated:YES];
	
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title =  NSLocalizedString(@"Surfing Diary", @"surfing diary");
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[selectionViewController release];
}


@end
