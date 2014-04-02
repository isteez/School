//
//  MoviesDataSource.m
//  TableViewBasics
//
//  Created by AAK on 2/24/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//

#import "MoviesDataSource.h"

static BOOL _debug = NO;

@interface MoviesDataSource()

@property (nonatomic, copy) NSString *moviesURLString;
@property (nonatomic) NSData *moviesNSData;
@property (nonatomic) NSMutableArray *allMovies;
@property (nonatomic) DownloadAssistant *downloadAssistant;


@end

@implementation MoviesDataSource

-(NSMutableArray *) allMovies
{
    if( ! _allMovies )
        _allMovies = [[NSMutableArray alloc] init];
    return _allMovies;
}


-(instancetype) initWithJSONArray:(NSArray *)jsonArray
{
    if( (self = [super init]) == nil )
        return nil;

    for ( NSDictionary *movieTuple in jsonArray ) {
        Movie *movie = [[Movie alloc] initWithDictionary:movieTuple];
        if( _debug) [movie print];
        [self.allMovies addObject: movie];
    }
    return self;
}

-(void) print
{
    for( Movie *m in self.allMovies )
        [m print];
}


-(Movie *) movieWithTitle: (NSString *) movieTitle
{    
	if(  [self.allMovies count] == 0 )
		return nil;
    for( Movie *movie in self.allMovies )
        if( [movie.title isEqualToString: movieTitle] )
            return movie;
    return nil;
}

-(NSArray *) getAllMovies
{
    return self.allMovies;
}

-(BOOL) deleteMovieAtIndex: (NSInteger) idx
{
    [self.allMovies removeObjectAtIndex:idx];
    return YES;
}

-(Movie *) movieAtIndex: (int) idx
{
	if( idx >= [self.allMovies count] )
        return nil;
	return [self.allMovies objectAtIndex: idx];
}

-(int) numberOfMovies
{
	return [self.allMovies count];
}

-(NSString *) moviesTabBarTitle
{
	return @"Movies";
}

-(NSString *) moviesBarButtonItemBackButtonTitle
{
	return @"Movies";
}

-(NSString *) moviesTabBarImage
{
	return @"46-movie2.png";
}

@end
