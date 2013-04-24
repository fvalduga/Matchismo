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
#define FONT_SIZE 13.0
#define RESULT_VIEW_CARD_START_POSITION 2.0
#define RESULT_VIEW_CARD_WIDTH 36.0
#define RESULT_VIEW_CARD_HEIGHT 50.0
#define RESULT_VIEW_CARD_SPACING 40.0

#define CARD_COUNT_KEY @"cardCount"
#define N_CARD_MATCH_KEY @"numberOfCardsToMatch"
#define MATCH_BONUS_KEY @"matchBonus"
#define MISMATCH_PENALTY_KEY @"mismatchPenalty"
#define FLIP_COST_KEY @"flipCost"

-(Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSDictionary *)getGameOptions
{
    return @{CARD_COUNT_KEY : @(22), N_CARD_MATCH_KEY : @(2), MATCH_BONUS_KEY : @(4), MISMATCH_PENALTY_KEY : @(2), FLIP_COST_KEY : @(1)};
}

- (NSString *)getGameType
{
    return @"P"; // P for PlayingCard game
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

-(void)updateResultsInView:(UIView *)view usingCards:(NSArray *)cards withScore:(int)score
{
    CGFloat xPos = RESULT_VIEW_CARD_START_POSITION;
    
    for (Card *card in cards) {
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            PlayingCardView *playingCardView = [[PlayingCardView alloc] initWithFrame:CGRectMake(xPos, RESULT_VIEW_CARD_START_POSITION, RESULT_VIEW_CARD_WIDTH, RESULT_VIEW_CARD_HEIGHT)];
            
            playingCardView.opaque = NO;
            playingCardView.suit = playingCard.suit;
            playingCardView.rank = playingCard.rank;
            playingCardView.faceUp = YES;
            
            [view addSubview:playingCardView];
        }
        
        xPos += RESULT_VIEW_CARD_SPACING;
    }
    
    if ([cards count]) {
        
        UILabel *resultText = [[UILabel alloc] initWithFrame:CGRectMake(xPos, RESULT_VIEW_CARD_START_POSITION, view.bounds.size.width - xPos, RESULT_VIEW_CARD_HEIGHT)];
        resultText.font = [UIFont systemFontOfSize:FONT_SIZE];
        [resultText setBackgroundColor:[UIColor clearColor]];
        
        if (score < 0) {
            resultText.text = [NSString stringWithFormat: @"don't match. %d points penalty!", -score];
        } else if (score > 0) {
            resultText.text = [NSString stringWithFormat: @"matched for %d points!", score];
        } else {
            resultText.text = @"flipped up!";
        }
        
        [view addSubview:resultText];
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
