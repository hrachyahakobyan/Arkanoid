//
//  HallOfFameVC.m
//  Arkanoid
//
//  Created by Admin on 10.03.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "HallOfFameVC.h"
#import "HallOfFameManager.h"
#import "TableCellObject.h"
#import "CustomTableViewCell.h"

@interface HallOfFameVC ()
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property NSMutableArray* dataSource;

@end

@implementation HallOfFameVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [[NSMutableArray alloc]init];
    
    UIImage* backImage = [self imageWithImage:[UIImage imageNamed:@"back5"] scaledToSize:self.view.frame.size];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backImage];
    _myTableView.backgroundColor = [UIColor clearColor];
    
    // get the datasource form Hall of fame manager
    NSMutableArray* localDatasource = [HallOfFameManager sharedManager].datasource;
    
    // construct TabelcellObjects based on the data from localdatasource
    for( NSDictionary* currentDict in localDatasource)
    {
        NSInteger score = [currentDict[keyScore] integerValue];
        NSInteger level = [currentDict[keyLevel] integerValue];
        NSString* name = currentDict[keyUsername];
                          
        TableCellObject* object = [[TableCellObject alloc]initWithName:name score:score level:level];
                          
        [_dataSource addObject:object];
        
    }
    // Do any additional setup after loading the view.
}

// the additional cell is for giving the columns their titles
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count + 1;
}

- (IBAction)startNewGameAction:(id)sender
{
    if([_delegate respondsToSelector:@selector(hallOfFameDidCancel:)])
        [_delegate hallOfFameDidCancel:self];
}
// clears the hall, informs the manager to clean out hall of fame data
- (IBAction)clearHallAction:(id)sender
{
    [self.dataSource removeAllObjects];
    [self.myTableView reloadData];
    [[HallOfFameManager sharedManager] emptyHallOfFame];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomTableViewCell* myCell = [tableView dequeueReusableCellWithIdentifier:@"reuseID" forIndexPath:indexPath];
    
    if( indexPath.item == 0)
    {
        myCell.levelLabel.text = @"Level";
        myCell.scoreLabel.text = @"Score";
        myCell.nameLabel.text = @"Name ";
    }
    
    else
    {
        
    TableCellObject* currentObject = _dataSource[indexPath.item - 1];
    
    myCell.levelLabel.text = currentObject.level;
    myCell.scoreLabel.text = currentObject.score;
    myCell.nameLabel.text = [NSString stringWithFormat:@"%li. %@", (long)indexPath.item,currentObject.name];
    
    }
    
    return myCell;
}
                          
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
