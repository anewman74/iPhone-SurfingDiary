    //
//  ForecastSearchViewController.m
//  Surfing Diary
//
//  Created by Andrew Newman on 6/2/11.
//  Copyright 2011 LightenUp!Enterprises, LLC. All rights reserved.
//

#import "ForecastSearchViewController.h"
#import "Singleton.h"
#import "Surfing_JournalAppDelegate.h"

@implementation ForecastSearchViewController

@synthesize buoysdirection;
@synthesize buoysheight;
@synthesize buoysinterval;
@synthesize tide;
@synthesize winddirection;
@synthesize windspeed;
@synthesize region;
@synthesize resultnumber;

- (NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
														 , NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

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
	
	int windspeednum = [windspeed.text intValue];
	int buoysheightnum = [buoysheight.text intValue];
	int buoysintervalnum = [buoysinterval.text intValue];
	resultnum = [resultnumber.text intValue];
    
    buoysdirection.text = [buoysdirection.text lowercaseString];
	tide.text = [tide.text lowercaseString];
    winddirection.text = [winddirection.text lowercaseString];
    region.text = [region.text lowercaseString];
	
	//Determine buoys height range.
	buoysheight1 = buoysheightnum -1;
	buoysheight2 = buoysheightnum +1;
	
	//Determine buoys interval range.
	buoysinterval1 = buoysintervalnum -3;
	buoysinterval2 = buoysintervalnum +3;
    
    //Determine wind speed range.
	windspeed1 = windspeednum -1;
	windspeed2 = windspeednum +1; 
    
    
	#pragma mark - methods after user inputs data.
	//Search where buoys direction, wave height and interval are given.
    if((![buoysdirection.text isEqualToString:@""]) && (![buoysheight.text isEqualToString:@""]) && (![buoysinterval.text isEqualToString:@""]) && ([tide.text isEqualToString:@""]) && ([winddirection.text isEqualToString:@""]) && ([windspeed.text isEqualToString:@""]) && ([region.text isEqualToString:@""])){
		
		[self runSelectionInDatabase3:@"buoysdirection" givenStringText:buoysdirection.text givenString2:@"buoysheight" givenStringText2:buoysheight.text givenString3:@"buoysinterval" givenStringText3:buoysinterval.text];		
	}
    
    //Search where wind direction and speed are only given.
	else if(([buoysdirection.text isEqualToString:@""]) && ([buoysheight.text isEqualToString:@""]) && ([buoysinterval.text isEqualToString:@""]) && ([tide.text isEqualToString:@""]) && (![winddirection.text isEqualToString:@""]) && (![windspeed.text isEqualToString:@""]) && ([region.text isEqualToString:@""])) {
		
		[self runSelectionInDatabase2:@"winddirection" givenStringText:winddirection.text givenString2:@"windspeed" givenStringText2:windspeed.text];
	}
	
	//Search where tide is only given.
	else if(([buoysdirection.text isEqualToString:@""]) && ([buoysheight.text isEqualToString:@""]) && ([buoysinterval.text isEqualToString:@""]) && (![tide.text isEqualToString:@""]) && ([winddirection.text isEqualToString:@""]) && ([windspeed.text isEqualToString:@""]) && ([region.text isEqualToString:@""])) {
		
		[self runSelectionInDatabase: @"tide" givenStringText:tide.text];		
	}
		
	//Search where region is only given.
	else if(([buoysdirection.text isEqualToString:@""]) && ([buoysheight.text isEqualToString:@""]) && ([buoysinterval.text isEqualToString:@""]) && ([tide.text isEqualToString:@""]) && ([winddirection.text isEqualToString:@""]) && ([windspeed.text isEqualToString:@""]) && (![region.text isEqualToString:@""])) {
		
		[self runSelectionInDatabase: @"region" givenStringText:region.text];		
	}
	
	
	//Search where region and tide are given.
	else if(([buoysdirection.text isEqualToString:@""]) && ([buoysheight.text isEqualToString:@""]) && ([buoysinterval.text isEqualToString:@""]) && (![tide.text isEqualToString:@""]) && ([winddirection.text isEqualToString:@""]) && ([windspeed.text isEqualToString:@""]) && (![region.text isEqualToString:@""])){
		
		[self runSelectionInDatabase2:@"region" givenStringText:region.text givenString2:@"tide" givenStringText2:tide.text];		
	}
	
	//Search where region, wind direction and wind speed are given.
	else if(([buoysdirection.text isEqualToString:@""]) && ([buoysheight.text isEqualToString:@""]) && ([buoysinterval.text isEqualToString:@""]) && ([tide.text isEqualToString:@""]) && (![winddirection.text isEqualToString:@""]) && (![windspeed.text isEqualToString:@""]) && (![region.text isEqualToString:@""])){
        
        [self runSelectionInDatabase3:@"region" givenStringText:region.text givenString2:@"winddirection" givenStringText2:winddirection.text givenString3:@"windspeed" givenStringText3:windspeed.text];
	}
    
    //Search where tide, wind direction and wind speed are given.
	else if(([buoysdirection.text isEqualToString:@""]) && ([buoysheight.text isEqualToString:@""]) && ([buoysinterval.text isEqualToString:@""]) && (![tide.text isEqualToString:@""]) && (![winddirection.text isEqualToString:@""]) && (![windspeed.text isEqualToString:@""]) && ([region.text isEqualToString:@""])){
        
        [self runSelectionInDatabase3:@"tide" givenStringText:tide.text givenString2:@"winddirection" givenStringText2:winddirection.text givenString3:@"windspeed" givenStringText3:windspeed.text];
	}
    
    //Search where wind direction, speed, tide and region are given.
    else if(([buoysdirection.text isEqualToString:@""]) && ([buoysheight.text isEqualToString:@""]) && ([buoysinterval.text isEqualToString:@""]) && (![tide.text isEqualToString:@""]) && (![winddirection.text isEqualToString:@""]) && (![windspeed.text isEqualToString:@""]) && (![region.text isEqualToString:@""])){
		
		[self runSelectionInDatabase4:@"winddirection" givenStringText:winddirection.text givenString2:@"windspeed" givenStringText2:windspeed.text givenString3:@"tide" givenStringText3:tide.text givenString4:@"region" givenStringText4:region.text];		
	}
    
    //Search where buoys direction, wave height,interval and tide are given.
    else if((![buoysdirection.text isEqualToString:@""]) && (![buoysheight.text isEqualToString:@""]) && (![buoysinterval.text isEqualToString:@""]) && (![tide.text isEqualToString:@""]) && ([winddirection.text isEqualToString:@""]) && ([windspeed.text isEqualToString:@""]) && ([region.text isEqualToString:@""])){
		
		[self runSelectionInDatabase4:@"buoysdirection" givenStringText:buoysdirection.text givenString2:@"buoysheight" givenStringText2:buoysheight.text givenString3:@"buoysinterval" givenStringText3:buoysinterval.text givenString4:@"tide" givenStringText4:tide.text];		
	}
    
    //Search where buoys direction, wave height,interval and region are given.
    else if((![buoysdirection.text isEqualToString:@""]) && (![buoysheight.text isEqualToString:@""]) && (![buoysinterval.text isEqualToString:@""]) && ([tide.text isEqualToString:@""]) && ([winddirection.text isEqualToString:@""]) && ([windspeed.text isEqualToString:@""]) && (![region.text isEqualToString:@""])){
		
		[self runSelectionInDatabase4:@"buoysdirection" givenStringText:buoysdirection.text givenString2:@"buoysheight" givenStringText2:buoysheight.text givenString3:@"buoysinterval" givenStringText3:buoysinterval.text givenString4:@"region" givenStringText4:region.text];		
	}
    
    //Search where buoys direction, wave height,interval, tide and region are given.
    else if((![buoysdirection.text isEqualToString:@""]) && (![buoysheight.text isEqualToString:@""]) && (![buoysinterval.text isEqualToString:@""]) && (![tide.text isEqualToString:@""]) && ([winddirection.text isEqualToString:@""]) && ([windspeed.text isEqualToString:@""]) && (![region.text isEqualToString:@""])){
		
		[self runSelectionInDatabase5:@"buoysdirection" givenStringText:buoysdirection.text givenString2:@"buoysheight" givenStringText2:buoysheight.text givenString3:@"buoysinterval" givenStringText3:buoysinterval.text givenString4:@"tide" givenStringText4:tide.text givenString5:@"region" givenStringText5:region.text];		
	}
	
    //Search where buoys and wind are given.
    else if((![buoysdirection.text isEqualToString:@""]) && (![buoysheight.text isEqualToString:@""]) && (![buoysinterval.text isEqualToString:@""]) && ([tide.text isEqualToString:@""]) && (![winddirection.text isEqualToString:@""]) && (![windspeed.text isEqualToString:@""]) && ([region.text isEqualToString:@""])){
		
		[self runSelectionInDatabase5:@"buoysdirection" givenStringText:buoysdirection.text givenString2:@"buoysheight" givenStringText2:buoysheight.text givenString3:@"buoysinterval" givenStringText3:buoysinterval.text givenString4:@"winddirection" givenStringText4:winddirection.text givenString5:@"windspeed" givenStringText5:windspeed.text];		
	}
    
    //Search where buoys, wind and tide are given.
    else if((![buoysdirection.text isEqualToString:@""]) && (![buoysheight.text isEqualToString:@""]) && (![buoysinterval.text isEqualToString:@""]) && (![tide.text isEqualToString:@""]) && (![winddirection.text isEqualToString:@""]) && (![windspeed.text isEqualToString:@""]) && ([region.text isEqualToString:@""])){
		
		[self runSelectionInDatabase6:@"buoysdirection" givenStringText:buoysdirection.text givenString2:@"buoysheight" givenStringText2:buoysheight.text givenString3:@"buoysinterval" givenStringText3:buoysinterval.text givenString4:@"winddirection" givenStringText4:winddirection.text givenString5:@"windspeed" givenStringText5:windspeed.text givenString6:@"tide" givenStringText6:tide.text];
    }
    
    //Search where buoys, wind and region are given.
    else if((![buoysdirection.text isEqualToString:@""]) && (![buoysheight.text isEqualToString:@""]) && (![buoysinterval.text isEqualToString:@""]) && ([tide.text isEqualToString:@""]) && (![winddirection.text isEqualToString:@""]) && (![windspeed.text isEqualToString:@""]) && (![region.text isEqualToString:@""])){
		
		[self runSelectionInDatabase6:@"buoysdirection" givenStringText:buoysdirection.text givenString2:@"buoysheight" givenStringText2:buoysheight.text givenString3:@"buoysinterval" givenStringText3:buoysinterval.text givenString4:@"winddirection" givenStringText4:winddirection.text givenString5:@"windspeed" givenStringText5:windspeed.text givenString6:@"region" givenStringText6:region.text];
    }
	
	//Search where all the factors are given.
	else if((![buoysdirection.text isEqualToString:@""]) && (![buoysheight.text isEqualToString:@""]) && (![buoysinterval.text isEqualToString:@""]) && (![tide.text isEqualToString:@""]) && (![winddirection.text isEqualToString:@""]) && (![windspeed.text isEqualToString:@""]) && (![region.text isEqualToString:@""])){
		
        [self runSelectionInDatabase7:@"buoysdirection" givenStringText:buoysdirection.text givenString2:@"buoysheight" givenStringText2:buoysheight.text givenString3:@"buoysinterval" givenStringText3:buoysinterval.text givenString4:@"winddirection" givenStringText4:winddirection.text givenString5:@"windspeed" givenStringText5:windspeed.text givenString6:@"tide" givenStringText6:tide.text givenString7:@"region" givenStringText7:region.text];
	}
}

