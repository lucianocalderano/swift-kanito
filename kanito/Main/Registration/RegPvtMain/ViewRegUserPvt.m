
#import "ViewRegUserPvt.h"
#import "ClsInputScrollView.h"
#import "MyTextField.h"
#import "MyInputView.h"
#import "ClsFB.h"
#import "MyBaseViewController+ShowAlert.h"

@interface ViewRegUserPvt ()  {
    IBOutlet UIView *viewMail;
    IBOutlet UIView *viewUser;
    IBOutlet UIView *viewPass;
    
    IBOutlet MyTextField *txtMail;
    IBOutlet MyTextField *txtUser;
    IBOutlet MyTextField *txtPass;
    
    IBOutlet UIButton *btnFb;
}

@property (nonatomic, strong) IBOutlet ClsInputScrollView *inputScrollView;
@end

@implementation ViewRegUserPvt

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSAttributedString *s = [ClsUtil attributedStringWithLeftImageName:@"Facebook"
                                                               MaxSize:16
                                                             RightText:keyLang(@"usrLogin.FB")];
    
    [btnFb setAttributedTitle:s forState:UIControlStateNormal];

    txtUser.placeholder = keyLang(@"regUserPvt.UserErr");
    txtPass.placeholder = keyLang(@"regUserPvt.PassErr");
    txtMail.placeholder = keyLang(@"regUserPvt.MailErr");

    [self updateView:viewMail];
    [self updateView:viewUser];
    [self updateView:viewPass];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.myNavigationBar.titolo = @"#regUserPvt.Title";
}

- (void) updateView:(UIView *) view {
    view.layer.cornerRadius = 10;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1;
}

- (BOOL)validateEmailWithString:(NSString*)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (BOOL)validateUserWithString:(NSString*)strUser {
    NSString *emailRegex = @"[A-Za-z0-9]{3,20}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:strUser];
}

#pragma mark -

- (IBAction) btnRegister {
    [self.view endEditing:YES];

    NSString *strMail = [txtMail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *strUser = [txtUser.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *strPass = [txtPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if ((strMail.length == 0) || ([self validateEmailWithString:strMail] == FALSE )) {
        [self showAlertWithTitle:keyLang(@"usrLogin.AlertTitle")
                        message:keyLang(@"regUserPvt.MailErr")];
        [txtMail becomeFirstResponder];
        return;
    }
    if ((strUser.length == 0) || ([self validateUserWithString:strUser] == FALSE )) {
        [self showAlertWithTitle:keyLang(@"usrLogin.AlertTitle")
                         message:keyLang(@"regUserPvt.UserErr")];
        [txtUser becomeFirstResponder];
        return;
    }
    if (strPass.length == 0) {
        [self showAlertWithTitle:keyLang(@"usrLogin.AlertTitle")
                         message:keyLang(@"regUserPvt.PassErr")];
        [txtPass becomeFirstResponder];
        return;
    }
    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = self.view;
    request.page = @"registration";
    request.json = @{
                     @"email": strMail,
                     @"username": strUser,
                     @"password": strPass,
                     @"account_type": defUserPvt,
                     @"business_name": @"",
                     @"facebook": @"0"
                     };
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 if (succeeded) {
                     [self regOk];
                 }
             }];
}

- (void) regOk {
    [self showAlertWithTitle:keyLang(@"regUser.Ok") message:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Facebook SDK

- (IBAction) btnFB {
    ClsFB *fb = [[ClsFB alloc] init];
    fb.viewCtrl = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [fb queryFacebookOnComplete:^(BOOL succeeded, NSDictionary *dicExit) {
                          if (succeeded && dicExit) {
                              [self fbResponse:dicExit];
                          }
                          else {
                              [self showAlertWithTitle:@"Facebook error"
                                               message:[dicExit getString:@"err"]];
                          }
                      }];
}

- (void) fbResponse:(NSDictionary *) dic {
    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = self.view;
    request.page = @"registration";
    request.json = dic;
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 if (succeeded) {
                     [self regOk];
                 }
             }];
}

@end
