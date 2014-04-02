//
//  SubViewViewController.m
//  Pentago
//
//  Created by Stephen Kyles on 2/23/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "SubViewViewController.h"
#import "PentagoBrain.h"
#import "WhichView.h"
#import "Player.h"

const int BORDER_WIDTH = 20;
const int TOP_MARGIN = 50;

@interface SubViewViewController () {
    int subsquareNumber;
    int widthOfSubsquare;
    BOOL rotationMade;
}
@property (nonatomic) PentagoBrain *pBrain;
@property (nonatomic) int player;
@property (nonatomic) CALayer *ballLayer;
@property (nonatomic) UIImage *grid;
@property (nonatomic) UIImageView *gridView;
@property (nonatomic) CGRect viewFrame;
@property (nonatomic) UITapGestureRecognizer *tapGest;
@property (nonatomic) UISwipeGestureRecognizer *rightSwipe;
@property (nonatomic) UISwipeGestureRecognizer *leftSwipe;
@end

@implementation SubViewViewController

// Code provided via class website.
// Initializes the subsquare and gives a position in the parent view controller.
// 0 = top left, 1 = top right, 2 = bottom left, 3 = bottom right
-(id) initWithSubsquare: (int) position
{
    if( (self = [super init]) == nil )
        return nil;
    subsquareNumber = position;
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    widthOfSubsquare = ( appFrame.size.width - 3 * BORDER_WIDTH ) / 2;
    return self;
}

// Shared instance of the Pentago Brain
-(PentagoBrain *) pBrain
{
    if( ! _pBrain )
        _pBrain = [PentagoBrain sharedInstance];
    return _pBrain;
}

// Makes the imageView that contains the grid image
// the correct size for the squares on the grid.
- (UIImageView *) gridView
{
    if( !_gridView ) {
        _gridView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, widthOfSubsquare, widthOfSubsquare)];
    }
    return _gridView;
}

// Sets the image to the grid image
- (UIImage *) grid
{
    if( !_grid ) {
        _grid = [UIImage imageNamed:@"grid.png"];
    }
    return _grid;
}

