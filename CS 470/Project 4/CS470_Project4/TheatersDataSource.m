//
//  TheaterDataSource.m
//  TableViewDemoPart1
//
//  Created by AAK on 3/8/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//

#import "TheatersDataSource.h"
#import "Theater.h"

static BOOL _debug = NO;

@interface TheatersDataSource ()

@property(nonatomic) NSMutableArray *allTheaters;

@end

@implementation TheatersDataSource

-(instancetype) initWithJSONArray:(NSArray *)jsonArray
{
    if( (self = [super init]) == nil )
        return nil;
    
    _allTheaters = [[NSMutableArray alloc] init];
    for ( NSDictionary *theaterTuple in jsonArray ) {
        Theater *theater = [[Theater alloc] initWithDictionary:theaterTuple];
        if( _debug) [theater print];
        [self.allTheaters addObject: theater];
    }
    return self;
}

-(NSArray *) getTheaterInCity: (NSString *) cityName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityName = %@", cityName];
    return [self.allTheaters filteredArrayUsingPredicate:predicate];
}

-(Theater *) theaterWithName: (NSString *) theaterName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"theaterName = %@", theaterName];
    NSArray *theater = [self.allTheaters filteredArrayUsingPredicate:predicate];
    return [theater count] == 0 ? nil : [theater objectAtIndex: 0];    
}

-(NSArray *) getAllTheaters
{
    return self.allTheaters;
}

-(Theater *) theaterAtIndex: (int) idx
{
    return [self.allTheaters objectAtIndex:idx];
}

-(int) numberOfTheaters
{
    return [self.allTheaters count];
}

-(NSString *) theaterTabBarTitle
{
    return @"Theaters";
}
-(NSString *) theaterTabBarImage
{
    return nil;
}
-(NSString *) theaterBarButtonItemBackButtonTitle
{
    return @"Theaters";
}

-(BOOL) deleteTheaterAtIndex: (NSInteger) idx
{
    // Need to preserve the referential integrity of the dataset.
    // Will have to cascade delete moives-at-theaters and showtimes.
    
    return NO;
}

-(void) print
{
    NSLog(@"Printing theaters...");
    for( Theater *theater in self.allTheaters )
        [theater print];
    NSLog(@"Printing theaters ends.");
}


@end
