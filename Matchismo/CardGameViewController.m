//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Felipe Valduga on 1/30/13.
//  Copyright (c) 2013 Felipe Valduga. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "PlayingCardView.h"


@interface CardGameViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *flipsHistory;

@end

@implementation CardGameViewController


#define DEFAULT_FONT_SIZE 13
#define CARD_EDGE_INSET 4.0
#define RESULT_LABEL_FADED_ALPHA_VALUE 0.4

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.startingCardCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
}

-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    //implemented in subclass
}

-(Deck *)createDeck
{
    //implemented in subclass
    return nil;
}

- (NSDictionary *)getGameOptions
{
    //implemented in subclass
    return nil;
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                  usingDeck:[self createDeck]
                                                   matching:self.numberOfCardsToMatch
                                                gameOptions:[self getGameOptions]];
    }
    return _game;
}

- (NSMutableArray *)flipsHistory
{
    if (!_flipsHistory) _flipsHistory = [[NSMutableArray alloc] init];
    return _flipsHistory;
}

- (void)updateUI
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"score: %d", self.game.score];
    
    [self updateResultLabel:[self.flipsHistory lastObject]];
    self.resultLabel.alpha = 1.0;
}

- (void)updateResultLabel:(id)flipResult
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"Result: "];
    
    if (flipResult && [flipResult isKindOfClass:[NSAttributedString class]]) {
        [result appendAttributedString: flipResult];
    }
    [result addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:DEFAULT_FONT_SIZE] range:NSMakeRange(0, [result length])];
    self.resultLabel.attributedText = result;
}

- (void)createResultDescription
{
//    NSArray *cardsFlipped = [self.game.flipResults objectForKey:@"cardsFlipped"];
//    int score = [[self.game.flipResults objectForKey:@"flipScore"] integerValue];
//    
//    NSMutableAttributedString *flipResultText = [self getCardsFlippedContents:cardsFlipped];
//    
//    if ([cardsFlipped count] == self.numberOfCardsToMatch) {
//        if (score > 0) {
//            [flipResultText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" matched for %d points!", score]]];
//        } else {
//            [flipResultText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" don't match. %d points penalty!", -score]]];
//        }
//    } else if ([cardsFlipped count]){
//        [flipResultText appendAttributedString:[[NSAttributedString alloc] initWithString:@" flipped."]];
//    }
//    if ([flipResultText length]) {
//        [self.flipsHistory addObject:flipResultText];
//    }
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    
    if (indexPath) {
        [self.game flipCardAtIndex:indexPath.item];
        [self createResultDescription];
        [self updateUI];
    }
}

- (IBAction)dealPressed {
    self.game = nil; //recreate game when the getter is called in updateUI (Lazy Instantiation)
    [self.flipsHistory removeAllObjects];
    [self updateUI];
}

- (IBAction)historySliderChanged:(UISlider *)sender {
    
    // link slider movement with flips history array
    if ([self.flipsHistory count]) {
        self.historySlider.maximumValue = [self.flipsHistory count] - 1;
        [self updateResultLabel:self.flipsHistory[[@(sender.value) intValue]]];
    }
    //fade result label when checking flips history
    if (sender.value != ([self.flipsHistory count] - 1)) {
        self.resultLabel.alpha = RESULT_LABEL_FADED_ALPHA_VALUE;
    } else {
        self.resultLabel.alpha = 1.0;
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self dealPressed];
}

@end