#pragma mark - runSelectionInDatabase.
-(void)runSelectionInDatabase:(NSString *)givenString givenStringText:(NSString *)givenStringText{
    
    query = [[NSString alloc] initWithFormat: @"SELECT row, winddirection,windspeed,buoysdirection, buoysheight, buoysinterval, tide, region,location,rating,comment, date, session FROM surflog where %@ = '%@' ORDER BY rating DESC",givenString,givenStringText];
		
    query2 = [[NSString alloc] initWithFormat:  @"SELECT count(*) FROM surflog where %@ = '%@'",givenString,givenStringText];
	
    [self showQueryResults:query countquery:query2]; 
}

#pragma mark - runSelectionInDatabase2
-(void)runSelectionInDatabase2:(NSString *)givenString givenStringText:(NSString *)givenStringText givenString2:(NSString *)givenString2 givenStringText2:(NSString *)givenStringText2 {
    
    if(![winddirection.text isEqualToString:@""]){
        
        winddirectionvalues = [[NSMutableArray alloc] init];
        winddirectionvalues =  [self directionValues:winddirection.text];       
    }
	
	if ([givenString isEqualToString:@"winddirection"]) {
		query = [[NSString alloc] initWithFormat: @"SELECT row, winddirection,windspeed,buoysdirection, buoysheight, buoysinterval, tide, region,location,rating,comment, date, session FROM surflog where (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i and %@ <= %i) ORDER BY rating DESC",givenString,[winddirectionvalues objectAtIndex:0],givenString,[winddirectionvalues objectAtIndex:1],givenString,[winddirectionvalues objectAtIndex:2],givenString2,windspeed1,givenString2,windspeed2];
		
		query2 = [[NSString alloc] initWithFormat:  @"SELECT count(*) FROM surflog where (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i and %@ <= %i)",givenString,[winddirectionvalues objectAtIndex:0],givenString,[winddirectionvalues objectAtIndex:1],givenString,[winddirectionvalues objectAtIndex:2],givenString2,windspeed1,givenString2,windspeed2];
	}
	
    //region and tide given
	else {
		query = [[NSString alloc] initWithFormat: @"SELECT row, winddirection,windspeed,buoysdirection, buoysheight, buoysinterval, tide, region,location,rating,comment, date, session FROM surflog where %@ = '%@' and %@ = '%@' ORDER BY rating DESC",givenString,givenStringText,givenString2,givenStringText2];
		
		query2 = [[NSString alloc] initWithFormat:  @"SELECT count(*) FROM surflog where %@ = '%@' and %@ = '%@'",givenString,givenStringText,givenString2,givenStringText2];
	}
    
    [self showQueryResults:query countquery:query2];	
}


