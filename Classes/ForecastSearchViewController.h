//
//  ForecastSearchViewController.h
//  Surfing Diary
//
//  Created by Andrew Newman on 6/2/11.
//  Copyright 2011 LightenUp!Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

#define kFilename	@"surf1.sqlite3"

@interface ForecastSearchViewController : UIViewController <UITextFieldDelegate>  {
	
	IBOutlet UITextField *buoysdirection;
	IBOutlet UITextField *buoysheight;
	IBOutlet UITextField *buoysinterval;	
	IBOutlet UITextField *tide;
	IBOutlet UITextField *winddirection;
    IBOutlet UITextField *windspeed;
	IBOutlet UITextField *region;
	IBOutlet UITextField *resultnumber;
	
	BOOL moveViewUp;
	CGFloat scrollAmount;
	
	sqlite3 *database;
	
	int count;
	int resultnum;
    
    NSMutableArray *buoysdirectionvalues;
    NSMutableArray *winddirectionvalues;
	NSMutableArray *testvalues;
    
	int buoysheight1;
	int buoysheight2;
	int buoysinterval1;
	int buoysinterval2;

    int windspeed1;
	int windspeed2;
	
	NSString *query;
	NSString *query2;
	
	NSString *title;
	NSString *message;
	UIAlertView *alert;
	
}

@property (nonatomic, retain) UITextField *buoysdirection;
@property (nonatomic, retain) UITextField *buoysheight;
@property (nonatomic, retain) UITextField *buoysinterval;
@property (nonatomic, retain) UITextField *tide;
@property (nonatomic, retain) UITextField *winddirection;
@property (nonatomic, retain) UITextField *windspeed;
@property (nonatomic, retain) UITextField *region;
@property (nonatomic, retain) UITextField *resultnumber;

-(NSString *)dataFilePath;
-(void)applicationWillTerminate:(NSNotification *)notification;

-(void)runSelectionInDatabase:(NSString *)givenString givenStringText:(NSString *)givenStringText;

-(void)runSelectionInDatabase2:(NSString *)givenString givenStringText:(NSString *)givenStringText givenString2:(NSString *)givenString2 givenStringText2:(NSString *)givenStringText2;

-(void)runSelectionInDatabase3:(NSString *)givenString givenStringText:(NSString *)givenStringText givenString2:(NSString *)givenString2 givenStringText2:(NSString *)givenStringText2 givenString3:(NSString *)givenString3 givenStringText3:(NSString *)givenStringText3;

-(void)runSelectionInDatabase4:(NSString *)givenString givenStringText:(NSString *)givenStringText givenString2:(NSString *)givenString2 givenStringText2:(NSString *)givenStringText2 givenString3:(NSString *)givenString3 givenStringText3:(NSString *)givenStringText3 givenString4:(NSString *)givenString4 givenStringText4:(NSString *)givenStringText4;

-(void)runSelectionInDatabase5:(NSString *)givenString givenStringText:(NSString *)givenStringText givenString2:(NSString *)givenString2 givenStringText2:(NSString *)givenStringText2 givenString3:(NSString *)givenString3 givenStringText3:(NSString *)givenStringText3 givenString4:(NSString *)givenString4 givenStringText4:(NSString *)givenStringText4 givenString5:(NSString *)givenString5 givenStringText5:(NSString *)givenStringText5;

-(void)runSelectionInDatabase6:(NSString *)givenString givenStringText:(NSString *)givenStringText givenString2:(NSString *)givenString2 givenStringText2:(NSString *)givenStringText2 givenString3:(NSString *)givenString3 givenStringText3:(NSString *)givenStringText3 givenString4:(NSString *)givenString4 givenStringText4:(NSString *)givenStringText4 givenString5:(NSString *)givenString5 givenStringText5:(NSString *)givenStringText5 givenString6:(NSString *)givenString6 givenStringText6:(NSString *)givenStringText6;

-(void)runSelectionInDatabase7:(NSString *)givenString givenStringText:(NSString *)givenStringText givenString2:(NSString *)givenString2 givenStringText2:(NSString *)givenStringText2 givenString3:(NSString *)givenString3 givenStringText3:(NSString *)givenStringText3 givenString4:(NSString *)givenString4 givenStringText4:(NSString *)givenStringText4 givenString5:(NSString *)givenString5 givenStringText5:(NSString *)givenStringText5 givenString6:(NSString *)givenString6 givenStringText6:(NSString *)givenStringText6 givenString7:(NSString *)givenString7 givenStringText7:(NSString *)givenStringText7;

-(NSMutableArray *)directionValues:(NSString *)givenString;
-(void)showQueryResults: (NSString *)sqlquery countquery:(NSString *)sqlquery2;

-(void) scrollTheView:(BOOL)movedUp;
-(IBAction) searchdatabase;

@end