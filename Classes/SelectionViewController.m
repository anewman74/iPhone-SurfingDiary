    //
//  SelectionViewController.m
//  Surfing Diary
//
//  Created by Andrew Newman on 6/2/11.
//  Copyright 2011 LightenUp!Enterprises, LLC. All rights reserved.
//

#import "SelectionViewController.h"
#import "Surfing_JournalAppDelegate.h"
#import "AddJournalViewController.h"
#import "AllJournalsViewController.h"
#import "SpecificSearchViewController.h"
#import "ForecastSearchViewController.h"

@implementation SelectionViewController

@synthesize addJournalViewController;
@synthesize allJournalsViewController;
@synthesize specificSearchViewController;
@synthesize forecastSearchViewController;

#pragma all methods
-(IBAction) add {
	
	if (self.addJournalViewController == nil)
	{
		AddJournalViewController *aDetail = [[AddJournalViewController alloc] initWithNibName: @"AddJournalView" bundle:[NSBundle mainBundle]];
		self.addJournalViewController = aDetail;
		[aDetail release];
	}
	
	Surfing_JournalAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.surfingNavController pushViewController:addJournalViewController animated:YES];		
}

-(IBAction) all {
	
	if (self.allJournalsViewController == nil)
	{
		AllJournalsViewController *aDetail = [[AllJournalsViewController alloc] initWithNibName: @"AllJournalsView" bundle:[NSBundle mainBundle]];
		self.allJournalsViewController = aDetail;
		[aDetail release];
	}
	
	Surfing_JournalAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.surfingNavController pushViewController:allJournalsViewController animated:YES];		
}

-(IBAction) specific {
	
	if (self.specificSearchViewController == nil)
	{
		SpecificSearchViewController *aDetail = [[SpecificSearchViewController alloc] initWithNibName: @"SpecificSearchView" bundle:[NSBundle mainBundle]];
		self.specificSearchViewController = aDetail;
		[aDetail release];
	}
	
	Surfing_JournalAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.surfingNavController pushViewController:specificSearchViewController animated:YES];		
}

-(IBAction) forecast {
	
	if (self.forecastSearchViewController == nil)
	{
		ForecastSearchViewController *aDetail = [[ForecastSearchViewController alloc] initWithNibName: @"ForecastView" bundle:[NSBundle mainBundle]];
		self.forecastSearchViewController = aDetail;
		[aDetail release];
	}
	
	Surfing_JournalAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.surfingNavController pushViewController:forecastSearchViewController animated:YES];		
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title =  NSLocalizedString(@"Choose Action", @"choose action");
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
    [addjournalViewController release];
    [allJournalsViewController release];
    [specificSearchViewController release];
    [forecastSearchViewController release];
}


@end
