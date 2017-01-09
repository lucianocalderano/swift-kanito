//
//  ViewUserDogsViewController.m
//  Kanito
//
//  Created by Luciano Lc on 21/07/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "ViewMyNewDog.h"
#import "ViewMyDogOpt.h"
#import "MyBaseViewController+ShowAlert.h"

@interface ViewMyNewDog () <UITextFieldDelegate> {

}

@end

@implementation ViewMyNewDog {
    IBOutlet UITextField *txtDogName;

    IBOutlet UIButton *btnM;
    IBOutlet UIButton *btnF;

    NSString *strIdDog;
    NSString *strIdAlbum;
    NSInteger idBreed;
    NSInteger idAgess;
    NSInteger idSizes;
    NSInteger idSex;
    UIButton *btnSelected;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    btnM.layer.cornerRadius = btnM.frame.size.width / 2;
    btnF.layer.cornerRadius = btnF.frame.size.width / 2;
    btnM.layer.borderColor = [MyColor myGreyDark].CGColor;
    btnF.layer.borderColor = [MyColor myGreyDark].CGColor;

    txtDogName.placeholder = keyLang(@"myNewDog.Name");
    txtDogName.delegate = self;
    idAgess = idBreed = idSizes = idSex = 0;

    [self switchSex:btnM];
}

#pragma mark - Option selected

- (IBAction) switchSex:(id) sender {
    UIButton *btn = sender;
    idSex = btn.tag;
    btnM.layer.borderWidth = 0;
    btnF.layer.borderWidth = 0;
    if (idSex == 0)
        btnM.layer.borderWidth = 4;
    else
        btnF.layer.borderWidth = 4;
}

- (IBAction)btnOpt:(id)sender {
    ViewMyDogOpt *viewOptPhoto;
    btnSelected = sender;
    viewOptPhoto = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewOptPhoto"];
    viewOptPhoto.delegate = self;
    [viewOptPhoto configNewDog:btnSelected.tag];
    [self showViewController:viewOptPhoto sender:self];
}

- (void) exitOptPhotoId:(NSString *)strId Descri:(NSString *)strDescri {
    if (strId.integerValue == 0)
        return;
    [btnSelected setTitle:strDescri forState:UIControlStateNormal];
    NSInteger idSelected = strId.integerValue;
    switch (btnSelected.tag) {
        case optNewDogBrd:
            idBreed = idSelected;
            break;
        case optNewDogAge:
            idAgess = idSelected;
            break;
        case optNewDogSiz:
            idSizes = idSelected;
            break;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
	return TRUE;
}

#pragma mark - Add dog

- (IBAction)btnAddNewDog:(id)sender {
    if (txtDogName.text.length == 0) {
        [self showAlertWithTitle:keyLang(@"noDogNam") message:nil];
        return;
    }
    if (idBreed == 0 || idAgess == 0 || idSizes == 0) {
        [self showAlertWithTitle:keyLang(@"noDogDat") message:nil];
        return;
    }

    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = self.view;
    request.page = @"save-new-dog";
    request.json = @{
                     @"user_id"            : [ClsUser userId],
                     @"user_type"          : [ClsUser userType],
                     @"name"               : txtDogName.text,
                     @"gender"             : @(idSex),
                     @"primary_breed_id"   : @(idBreed),
                     @"age_id"             : @(idAgess),
                     @"size_id"            : @(idSizes),
//                     @"gender"             : [NSString stringWithFormat:@"%ld", (long)idSex],
//                     @"primary_breed_id"   : [NSString stringWithFormat:@"%ld", (long)idBreed],
//                     @"age_id"             : [NSString stringWithFormat:@"%ld", (long)idAgess],
//                     @"size_id"            : [NSString stringWithFormat:@"%ld", (long)idSizes],
                     };
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 NSInteger status = [resultDict getString:@"status"].integerValue;
                 if (status == 1)
                     [self.navigationController popViewControllerAnimated:YES];
                 else
                     [self showAlertWithTitle:@"Error" message:resultDict[@"error_msg"]];
             }];
}


@end
