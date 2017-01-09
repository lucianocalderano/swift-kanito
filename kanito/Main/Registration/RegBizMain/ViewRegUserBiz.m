
#import "ViewRegUserBiz.h"
#import "SubRegUserBiz.h"
#import "ViewRegBizOpt.h"
#import "ViewRegBizAct.h"
#import "ClsInputScrollView.h"
#import "MyBaseViewController+ShowAlert.h"

@interface ViewRegUserBiz () < SubRegUserBizDelegate, ViewRegBizOptDelegate, ViewRegBizActDelegate > {
    IBOutlet ClsInputScrollView *scrlUser;
    IBOutlet SubRegUserBiz *subRegUserBiz;
    ClsRegUserBiz *clsRegUserBiz;
}
@end

static NSString *isoStdCountry = @"IT";
static NSString *strStdCountry = @"Italia";

@implementation ViewRegUserBiz

- (void)viewDidLoad {
    [super viewDidLoad];
    clsRegUserBiz = [[ClsRegUserBiz alloc] init];
    clsRegUserBiz.country.strIso = isoStdCountry;
    clsRegUserBiz.country.strName = strStdCountry;
    
    subRegUserBiz.delegate = self;
    subRegUserBiz.lblCountry.text = clsRegUserBiz.country.strName;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.myNavigationBar.titolo = @"#regUserBiz.Title";
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    scrlUser.contentSize = subRegUserBiz.frame.size;
}

- (IBAction) btnReg {
    [self.view endEditing:YES];
    
    if (subRegUserBiz.checkUserData == NO)
        return;
    
    if (clsRegUserBiz.city.strId.length == 0) {
        [self showAlertWithTitle:keyLang(@"regUserBiz.AlertTitle")
                         message:keyLang(@"regUserBiz.City")];
        return;
    }
    if (clsRegUserBiz.country.strIso == 0) {
        [self showAlertWithTitle:keyLang(@"regUserBiz.AlertTitle")
                         message:keyLang(@"regUserBiz.Country")];
        return;
    }
    if (clsRegUserBiz.activity.arrId.count == 0) {
        [self showAlertWithTitle:keyLang(@"regUserBiz.AlertTitle")
                         message:keyLang(@"regUserBiz.Activities")];
        return;
    }
    
    if ([clsRegUserBiz.country.strIso isEqualToString:isoStdCountry])
        [self sendRequest];
    else
        [self askForeingCity];
}

- (void) askForeingCity {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:keyLang(@"regUserBiz.ForeignCity")
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:keyLang(@"OK")
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                UITextField *txt = alert.textFields[0];
                                                clsRegUserBiz.strForeignCity = txt.text;
                                                if (clsRegUserBiz.strForeignCity > 0)
                                                    [self sendRequest];
                                            }]
     ];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"City";
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) sendRequest {
    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = self.view;
    request.page = @"registration";
    request.json = @{
                     @"account_type"   : defUserBiz,
                     @"business_name"  : clsRegUserBiz.strNome,
                     @"email"          : clsRegUserBiz.strMail,
                     @"username"       : clsRegUserBiz.strUser,
                     @"password"       : clsRegUserBiz.strPass,
                     @"address"        : clsRegUserBiz.strAddr,
                     @"cap"            : clsRegUserBiz.strCap,
                     @"city_id"        : clsRegUserBiz.city.strId,
                     @"country_iso"    : clsRegUserBiz.country.strIso,
                     //@"foreign_city"   : clsRegUserBiz.strForeignCity,
                     @"activities[Activity_habtm]"    : clsRegUserBiz.activity.arrId,
                     };
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 if (succeeded) {
                     [self showAlertWithTitle:keyLang(@"regUser.Ok")
                                      message:nil
                                      okBlock:^{
                                          [self.navigationController popToRootViewControllerAnimated:YES];
                                      }];
                 }
             }];
}

#pragma mark - Open view options

- (void) exitSubRegUserBiz:(regUserBiz_Items) item {
    switch (item) {
        case regUserBiz_Region:
        case regUserBiz_Country: {
            ViewRegBizOpt *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewRegBizOpt"];
            [self.navigationController showViewController:ctrl sender:self];
            [ctrl clsRegUserBizId:clsRegUserBiz Delegate:self Item:item];
        }
            break;
        case regUserBiz_Activities: {
            ViewRegBizAct *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewRegBizAct"];
            [self.navigationController showViewController:ctrl sender:self];
            [ctrl clsRegUserBizId:clsRegUserBiz Delegate:self];
        }
            break;
        default:
            return;
    }
}

#pragma mark - Exit from options

- (void) exitViewRegBizOptWithItem:(regUserBiz_Items)item {
    switch (item) {
        case regUserBiz_City:
            subRegUserBiz.lblCity.text = clsRegUserBiz.city.strName;
            break;
        case regUserBiz_Country:
            subRegUserBiz.lblCountry.text = clsRegUserBiz.country.strName;
            break;
        default:
            break;
    }
}

- (void) exitViewRegBizAct {
    NSString *s = keyLang(@"regUserBiz.SelActivities");
    NSString *n = [NSString stringWithFormat:@"%lu", (unsigned long)clsRegUserBiz.activity.arrId.count];
    subRegUserBiz.lblActivities.text = [s stringByReplacingOccurrencesOfString:@"$$" withString:n];
}
@end