#pragma mark - runSelectionInDatabase3
-(void)runSelectionInDatabase3:(NSString *)givenString givenStringText:(NSString *)givenStringText givenString2:(NSString *)givenString2 givenStringText2:(NSString *)givenStringText2 givenString3:(NSString *)givenString3 givenStringText3:(NSString *)givenStringText3 {

    if(![buoysdirection.text isEqualToString:@""]){
        
        buoysdirectionvalues = [[NSMutableArray alloc] init];
        buoysdirectionvalues =  [self directionValues:buoysdirection.text];      
    }
    
    if(![winddirection.text isEqualToString:@""]){
        
        winddirectionvalues = [[NSMutableArray alloc] init];
        winddirectionvalues =  [self directionValues:winddirection.text];       
    }
    
    //If only buoys dimensions are given
    if ([givenString isEqualToString:@"buoysdirection"]) {
		query = [[NSString alloc] initWithFormat: @"SELECT row, winddirection,windspeed,buoysdirection, buoysheight, buoysinterval, tide, region,location,rating,comment, date, session FROM surflog where (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i and %@ <= %i) AND (%@ >= %i and %@ <= %i) ORDER BY rating DESC",givenString,[buoysdirectionvalues objectAtIndex:0],givenString,[buoysdirectionvalues objectAtIndex:1],givenString,[buoysdirectionvalues objectAtIndex:2],givenString2,buoysheight1,givenString2,buoysheight2,givenString3,buoysinterval1,givenString3,buoysinterval2];
		
		query2 = [[NSString alloc] initWithFormat:  @"SELECT count(*) FROM surflog where (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i and %@ <= %i) AND (%@ >= %i and %@ <= %i)",givenString,[buoysdirectionvalues objectAtIndex:0],givenString,[buoysdirectionvalues objectAtIndex:1],givenString,[buoysdirectionvalues objectAtIndex:2],givenString2,buoysheight1,givenString2,buoysheight2,givenString3,buoysinterval1,givenString3,buoysinterval2];
	}
	
	
	//Search where region or tide, and wind direction and wind speed are given.
	else {
		query = [[NSString alloc] initWithFormat: @"SELECT row, winddirection,windspeed,buoysdirection, buoysheight, buoysinterval, tide, region,location,rating,comment, date, session FROM surflog where (%@ = '%@') AND (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i AND %@ <= %i) ORDER BY rating DESC",givenString,givenStringText,givenString2,[winddirectionvalues objectAtIndex:0],givenString2,[winddirectionvalues objectAtIndex:1],givenString2,[winddirectionvalues objectAtIndex:2],givenString3,windspeed1,givenString3,windspeed2];
		
		query2 = [[NSString alloc] initWithFormat:  @"SELECT count(*) FROM surflog where (%@ = '%@') AND (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i AND %@ <= %i)",givenString,givenStringText,givenString2,[winddirectionvalues objectAtIndex:0],givenString2,[winddirectionvalues objectAtIndex:1],givenString2,[winddirectionvalues objectAtIndex:2],givenString3,windspeed1,givenString3,windspeed2];
	}
	
    [self showQueryResults:query countquery:query2]; 
    
}

