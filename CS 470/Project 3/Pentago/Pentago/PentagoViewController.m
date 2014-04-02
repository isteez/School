//
//  PentagoViewController.m
//  Pentago
//
//  Created by Stephen Kyles on 2/23/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "PentagoViewController.h"
#import "SubViewViewController.h"

@interface PentagoViewController ()
@property (nonatomic, strong) NSMutableArray *subViewControllers;
@end

@implementation PentagoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSMutableArray *) subViewControllers
{
    if( ! _subViewControllers )
        _subViewControllers = [[NSMutableArray alloc] initWithCapacity:4];
    return _subViewControllers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    [self.view setFrame:frame];
    
    // This is our root view-controller. Each of the quadrants of the game is
    // represented by a different view-controller. We create them here and add their views to the
    // view of the root view-controller.
    for (int i = 0; i < 4; i++) {
        SubViewViewController *p = [[SubViewViewController alloc] initWithSubsquare:i];
        [self.subViewControllers addObject: p];
        [self.view addSubview: p.view];
    }
    
    // Game name label just for fun
    UILabel *playersTurn = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, frame.size.width, 20)];
    playersTurn.text = @"Pentago";
    playersTurn.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:playersTurn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end