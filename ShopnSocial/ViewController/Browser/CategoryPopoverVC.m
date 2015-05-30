//
//  CategoryPopoverVC.m
//  ShopnSocial
//
//  Created by rock on 5/12/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "CategoryPopoverVC.h"
#import "Global.h"
#import "YIInnerShadowView.h"

@interface CategoryPopoverVC ()
{
    int expandedSection;
    
    NSMutableArray* localCategories;
    NSMutableArray* globalCategories;
    NSMutableArray* globalCountries;
}
@end

@implementation CategoryPopoverVC

-(void) viewDidLoad
{
    expandedSection = -1;
    
    localCategories = [NSMutableArray array];
    globalCategories = [NSMutableArray array];
    globalCountries = [NSMutableArray array];
    
    NSMutableDictionary* globalIndex = [NSMutableDictionary dictionary];
    
    NSArray* _categories = [ProductCategory getCategoriesSync];
    NSDictionary* _countries = [Country getCountryDictionarySync];
    User* _currentUser = [User currentUser];
    
    int localID = [_currentUser.Location intValue];
    
    if (localID == 0) localID = 1;
    
    for (ProductCategory* pc in _categories) {
        if (pc.LocationCode == localID) {
            [localCategories addObject:pc];
        }
        else {
            NSMutableArray* subCategories = [globalIndex objectForKey:[NSNumber numberWithInt:pc.LocationCode]];
            if (subCategories == nil)
            {
                Country* co = [_countries objectForKey:[NSNumber numberWithInt:pc.LocationCode]];
                if (co == nil) continue;
                
                subCategories = [NSMutableArray array];
                
                [globalIndex setObject:subCategories forKey:[NSNumber numberWithInt:pc.LocationCode]];
                [globalCategories addObject:subCategories];
                [globalCountries addObject:co];
            }
            
            [subCategories addObject:pc];
        }
    }
}

#pragma mark -

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    if (localCategories.count == 0)
        return YES;
    
    return section > 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (localCategories.count == 0)
        return globalCategories.count;
    
    return 1 + globalCategories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && localCategories.count > 0)
    {
        return localCategories.count;
    }
    else
    {
        if (localCategories.count == 0) section += 1;
        
        if (expandedSection == section)
        {
            NSArray* array = [globalCategories objectAtIndex:section - 1];
            
            return array.count + 1;
        }
        
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        YIInnerShadowView* _innerShadow = [[YIInnerShadowView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
        _innerShadow.backgroundColor = [UIColor clearColor];
        _innerShadow.shadowRadius = 3;
        _innerShadow.shadowColor = [UIColor colorWithWhite:0 alpha:1];
        _innerShadow.shadowMask = YIInnerShadowMaskNone;
        _innerShadow.tag = 1001;
        
        [cell addSubview:_innerShadow];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = self.view.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    // Configure the cell...
    if (indexPath.section == 0 && localCategories.count > 0)
    {
        ProductCategory* pc = [localCategories objectAtIndex:indexPath.row];
        cell.textLabel.text = pc.Name;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryView = nil;
    }
    else
    {
        if (localCategories.count == 0)
        {
            indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + 1];
        }
        
        if (indexPath.row == 0)
        {
            Country* co = [globalCountries objectAtIndex:indexPath.section - 1];
            cell.textLabel.text = co.Name;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            
            if (expandedSection == indexPath.section)
            {
                cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"ic_collapsable"]];
                [cell.accessoryView setFrame:CGRectMake(0, 0, 15, 17)];
            }
            else
            {
                cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"ic_expandable"]];
                [cell.accessoryView setFrame:CGRectMake(0, 0, 17, 15)];
            }
            
            cell.imageView.image = [UIImage imageNamed:@"ic_earth"];
        }
        else
        {
            NSArray* subCategories = [globalCategories objectAtIndex:indexPath.section - 1];
            ProductCategory* pc = [subCategories objectAtIndex:indexPath.row - 1];
            
            YIInnerShadowView* _innerShadow = (YIInnerShadowView*)[cell viewWithTag:1001];
            if (_innerShadow != nil) {
                if (indexPath.row == 1) {
                    _innerShadow.shadowMask = YIInnerShadowMaskTop;
                } else if (indexPath.row == subCategories.count)
                {
                    _innerShadow.shadowMask = YIInnerShadowMaskBottom;
                }
                else _innerShadow.shadowMask = YIInnerShadowMaskNone;
                
                CGRect frame = cell.bounds;
                frame.size.height --;
                _innerShadow.frame = frame;
            }
            
            // all other rows
            cell.textLabel.text = pc.Name;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.backgroundColor = [UIColor colorWithRed:13 / 255.0f green:122 / 255.0f blue:191 / 255.0f alpha:1];
        }
    }
    
    return cell;
    
}

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && localCategories.count > 0)
    {
        if (self.delegate != nil)
            [self.delegate onTapCategory:[localCategories objectAtIndex:indexPath.row]];
    }
    else
    {
        if (indexPath.row == 0)
        {
            BOOL currentlyExpanded = expandedSection == indexPath.section;
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            if (expandedSection != -1)
            {
                int rows = [self tableView:tableView numberOfRowsInSection:expandedSection];
                for (int i = 1; i < rows; i++) {
                    [tmpArray addObject:[NSIndexPath indexPathForRow:i inSection:expandedSection]];
                }
                
                int section = expandedSection;
                expandedSection = -1;
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                
                cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"ic_expandable"]];
                [cell.accessoryView setFrame:CGRectMake(0, 0, 17, 15)];
            }
            
            if (currentlyExpanded == false)
            {
                tmpArray = [NSMutableArray array];
                
                expandedSection = indexPath.section;
                
                int rows = [self tableView:tableView numberOfRowsInSection:indexPath.section];
                for (int i = 1; i < rows; i++) {
                    [tmpArray addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                }
                
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                
                cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"ic_collapsable"]];
                [cell.accessoryView setFrame:CGRectMake(0, 0, 15, 17)];
            }
        }
        else
        {
            if (localCategories.count == 0)
            {
                indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + 1];
            }
            
            if (self.delegate != nil)
            {
                NSArray* subcategories = [globalCategories objectAtIndex:indexPath.section - 1];
                [self.delegate onTapCategory:[subcategories objectAtIndex:indexPath.row - 1]];
            }

        }
    }
}

@end
