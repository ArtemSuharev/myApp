import UIKit
import FMDB
import GRDB
import DropDown
import CoreData

// Стартовый экран приложения, который запускается сразу после экрана-заставки

class LaunchScreen: UIViewController {
    
    func recolorStatusBar(color: UIColor) {
        viewMain.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    }
    
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var buttonContinue: UIButton!
    
    let helpFunc = HelpClasses()
    
    var timerr: Timer?
    var timerLoadProducts: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonContinue.isHidden = true
        buttonContinue.isEnabled = false
        
        let number_launch: Int = helpFunc.loadAppData_Int(key: AD_count_launch_app)
        helpFunc.saveAppData_Any(b: number_launch + 1, key: AD_count_launch_app)
        
        // Во время непродолжительной загрузки, внизу экрана появляются подсказки по работе с приложением 
      
        let arrayText = [
            NSLocalizedString("start_screen_001", comment: ""),
            NSLocalizedString("start_screen_002", comment: ""),
            NSLocalizedString("start_screen_003", comment: ""),
            NSLocalizedString("start_screen_004", comment: ""),
            NSLocalizedString("start_screen_005", comment: ""),
            NSLocalizedString("start_screen_006", comment: ""),
            NSLocalizedString("start_screen_007", comment: ""),
            NSLocalizedString("start_screen_008", comment: ""),
            NSLocalizedString("start_screen_009", comment: ""),
            NSLocalizedString("start_screen_010", comment: ""),
            NSLocalizedString("start_screen_011", comment: ""),
            NSLocalizedString("start_screen_012", comment: ""),
            NSLocalizedString("start_screen_013", comment: ""),
            NSLocalizedString("start_screen_014", comment: ""),
            NSLocalizedString("start_screen_015", comment: ""),
            NSLocalizedString("start_screen_016", comment: ""),
            NSLocalizedString("start_screen_017", comment: ""),
            NSLocalizedString("start_screen_018", comment: ""),
            NSLocalizedString("start_screen_019", comment: ""),
            NSLocalizedString("start_screen_020", comment: ""),
            NSLocalizedString("start_screen_021", comment: ""),
            NSLocalizedString("start_screen_022", comment: ""),
            NSLocalizedString("start_screen_023", comment: ""),
            NSLocalizedString("start_screen_024", comment: ""),
            NSLocalizedString("start_screen_025", comment: ""),
            NSLocalizedString("start_screen_026", comment: ""),
            NSLocalizedString("start_screen_027", comment: ""),
            NSLocalizedString("start_screen_028", comment: ""),
            NSLocalizedString("start_screen_029", comment: ""),
            NSLocalizedString("start_screen_030", comment: ""),
            NSLocalizedString("start_screen_031", comment: ""),
            NSLocalizedString("start_screen_032", comment: ""),
            NSLocalizedString("start_screen_033", comment: ""),
            NSLocalizedString("start_screen_034", comment: ""),
            NSLocalizedString("start_screen_035", comment: ""),
            NSLocalizedString("start_screen_036", comment: ""),
            NSLocalizedString("start_screen_037", comment: ""),
            NSLocalizedString("start_screen_038", comment: ""),
            NSLocalizedString("start_screen_039", comment: ""),
            NSLocalizedString("start_screen_040", comment: ""),
            NSLocalizedString("start_screen_041", comment: ""),
            NSLocalizedString("start_screen_042", comment: ""),
            NSLocalizedString("start_screen_043", comment: ""),
            NSLocalizedString("start_screen_044", comment: ""),
            NSLocalizedString("start_screen_045", comment: ""),
            NSLocalizedString("start_screen_046", comment: ""),
            NSLocalizedString("start_screen_047", comment: ""),
            NSLocalizedString("start_screen_048", comment: ""),
            NSLocalizedString("start_screen_049", comment: ""),
            NSLocalizedString("start_screen_050", comment: ""),
            NSLocalizedString("start_screen_051", comment: ""),
            NSLocalizedString("start_screen_052", comment: ""),
            NSLocalizedString("start_screen_053", comment: ""),
            NSLocalizedString("start_screen_054", comment: ""),
            NSLocalizedString("start_screen_055", comment: ""),
            NSLocalizedString("start_screen_056", comment: ""),
            NSLocalizedString("start_screen_057", comment: ""),
            NSLocalizedString("start_screen_058", comment: ""),
            NSLocalizedString("start_screen_059", comment: ""),
            NSLocalizedString("start_screen_060", comment: ""),
            NSLocalizedString("start_screen_061", comment: ""),
            NSLocalizedString("start_screen_062", comment: ""),
            NSLocalizedString("start_screen_063", comment: ""),
            NSLocalizedString("start_screen_064", comment: ""),
            NSLocalizedString("start_screen_065", comment: ""),
            NSLocalizedString("start_screen_066", comment: ""),
            NSLocalizedString("start_screen_067", comment: ""),
            NSLocalizedString("start_screen_068", comment: ""),
            NSLocalizedString("start_screen_069", comment: ""),
            NSLocalizedString("start_screen_070", comment: ""),
            NSLocalizedString("start_screen_071", comment: ""),
            NSLocalizedString("start_screen_072", comment: ""),
            NSLocalizedString("start_screen_073", comment: ""),
            NSLocalizedString("start_screen_074", comment: ""),
            NSLocalizedString("start_screen_075", comment: ""),
            NSLocalizedString("start_screen_076", comment: ""),
            NSLocalizedString("start_screen_077", comment: ""),
            NSLocalizedString("start_screen_078", comment: ""),
            NSLocalizedString("start_screen_079", comment: ""),
            NSLocalizedString("start_screen_080", comment: "")
        ]
        
