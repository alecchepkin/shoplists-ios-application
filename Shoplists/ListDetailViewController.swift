import UIKit

protocol ListDetailViewControllerDelegate: class {
  func listDetailViewControllerDidCancel(controller: ListDetailViewController)
  func listDetailViewController(controller: ListDetailViewController, didFinishAddingShoplist shoplist: Shoplist)
  func listDetailViewController(controller: ListDetailViewController, didFinishEditingShoplist shoplist: Shoplist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!  
  @IBOutlet weak var iconImageView: UIImageView!

  weak var delegate: ListDetailViewControllerDelegate?
  
  var shoplistToEdit: Shoplist?
  var iconName = "Folder"

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let shoplist = shoplistToEdit {
      title = "Edit Shoplist"
      textField.text = shoplist.name
      doneBarButton.enabled = true
      iconName = shoplist.iconName
    }
    
    iconImageView.image = UIImage(named: iconName)
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
      shoplist.iconName = iconName
      delegate?.listDetailViewController(self, didFinishEditingShoplist: shoplist)
    } else {
      let shoplist = Shoplist(name: textField.text!, iconName: iconName)
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
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "PickIcon" {
      let controller = segue.destinationViewController as! IconPickerViewController
      controller.delegate = self
    }
  }
  
  func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String) {
    self.iconName = iconName
    iconImageView.image = UIImage(named: iconName)
    navigationController?.popViewControllerAnimated(true)
  }
}