#pragma mark - runSelectionInDatabase4
-(void)runSelectionInDatabase4:(NSString *)givenString givenStringText:(NSString *)givenStringText givenString2:(NSString *)givenString2 givenStringText2:(NSString *)givenStringText2 givenString3:(NSString *)givenString3 givenStringText3:(NSString *)givenStringText3 givenString4:(NSString *)givenString4 givenStringText4:(NSString *)givenStringText4 {
    
    if(![buoysdirection.text isEqualToString:@""]){
        
        buoysdirectionvalues = [[NSMutableArray alloc] init];
        buoysdirectionvalues =  [self directionValues:buoysdirection.text];      
    }
    
    if(![winddirection.text isEqualToString:@""]){
        
        winddirectionvalues = [[NSMutableArray alloc] init];
        winddirectionvalues =  [self directionValues:winddirection.text];       
    }
    
    //If wind, tide and region are given
    if ([givenString isEqualToString:@"winddirection"]) {
		query = [[NSString alloc] initWithFormat: @"SELECT row, winddirection,windspeed,buoysdirection, buoysheight, buoysinterval, tide, region,location,rating,comment, date, session FROM surflog where (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i and %@ <= %i) AND (%@ = '%@') AND (%@ = '%@') ORDER BY rating DESC",givenString,[winddirectionvalues objectAtIndex:0],givenString,[winddirectionvalues objectAtIndex:1],givenString,[winddirectionvalues objectAtIndex:2],givenString2,windspeed1,givenString2,windspeed2,givenString3,givenStringText3,givenString4,givenStringText4];
		
		query2 = [[NSString alloc] initWithFormat:  @"SELECT count(*) FROM surflog where (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i and %@ <= %i) AND (%@ = '%@') AND (%@ = '%@')",givenString,[winddirectionvalues objectAtIndex:0],givenString,[winddirectionvalues objectAtIndex:1],givenString,[winddirectionvalues objectAtIndex:2],givenString2,windspeed1,givenString2,windspeed2,givenString3,givenStringText3,givenString4,givenStringText4];
	}
    
    //If region or tide and buoys dimensions are given
    else {
		query = [[NSString alloc] initWithFormat: @"SELECT row, winddirection,windspeed,buoysdirection, buoysheight, buoysinterval, tide, region,location,rating,comment, date, session FROM surflog where (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i and %@ <= %i) AND (%@ >= %i and %@ <= %i) AND (%@ = '%@') ORDER BY rating DESC",givenString,[buoysdirectionvalues objectAtIndex:0],givenString,[buoysdirectionvalues objectAtIndex:1],givenString,[buoysdirectionvalues objectAtIndex:2],givenString2,buoysheight1,givenString2,buoysheight2,givenString3,buoysinterval1,givenString3,buoysinterval2,givenString4,givenStringText4];
		
		query2 = [[NSString alloc] initWithFormat:  @"SELECT count(*) FROM surflog where (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i and %@ <= %i) AND (%@ >= %i and %@ <= %i) AND (%@ = '%@')",givenString,[buoysdirectionvalues objectAtIndex:0],givenString,[buoysdirectionvalues objectAtIndex:1],givenString,[buoysdirectionvalues objectAtIndex:2],givenString2,buoysheight1,givenString2,buoysheight2,givenString3,buoysinterval1,givenString3,buoysinterval2,givenString4,givenStringText4];
	}
	
    [self showQueryResults:query countquery:query2]; 
    
}

