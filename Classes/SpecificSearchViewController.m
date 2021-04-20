    //
//  SpecificSearchViewController.m
//  Surfing Diary
//
//  Created by Andrew Newman on 6/2/11.
//  Copyright 2011 LightenUp!Enterprises, LLC. All rights reserved.
//

#import "SpecificSearchViewController.h"
#import "Singleton.h"
#import "Surfing_JournalAppDelegate.h"

@implementation SpecificSearchViewController

@synthesize rating;
@synthesize region;
@synthesize location;
@synthesize resultnumber;

- (NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
														 , NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:kFilename];
}


#pragma search database method
-(IBAction)searchdatabase {
	
	if(sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert(0,@"Failed to open database");
	}
	
	char *errorMsg;
	NSString *createSQL = @"CREATE TABLE IF NOT EXISTS surflog (row integer primary key,date text, session text, winddirection text,windspeed integer, buoysdirection text, buoysheight integer, buoysinterval integer, tide text, rating integer, comment text, region text, location text);";
	if(sqlite3_exec(database, [createSQL UTF8String],NULL,NULL,&errorMsg) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert1(0,@"Error creating table: %s", errorMsg);
	}
		
	ratingint = [rating.text intValue];
	resultnum = [resultnumber.text intValue];    
    location.text = [location.text lowercaseString];
	region.text = [region.text lowercaseString];
	
	//Search Rating only.
	if(([location.text isEqualToString:@""]) && ([region.text isEqualToString:@""]) && (![rating.text isEqualToString:@""])) {
		
		[self runSelectionInDatabase:@"rating" givenStringText:rating.text];
	}
	
	//Search Location only.
	else if(([rating.text isEqualToString:@""]) && ([region.text isEqualToString:@""]) && (![location.text isEqualToString:@""])) {
		
		[self runSelectionInDatabase:@"location" givenStringText:location.text];
	}
	
	//Search Region only.
	else if(([location.text isEqualToString:@""]) && ([rating.text isEqualToString:@""]) && (![region.text isEqualToString:@""])) {
		
		[self runSelectionInDatabase:@"region" givenStringText:region.text];
	}
	
	//Search Region and Location only.
	else if(([rating.text isEqualToString:@""]) && (![region.text isEqualToString:@""]) && (![location.text isEqualToString:@""])) {
		
		[self runSelectionInDatabase2:@"region" givenStringText:region.text givenString2:@"location" givenStringText2:location.text];
	}
	
	//Search Rating and Region only.
	else if(([location.text isEqualToString:@""]) && (![rating.text isEqualToString:@""]) && (![region.text isEqualToString:@""])) {
		
		[self runSelectionInDatabase2:@"rating" givenStringText:rating.text givenString2:@"region" givenStringText2:region.text];
	}
	
	//Search Location and rating only.
	else if(([region.text isEqualToString:@""]) && (![rating.text isEqualToString:@""]) && (![location.text isEqualToString:@""])) {
		
		[self runSelectionInDatabase2:@"rating" givenStringText:rating.text givenString2:@"location" givenStringText2:location.text];
	}
	
	//Search Location,region and rating.
	else if((![region.text isEqualToString:@""]) && (![location.text isEqualToString:@""]) && (![rating.text isEqualToString:@""])) {
		
		query = [[NSString alloc] initWithFormat: @"SELECT row, winddirection,windspeed,buoysdirection, buoysheight, buoysinterval, tide, region,location,rating,comment, date, session FROM surflog where region = '%@' and location = '%@' and rating >= %i ORDER BY rating DESC",region.text,location.text,ratingint];

		sqlite3_stmt *statement;
		
		//count - relates to number of search requests user requires.
		count=0;
		
		if(sqlite3_prepare_v2(database, [query UTF8String],-1, &statement, nil) == SQLITE_OK){
			while(sqlite3_step(statement) == SQLITE_ROW){
				
				count++;
				
				int row = sqlite3_column_int(statement, 0);
                NSLog(@"Row: %i", row);
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
				
				if(count <= resultnum){
					//Alert view message.
					title = [[NSString alloc] initWithFormat:@"Results"];
					message = [[NSString alloc] initWithFormat:
							   @"Date: '%s - %s'.        Region:  '%s'.      Location: '%s'.       Wind Direction: '%s'.       Wind Speed: %i knots.      Buoys Direction: '%s'.       Buoys Wave Height: %i feet.       Buoys Interval: %i seconds.       Tide:  '%s'.      Rating: '%i'.       Comment: '%s'. ", dateid,sessionid,regiondata,locationdata,winddirectiondata,windspeeddata,buoysdirectiondata,buoysheightdata,buoysintervaldata,tidedata,ratingdata, commentdata];
					alert = [[UIAlertView alloc] initWithTitle:title
													   message:message
													  delegate:nil
											 cancelButtonTitle:@"Cool!"
											 otherButtonTitles:nil];
					[alert show];
					[alert release];
				}
			}
			sqlite3_finalize(statement);
		}
		
		query2 = [[NSString alloc] initWithFormat:  @"SELECT count(*) FROM surflog where region = '%@' and location = '%@' and rating >= %i",region.text,location.text,ratingint];
		
		sqlite3_stmt *statement2;
		if(sqlite3_prepare_v2(database, [query2 UTF8String],-1, &statement2, nil) == SQLITE_OK){
			while(sqlite3_step(statement2) == SQLITE_ROW){
				count = sqlite3_column_int(statement2, 0);	
				
				if(count == 0){
					title = [[NSString alloc] initWithFormat:@"Results"];
					message = [[NSString alloc] initWithFormat:@"Sorry, there are no matches in your database for this search."];
					alert = [[UIAlertView alloc] initWithTitle:title
													   message:message
													  delegate:nil
											 cancelButtonTitle:@"Oops!"
											 otherButtonTitles:nil];
					[alert show];
					[alert release];
				}
			}
			sqlite3_finalize(statement2);
		}
	}
}

