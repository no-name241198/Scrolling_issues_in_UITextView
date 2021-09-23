//
//  ViewController.swift
//  Scrolling_issues_in_UITextView
//
//  Created by Ryota on 2021/09/23.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var mainView: UITextView!
    @IBOutlet weak var sideView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
    
    var scrollCheck = Bool()
    var scrollPosition = CGFloat()
    let smapleText = """
    山路やまみちを登りながら、こう考えた。智ちに働けば角かどが立つ。情じょうに棹さおさせば流される。意地を通とおせば窮屈きゅうくつだ。とかくに人の世は住みにくい。住みにくさが高こうじると、安い所へ引き越したくなる。どこへ越しても住みにくいと悟さとった時、詩が生れて、画えが出来る。
    人の世を作ったものは神でもなければ鬼でもない。やはり向う三軒両隣りょうどなりにちらちらするただの人である。ただの人が作った人の世が住みにくいからとて、越す国はあるまい。あれば人でなしの国へ行くばかりだ。人でなしの国は人の世よりもなお住みにくかろう。
    越す事のならぬ世が住みにくければ、住みにくい所をどれほどか、寛容くつろげて、束つかの間まの命を、束の間でも住みよくせねばならぬ。ここに詩人という天職が出来て、ここに画家という使命が降くだる。あらゆる芸術の士は人の世を長閑のどかにし、人の心を豊かにするが故ゆえに尊たっとい。
    住みにくき世から、住みにくき煩わずらいを引き抜いて、ありがたい世界をまのあたりに写すのが詩である、画えである。あるは音楽と彫刻である。こまかに云いえば写さないでもよい。ただまのあたりに見れば、そこに詩も生き、歌も湧わく。着想を紙に落さぬとも※(「王＋膠のつくり」、第3水準1-88-22)鏘きゅうそうの音おんは胸裏きょうりに起おこる。丹青たんせいは画架がかに向って塗抹とまつせんでも五彩ごさいの絢爛けんらんは自おのずから心眼しんがんに映る。ただおのが住む世を、かく観かんじ得て、霊台方寸れいだいほうすんのカメラに澆季溷濁ぎょうきこんだくの俗界を清くうららかに収め得うれば足たる。この故に無声むせいの詩人には一句なく、無色むしょくの画家には尺※(「糸＋賺のつくり」、第3水準1-90-17)せっけんなきも、かく人世じんせいを観じ得るの点において、かく煩悩ぼんのうを解脱げだつするの点において、かく清浄界しょうじょうかいに出入しゅつにゅうし得るの点において、またこの不同不二ふどうふじの乾坤けんこんを建立こんりゅうし得るの点において、我利私慾がりしよくの覊絆きはんを掃蕩そうとうするの点において、――千金せんきんの子よりも、万乗ばんじょうの君よりも、あらゆる俗界の寵児ちょうじよりも幸福である。
    """
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideView.layer.cornerRadius = 12.0
        
        mainView.textColor = UIColor.black
        mainView.text = smapleText
        mainView.font = UIFont(name: "Helvetica", size: 16)
        mainView.delegate = self
        
        scrollView.delegate = self
        
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGR)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil) { [self] notification in
            scrollCheck = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                //scrollView.contentOffset.y = scrollPosition
                scrollCheck = true
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let cursorPosition = mainView.caretRect(for: mainView.selectedTextRange!.start)
        //print("cursorPosition:\(cursorPosition)")
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollCheck {
            scrollPosition = scrollView.contentOffset.y
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardFrameHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue?.height
        scrollViewBottom.constant = keyboardFrameHeight!
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollViewBottom.constant = 0
    }
    
    @IBAction func changeButton(_ sender: Any) {
        if !mainView.text.isEmpty {
            mainView.text = "Placeholder for UITextView"
            mainView.textColor = UIColor.lightGray
            mainView.font = UIFont(name: "Helvetica", size: 13.0)
            mainView.resignFirstResponder()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if mainView.textColor == UIColor.lightGray {
            mainView.text = ""
            mainView.textColor = UIColor.black
            mainView.font = UIFont(name: "Helvetica", size: 16)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if mainView.text.isEmpty {
            mainView.text = "Placeholder for UITextView"
            mainView.textColor = UIColor.lightGray
            mainView.font = UIFont(name: "Helvetica", size: 13.0)
        }
    }
}

