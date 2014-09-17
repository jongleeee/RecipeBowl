//
//  FavoriteRecipeTableViewController.m
//  ShareRecipe
//
//  Created by Jong Yun Lee on 9/12/14.
//  Copyright (c) 2014 HeapStack. All rights reserved.
//

#import "FavoriteRecipeTableViewController.h"
#import "MyRecipeCustomTableViewCell.h"
#import "FavoriteRecipeDetailViewController.h"
#import "FavoriteRecipeTableViewCell.h"

@interface FavoriteRecipeTableViewController ()



@end


@implementation FavoriteRecipeTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];

}


- (void)viewWillAppear:(BOOL)animated
{
    
    self.loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:self.loading];
    self.loading.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.loading startAnimating];
    [self performSelector:@selector(loadingCell) withObject:self.loading afterDelay:1.0];


}

- (void)loadingCell {
    
    NSString *bowl = @"_Bowl";
    NSString *favorite = [appDelegate.currentUserName stringByAppendingString:bowl];
    
    PFQuery *query = [PFQuery queryWithClassName:favorite];
    [query whereKey:@"type" equalTo:@"recipe"];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"error: %@", error);
        }
        else
        {
            self.bowlRecipe = objects;
            [self.tableView reloadData];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"favoriteRecipeDetail"])
    {
        FavoriteRecipeDetailViewController *viewController = (FavoriteRecipeDetailViewController *)segue.destinationViewController;
        viewController.selectedRecipe = self.selectedRecipe;
        viewController.tabBarController.hidesBottomBarWhenPushed = YES;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bowlRecipe count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavoriteRecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFObject *recipe = [self.bowlRecipe objectAtIndex:indexPath.row];
    
    cell.name.text = recipe[@"name"];
    cell.time.text = recipe[@"time"];
    
    NSString *imageFileURL = [recipe objectForKey:@"imageURL"];
    
    if (imageFileURL)
    {
    
        
        NSURL *imageFile = [[NSURL alloc] initWithString:imageFileURL];
        NSData *imageData = [NSData dataWithContentsOfURL:imageFile];
        cell.image.image = [UIImage imageWithData:imageData];
    }
    else
    {
        cell.image.image = [UIImage imageNamed:@"restaurant"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRecipe = [self.bowlRecipe objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"favoriteRecipeDetail" sender:self];
}


- (IBAction)myRecipe:(id)sender {
    
    [self performSegueWithIdentifier:@"myRecipe" sender:self];
    
}

- (IBAction)addRecipe:(id)sender {
    
    [self performSegueWithIdentifier:@"addRecipe" sender:self];
}
@end