#pragma mark - runSelectionInDatabase5
-(void)runSelectionInDatabase5:(NSString *)givenString givenStringText:(NSString *)givenStringText givenString2:(NSString *)givenString2 givenStringText2:(NSString *)givenStringText2 givenString3:(NSString *)givenString3 givenStringText3:(NSString *)givenStringText3 givenString4:(NSString *)givenString4 givenStringText4:(NSString *)givenStringText4 givenString5:(NSString *)givenString5 givenStringText5:(NSString *)givenStringText5 {
    
    if(![buoysdirection.text isEqualToString:@""]){
        
        buoysdirectionvalues = [[NSMutableArray alloc] init];
        buoysdirectionvalues =  [self directionValues:buoysdirection.text];        
    }
    
    if(![winddirection.text isEqualToString:@""]){
        
        winddirectionvalues = [[NSMutableArray alloc] init];
        winddirectionvalues =  [self directionValues:winddirection.text];       
    }
    
    //If buoys and wind are given
    if ([givenString isEqualToString:@"winddirection"]) {
		query = [[NSString alloc] initWithFormat: @"SELECT row, winddirection,windspeed,buoysdirection, buoysheight, buoysinterval, tide, region,location,rating,comment, date, session FROM surflog where (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i AND %@ <= %i) AND (%@ >= %i AND %@ <= %i) AND (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i AND %@ <= %i) ORDER BY rating DESC",givenString,[buoysdirectionvalues objectAtIndex:0],givenString,[buoysdirectionvalues objectAtIndex:1],givenString,[buoysdirectionvalues objectAtIndex:2],givenString2,buoysheight1,givenString2,buoysheight2,givenString3,buoysinterval1,givenString3,buoysinterval2,givenString4,[winddirectionvalues objectAtIndex:0],givenString4,[winddirectionvalues objectAtIndex:1],givenString4,[winddirectionvalues objectAtIndex:2],givenString5,windspeed1,givenString5,windspeed2];
		
		query2 = [[NSString alloc] initWithFormat:  @"SELECT count(*) FROM surflog where (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i AND %@ <= %i) AND (%@ >= %i AND %@ <= %i) AND (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i AND %@ <= %i)",givenString,[buoysdirectionvalues objectAtIndex:0],givenString,[buoysdirectionvalues objectAtIndex:1],givenString,[buoysdirectionvalues objectAtIndex:2],givenString2,buoysheight1,givenString2,buoysheight2,givenString3,buoysinterval1,givenString3,buoysinterval2,givenString4,[winddirectionvalues objectAtIndex:0],givenString4,[winddirectionvalues objectAtIndex:1],givenString4,[winddirectionvalues objectAtIndex:2],givenString5,windspeed1,givenString5,windspeed2];
	}
    
    //If buoys, region and tide are given
    else {
		query = [[NSString alloc] initWithFormat: @"SELECT row, winddirection,windspeed,buoysdirection, buoysheight, buoysinterval, tide, region,location,rating,comment, date, session FROM surflog where (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i AND %@ <= %i) AND (%@ >= %i AND %@ <= %i) AND (%@ = '%@') AND (%@ = '%@') ORDER BY rating DESC",givenString,[buoysdirectionvalues objectAtIndex:0],givenString,[buoysdirectionvalues objectAtIndex:1],givenString,[buoysdirectionvalues objectAtIndex:2],givenString2,buoysheight1,givenString2,buoysheight2,givenString3,buoysinterval1,givenString3,buoysinterval2,givenString4,givenStringText4,givenString5,givenStringText5];
		
		query2 = [[NSString alloc] initWithFormat:  @"SELECT count(*) FROM surflog where (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i AND %@ <= %i) AND (%@ >= %i AND %@ <= %i) AND (%@ = '%@') AND (%@ = '%@')",givenString,[buoysdirectionvalues objectAtIndex:0],givenString,[buoysdirectionvalues objectAtIndex:1],givenString,[buoysdirectionvalues objectAtIndex:2],givenString2,buoysheight1,givenString2,buoysheight2,givenString3,buoysinterval1,givenString3,buoysinterval2,givenString4,givenStringText4,givenString5,givenStringText5];
	}
	
    [self showQueryResults:query countquery:query2]; 
    
}

