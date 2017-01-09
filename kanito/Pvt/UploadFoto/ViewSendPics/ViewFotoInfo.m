//
//  ViewSendPics.m
//  Kanito
//
//  Created by Luciano Lc on 22/07/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "ViewFotoInfo.h"
#import "ViewFotoUpld.h"
#import "MyBaseViewController+ShowAlert.h"

#import "ClsSettings.h"

@interface ViewFotoInfo  () < UIAlertViewDelegate , UITableViewDelegate, MyNavigationBarDelegate > {
    IBOutlet UILabel *lblPicTit;
    IBOutlet UILabel *lblSelDog;
    IBOutlet UILabel *lblSelAlb;
    IBOutlet UISwitch *switchSave;
    IBOutlet UITextField *txtTitle;
    IBOutlet UITableView *tblMyDogs;
    IBOutlet UITableView *tblAlbums;
    
    NSArray *arrMyDogs;
    NSArray *arrAlbums;
    
    NSString *strIdDog;
    NSString *strIdAlbum;
    NSInteger idLocat;
    NSInteger idActiv;
    UIButton *btnSelected;
    BOOL backFromNewDogView;
}
@end

@implementation ViewFotoInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    backFromNewDogView = NO;
    tblMyDogs.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tblMyDogs.layer.borderWidth = 1;
    tblMyDogs.layer.cornerRadius = 15;
    tblMyDogs.tag = -2;
    tblAlbums.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tblAlbums.layer.borderWidth = 1;
    tblAlbums.layer.cornerRadius = 15;
    tblAlbums.tag = -2;

    lblPicTit.attributedText = [ClsUtil attributedStringWithLeftImageName:@"Titolo_FotoUpld"
                                                                  MaxSize:lblPicTit.frame.size.height - 2
                                                                RightText:keyLang(@"viewFotoSend.PhotoTitle")];
    lblSelDog.attributedText = [ClsUtil attributedStringWithLeftImageName:@"Cane_FotoUpld"
                                                                  MaxSize:lblSelDog.frame.size.height - 2
                                                                RightText:keyLang(@"viewFotoSend.DogSel")];
    lblSelAlb.attributedText = [ClsUtil attributedStringWithLeftImageName:@"Album_FotoUpld"
                                                                  MaxSize:lblSelAlb.frame.size.height - 2
                                                                RightText:keyLang(@"viewFotoSend.AlbumSel")];
    
    
    txtTitle.placeholder = keyLang(@"viewFotoSend.Placeholder");

    arrMyDogs = (NSArray *) [ClsSettings getObjForKey:userListDogs];
    arrAlbums = (NSArray *) [ClsSettings getObjForKey:userListAlbum];
    
    strIdDog   = [ClsSettings getValForKey:userSetDogId];
    strIdAlbum = [ClsSettings getValForKey:userSetPicAlbumId];

    if (arrMyDogs.count == 0) {
        [self loadDogs];
    } else if (arrAlbums.count == 0) {
        [self loadAlbums];
    }
#if TARGET_IPHONE_SIMULATOR
    switchSave.selected = NO;
#endif
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (backFromNewDogView == NO)
        return;
    strIdDog = @"";
    strIdAlbum = @"";
    [self loadDogs];
}

- (void)myNavigatorBackButtonTapped {
#if TARGET_IPHONE_SIMULATOR
    [self.navigationController popToRootViewControllerAnimated:YES];
#else
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
#endif
}

- (void) loadDogs {
    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = self.view;
    request.page = @"user-dogs-list";
    request.json = @{
                     @"user_id"    : [ClsUser userId],
                     @"user_type"  : [ClsUser userType],
                     };
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 if (succeeded) {
                     arrMyDogs = [resultDict getArray:@"Dogs"];
                     [ClsSettings setObj:arrMyDogs ForKey:userListDogs];
                     [tblMyDogs reloadData];
                     [self loadAlbums];
                 }
             }];
}

