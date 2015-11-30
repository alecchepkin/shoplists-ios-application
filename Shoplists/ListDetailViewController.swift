import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(controller: ListDetailViewController)
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingShoplist shoplist: Shoplist)
    func listDetailViewController(controller: ListDetailViewController, didFinishEditingShoplist shoplist: Shoplist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var shoplistToEdit: Shoplist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let shoplist = shoplistToEdit {
            title = NSLocalizedString("EDIT_SHOPLIST", comment: "Edit Shoplist")
            textField.text = shoplist.name
            doneBarButton.enabled = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let shoplist = shoplistToEdit {
            shoplist.name = textField.text!
            delegate?.listDetailViewController(self, didFinishEditingShoplist: shoplist)
        } else {
            let shoplist = Shoplist(name: textField.text!)
            delegate?.listDetailViewController(self, didFinishAddingShoplist: shoplist)
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        doneBarButton.enabled = (newText.length > 0)
        return true
    }
    
}
