    //
//  AddJournalViewController.m
//  Surfing Diary
//
//  Created by Andrew Newman on 6/2/11.
//  Copyright 2011 LightenUp!Enterprises, LLC. All rights reserved.
//

#import "AddJournalViewController.h"
#import "Surfing_JournalAppDelegate.h"
#import "DetailsViewController.h"
#import "Singleton.h"


@implementation AddJournalViewController

@synthesize detailsViewController;
@synthesize datePicker;


- (NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
														 , NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

#pragma details method gets the date and session
-(IBAction) details {
	
	//Selected Time Values:
	formatter = [[[NSDateFormatter alloc] init] autorelease];
	dateSelectedTime = [datePicker date];
    NSLog(@"Datew orignal in if stat: %@",dateSelectedTime);
	
	[formatter setDateFormat:@"HH:mm. EEEE dd MMMM, yyyy"];
	strSelectedTime = [formatter stringFromDate:dateSelectedTime];	
    NSLog(@"Datew orignal in if stat: %@",strSelectedTime);
	
	formatter2 = [[[NSDateFormatter alloc] init] autorelease];	
	[formatter2 setDateFormat:@"MMMM dd yyyy"];
	strSelectedDay = [formatter2 stringFromDate:dateSelectedTime];	
    NSLog(@"Datew orignal in if stat: %@",strSelectedDay);
	intSelectedDay = [strSelectedDay intValue];
	
	[formatter2 setDateFormat:@"HH"];
	strSelectedHour = [formatter2 stringFromDate:dateSelectedTime];
    NSLog(@"Datew orignal in if stat: %@",strSelectedHour);
	intSelectedHour = [strSelectedHour intValue];
	
	if(intSelectedHour >=5 && intSelectedHour <10) {
		session = [[NSString alloc] initWithFormat:@"dawn patrol"];
	}
	else if(intSelectedHour >=10 && intSelectedHour <15){
		session = [[NSString alloc] initWithFormat:@"midday sess"];
	}
	else if(intSelectedHour >=15 && intSelectedHour <20){
		session = [[NSString alloc] initWithFormat:@"evening sess"];
	}
	else if((intSelectedHour >=0 && intSelectedHour <5) || (intSelectedHour >=20 && intSelectedHour <24)){
		session = [[NSString alloc] initWithFormat:@"night sess"];
	}
    
	char *update = "INSERT INTO surflog (date,session) VALUES(?,?);";
	
	sqlite3_stmt *stmt;
	if(sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK){
		sqlite3_bind_text(stmt, 1, [strSelectedDay UTF8String], -1, NULL);
		sqlite3_bind_text(stmt, 2, [session UTF8String], -1, NULL);
	}
	if(sqlite3_step(stmt) != SQLITE_DONE)
		NSLog(@"statement falied");
    sqlite3_finalize(stmt);
	
    //This gives me the last entry made to carry to next view in singleton to use in update.
	NSString *query =  @"SELECT ROW FROM surflog order by row desc limit 1"; 
	
	sqlite3_stmt *statement;
	if(sqlite3_prepare_v2(database, [query UTF8String],-1, &statement, nil) == SQLITE_OK){
		while(sqlite3_step(statement) == SQLITE_ROW){
			int row = sqlite3_column_int(statement, 0);
			
			[[Singleton sharedSingleton] setnewrownumber:row];
			
		}
		sqlite3_finalize(statement);
	}
	
	sqlite3_close(database);

	
	if (self.detailsViewController == nil)
	{
		DetailsViewController *aDetail = [[DetailsViewController alloc] initWithNibName: @"DetailsView" bundle:[NSBundle mainBundle]];
		self.detailsViewController = aDetail;
		[aDetail release];
	}
	
	Surfing_JournalAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.surfingNavController pushViewController:detailsViewController animated:YES];
}


-(void)applicationWillTerminate:(NSNotification *)notification {
	sqlite3_close(database);
}

#pragma view will appear
-(void)viewWillAppear:(BOOL)animated {
	now = [[NSDate alloc] init];
	[datePicker setDate:now animated:YES];
	[datePicker setMinimumDate:nil];
	[datePicker setMaximumDate:nil];
	
	[now release];
	
	if(sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert(0,@"Failed to open database");
	}
	
	char *errorMsg;
	NSString *createSQL = @"CREATE TABLE IF NOT EXISTS surflog (row integer primary key,date text, session text, winddirection text,windspeed integer, buoysdirection text, buoysheight integer, buoysinterval integer, tide text, rating integer, comment text, region text, location text);";
	if(sqlite3_exec(database, [createSQL UTF8String],NULL,NULL,&errorMsg) != SQLITE_OK){
		sqlite3_close(database);
	}
}


#pragma view did load
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title =  NSLocalizedString(@"New Entry", @"new entries");
	
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


- (void)dealloc {
    [super dealloc];
    [datePicker release];
    [detailsViewController release];
    [formatter release];
    [formatter2 release];
    [formatter3 release];
    [now release];
    [strSelectedDay release];
    [strSelectedHour release];
    [strSelectedMinutes release];
    [strSelectedTime release];
    [dateSelectedTime release];
    [session release];
}


@end
