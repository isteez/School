//
//  CityDataSource.m
//  CS470_Project4
//
//  Created by Stephen Kyles on 3/25/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "CityDataSource.h"
#import "City.h"

static BOOL _debug = NO;

@interface CityDataSource ()

@property(nonatomic) NSMutableArray *allCities;

@end

@implementation CityDataSource

-(instancetype) initWithJSONArray:(NSArray *)jsonArray
{
    if( (self = [super init]) == nil )
        return nil;

    _allCities = [[NSMutableArray alloc] init];
    for ( NSDictionary *cityTuple in jsonArray ) {
        City *city = [[City alloc] initWithDictionary:cityTuple];
        if( _debug) [city print];
        [self.allCities addObject: city];
    }
    return self;
}

-(City *) cityWithName: (NSString *)cityName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityName = %@", cityName];
    NSArray *city = [self.allCities filteredArrayUsingPredicate:predicate];
    return [city count] == 0 ? nil : [city objectAtIndex: 0];
}

-(NSArray *) getAllCities
{
    return self.allCities;
}

-(City *) cityAtIndex: (int) idx
{
    return [self.allCities objectAtIndex:idx];
}

-(int) numberOfCities
{
    return [self.allCities count];
}

-(NSString *) cityTabBarTitle
{
    return @"Cities";
}
-(NSString *) cityTabBarImage
{
    return nil;
}
-(NSString *) cityBarButtonItemBackButtonTitle
{
    return @"Cities";
}

-(void) print
{
    NSLog(@"Printing theaters...");
    for( City *city in self.allCities )
        [city print];
    NSLog(@"Printing theaters ends.");
}


@end
