    //
//  DetailsViewController.m
//  Surfing Diary
//
//  Created by Andrew Newman on 6/2/11.
//  Copyright 2011 LightenUp!Enterprises, LLC. All rights reserved.
//

#import "DetailsViewController.h"
#import "Surfing_JournalAppDelegate.h"
#import "Singleton.h"

@implementation DetailsViewController

@synthesize winddirection;
@synthesize windspeed;
@synthesize buoysdirection;
@synthesize buoysheight;
@synthesize buoysinterval;
@synthesize tide;
@synthesize region;
@synthesize location;
@synthesize rating;
@synthesize comment;


- (NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
														 , NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:kFilename];
}


#pragma save function
-(IBAction) save {

	char *update = "update surflog set winddirection = ?, windspeed = ?, buoysdirection = ?, buoysheight = ?, buoysinterval = ?, tide = ?, region = ?, location = ?, rating = ?, comment = ? where row = ?;";	
	
    int windsp = [windspeed.text intValue];
	int buoyshei = [buoysheight.text intValue];
	int buoysint = [buoysinterval.text intValue];
	int ratingint = [rating.text intValue];
	
	winddirection.text = [winddirection.text lowercaseString];
    buoysdirection.text = [buoysdirection.text lowercaseString];
	tide.text = [tide.text lowercaseString];
	region.text = [region.text lowercaseString];
	location.text = [location.text lowercaseString];
	comment.text = [comment.text lowercaseString];
	
	sqlite3_stmt *stmt;
	if(sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK){
		sqlite3_bind_text(stmt, 1, [winddirection.text UTF8String], -1, NULL);
		sqlite3_bind_int(stmt, 2, windsp);
        sqlite3_bind_text(stmt, 3, [buoysdirection.text UTF8String], -1, NULL);
		sqlite3_bind_int(stmt, 4, buoyshei);
		sqlite3_bind_int(stmt, 5, buoysint);
		sqlite3_bind_text(stmt, 6, [tide.text UTF8String], -1, NULL);
		sqlite3_bind_text(stmt, 7, [region.text UTF8String], -1, NULL);
		sqlite3_bind_text(stmt, 8, [location.text UTF8String], -1, NULL);
		sqlite3_bind_int(stmt, 9, ratingint);
		sqlite3_bind_text(stmt, 10, [comment.text UTF8String], -1, NULL);
		sqlite3_bind_int(stmt, 11, newrownumber);			
	}
	if(sqlite3_step(stmt) != SQLITE_DONE)
		NSLog(@"statement falied");
	sqlite3_finalize(stmt);

	sqlite3_close(database);
	
	//Alert view message.
	title = [[NSString alloc] initWithFormat:@"Saved"];
	message = [[NSString alloc] initWithFormat:
		   @"Your journal entry has been saved. For review, click on the 'View All Entries' button in the 'Choose Action' view."];

	alert = [[UIAlertView alloc] initWithTitle:title
								   message:message
								  delegate:nil
						 cancelButtonTitle:@"Thanks coach!"
						 otherButtonTitles:nil];
	[alert show];
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)applicationWillTerminate:(NSNotification *)notification {
	sqlite3_close(database);
}


#pragma mark - viewWillAppear.
- (void) viewWillAppear:(BOOL)animated {
	
	//Registering a notification when keyboard will show.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:self.view.window];
	
	if(sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert(0,@"Failed to open database");
	}
	
	newrownumber  = [[Singleton sharedSingleton] getnewrownumber];
	region.text = @"";
	location.text = @"";
	winddirection.text = @"";
    windspeed.text = @"";
	buoysdirection.text = @"";
	buoysheight.text = @"";
	buoysinterval.text = @"";
	tide.text = @"";
	rating.text = @"";
	comment.text = @"";
	
	[super viewWillAppear:animated];
}


#pragma view did load
- (void)viewDidLoad {
	
	[super viewDidLoad];
	self.title =  NSLocalizedString(@"Extra Details", @"extra");
	
	UIApplication *app2 = [UIApplication sharedApplication];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillTerminate:)
												 name:UIApplicationWillTerminateNotification
											   object:app2];
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

#pragma mark - method viewWillDisappear.
-(void) viewWillDisappear:(BOOL)animated {
	
	sqlite3_close(database);
	
	//Scroll keyboard down screen if showing.
	if(winddirection.editing){
		[winddirection resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
    else if(windspeed.editing){
		[windspeed resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
	else if(buoysheight.editing){
		[buoysheight resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
	else if(buoysinterval.editing){
		[buoysinterval resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
	else if(buoysdirection.editing){
		[buoysdirection resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
	else if(tide.editing){
		[tide resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
	else if(region.editing){
		[region resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
	else if(location.editing){
		[location resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
	else if(rating.editing){
		[rating resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
	else if(comment.editing){
		[comment resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
	
	//Unregistering keyboard notification.
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillShowNotification object:nil];
	
	[super viewWillDisappear:animated];
}



#pragma mark - methods for the keyboard scrolling effect.
-(void) keyboardWillShow:(NSNotification *)notif {
	CGRect keyboardEndFrame;
	[[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
	CGFloat keyboardSize;
	if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
		keyboardSize = keyboardEndFrame.size.height;
	}
	else {
		keyboardSize = keyboardEndFrame.size.width;
	}
	
	
	if(tide.editing){
		float bottomPoint = (tide.frame.origin.y + 
							 tide.frame.size.height);
		scrollAmount = keyboardSize - (411 - bottomPoint);
	}
	
	if(rating.editing){
		float bottomPoint = (rating.frame.origin.y + 
							 rating.frame.size.height);
		scrollAmount = keyboardSize - (411 - bottomPoint);
	}
	
	if(comment.editing){
		float bottomPoint = (comment.frame.origin.y + 
							 comment.frame.size.height);
		scrollAmount = keyboardSize - (411 - bottomPoint);
	}
	
	if(scrollAmount > 0) {
		moveViewUp = YES;
		[self scrollTheView:YES];
	}
	else {
		moveViewUp = NO;
	}
	
}
- (void) scrollTheView: (BOOL) movedUp {
		
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];	
	CGRect rect = self.view.frame;
	
	if(movedUp){
		rect.origin.y -= scrollAmount;
	}
	else {
		rect.origin.y += scrollAmount;
	}
	
	self.view.frame = rect;	
	[UIView commitAnimations];	
}

-(BOOL) textFieldShouldReturn: (UITextField *) theTextField {	
	
	[theTextField resignFirstResponder];
	[self becomeFirstResponder];
	
	if(moveViewUp) [self scrollTheView:NO];	
	
	//After keyboard has been set back down, set scroll amount to nil.
	scrollAmount = 0;	
	
	return YES;
}

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *)event {	
	if(winddirection.editing){
		[winddirection resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
    else if(windspeed.editing){
		[windspeed resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
	else if(buoysdirection.editing){
		[buoysdirection resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
	else if(buoysheight.editing){
		[buoysheight resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
	else if(buoysinterval.editing){
		[buoysinterval resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
	else if(tide.editing){
		[tide resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
	else if(region.editing){
		[region resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
	else if(location.editing){
		[location resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
	else if(rating.editing){
		[rating resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
	else if(comment.editing){
		[comment resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}	
	[super touchesBegan:touches withEvent:event];
}



- (void)dealloc {
    [super dealloc];
    [windspeed release];
    [winddirection release];
    [buoysdirection release];
    [buoysheight release];
    [buoysinterval release];
    [tide release];
    [region release];
    [location release];
    [rating release];
    [comment release];
    [title release];
    [message release];
    [alert release];
}


@end
