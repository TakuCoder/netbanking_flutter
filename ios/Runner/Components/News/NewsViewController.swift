
import UIKit
import WebKit

class NewsViewController: UIViewController,WKNavigationDelegate,WKUIDelegate {
    var coordinatorDelegate: NewsCoordinatorDelegate?
    
    
    
    @IBAction func goToFlutter(_ sender: Any) {
        coordinatorDelegate?.navigateToFlutter()
    }
    
    var finalname = "";
    
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var webViewContainer: UIView!
    
    
    var webView: WKWebView!
    
    //UAT
    
    //        var loadUrl = URL(string: "https://pguat.credopay.info/credopay/api/visasubmit1.php")!
    //        let firstLeg = "https://pguat.credopay.info/credopay/api/CPDirectPG.php";
    //        let cardSubmit = "https://pguat.credopay.info/credopay/api/visasubmit1.php";
    //        let returnUrl = "https://pguat.credopay.info/credopay/api/appresponsemerchant.php?randomgen="
    //        let netbanking_sale = "https://pguat.credopay.info/credopay/CPWebPG.php";
    
    
    //PROD
    
    var loadUrl = URL(string: "https://pg.credopay.in/credopay/api/visasubmit1.php")!
    let redirectionurl = "https://example.com?"
    let firstLeg = "https://pg.credopay.in/credopay/api/CPDirectPG.php";
    let cardSubmit = "https://pg.credopay.in/credopay/api/visasubmit1.php";
    let returnUrl = "https://pg.credopay.in/credopay/api/appresponsemerchant.php?randomgen="
    let netbanking_sale = "https://pg.credopay.in/credopay/CPWebPG.php";
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddhhmmss"
        let currentDate = Date()
        let timestamp: String = dateFormatter.string(from: currentDate)
        let amount = "1"
        let merchant_id = "E01010000001529"
        let Transaction_id = merchant_id + timestamp
        // let redirectionurl = "https://example.com?"
        
        
        
        
        
        
        
        
        
        let webConfiguration = WKWebViewConfiguration()
        let customFrame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 0.0, height: self.webViewContainer.frame.size.height))
        self.webView = WKWebView (frame: customFrame , configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.webViewContainer.addSubview(webView)
        webView.topAnchor.constraint(equalTo: webViewContainer.topAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: webViewContainer.rightAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: webViewContainer.leftAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: webViewContainer.bottomAnchor).isActive = true
        webView.heightAnchor.constraint(equalTo: webViewContainer.heightAnchor).isActive = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        
        print("============setting value============")
        print(merchant_id)
        print(amount)
        print(Transaction_id)
        print(redirectionurl)
        print(timestamp)
        print("============setting value============")
        
        
        
        perform_sale_transaction(merchant_id: merchant_id, amount : amount,Transaction_id : Transaction_id,redirectionurl : redirectionurl,timestamp : timestamp);
        
        
        
    }
    func perform_sale_transaction(merchant_id : String,amount :  String , Transaction_id : String,redirectionurl : String,timestamp : String)
    {
        
        
        let params = [
            "merchant_id" : merchant_id ,
            "&amount" : amount ,
            "&currency" : "INR",
            "&env" : "live" ,
            "&timestamp" : timestamp ,
            "&Transaction_id" : Transaction_id ,
            "&TransactionType" : "AA" ,
            "&redirectionurl" : redirectionurl
            
            
        ]
        let postString = getPostString(params: params)
        print(postString);
        var new_req = URLRequest(url: URL(string: self.netbanking_sale)!)
        new_req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        new_req.httpMethod = "POST"
        new_req.httpBody = postString.data(using: .utf8)
        self.webView.load(new_req)
        
        
        
        
        
        
    }
    
    func getPostString(params:[String:String]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
            
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    func SucccessCallback(url_data: URL, url : String)
    {
        print(url_data["responsecode"]!)
        print(url_data["merchant_id"]!)
        print(url_data["transaction_id"]!)
        print(url_data["amount"]!)
        print(url_data["TransactionType"]!)
        print(url_data["success"]!)
        print(url_data["errordesc"]!)
        print(url_data["refNbr"]!)
        let alert = UIAlertController(title: url_data["success"]!, message: url, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    func FailureCallback(url_data: URL, url : String)
    {
        print(url_data["responsecode"]!)
        print(url_data["merchant_id"]!)
        print(url_data["transaction_id"]!)
        print(url_data["amount"]!)
        print(url_data["TransactionType"]!)
        print(url_data["success"]!)
        print(url_data["errordesc"]!)
        print(url_data["refNbr"]!)
        let alert = UIAlertController(title: url_data["success"]!, message: url, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension URL {
    subscript(queryParam:String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParam })?.value
    }
}
extension NewsViewController
{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(navigationAction.request.url!)
        let url = navigationAction.request.url?.absoluteString ?? "value nil"
        
        if(url.contains("success=Success"))
        {
            
            let url_data = URL(string: url);
            SucccessCallback(url_data: url_data!,url : url);
            
            
        }
        
        
        
        
        if(url.contains("success=Failed"))
        {
            
            
            
            let url_data = URL(string: url);
            FailureCallback(url_data: url_data!,url : url);
            
            
            
        }
        
        decisionHandler(.allow)
    }
    
    
}


