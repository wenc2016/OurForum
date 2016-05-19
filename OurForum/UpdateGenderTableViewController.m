//
//  UpdateGenderTableViewController.m
//  OurForum
//
//  Created by wenc on 16/5/19.
//  Copyright © 2016年 wenc. All rights reserved.
//

#import "UpdateGenderTableViewController.h"
#import "Utils.h"
#import "NetworkManager.h"

@interface UpdateGenderTableViewController ()

@end

@implementation UpdateGenderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadData {
    if ([NetworkManager sharedManager].myProfile.gender) {
        for (int i = 0; i < 3; i++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            if ([NetworkManager sharedManager].myProfile.gender.id == i + 1) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    else {
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (int i = 0; i < 3; i++) {
        NSIndexPath* tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:tempIndexPath];
        if (i == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    [self.tableView  deselectRowAtIndexPath:indexPath animated:YES];
}


- (IBAction)submitButtonPressed:(id)sender {
    [self.view makeToastActivity:CSToastPositionCenter];
    UserGender* userGender = [[UserGender alloc] init];
    userGender.genderId = 1;
    for (int i = 0; i < 3; i++) {
        NSIndexPath* tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:tempIndexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
            userGender.genderId = i + 1;
    }
    [[NetworkManager sharedManager] postDataWithUrl:@"myProfile/gender" data:[userGender toJSONData] completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        //        NSLog(@"Status code: %ld, Data: %@", statusCode, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        [self.view hideToastActivity];
        if (statusCode == 200) {
            NSError *error;
            UserProfile* myProfile = [[UserProfile alloc] initWithData:data error:&error];
            if (error != nil) NSLog(@"%@", error);
            
            [[NetworkManager sharedManager] setMyProfile:myProfile];
            //                NSLog(@"%@", myProfile);
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.view makeToast:errorMessage];
        }
    }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