#pragma runSelectionInDatabase
-(void)runSelectionInDatabase:(NSString *)givenString givenStringText:(NSString *)givenStringText {
	
	if ([givenString isEqualToString:@"rating"]) {
		query = [[NSString alloc] initWithFormat: @"SELECT row, winddirection,windspeed,buoysdirection, buoysheight, buoysinterval, tide, region,location,rating,comment, date, session FROM surflog where %@ >= %i ORDER BY rating DESC",givenString,ratingint];
		
		query2 = [[NSString alloc] initWithFormat:  @"SELECT count(*) FROM surflog where %@ >= %i",givenString,ratingint];
	}
	
	else {
		query = [[NSString alloc] initWithFormat: @"SELECT row, winddirection,windspeed,buoysdirection, buoysheight, buoysinterval, tide, region,location,rating,comment, date, session FROM surflog where %@ = '%@' ORDER BY rating DESC",givenString,givenStringText];
		
		query2 = [[NSString alloc] initWithFormat:  @"SELECT count(*) FROM surflog where %@ = '%@'",givenString,givenStringText];
	}

	
	
	sqlite3_stmt *statement;
	
	//count - relates to number of search requests user requires.
	count=0;
	
	if(sqlite3_prepare_v2(database, [query UTF8String],-1, &statement, nil) == SQLITE_OK){
		while(sqlite3_step(statement) == SQLITE_ROW){
			
			count++;
			
			int row = sqlite3_column_int(statement, 0);
            NSLog(@"Row: %i", row);
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
			
			if(count <= resultnum){
				//Alert view message.
				title = [[NSString alloc] initWithFormat:@"Results"];
				message = [[NSString alloc] initWithFormat:
						   @"Date: '%s - %s'.        Region:  '%s'.      Location: '%s'.       Wind Direction: '%s'.       Wind Speed: %i knots.      Buoys Direction: '%s'.       Buoys Wave Height: %i feet.       Buoys Interval: %i seconds.       Tide:  '%s'.      Rating: '%i'.       Comment: '%s'. ", dateid,sessionid,regiondata,locationdata,winddirectiondata,windspeeddata, buoysdirectiondata,buoysheightdata,buoysintervaldata,tidedata,ratingdata, commentdata];
				alert = [[UIAlertView alloc] initWithTitle:title
												   message:message
												  delegate:nil
										 cancelButtonTitle:@"Cool!"
										 otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
		}
		sqlite3_finalize(statement);
	}
	
	sqlite3_stmt *statement2;
	if(sqlite3_prepare_v2(database, [query2 UTF8String],-1, &statement2, nil) == SQLITE_OK){
		while(sqlite3_step(statement2) == SQLITE_ROW){
			count = sqlite3_column_int(statement2, 0);
			
			if(count == 0){
				title = [[NSString alloc] initWithFormat:@"Results"];
				message = [[NSString alloc] initWithFormat:@"Sorry, there are no matches in your database for this search."];
				alert = [[UIAlertView alloc] initWithTitle:title
												   message:message
												  delegate:nil
										 cancelButtonTitle:@"Oops!"
										 otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
		}
		sqlite3_finalize(statement2);
	}
}

#pragma runSelectionInDatabase2
-(void)runSelectionInDatabase2:(NSString *)givenString givenStringText:(NSString *)givenStringText givenString2:(NSString *)givenString2 givenStringText2:(NSString *)givenStringText2 {
	
	if ([givenString isEqualToString:@"rating"]) {
		query = [[NSString alloc] initWithFormat: @"SELECT row, winddirection, windspeed,buoysdirection, buoysheight, buoysinterval, tide, region,location,rating,comment, date, session FROM surflog where %@ >= %i and %@ = '%@' ORDER BY rating DESC",givenString,ratingint,givenString2,givenStringText2];
		
		query2 = [[NSString alloc] initWithFormat:  @"SELECT count(*) FROM surflog where %@ >= %i and %@ = '%@'",givenString,ratingint,givenString2,givenStringText2];
	}
	
	else {
		query = [[NSString alloc] initWithFormat: @"SELECT row, winddirection, windspeed,buoysdirection, buoysheight, buoysinterval, tide, region,location,rating,comment, date, session FROM surflog where %@ = '%@' and %@ = '%@' ORDER BY rating DESC",givenString,givenStringText,givenString2,givenStringText2];
		
		query2 = [[NSString alloc] initWithFormat:  @"SELECT count(*) FROM surflog where %@ = '%@' and %@ = '%@'",givenString,givenStringText,givenString2,givenStringText2];
	}

	sqlite3_stmt *statement;
	
	//count - relates to number of search results shown to the user.
	count=0;
	
	if(sqlite3_prepare_v2(database, [query UTF8String],-1, &statement, nil) == SQLITE_OK){
		while(sqlite3_step(statement) == SQLITE_ROW){
			
			count++;
			
			int row = sqlite3_column_int(statement, 0);
            NSLog(@"Row: %i", row);
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
			
			if(count <= resultnum){
				//Alert view message.
				title = [[NSString alloc] initWithFormat:@"Results"];
				message = [[NSString alloc] initWithFormat:
						   @"Date: '%s - %s'.        Region:  '%s'.      Location: '%s'.       Wind Direction: '%s'.       Wind Speed: %i knots.      Buoys Direction: '%s'.       Buoys Wave Height: %i feet.       Buoys Interval: %i seconds.       Tide:  '%s'.      Rating: '%i'.       Comment: '%s'. ", dateid,sessionid,regiondata,locationdata,winddirectiondata,windspeeddata, buoysdirectiondata,buoysheightdata,buoysintervaldata,tidedata,ratingdata, commentdata];
				alert = [[UIAlertView alloc] initWithTitle:title
												   message:message
												  delegate:nil
										 cancelButtonTitle:@"Cool!"
										 otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
		}
		sqlite3_finalize(statement);
	}
	
	sqlite3_stmt *statement2;
	if(sqlite3_prepare_v2(database, [query2 UTF8String],-1, &statement2, nil) == SQLITE_OK){
		while(sqlite3_step(statement2) == SQLITE_ROW){
			count = sqlite3_column_int(statement2, 0);
			
			if(count == 0){
				title = [[NSString alloc] initWithFormat:@"Results"];
				message = [[NSString alloc] initWithFormat:@"Sorry, there are no matches in your database for this search."];
				alert = [[UIAlertView alloc] initWithTitle:title
												   message:message
												  delegate:nil
										 cancelButtonTitle:@"Oops!"
										 otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
		}
		sqlite3_finalize(statement2);
	}
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
	
	[super viewWillAppear:animated];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.title = NSLocalizedString(@"Database Search", @"database search");
	
	UIApplication *app2 = [UIApplication sharedApplication];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillTerminate:)
												 name:UIApplicationWillTerminateNotification
											   object:app2];
	
	[super viewDidLoad];
	
	
}


#pragma mark - method viewWillDisappear.
-(void) viewWillDisappear:(BOOL)animated {
	
	//Scroll keyboard down screen if showing.
	if(rating.editing){
		[rating resignFirstResponder];
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
	else if(resultnumber.editing){
		[resultnumber resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
    
    rating.text = @"";
    region.text = @"";
    location.text = @"";
    resultnumber.text = @"3";

	
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
	
	
	if(location.editing){
		float bottomPoint = (location.frame.origin.y + 
							 location.frame.size.height);
		scrollAmount = keyboardSize - (411 - bottomPoint);
	}
	
	else if(resultnumber.editing){
		float bottomPoint = (resultnumber.frame.origin.y + 
							 resultnumber.frame.size.height);
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
	if(rating.editing){
		[rating resignFirstResponder];
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
	else if(resultnumber.editing){
		[resultnumber resignFirstResponder];
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
    [rating release];
    [region release];
    [location release];
    [resultnumber release];
    [query release];
    [query2 release];
    [title release];
    [message release];
    [alert release];
}


@end