#pragma mark - runSelectionInDatabase6
-(void)runSelectionInDatabase6:(NSString *)givenString givenStringText:(NSString *)givenStringText givenString2:(NSString *)givenString2 givenStringText2:(NSString *)givenStringText2 givenString3:(NSString *)givenString3 givenStringText3:(NSString *)givenStringText3 givenString4:(NSString *)givenString4 givenStringText4:(NSString *)givenStringText4 givenString5:(NSString *)givenString5 givenStringText5:(NSString *)givenStringText5 givenString6:(NSString *)givenString6 givenStringText6:(NSString *)givenStringText6 {
    
    if(![buoysdirection.text isEqualToString:@""]){
        
        buoysdirectionvalues = [[NSMutableArray alloc] init];
        buoysdirectionvalues =  [self directionValues:buoysdirection.text];      
    }
    
    if(![winddirection.text isEqualToString:@""]){
        
        winddirectionvalues = [[NSMutableArray alloc] init];
        winddirectionvalues =  [self directionValues:winddirection.text];      
    }
    
    //If buoys and wind and (region or tide) are given
    query = [[NSString alloc] initWithFormat: @"SELECT row, winddirection,windspeed,buoysdirection, buoysheight, buoysinterval, tide, region,location,rating,comment, date, session FROM surflog where (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i AND %@ <= %i) AND (%@ >= %i AND %@ <= %i) AND (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i AND %@ <= %i) AND (%@ = '%@') ORDER BY rating DESC",givenString,[buoysdirectionvalues objectAtIndex:0],givenString,[buoysdirectionvalues objectAtIndex:1],givenString,[buoysdirectionvalues objectAtIndex:2],givenString2,buoysheight1,givenString2,buoysheight2,givenString3,buoysinterval1,givenString3,buoysinterval2,givenString4,[winddirectionvalues objectAtIndex:0],givenString4,[winddirectionvalues objectAtIndex:1],givenString4,[winddirectionvalues objectAtIndex:2],givenString5,windspeed1,givenString5,windspeed2,givenString6,givenStringText6];
		
    query2 = [[NSString alloc] initWithFormat:  @"SELECT count(*) FROM surflog where (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i AND %@ <= %i) AND (%@ >= %i AND %@ <= %i) AND (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i AND %@ <= %i) AND (%@ = '%@')",givenString,[buoysdirectionvalues objectAtIndex:0],givenString,[buoysdirectionvalues objectAtIndex:1],givenString,[buoysdirectionvalues objectAtIndex:2],givenString2,buoysheight1,givenString2,buoysheight2,givenString3,buoysinterval1,givenString3,buoysinterval2,givenString4,[winddirectionvalues objectAtIndex:0],givenString4,[winddirectionvalues objectAtIndex:1],givenString4,[winddirectionvalues objectAtIndex:2],givenString5,windspeed1,givenString5,windspeed2,givenString6,givenStringText6];
	
    [self showQueryResults:query countquery:query2]; 
    
}

