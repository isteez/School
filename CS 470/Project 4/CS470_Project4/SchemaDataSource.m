//
//  SchemaDataSource.m
//  TableViewDemoPart1
//
//  Created by AAK on 3/8/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//

#import "SchemaDataSource.h"
#import "DownloadAssistant.h"

static NSString *moviesURLString = @"http://cwolf.cs.sonoma.edu/~skyles/movies/dbInterface.py?rType=movies";
static NSString *theaterURLString = @"http://cwolf.cs.sonoma.edu/~skyles/movies/dbInterface.py?rType=movieTheaters";
static NSString *showtimeURLString = @"http://cwolf.cs.sonoma.edu/~skyles/movies/dbInterface.py?rType=showtimes";
static NSString *moviesAtThreaters = @"http://cwolf.cs.sonoma.edu/~skyles/movies/dbInterface.py?rType=moviesAtTheaters";
static NSString *citiesURLString = @"http://cwolf.cs.sonoma.edu/~skyles/movies/dbInterface.py?rType=cities";

static BOOL _debug = NO;

@interface SchemaDataSource() {
    BOOL _moviesReady, _theaterReady, _showtimeReady, _moviesAtTheatersReady, _citiesReady;
}

@property(nonatomic) DownloadAssistant *downloadAssistant;

@end

@implementation SchemaDataSource

+(SchemaDataSource *) sharedInstance
{
    static SchemaDataSource *instance = nil;
    if( ! instance )
        instance = [[SchemaDataSource alloc] init];
    return instance;
}

-(instancetype) init
{
    if( (self = [super init]) == nil )
        return nil;
    
    _moviesReady = _theaterReady = _showtimeReady = _moviesAtTheatersReady = _citiesReady = NO;
    
    _downloadAssistant = [[DownloadAssistant alloc] init];
    [self.downloadAssistant setDelegate: self];
    
    NSURL *url = [NSURL URLWithString: moviesURLString];
    [self.downloadAssistant downloadContentsOfURL:url];
    url = nil;
    return self;
}

-(BOOL) dataSourceReady
{
    return _moviesReady && _theaterReady && _showtimeReady && _moviesAtTheatersReady && _citiesReady;
}

-(NSArray *) jsonFromData: (NSData *) data
{
    NSError *parseError = nil;
    NSArray *jsonArray =  [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
    if( _debug )
        NSLog(@"%@", jsonArray);
    if( parseError ) {
        NSLog(@"Badly formed JSON string. %@", [parseError localizedDescription] );
        exit(1);
    }
    return jsonArray;
}

-(void) acceptWebData:(NSData *)webData forURL:(NSURL *)url
{
    // This function needs to be made more robust. At its current implementation,
    // this class never will call its delegate if things go wrong!
    
    // This class is the delegate for the module that provides access to the data for different
    // relations such as movie, theater, showtime, etc. We assume that the initializer or some other
    // function starts the download of one of the data sets. Once the download is complete, this
    // function gets called. The function then create the data source that corresonds to the
    // data set that was just downloaded and launches the next download. Ultimately, after all
    // the data sets are downloaded, it sets the variable self.dataSourceReady so that the objects
    // that are the observers for this variable are called.
    
    NSString *urlString = [NSString stringWithFormat:@"%@:%@", [url scheme], [url resourceSpecifier]];
    if( [urlString isEqualToString: moviesURLString] )
    {
        _moviesReady = YES;
        self.moviesDataSource = [[MoviesDataSource alloc] initWithJSONArray: [self jsonFromData:webData]];
        [self.downloadAssistant downloadContentsOfURL:[ NSURL URLWithString:theaterURLString]];
    }
    else if( [urlString isEqualToString: theaterURLString] )
    {
        _theaterReady = YES;
        self.theatersDataSource = [[TheatersDataSource alloc] initWithJSONArray: [self jsonFromData:webData]];
        [self.downloadAssistant downloadContentsOfURL:[NSURL URLWithString:showtimeURLString]];
    }
    else if( [urlString isEqualToString: showtimeURLString] )
    {
        _showtimeReady = YES;
        self.showtimesDataSource = [[ShowtimesDataSource alloc] initWithJSONArray: [self jsonFromData:webData]];
        [self.downloadAssistant downloadContentsOfURL:[NSURL URLWithString:citiesURLString]];
    }
    else if( [urlString isEqualToString: citiesURLString] )
    {
        _citiesReady = YES;
        self.cityDataSource = [[CityDataSource alloc] initWithJSONArray: [self jsonFromData:webData]];
        [self.downloadAssistant downloadContentsOfURL:[NSURL URLWithString:moviesAtThreaters]];
    }
    else if( [urlString isEqualToString: moviesAtThreaters] )
    {
        _moviesAtTheatersReady = YES;
        self.moviesAtTheatersDataSource = [[MoviesAtTheatersDataSrouce alloc] initWithJSONArray:[self jsonFromData:webData]];
        if( [self.delegate respondsToSelector:@selector(dataSourceReadyForUse:)] )
            [self.delegate performSelector:@selector(dataSourceReadyForUse:) withObject:self];
        self.dataSourceReady = _moviesReady && _theaterReady && _showtimeReady && _moviesAtTheatersReady && _citiesReady;
    }
}

@end