- (void) loadAlbums {
    if (strIdDog.length == 0)
        return;

    strIdAlbum = @"";
    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = self.view;
    request.page = @"dog-albums-list";
    request.json = @{
                     @"dog_id"    : strIdDog,
                     };
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 if (succeeded) {
                     arrAlbums = [resultDict getArray:@"Albums"];
                     [ClsSettings setObj:arrAlbums ForKey:userListAlbum];
                     [tblAlbums reloadData];
                 }
             }];
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == tblAlbums)
        return arrAlbums.count;
    else
        return arrMyDogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.textColor = [UIColor clearColor];
    }

    cell.accessoryType = (tableView.tag == indexPath.row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    if (tableView == tblAlbums) {
        NSDictionary *dic = arrAlbums[indexPath.row];
        cell.textLabel.text = [dic getString:@"Frontalbum.name"];
        cell.detailTextLabel.text = [dic getString:@"Frontalbum.id"];
    }
    else {
        NSDictionary *dic = arrMyDogs[indexPath.row];
        cell.textLabel.text = [dic getString:@"Dog.name"];
        cell.detailTextLabel.text = [dic getString:@"Dog.id"];
    }
    cell.textLabel.font = [MyFont fontSize:17];
    cell.textLabel.textColor = [MyColor blackColor];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    if (tableView == tblAlbums) {
        strIdAlbum = cell.detailTextLabel.text;
    }
    else {
        strIdDog = cell.detailTextLabel.text;
        strIdAlbum = @"";
        [self loadAlbums];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView.tag == -2)
        [self tableViewWillFinishLoading:tableView];
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableViewWillFinishLoading:(UITableView *)tableView {
    tableView.tag = -1;
    NSString *strId;
    if (tableView == tblAlbums) {
        strId = strIdAlbum;
    }
    else {
        strId = strIdDog;
    }
    if (strId.length == 0)
        return;
    
    int i = 0;
    NSIndexPath *idx;
    if (tableView == tblAlbums) {
        for (NSDictionary *dicAlb in arrAlbums) {
            NSDictionary  *dic = [dicAlb getDictionary:@"Frontalbum"];
            if ([dic[@"id"] isEqualToString:strId]) {
                idx = [NSIndexPath indexPathForRow:i inSection:0];
                break;
            }
            i++;
        }
    }
    else {
        for (NSDictionary *dicDog in arrMyDogs) {
            NSDictionary  *dic = [dicDog getDictionary:@"Dog"];
            if ([dic[@"id"] isEqualToString:strId]) {
                idx = [NSIndexPath indexPathForRow:i inSection:0];
                break;
            }
            i++;
        }
    }
    if (idx) {
        tableView.tag = idx.row;
        [tableView selectRowAtIndexPath:idx animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:idx];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.view endEditing:YES];
	return TRUE;
}

#pragma mark - Upload

- (BOOL) checkAlbum {
    if (strIdAlbum.integerValue > 0)
        return YES;
    
    [self showAlertWithTitle:keyLang(@"noSelect") message:nil];
    return NO;
}

#define nextCtrl @"ViewFotoUpld"

- (IBAction)btnOpts {
    if ([self checkAlbum] == NO)
        return;
    [self saveOnGallery];

    [ClsSettings setVal:strIdDog   ForKey:userSetDogId];
    [ClsSettings setVal:strIdAlbum ForKey:userSetPicAlbumId];
    
    [self performSegueWithIdentifier:nextCtrl sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:nextCtrl]) {
        ViewFotoUpld *ctrl = segue.destinationViewController;
        ctrl.dicPhoto = @{
            @"album_id" : strIdAlbum,
            @"title"    : txtTitle.text,
            };
    }
    else {
        backFromNewDogView = YES;
    }
}

- (void) saveOnGallery {
    if (switchSave.on) {
        NSArray *arr = (NSArray *) [ClsSettings getObjForKey:userArrayDataForPicsToUpload];
        if (arr.count > 0) {
            UIImage *img = [UIImage imageWithData:arr[0]];
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        }
    }
}
#pragma mark - New album

- (IBAction)btnNewAlbum {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:keyLang(@"newAlbumTit")
                                                                   message:keyLang(@"newAlbumDes")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
         textField.placeholder = @"Album";
     }];
    
    [alert addAction:[UIAlertAction actionWithTitle:keyLang(@"cancel")
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:keyLang(@"OK")
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                UITextField *album = alert.textFields.firstObject;
                                                [self okTappedWithAlbumName:album.text];
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}




- (void) okTappedWithAlbumName:(NSString *) albumName {
    if (albumName.length == 0)
        return;
    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = self.view;
    request.page = @"save-new-album";
    request.json = @{
                     @"owner_id"    : strIdDog,
                     @"owner_type"  : defTypeDog,
                     @"name"        : albumName,
                     };
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 if (succeeded) {
                     [self loadAlbums];
                 }
             }];
}

@end