#pragma mark - runSelectionInDatabase7
-(void)runSelectionInDatabase7:(NSString *)givenString givenStringText:(NSString *)givenStringText givenString2:(NSString *)givenString2 givenStringText2:(NSString *)givenStringText2 givenString3:(NSString *)givenString3 givenStringText3:(NSString *)givenStringText3 givenString4:(NSString *)givenString4 givenStringText4:(NSString *)givenStringText4 givenString5:(NSString *)givenString5 givenStringText5:(NSString *)givenStringText5 givenString6:(NSString *)givenString6 givenStringText6:(NSString *)givenStringText6 givenString7:(NSString *)givenString7 givenStringText7:(NSString *)givenStringText7 {
    
    if(![buoysdirection.text isEqualToString:@""]){
        
        buoysdirectionvalues = [[NSMutableArray alloc] init];
        buoysdirectionvalues =  [self directionValues:buoysdirection.text];      
    }
    
    if(![winddirection.text isEqualToString:@""]){
        
        winddirectionvalues = [[NSMutableArray alloc] init];
        winddirectionvalues =  [self directionValues:winddirection.text];       
    }
    
    //If buoys and wind and (region or tide) are given
    query = [[NSString alloc] initWithFormat: @"SELECT row, winddirection,windspeed,buoysdirection, buoysheight, buoysinterval, tide, region,location,rating,comment, date, session FROM surflog where (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i AND %@ <= %i) AND (%@ >= %i AND %@ <= %i) AND (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i AND %@ <= %i) AND (%@ = '%@') AND (%@ = '%@') ORDER BY rating DESC",givenString,[buoysdirectionvalues objectAtIndex:0],givenString,[buoysdirectionvalues objectAtIndex:1],givenString,[buoysdirectionvalues objectAtIndex:2],givenString2,buoysheight1,givenString2,buoysheight2,givenString3,buoysinterval1,givenString3,buoysinterval2,givenString4,[winddirectionvalues objectAtIndex:0],givenString4,[winddirectionvalues objectAtIndex:1],givenString4,[winddirectionvalues objectAtIndex:2],givenString5,windspeed1,givenString5,windspeed2,givenString6,givenStringText6,givenString7,givenStringText7];
    
    query2 = [[NSString alloc] initWithFormat:  @"SELECT count(*) FROM surflog where (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i AND %@ <= %i) AND (%@ >= %i AND %@ <= %i) AND (%@ = '%@' OR %@ = '%@' OR %@ = '%@') AND (%@ >= %i AND %@ <= %i) AND (%@ = '%@') AND (%@ = '%@')",givenString,[buoysdirectionvalues objectAtIndex:0],givenString,[buoysdirectionvalues objectAtIndex:1],givenString,[buoysdirectionvalues objectAtIndex:2],givenString2,buoysheight1,givenString2,buoysheight2,givenString3,buoysinterval1,givenString3,buoysinterval2,givenString4,[winddirectionvalues objectAtIndex:0],givenString4,[winddirectionvalues objectAtIndex:1],givenString4,[winddirectionvalues objectAtIndex:2],givenString5,windspeed1,givenString5,windspeed2,givenString6,givenStringText6,givenString7,givenStringText7];
	
    [self showQueryResults:query countquery:query2]; 
}


