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
#import "SetCardCollectionViewCell.h"


@implementation SetGameViewController

#define FADE_ALPHA_VALUE 0.3
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
    return [[SetCardDeck alloc] init];
}

-(NSUInteger)numberOfCardsToDeal
{
    return 3;
}

- (NSDictionary *)getGameOptions
{  
    return @{CARD_COUNT_KEY : @(12), N_CARD_MATCH_KEY : @(3), MATCH_BONUS_KEY : @(5), MISMATCH_PENALTY_KEY : @(5), FLIP_COST_KEY : @(0)};
}

- (NSString *)getGameType
{
    return @"S"; // S for Set Game
}

-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        SetCardView *setCardView = ((SetCardCollectionViewCell *) cell).setCardView;
        
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
            
            setCardView.number = setCard.number;
            setCardView.symbol = setCard.symbol;
            setCardView.color = setCard.color;
            setCardView.shading = setCard.shading;
            
            setCardView.faceUp = setCard.isFaceUp;
            setCardView.alpha = setCard.isUnplayable ? 0.0 : 1.0;
            
        }
    }
}

-(void)updateResultsInView:(UIView *)view usingCards:(NSArray *)cards withScore:(int)score
{
    CGFloat xPos = RESULT_VIEW_CARD_START_POSITION;
    
    for (Card *card in cards) {
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
            SetCardView *setCardView = [[SetCardView alloc] initWithFrame:CGRectMake(xPos, RESULT_VIEW_CARD_START_POSITION, RESULT_VIEW_CARD_WIDTH, RESULT_VIEW_CARD_HEIGHT)];
            
            setCardView.opaque = NO;
            setCardView.faceUp = YES;
            setCardView.number = setCard.number;
            setCardView.symbol = setCard.symbol;
            setCardView.color = setCard.color;
            setCardView.shading = setCard.shading;

            
            [view addSubview:setCardView];
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
            resultText.text = @"selected!";
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
