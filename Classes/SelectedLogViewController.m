    //
//  SelectedLogViewController.m
//  Surfing Diary
//
//  Created by Andrew Newman on 6/2/11.
//  Copyright 2011 LightenUp!Enterprises, LLC. All rights reserved.
//

#import "SelectedLogViewController.h"
#import "Singleton.h"
#import "AllJournalsViewController.h"

@implementation SelectedLogViewController

@synthesize date;
@synthesize session;
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

-(void)applicationWillTerminate:(NSNotification *)notification {
	//NSLog(@"in selected log");
	sqlite3_close(database);
}


#pragma update database
-(IBAction) save {
    
	char *update = "update surflog set date = ?, session = ?, winddirection = ?, windspeed = ?, buoysdirection = ?, buoysheight = ?, buoysinterval = ?, tide = ?, region = ?, location = ?, rating = ?, comment = ? where row = ?;";

	int windsp = [windspeed.text intValue];
	int buoyshei = [buoysheight.text intValue];
	int buoysint = [buoysinterval.text intValue];
	int ratingint = [rating.text intValue];
	
	winddirection.text = [winddirection.text lowercaseString];
    buoysdirection.text = [buoysdirection.text lowercaseString];
	region.text = [region.text lowercaseString];
	location.text = [location.text lowercaseString];
	comment.text = [comment.text lowercaseString];
    date.text = [date.text lowercaseString];
	session.text = [session.text lowercaseString];
	
	sqlite3_stmt *stmt;
	if(sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK){
		sqlite3_bind_text(stmt, 1, [date.text UTF8String], -1, NULL);
		sqlite3_bind_text(stmt, 2, [session.text UTF8String], -1, NULL);
		sqlite3_bind_text(stmt, 3, [winddirection.text UTF8String], -1, NULL);
		sqlite3_bind_int(stmt, 4, windsp);
        sqlite3_bind_text(stmt, 5, [buoysdirection.text UTF8String], -1, NULL);
		sqlite3_bind_int(stmt, 6, buoyshei);
		sqlite3_bind_int(stmt, 7, buoysint);
		sqlite3_bind_text(stmt, 8, [tide.text UTF8String], -1, NULL);
		sqlite3_bind_text(stmt, 9, [region.text UTF8String], -1, NULL);
		sqlite3_bind_text(stmt, 10, [location.text UTF8String], -1, NULL);
		sqlite3_bind_int(stmt, 11, ratingint);
		sqlite3_bind_text(stmt, 12, [comment.text UTF8String], -1, NULL);
		sqlite3_bind_int(stmt, 13, newrownumber);	
		
	}
	if(sqlite3_step(stmt) != SQLITE_DONE)
		NSLog(@"statement falied");
	sqlite3_finalize(stmt);
	
	//Alert view message.
	title = [[NSString alloc] initWithFormat:@"Updated"];
	message = [[NSString alloc] initWithFormat:
			   @"Your journal entry has been updated. For review, click on the 'View All Entries' button in the 'Choose Action' view."];
	
	alert = [[UIAlertView alloc] initWithTitle:title
									   message:message
									  delegate:nil
							 cancelButtonTitle:@"Thanks coach!"
							 otherButtonTitles:nil];
	[alert show];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma delete entry
-(IBAction)deleteLog{

	char *update = "delete from surflog where row = ?;";
	
	sqlite3_stmt *stmt;
	if(sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK){
		sqlite3_bind_int(stmt, 1, newrownumber);		
	}
    
	if(sqlite3_step(stmt) != SQLITE_DONE)
		NSLog(@"statement falied");
    
    else {
        //Alert view message.
        title = [[NSString alloc] initWithFormat:@"Game Over"];
        message = [[NSString alloc] initWithFormat:
                   @"Your journal entry has been deleted."];
        
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:@"Super!"
                                 otherButtonTitles:nil];
        [alert show];
    }
	sqlite3_finalize(stmt);
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma view will appear
-(void)viewWillAppear:(BOOL)animated {

	newrownumber  = [[Singleton sharedSingleton] getnewrownumber];
	
	if(sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert(0,@"Failed to open database");
	}
	
	
	NSString *query = [[NSString alloc] initWithFormat: @"SELECT ROW, winddirection,windspeed,buoysdirection, buoysheight, buoysinterval, tide, region,location,rating,comment, date, session FROM surflog where row = %i",newrownumber];

	sqlite3_stmt *statement;
	if(sqlite3_prepare_v2(database, [query UTF8String],-1, &statement, nil) == SQLITE_OK){
		while(sqlite3_step(statement) == SQLITE_ROW){
			int row = sqlite3_column_int(statement, 0);
			char *winddirectiondata = (char *)sqlite3_column_text(statement, 1);
			int windspeeddata = sqlite3_column_int(statement, 2);
            char *buoysdirectiondata = (char *)sqlite3_column_text(statement, 3);
			int buoysheightdata = sqlite3_column_int(statement, 4);
			int buoysintervaldata = sqlite3_column_int(statement, 5);
			char *tidedata = (char *)sqlite3_column_text(statement, 6);
			char *regiondata = (char *)sqlite3_column_text(statement, 7);
			char *locationdata = (char *)sqlite3_column_text(statement, 8);
			int ratingdata = sqlite3_column_int(statement, 9);
			char *commentdata = (char *)sqlite3_column_text(statement, 10);
			char *dateid = (char *)sqlite3_column_text(statement, 11);
			char *sessionid = (char *)sqlite3_column_text(statement, 12);
			
			NSLog(@"ROW in details: %i",row);
			
			date.text = [[NSString alloc] initWithFormat:@"%s",dateid];
			session.text = [[NSString alloc] initWithFormat:@"%s",sessionid];
			location.text = [[NSString alloc] initWithFormat:@"%s",locationdata];
			winddirection.text = [[NSString alloc] initWithFormat:@"%s",winddirectiondata];
            windspeed.text = [[NSString alloc] initWithFormat:@"%i",windspeeddata];
			buoysdirection.text = [[NSString alloc] initWithFormat:@"%s",buoysdirectiondata];
			buoysheight.text = [[NSString alloc] initWithFormat:@"%i",buoysheightdata];
			buoysinterval.text = [[NSString alloc] initWithFormat:@"%i",buoysintervaldata];
			tide.text = [[NSString alloc] initWithFormat:@"%s",tidedata];
			region.text = [[NSString alloc] initWithFormat:@"%s",regiondata];
			rating.text = [[NSString alloc] initWithFormat:@"%i",ratingdata];
			comment.text = [[NSString alloc] initWithFormat:@"%s",commentdata];
		}
		sqlite3_finalize(statement);
	}
	
	//Registering a notification when keyboard will show.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:self.view.window];
	
	[super viewWillAppear:animated];
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.title = NSLocalizedString(@"Log Details", @"details");
	
	UIApplication *app2 = [UIApplication sharedApplication];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillTerminate:)
												 name:UIApplicationWillTerminateNotification
											   object:app2];
	
	[super viewDidLoad];
}


#pragma mark - method viewWillDisappear.
-(void) viewWillDisappear:(BOOL)animated {
	
	sqlite3_close(database);
	
	//Scroll keyboard down screen if showing.
	if(date.editing){
		[date resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
	else if(session.editing){
		[session resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
	else if(winddirection.editing){
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
    
    if(comment.editing){
		float bottomPoint = (comment.frame.origin.y + 
							 comment.frame.size.height);
		scrollAmount = keyboardSize - (411 - bottomPoint);
	}
	
	if(rating.editing){
		float bottomPoint = (rating.frame.origin.y + 
							 rating.frame.size.height);
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
	
	if(moveViewUp) [self scrollTheView:NO];	
	
	//After keyboard has been set back down, set scroll amount to nil.
	scrollAmount = 0;
	
	
	return YES;
}

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *)event {	
	if(date.editing){
		[date resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
	else if(session.editing){
		[session resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
	else if(winddirection.editing){
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
    [date release];
    [session release];
    [buoysdirection release];
    [buoysheight release];
    [buoysinterval release];
    [winddirection release];
    [windspeed release];
    [tide release];
    [rating release];
    [location release];
    [comment release];
    [region release];
    [title release];
    [message release];
    [alert release];
}


@end