// Allocate and initialize the right swipe gesture
-(UISwipeGestureRecognizer *) rightSwipe
{
    if( !_rightSwipe ) {
        _rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
        [_rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    }
    return _rightSwipe;
}

// Allocate and initialize the left swipe gesture
-(UISwipeGestureRecognizer *) leftSwipe
{
    if( !_leftSwipe ) {
        _leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
        [_leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    }
    return _leftSwipe;
}

// Allocate and initialize the tap gesture
// Set number of taps required
-(UITapGestureRecognizer *) tapGest
{
    if( ! _tapGest ) {
        _tapGest = [[UITapGestureRecognizer alloc]
                    initWithTarget:self action:@selector(didTapTheView:)];
        
        [_tapGest setNumberOfTapsRequired:1];
        [_tapGest setNumberOfTouchesRequired:1];
    }
    return _tapGest;
}

// Sets the view frame to be the same size as the sub square
// Adds the image to the image view
// Adds gesture recognizers
// Adds image view to the view
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.viewFrame = CGRectMake( (BORDER_WIDTH + widthOfSubsquare) * (subsquareNumber % 2) + BORDER_WIDTH,
                                (BORDER_WIDTH + widthOfSubsquare) * (subsquareNumber / 2) + BORDER_WIDTH + TOP_MARGIN,
                                widthOfSubsquare, widthOfSubsquare - BORDER_WIDTH);
    self.view.frame = self.viewFrame;
    [self.gridView setImage:self.grid];
    [self.view addSubview:self.gridView];
    [self.view addGestureRecognizer:self.rightSwipe];
    [self.view addGestureRecognizer:self.leftSwipe];
    [self.view addGestureRecognizer:self.tapGest];
    self.pBrain.redCanGo = YES;
    rotationMade = YES;
}

// Dispose of any resources that can be recreated.
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// When a user taps the screen, the same point is captured twice:
// Once in the image view, the view that rotates
// and the second in the vc's view, the view that doesn't rotate
// Both are sent to the brain to find their exact location within the grid.
// If the location is empty a ball is placed, if not a message is passed to the console
// Once a ball is placed, check for a winner
-(void)didTapTheView:(UITapGestureRecognizer *)tapObject
{
    // Capturing same point twice
    CGPoint p = [tapObject locationInView:self.gridView];
    CGPoint q = [tapObject locationInView:self.view];
    self.player = [self.pBrain whosTurnIsIt];
    int squareWidth = widthOfSubsquare / 3;
    
    // Sending touch point from gridView
    CGPoint temp = [self.pBrain getLocationInSubView:CGPointMake((int)(p.x / squareWidth) * squareWidth,
                                                             (int)(p.y / squareWidth) * squareWidth)
                          andTellBrainWhoItsFrom:subsquareNumber];
    // Sending touch point from view
    CGPoint temp2 = [self.pBrain getLocationInSubView:CGPointMake((int)(q.x / squareWidth) * squareWidth,
                                                              (int)(q.y / squareWidth) * squareWidth)
                           andTellBrainWhoItsFrom:subsquareNumber];
    
    if (![self.pBrain isThereABallInThatHoleAlready:temp subView:subsquareNumber]) {
        [self.pBrain addBallToTheGame:temp player:self.player point:theGridView subView:subsquareNumber];
        [self.pBrain addBallToTheGame:temp2 player:self.player point:theView subView:subsquareNumber];
        
        NSLog(@"player: %d", self.player);
        
        if (self.player == red) {
            UIImageView *iView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redMarble.png"]];
            iView.frame = CGRectMake((int) (p.x / squareWidth) * squareWidth,
                                 (int) (p.y / squareWidth) * squareWidth,
                                 squareWidth,
                                 squareWidth);
        
            self.ballLayer = [CALayer layer];
            [self.ballLayer addSublayer: iView.layer];
            self.ballLayer.frame = CGRectMake(0, 0, widthOfSubsquare, widthOfSubsquare);
            self.ballLayer.affineTransform = CGAffineTransformMakeRotation(0.0);
            [self.gridView.layer addSublayer:self.ballLayer];
            self.pBrain.redCanGo = NO;
            rotationMade = NO;
        }
        else {
            UIImageView *iView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueMarble"]];
            iView.frame = CGRectMake((int) (p.x / squareWidth) * squareWidth,
                                     (int) (p.y / squareWidth) * squareWidth,
                                     squareWidth,
                                     squareWidth);
            
            self.ballLayer = [CALayer layer];
            [self.ballLayer addSublayer: iView.layer];
            self.ballLayer.frame = CGRectMake(0, 0, widthOfSubsquare, widthOfSubsquare);
            self.ballLayer.affineTransform = CGAffineTransformMakeRotation(0.0);
            [self.gridView.layer addSublayer:self.ballLayer];
            self.pBrain.redCanGo = YES;
            rotationMade = NO;
        }
    }
    else {
        NSLog(@"can't place here");
    }
    
    if ([self.pBrain checkForWin:self.player]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations"
                                                        message:@"You won the game"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
}

// Only allows a swipe if a ball was placed on the grid by a player
// Checks for a winner after the grid is rotated
-(void)didSwipeLeft:(UISwipeGestureRecognizer *)swipeObject
{
    if (!rotationMade) {
        CGAffineTransform currTransform = self.gridView.layer.affineTransform;
        [UIView animateWithDuration:1 animations:^ {
            CGAffineTransform newTransform = CGAffineTransformConcat(currTransform, CGAffineTransformMakeRotation(-M_PI/2));
            self.gridView.layer.affineTransform = newTransform;
        }];
        [self.pBrain handleLeftRotatationOfBalls:subsquareNumber];
        rotationMade = YES;
        
        if ([self.pBrain checkForWin:self.player]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations"
                                                            message:@"You won the game"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

// Only allows a swipe if a ball was placed on the grid by a player
// Checks for a winner after the grid is rotated
-(void)didSwipeRight:(UISwipeGestureRecognizer *)swipeObject
{
    if (!rotationMade) {
        CGAffineTransform currTransform = self.gridView.layer.affineTransform;
        [UIView animateWithDuration:1 animations:^ {
            CGAffineTransform newTransform = CGAffineTransformConcat(currTransform, CGAffineTransformMakeRotation(M_PI/2));
            self.gridView.layer.affineTransform = newTransform;
        }];
        [self.pBrain handleRightRotatationOfBalls:subsquareNumber];
        rotationMade = YES;
        
        if ([self.pBrain checkForWin:self.player]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations"
                                                            message:@"You won the game"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

@end
