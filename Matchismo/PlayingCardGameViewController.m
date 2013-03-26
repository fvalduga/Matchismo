//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Felipe Valduga on 2/16/13.
//  Copyright (c) 2013 Felipe Valduga. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"

@interface PlayingCardGameViewController ()



@end

@implementation PlayingCardGameViewController

#define CARD_UNPLAYABLE_TRANSPARENCY_VALUE 0.3
#define CARD_SEPARATOR_CHARACTER @"&"

-(Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger)numberOfCardsToMatch
{
    //Playing Card Matching Game matches 2 cards
    return 2;
}

-(NSUInteger)startingCardCount
{
    return 20;
}

- (NSDictionary *)getGameOptions
{
    return @{@"matchBonus": @(4), @"mismatchPenalty": @(2), @"flipCost": @(1)};
}

-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *) cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            
            playingCardView.suit = playingCard.suit;
            playingCardView.rank = playingCard.rank;
            playingCardView.faceUp = playingCard.isFaceUp;
            playingCardView.alpha = (playingCard.isUnplayable) ? CARD_UNPLAYABLE_TRANSPARENCY_VALUE : 1.0;
        }
    }
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
