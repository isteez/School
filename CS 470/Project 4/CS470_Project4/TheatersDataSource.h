//
//  TheaterDataSource.h
//  TableViewDemoPart1
//
//  Created by AAK on 3/8/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadAssistant.h"
#import "Theater.h"

@interface TheatersDataSource : NSObject

@property (nonatomic) BOOL dataReadyForUse;

-(instancetype) initWithJSONArray:(NSArray *) jsonArray;
-(Theater *) theaterWithName: (NSString *) theaterName;
-(NSArray *) getTheaterInCity: (NSString *) cityName;
-(NSMutableArray *) getAllTheaters;
-(Theater *) theaterAtIndex: (int) idx;
-(int) numberOfTheaters;
-(NSString *) theaterTabBarTitle;
-(NSString *) theaterTabBarImage;
-(NSString *) theaterBarButtonItemBackButtonTitle;
-(BOOL) deleteTheaterAtIndex: (NSInteger) idx;
-(void) print;

@end
