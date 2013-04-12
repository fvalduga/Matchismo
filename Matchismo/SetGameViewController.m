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
    return 12;
}

-(NSUInteger)numberOfCardsToDeal
{
    return 3;
}

- (NSDictionary *)getGameOptions
{
    return @{@"matchBonus": @(5), @"mismatchPenalty": @(5), @"flipCost": @(0)};
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
