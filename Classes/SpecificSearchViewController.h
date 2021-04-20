//
//  SpecificSearchViewController.h
//  Surfing Diary
//
//  Created by Andrew Newman on 6/2/11.
//  Copyright 2011 LightenUp!Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

#define kFilename	@"surf1.sqlite3"

@interface SpecificSearchViewController : UIViewController <UITextFieldDelegate>  {

	IBOutlet UITextField *rating;
	IBOutlet UITextField *region;
	IBOutlet UITextField *location;
	IBOutlet UITextField *resultnumber;
	
	BOOL moveViewUp;
	CGFloat scrollAmount;
	
	sqlite3 *database;
	
	int count;
	int ratingint;
	int resultnum;
	
	NSString *query;
	NSString *query2;
	
	NSString *title;
	NSString *message;
	UIAlertView *alert;
	
}

@property (nonatomic, retain) UITextField *rating;
@property (nonatomic, retain) UITextField *region;
@property (nonatomic, retain) UITextField *location;
@property (nonatomic, retain) UITextField *resultnumber;


-(NSString *)dataFilePath;
-(void)applicationWillTerminate:(NSNotification *)notification;
-(void) scrollTheView:(BOOL)movedUp;
-(IBAction) searchdatabase;
-(void)runSelectionInDatabase:(NSString *)givenString givenStringText:(NSString *)givenStringText;
-(void)runSelectionInDatabase2:(NSString *)givenString givenStringText:(NSString *)givenStringText givenString2:(NSString *)givenString2 givenStringText2:(NSString *)givenStringText2;

@end