#pragma - Determine wind direction rand buoys direction ranges.
-(NSArray *)directionValues:(NSString *)givenDirection {
    
    testvalues = [[NSMutableArray alloc] init];
    [testvalues addObject:givenDirection];
    
    if ([givenDirection isEqualToString:@"n"]) {
        [testvalues addObject:@"nnw"];
        [testvalues addObject:@"nne"];
    }
    else if ([givenDirection isEqualToString:@"nne"]) {
        [testvalues addObject:@"n"];
        [testvalues addObject:@"ne"];
    }
    else if ([givenDirection isEqualToString:@"ne"]) {
        [testvalues addObject:@"nne"];
        [testvalues addObject:@"ene"];
    }
    else if ([givenDirection isEqualToString:@"ene"]) {
        [testvalues addObject:@"ne"];
        [testvalues addObject:@"e"];
    }
    else if ([givenDirection isEqualToString:@"e"]) {
        [testvalues addObject:@"ene"];
        [testvalues addObject:@"ese"];
    }
    else if ([givenDirection isEqualToString:@"ese"]) {
        [testvalues addObject:@"e"];
        [testvalues addObject:@"se"];
    }
    else if ([givenDirection isEqualToString:@"se"]) {
        [testvalues addObject:@"ese"];
        [testvalues addObject:@"sse"];
    }
    else if ([givenDirection isEqualToString:@"sse"]) {
        [testvalues addObject:@"se"];
        [testvalues addObject:@"s"];
    }
    else if ([givenDirection isEqualToString:@"s"]) {
        [testvalues addObject:@"sse"];
        [testvalues addObject:@"ssw"];
    }
    else if ([givenDirection isEqualToString:@"ssw"]) {
        [testvalues addObject:@"s"];
        [testvalues addObject:@"sw"];
    }
    else if ([givenDirection isEqualToString:@"sw"]) {
        [testvalues addObject:@"ssw"];
        [testvalues addObject:@"wsw"];
    }
    else if ([givenDirection isEqualToString:@"wsw"]) {
        [testvalues addObject:@"sw"];
        [testvalues addObject:@"w"];
    }
    else if ([givenDirection isEqualToString:@"w"]) {
        [testvalues addObject:@"wsw"];
        [testvalues addObject:@"wnw"];
    }
    else if ([givenDirection isEqualToString:@"wnw"]) {
        [testvalues addObject:@"w"];
        [testvalues addObject:@"nw"];
    }
    else if ([givenDirection isEqualToString:@"nw"]) {
        [testvalues addObject:@"wnw"];
        [testvalues addObject:@"nnw"];
    }
    else if ([givenDirection isEqualToString:@"nnw"]) {
        [testvalues addObject:@"nw"];
        [testvalues addObject:@"n"];
    }
    else {
        [testvalues addObject:@"incorrect1"];
        [testvalues addObject:@"incorrect2"];
    }
    
    return testvalues;
}


#pragma - show alert views with the results from the queries
-(void)showQueryResults: (NSString *)sqlquery countquery:(NSString *)sqlquery2 {
    
    sqlite3_stmt *statement;
	
	//count - relates to number of search requests user requires.
	count=0;
	
	if(sqlite3_prepare_v2(database, [query UTF8String],-1, &statement, nil) == SQLITE_OK){
		while(sqlite3_step(statement) == SQLITE_ROW){
			
			count++;
			
			int row = sqlite3_column_int(statement, 0);
            NSLog(@"ROW in details: %i",row);
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
	self.title = NSLocalizedString(@"Forecast Search", @"forecast search");
	
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
	if(buoysdirection.editing){
		[buoysdirection resignFirstResponder];
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
	else if(buoysheight.editing){
		[buoysheight resignFirstResponder];
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
	else if(region.editing){
		[region resignFirstResponder];
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
    
    buoysdirection.text = @"";
    buoysheight.text = @"";
    buoysinterval.text = @"";
    winddirection.text = @"";
    windspeed.text = @"";
    tide.text = @"";
    region.text = @"";
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
	
	if(tide.editing){
		float bottomPoint = (tide.frame.origin.y + 
							 tide.frame.size.height);
		scrollAmount = keyboardSize - (411 - bottomPoint);
	}
    
    else if(region.editing){
		float bottomPoint = (region.frame.origin.y + 
							 region.frame.size.height);
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
	if(buoysdirection.editing){
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
	else if(region.editing){
		[region resignFirstResponder];
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
    [buoysdirection release];
    [buoysheight release];
    [buoysinterval release];
    [winddirection release];
    [windspeed release];
    [resultnumber release];
    [region release];
    [tide release];
    [title release];
    [message release];
    [alert release];
    [buoysdirectionvalues release];
    [winddirectionvalues release];
    [testvalues release];
    [query release];
    [query2 release];
}


@end