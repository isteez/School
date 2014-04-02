//
//  DetailedMovieViewController.m
//  TableViewDemoPart1
//
//  Created by Stephen Kyles on 3/25/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//

#import "DetailedMovieViewController.h"
#import "ShowtimesDataSource.h"
#import "SchemaDataSource.h"

const int detailTextHeight = 95;
const int pictureHeightNumber = 200;
const int belowNavBar = 74;
const int borderBuffer = 10;
const int labelHeight = 50;

@interface DetailedMovieViewController ()
{
    CGRect appFrame;
}
@property(nonatomic) Movie *movie;
@property(nonatomic) Theater *theater;
@property(nonatomic) ShowtimesDataSource *showtimesDataSource;
@property(nonatomic) SchemaDataSource *dataSource;

@end

@implementation DetailedMovieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (ShowtimesDataSource *)showtimesDataSource
{
    if (!_showtimesDataSource) {
        _showtimesDataSource = [[ShowtimesDataSource alloc] init];
    }
    return _showtimesDataSource;
}

-(instancetype) initWithMovie: (Movie *) movie andTheater: (Theater *) theater
{
    if( (self = [super init]) == nil )
        return nil;
    
    self.movie = movie;
    self.theater = theater;
    self.title = [self.movie title];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = [SchemaDataSource sharedInstance];
    appFrame = [[UIScreen mainScreen] applicationFrame];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSURL *url = [NSURL URLWithString: [self.movie imageNameForDetailedView]];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:imageView];
    
    [self setGenreLabel];
    [self setRatingLabel];
    [self setWebFrame];
    
    if (self.theater) {
        imageView.frame = [self leftCornerOfScreen];
        // override default method for text layout within textView
        self.automaticallyAdjustsScrollViewInsets = NO;
        UITextView *showTimeLabel = [[UITextView alloc] init];
        showTimeLabel.text = [NSString stringWithFormat:@"Showtimes:\n%@", [self getShowTimeString]];
        showTimeLabel.textAlignment = NSTextAlignmentCenter;
        showTimeLabel.userInteractionEnabled = NO;
        showTimeLabel.font = [UIFont systemFontOfSize:16.0];
        showTimeLabel.frame = [self rightCornerOfScreen];
        [self.view addSubview:showTimeLabel];
    }
    else
    {
        imageView.frame = [self topCenterOfScreen];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect)topCenterOfScreen
{
    CGRect frame = CGRectMake(appFrame.size.width / 4, belowNavBar, appFrame.size.width / 2, pictureHeightNumber);
    return frame;
}

- (CGRect)leftCornerOfScreen
{
    CGRect frame = CGRectMake(borderBuffer, belowNavBar, appFrame.size.width / 2, pictureHeightNumber);
    return frame;
}

- (CGRect)rightCornerOfScreen
{
    CGRect frame = CGRectMake(borderBuffer + appFrame.size.width / 2, belowNavBar, appFrame.size.width / 2 - borderBuffer, pictureHeightNumber);
    return frame;
}

- (NSString *)getShowTimeString
{
    NSArray *showTimesArray = [[[self.dataSource showtimesDataSource] showtimeForMovie:self.movie.title atTheater:self.theater.theaterName] valueForKey:@"time"];
    if (![showTimesArray count]) {
        return @"This movie is not currently showing at this theater.";
    }
    NSMutableString *s = [[NSMutableString alloc] init];
    for (int i=0; i<[showTimesArray count]; i++) {
        [s appendString:[NSString stringWithFormat:@"%@\n", [showTimesArray objectAtIndex:i]]];
    }
    return s;
}

- (void)setGenreLabel
{
    CGRect genreLabelFrame = CGRectMake(borderBuffer, pictureHeightNumber + belowNavBar, appFrame.size.width - borderBuffer*2, labelHeight);
    UILabel *genreLabel = [[UILabel alloc] initWithFrame:genreLabelFrame];
    genreLabel.text = [NSString stringWithFormat:@"Genre: %@", [self.movie genreForDetailView]];
    genreLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:genreLabel];
}

- (void)setRatingLabel
{
    CGRect ratingLabelFrame = CGRectMake(borderBuffer, pictureHeightNumber + (belowNavBar + labelHeight/2), appFrame.size.width - borderBuffer*2, labelHeight);
    UILabel *ratingLabel = [[UILabel alloc] initWithFrame:ratingLabelFrame];
    ratingLabel.text = [NSString stringWithFormat:@"Rated: %@", [self.movie rating]];
    ratingLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:ratingLabel];
}

- (void)setWebFrame
{
    CGRect webFrame = CGRectMake(borderBuffer,
                                 appFrame.size.width + labelHeight/2,
                                 appFrame.size.width - borderBuffer*2,
                                 // gets the view height - the tabBar height and subtracts that from where the webFrame origin.y.
                                 // this allows for both 3.5 and 4 inch iPhone screens, so that the text is always viewable.
                                 ((self.view.bounds.size.height - self.tabBarController.tabBar.frame.size.height) - (appFrame.size.width + labelHeight/2)));
    UIWebView *descWebView = [[UIWebView alloc] initWithFrame:webFrame];
    descWebView.backgroundColor = [UIColor whiteColor];
    [descWebView loadHTMLString:[self.movie htmlDescriptionForDetailedView] baseURL:nil];
    [self.view addSubview:descWebView];
}

@end
