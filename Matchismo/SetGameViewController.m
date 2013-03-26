//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Felipe Valduga on 2/13/13.
//  Copyright (c) 2013 Felipe Valduga. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"


@implementation SetGameViewController


#define STROKE_WIDTH 5
#define FADE_ALPHA_VALUE 0.3
#define CARD_SEPARATOR_CHARACTER @"&"

-(Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (NSUInteger)numberOfCardsToMatch
{
    //Set Game matches 3 cards
    return 3;
}

-(NSUInteger)startingCardCount
{
    return 20;
}

- (NSDictionary *)getGameOptions
{
    return @{@"matchBonus": @(5), @"mismatchPenalty": @(5), @"flipCost": @(0)};
}

-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    //TO-DO
}


-(void)setup
{
    //initialization that can't wait intil viewDidLoad
}

-(void)awakeFromNib
{
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

@end
