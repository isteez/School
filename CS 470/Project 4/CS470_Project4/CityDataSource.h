//
//  CityDataSource.h
//  CS470_Project4
//
//  Created by Stephen Kyles on 3/25/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadAssistant.h"
#import "City.h"

@interface CityDataSource : NSObject

@property (nonatomic) BOOL dataReadyForUse;

-(instancetype) initWithJSONArray:(NSArray *) jsonArray;
-(City *) cityWithName: (NSString *)cityName;
-(NSMutableArray *) getAllCities;
-(City *) cityAtIndex: (int) idx;
-(int) numberOfCities;
-(NSString *) cityTabBarTitle;
-(NSString *) cityTabBarImage;
-(NSString *) cityBarButtonItemBackButtonTitle;
-(void) print;

@end
