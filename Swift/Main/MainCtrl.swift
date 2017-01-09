//
//  MainCtrl
//  Kanito
//
//  Created by Luciano Calderano on 20/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class MainCtrl: MYViewController, MainMenuSubViewDelegate {
    
    @IBOutlet private var footLoginView: UIView!
    @IBOutlet private var footUserView: UIView!
    @IBOutlet private var footUserLabel: MYLabel!
    
    @IBOutlet private var menuView: MainMenuSubView!

    @IBOutlet private var lblExpl: MYLabel!
    @IBOutlet private var lblAdoz: MYLabel!
    @IBOutlet private var lblPetS: MYLabel!
    @IBOutlet private var lblUpld: MYLabel!
    
    private let fotoLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuView?.delegate = self
        
        self.footUserLabel?.layer.cornerRadius = 5
        self.footUserLabel?.layer.masksToBounds = true

        FollowClass.loadFollowed()

        let swipeDx = UISwipeGestureRecognizer.init(target: self, action: #selector(self.btnOpenMenu))
        swipeDx.direction = .left
        self.view.addGestureRecognizer(swipeDx)

        self.setLang()
        self.checkTour()

        let strLangCode = ClsLang.langCode()
        if strLangCode.isEmpty {
            self.loadLanguagesFromServer()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.setWelcome()
        self.addFotoLabel()
    }
    
    private func setLang () {
        self.setWelcome()
        lblAdoz?.title = "#init.Adop"
        lblPetS?.title = "#init.Pets"
        lblExpl?.title = "#init.Expl"
        lblUpld?.title = "#init.Upld"
    }
    
    private func loadLanguagesFromServer () {
        let request =  MYHttpRequest.biz("retrive-languages-list")
        request.json = [: ]
        request.start() { (success, response) in
            if success {
                let array = response.array("languages_list") as! [JsonDict]
                if (array.count > 0) {
                    ClsLang.saveLanguageList (array)
                    self.setLang()
                }
            }
        }
    }
    
    private func setWelcome () {
        let dict = UserClass().userProfile
        let username = dict.string("username")
        if username.isEmpty {
            self.footLoginView?.isHidden = false
            self.footUserView?.isHidden = true
            self.footUserLabel?.text = ""
        }
        else {
            self.footLoginView?.isHidden = true
            self.footUserView?.isHidden = false
            self.footUserLabel?.text = Lng("init.Welcome") + username
        }
        self.menuView?.userType = UserClass().userType
    }
    
    private func addFotoLabel () {
        if fotoLabel.text?.isEmpty == false {
            return
        }
        fotoLabel.frame = CGRect.init(x: self.view.frame.size.width - 130, y: self.view.frame.size.height / 2, width: 240, height: 20)
        fotoLabel.text = "photo credits:f-orme.it"
        fotoLabel.font = UIFont.mySize(10)
        fotoLabel.textColor = UIColor.myGreyDark
        fotoLabel.transform = CGAffineTransform.init(rotationAngle: -(.pi / 2))
        fotoLabel.textAlignment = .center;
        self.view.addSubview (fotoLabel)
    }
    
    private func checkTour () {
        if  UserClass().tourIsComplete == false {
            self.jumpToStoryboard("Tour")
        }
    }
    
    //MARK: Menu delegate
    
    @IBAction func btnOpenMenu () {
        self.menuView?.mainView = self.view
        self.menuView?.moveMenu()
    }
    
    func menuButtonTapped (item: Int) {
        switch item {
        case ItemMenu.MyKanito.hashValue:
            self.selectedItem(item: .MyKanito)
        case ItemMenu.Home.hashValue:
            self.selectedItem(item: .Home)
        case ItemMenu.DogBuddy.hashValue:
            self.selectedItem(item: .DogBuddy)
        case ItemMenu.Logout.hashValue:
            self.selectedItem(item: .Logout)
        default:
            break
        }
    }

    //MARK: button tapped

    @IBAction func adoptionTapped () {
        self.selectedItem(item: .Adozioni)
    }
    @IBAction func petServTapped () {
        self.selectedItem(item: .PetServices)
    }
    @IBAction func exploreTapped () {
        self.selectedItem(item: .Explore)
    }
    @IBAction func uploadTapped () {
        if UserClass().userId > 0 {
            self.selectedItem(item: .Upload)
        }
        else {
            self.needToLogin()
        }
    }
    @IBAction func loginTapped () {
        self.selectedItem(item: .Login)
    }
    @IBAction func signinTapped () {
        self.selectedItem(item: .Reg)
    }
    
    private func selectedItem (item: ItemMenu) {
        self.menuView?.closeMenu()
        switch (item) {
        case .MyKanito:
            self.jumpToStoryboard("Login")
        case .DogBuddy:
            self.jumpToStoryboard("BizMain")
        case .Login:
            self.jumpToStoryboard("Login")
        case .Reg:
            self.jumpToStoryboard("Registration")
        case .PetServices:
            self.jumpToStoryboard("PetServices")
        case .Upload:
            self.jumpToStoryboard("PvtUpload")
        case .Adozioni:
            self.jumpToStoryboard("PvtAdop")
        case .Explore:
            self.jumpToStoryboard("Explore")
        case .NeedToLogin:
            self.needToLogin()
        case .Logout:
//            [ClsSettings setObj:@[] ForKey:userListDogs];
//            [ClsSettings setObj:@[] ForKey:userListAlbum];
            UserClass().logout()
            self.setWelcome()
        default:
            break
        }
    }
    
    private func needToLogin () {
        self.showAlert(Lng("loginMain.ToUploadDesc"), message: "") { (UIAlertAction) in
            self.jumpToStoryboard("Login")
        }
    }
    
    private func jumpToStoryboard (_ sb: String) {
        let sb = UIStoryboard.init(name: sb, bundle: nil)
        let ctrl = sb.instantiateInitialViewController()
        self.navigationController?.show(ctrl!, sender: self)
    }
}
