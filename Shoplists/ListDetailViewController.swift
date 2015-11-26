import UIKit

protocol ListDetailViewControllerDelegate: class {
  func listDetailViewControllerDidCancel(controller: ListDetailViewController)
  func listDetailViewController(controller: ListDetailViewController, didFinishAddingShoplist checklist: Shoplist)
  func listDetailViewController(controller: ListDetailViewController, didFinishEditingShoplist checklist: Shoplist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!  
  @IBOutlet weak var iconImageView: UIImageView!

  weak var delegate: ListDetailViewControllerDelegate?
  
  var checklistToEdit: Shoplist?
  var iconName = "Folder"

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let checklist = checklistToEdit {
      title = "Edit Shoplist"
      textField.text = checklist.name
      doneBarButton.enabled = true
      iconName = checklist.iconName
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
    if let checklist = checklistToEdit {
      checklist.name = textField.text!
      checklist.iconName = iconName
      delegate?.listDetailViewController(self, didFinishEditingShoplist: checklist)
    } else {
      let checklist = Shoplist(name: textField.text!, iconName: iconName)
      delegate?.listDetailViewController(self, didFinishAddingShoplist: checklist)
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
