//
//  ExampleViewController.m
//  BWSelectControllerExample
//
//  Created by Bruno Wernimont on 16/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExampleViewController.h"

#import "BWSelectViewController.h"

@interface ExampleViewController ()

@end

@implementation ExampleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)didPressEmptyView:(id)sender
{
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"No items :(";
    [label sizeToFit];
    
    vc.emptyView = label;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didPressCustomCell:(id)sender
{
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    vc.items = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil];
    
    [vc setWillDisplayCellBlock:^(BWSelectViewController *vc, UITableViewCell *cell, id object) {
        cell.detailTextLabel.text = @"Detail";
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didPressLoadMore {
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    NSArray *items1 = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", @"Item1", @"Item2", @"Item3", @"Item4", @"Item1", @"Item2", @"Item3", @"Item4", nil];
    NSArray *items2 = [NSArray arrayWithObjects:@"Item1", @"Item2", nil];
    NSDictionary *sections = [NSDictionary dictionaryWithObjectsAndKeys:items1, @"section1", items2, @"section2", nil];
    [vc setSections:sections orders:[NSArray arrayWithObjects:@"section1", @"section2", nil] loadMore:YES];
    vc.multiSelection = YES;
    vc.allowEmpty = NO;
    
    [vc setDidSelectBlock:^(NSArray *selectedIndexPaths, BWSelectViewController *controller) {
        NSLog(@"%@", selectedIndexPaths);
    }];
    
    [vc setShouldLoadMoreBlock:^(BWSelectViewController *vc) {
        NSDictionary *sections = [NSDictionary dictionaryWithObjectsAndKeys:items1, @"section1", items2, @"section2", items1, @"sections3", nil];
        [vc setSections:sections orders:[NSArray arrayWithObjects:@"section1", @"section2", @"sections3", nil] loadMore:NO];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didPressImageSelect:(id)sender
{
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    vc.items = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil];
    
    [vc setImageForObjectBlock:^UIImage *(id object) {
        return [UIImage imageNamed:@"tux.png"];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didPressSimpleSelect:(id)sender
{
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    vc.items = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil];
    vc.multiSelection = NO;
    vc.allowSearch = YES;
    
    [vc setDidSelectBlock:^(NSArray *selectedIndexPaths, BWSelectViewController *controller) {
        NSLog(@"%@", selectedIndexPaths);
    }];
    
    [vc setDidValidateSelectionBlock:^(BWSelectViewController *controller, NSArray *selectedObjects) {
        NSLog(@"%@", selectedObjects);
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didPressNetworkSearch:(id)sender
{
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
//    vc.items = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil];
    vc.allowSearch = YES;
    
    [vc setShouldSearchBlock:^(BWSelectViewController *controller, NSString *searchString) {
        NSString *column = @"SELF";
        NSString *stringPredicate = [NSString stringWithFormat:@"%@ CONTAINS[cd] \"%@\"", column, searchString];
        NSArray *items = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:stringPredicate];
        controller.searchItems = [items filteredArrayUsingPredicate:predicate];
    }];
    
    [vc setDidSelectBlock:^(NSArray *selectedIndexPaths, BWSelectViewController *controller) {
        NSLog(@"%@", selectedIndexPaths);
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didPressHeaderViewSelect:(id)sender
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Header view";
    label.textColor = [UIColor redColor];
    [label sizeToFit];
    
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    vc.items = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil];
    vc.multiSelection = NO;
    vc.tableHeaderView = label;
    
    [vc setDidSelectBlock:^(NSArray *selectedIndexPaths, BWSelectViewController *controller) {
        NSLog(@"%@", selectedIndexPaths);
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)sectionCustomHeaderView {
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    vc.items = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Header view";
    label.textColor = [UIColor redColor];
    [label sizeToFit];
    
    vc.sectionHeaderViews = @{ @(0): label };
    
    [vc setDidSelectBlock:^(NSArray *selectedIndexPaths, BWSelectViewController *controller) {
        NSLog(@"%@", selectedIndexPaths);
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didPressMultiSelect:(id)sender
{
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    vc.items = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil];
    vc.multiSelection = YES;
    
    [vc setDidSelectBlock:^(NSArray *selectedIndexPaths, BWSelectViewController *controller) {
        NSLog(@"%@", selectedIndexPaths);
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didPresPreSelectedItems:(id)sender
{
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    vc.items = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil];
    vc.multiSelection = YES;
    [vc setSlectedIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil]];
    
    [vc setDidSelectBlock:^(NSArray *selectedIndexPaths, BWSelectViewController *controller) {
        NSLog(@"%@", selectedIndexPaths);
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didPresAllowEmpty:(id)sender
{
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    vc.items = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil];
    vc.multiSelection = YES;
    vc.allowEmpty = YES;
    
    [vc setDidSelectBlock:^(NSArray *selectedIndexPaths, BWSelectViewController *controller) {
        NSLog(@"%@", selectedIndexPaths);
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didPresMultipleSection:(id)sender
{
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    NSArray *items1 = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil];
    NSArray *items2 = [NSArray arrayWithObjects:@"Item1", @"Item2", nil];
    NSDictionary *sections = [NSDictionary dictionaryWithObjectsAndKeys:items1, @"section1", items2, @"section2", nil];
    [vc setSections:sections orders:[NSArray arrayWithObjects:@"section1", @"section2", nil]];
    vc.multiSelection = YES;
    vc.allowEmpty = NO;
    
    [vc setDidSelectBlock:^(NSArray *selectedIndexPaths, BWSelectViewController *controller) {
        NSLog(@"%@", selectedIndexPaths);
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didPresDropDown:(id)sender
{
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    NSArray *items1 = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil];
    NSArray *items2 = [NSArray arrayWithObjects:@"Item1", @"Item2", nil];
    NSDictionary *sections = [NSDictionary dictionaryWithObjectsAndKeys:items1, @"section1", items2, @"section2", nil];
    [vc setSections:sections orders:[NSArray arrayWithObjects:@"section1", @"section2", nil]];
    vc.multiSelection = NO;
    vc.allowEmpty = NO;
    vc.dropDownSection = YES;
    
    [vc setDidSelectBlock:^(NSArray *selectedIndexPaths, BWSelectViewController *controller) {
        NSLog(@"%@", selectedIndexPaths);
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didPresOneChoiceBySection:(id)sender
{
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    NSArray *items1 = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil];
    NSArray *items2 = [NSArray arrayWithObjects:@"Item1", @"Item2", nil];
    NSDictionary *sections = [NSDictionary dictionaryWithObjectsAndKeys:items1, @"section1", items2, @"section2", nil];
    [vc setSections:sections orders:[NSArray arrayWithObjects:@"section1", @"section2", nil]];
    vc.oneSelectionBySection = YES;
    
    [vc setDidSelectBlock:^(NSArray *selectedIndexPaths, BWSelectViewController *controller) {
        NSLog(@"%@", selectedIndexPaths);
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
