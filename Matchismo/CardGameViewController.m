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
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UIView *resultView;


@end

@implementation CardGameViewController


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.game.numberOfCardsInPlay;
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

-(void)updateResultsInView:(UIView *)view usingCards:(NSArray *)cards withScore:(int)score
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

- (void)updateUI
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        
        //remove matched cards
        if (card.isUnplayable) {
            [self.game removeCardAtIndex:indexPath.item];
            [self.cardCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        } else {
            [self updateCell:cell usingCard:card];
        }
        
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"score: %d", self.game.score];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    
    if (indexPath) {
        [self.game flipCardAtIndex:indexPath.item];
        [self clearResultView];
        [self updateResultsInView:self.resultView usingCards:self.game.flippedCards withScore:self.game.flipScore];
        [self updateUI];
    }
}

- (void) clearResultView
{
    for (UIView *subView in self.resultView.subviews) {
        [subView removeFromSuperview];
    }
}

- (IBAction)restartGame
{
    self.game = nil; //recreate game when the getter is called in updateUI (Lazy Instantiation)
    [self.cardCollectionView reloadData];
    [self clearResultView];
    [self updateUI];
}

- (IBAction)dealCards
{
    int totalItems = self.game.numberOfCardsInPlay;
    
    NSMutableArray *indexArray = [[NSMutableArray alloc] init];
    NSIndexPath *index = nil;
    NSUInteger numberOfCardsDealt = [self.game dealMoreCards:self.numberOfCardsToDeal];
    
    if (numberOfCardsDealt) {
        
        for (int i = 0 ; i < numberOfCardsDealt ; i++) {
            index = [NSIndexPath indexPathForItem:(totalItems + i) inSection:0];
            [indexArray addObject:index];
        }
        
        [self.cardCollectionView insertItemsAtIndexPaths:indexArray];
        [self.cardCollectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    }
    
    if (numberOfCardsDealt < self.numberOfCardsToDeal) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Deck is Empty." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil
                              ];
        [alert show];
    }
    
    [self updateUI];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self restartGame];
}

@end
