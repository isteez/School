//
//  ShowTimeDataSource.m
//  TableViewDemoPart1
//
//  Created by AAK on 3/8/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//

#import "ShowtimesDataSource.h"
#import "Showtime.h"

BOOL _debug = NO;

@interface ShowtimesDataSource ()

@property (nonatomic) NSMutableArray *allShowtimes;


@end

@implementation ShowtimesDataSource

-(instancetype) initWithJSONArray:(NSArray *)jsonArray
{
    if( (self = [super init]) == nil )
        return nil;
    
    _allShowtimes = [[NSMutableArray alloc] init];
    for ( NSDictionary *showtimeTuple in jsonArray ) {
        Showtime *showtime = [[Showtime alloc] initWithDictionary: showtimeTuple];
        if( _debug) [showtime print];
        [self.allShowtimes addObject: showtime];
    }
    return self;
}

-(NSArray *) showtimeForMovie: (NSString *) movieName atTheater: (NSString *) theaterName;
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"movieTitle = %@ and theaterName = %@", movieName, theaterName];
    NSArray *showtimes = [self.allShowtimes filteredArrayUsingPredicate:predicate];
    return showtimes;
}

-(void) print
{
    NSLog(@"Printing showtimes...");
    for( Showtime *showtime in self.allShowtimes )
        [showtime print];
    NSLog(@"Printing showtimes ends.");
}


@end
