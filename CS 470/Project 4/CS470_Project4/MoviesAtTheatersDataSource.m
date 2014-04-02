//
//  MovieAtTheaterDataSrouce.m
//  TableViewDemoPart1
//
//  Created by AAK on 3/9/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//

#import "MoviesAtTheatersDataSource.h"
#import "MovieAtTheater.h"

@interface MoviesAtTheatersDataSrouce ()

@property (nonatomic) NSMutableArray *allMoviesAtTheaters;

@end

static BOOL _debug = NO;

@implementation MoviesAtTheatersDataSrouce

-(instancetype) initWithJSONArray:(NSArray *)jsonArray
{
    if( (self = [super init]) == nil )
        return nil;
    
    _allMoviesAtTheaters = [[NSMutableArray alloc] init];
    for ( NSDictionary *matTuple in jsonArray ) {
        MovieAtTheater *mat = [[MovieAtTheater alloc] initWithDictionary: matTuple];
        if( _debug) [mat print];
        [self.allMoviesAtTheaters addObject: mat];
    }
    return self;
}

-(NSArray *) moviesForTheater: (NSString *) theaterName inCity: (NSString *) cityName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"theaterName = %@ and cityName = %@", theaterName, cityName];
    return [self.allMoviesAtTheaters filteredArrayUsingPredicate:predicate];
}

@end