      // Случайным образом выбирается одна из подсказок и выводится на экран
      // Среди подсказок есть несколько пустых, при этом на экран ничего не выводится
      
        let randomNumber = Int.random(in: 1...arrayText.count - 1)
        let text = arrayText[randomNumber]
        if text.contains("start_screen") {
            labelText.text = ""
        } else {
            labelText.text = text
        }
        labelText.textColor = ColorText.textDark
        
        if !helpFunc.loadAppData_Bool(key: AD_first_launch){
            helpFunc.loadProductTable_first_lounch(first_item: 0)
            showSkip()
        } else {
            showSkip()
        }
        
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        timerr?.invalidate()
        openStartScreen()
    }
    
    func showSkip() {
        
        buttonContinue.isHidden = false
        buttonContinue.isEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.viewMain.addGestureRecognizer(gesture)
        
        buttonContinue.borderColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        buttonContinue.borderWidth = 1
        buttonContinue.cornerRadius = buttonContinue.frame.size.height / 2
        buttonContinue.setTitleColor(ColorText.textDark, for: .normal)
        buttonContinue.setTitle(NSLocalizedString("Skip", comment: ""), for: .normal)
        
        timerr = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(continueView), userInfo: nil, repeats: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    @objc func continueView () {
    
        openStartScreen()
        
    }
    
    func countProducts () -> Int {
        
        let dbPath = Bundle.main.path(forResource: "data", ofType: "db")!
        
        var item: Int = 0
        
        do {
            let dbQueue = try DatabaseQueue(path: dbPath)
            try dbQueue.read { db in
                let urls = try URL.fetchCursor(db, sql: "SELECT ? FROM title_weight", arguments: ["my_id"])
                while ((try urls.next()) != nil) {
                        item += 1
                    }
            }
        } catch  {
            print ("")
            return item
        }
        
        return item
        
    }
    
    @objc func showFirstText () {
        
        let arrayText = [
            NSLocalizedString("Uploading recipes...", comment: ""),
            NSLocalizedString("Search for delicious dishes...", comment: ""),
            NSLocalizedString("The scales were lost...", comment: ""),
            NSLocalizedString("Where's my apron...", comment: ""),
            NSLocalizedString("Almost done...", comment: ""),
            NSLocalizedString("We need to turn on the stove...", comment: ""),
            NSLocalizedString("Search for a good recipe...", comment: "")
        ]
        
        let randomNumber = Int.random(in: 1...arrayText.count-1)
        
        labelText.text = arrayText[randomNumber]
        labelText.textColor = ColorText.textDark
        
    }

    @IBAction func clickContinue(_ sender: Any) {
        
        timerr?.invalidate()
        openStartScreen()

    }
    
    func rsb (color: UIColor) {

        viewMain.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
    }
    
    func openStartScreen() {
        
        performSegue(withIdentifier: "showStartScreen", sender: nil)
        
    }

}
