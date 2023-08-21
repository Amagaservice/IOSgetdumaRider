//
//  PaymentExtension.swift
//  Ocory
//
//  Created by nile on 28/09/21.
//

import UIKit



extension PaymentVC: UITableViewDataSource ,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.cardData.count ) == 0 {
            tableView.setEmptyMessage("No Data Found")
        } else {
            tableView.removeErrorMessage()
        }
        return self.cardData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewCardModal = self.cardData[indexPath.row]
        let cell = self.payment_tableView.dequeueReusableCell(withIdentifier: "PaymentVCCell") as! PaymentVCCell
        cell.checkBtn.tag = indexPath.row
        cell.defaultBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        // cell.checkBtn.addTarget(self, action: #selector(checkBoxBtn), for: .touchUpInside)
        //   cell.deleteBtn.addTarget(self, action: #selector(deleteBtnAct), for: .touchUpInside)
        let viewModal = self.cardData[indexPath.row]
        cell.numberLbl.text = "" + "\(viewModal.card_number ?? "")"
        cell.nameLbl.text = "\(viewModal.card_holder_name ?? "")"
        cell.expiryLbl.text = "\(viewModal.expiry_month ?? "")" + "/"  + "\(viewModal.expiry_date ?? "")"
        
        if viewCardModal.is_default == "2"{
            cell.checkBtn.setImage(UIImage(named: "uncheck"), for: .normal)
            cell.defaultBtn.isHidden = true
            cell.deleteBtn.isHidden = true
        }
        else{
            cell.checkBtn.setImage(UIImage(named: "check"), for: .normal)
            cell.defaultBtn.isHidden = false
            cell.deleteBtn.isHidden = false
            kCardId = viewModal.id ?? ""
        }
        if checkBtnStatus == true  {
            if self.selectedIndex == indexPath.row{
                cell.checkBtn.isSelected  = true
                cell.checkBtn.setImage(UIImage(named: "check"), for: .normal)
            }else{
                cell.checkBtn.isSelected  = false
                cell.checkBtn.setImage(UIImage(named: "uncheck"), for: .normal)
            }
        }
        cell.configure(indexPath: indexPath)
        cell.callBackDropDown = {index in
            self.showAlertWithActionOkandCancel(Title: "Delete", Message: "Are you sure you want to delete?", OkButtonTitle: "Yes", CancelButtonTitle: "No") {
                let card_id = self.cardData[index.row].id ?? ""
                kCardId = card_id
                let param = ["card_id":card_id]
                Indicator.shared.showProgressView(self.view)
                self.conn.startConnectionWithPostType(getUrlString: "delete_card", params: param,authRequired: true) { (Value) in
                    Indicator.shared.hideProgressView()
                    if self.conn.responseCode == 1{
                        let msg = (Value["message"] as? String ?? "")
                        if (Value["status"] as? Int ?? 0) == 1{
                            print(Value)
                            self.showToast(message: "\(msg)")
                            self.savedCardApi()
                            self.payment_tableView.reloadData()
                        }else{
                            self.showAlert("GetDuma", message: msg)
                        }
                    }
                }
            }
        }
        cell.callCheckBox = { index in
            let card_id = self.cardData[index.row].id ?? ""
            kCardId = card_id
            self.checkBtnStatus = true
            self.selectedIndex = indexPath.row
            self.setdefaultCardApi(card_id: card_id, is_default: "1")
        }
        return cell
    }
    
    @objc func checkBoxBtn(_ sender: UIButton) {
        print(kCardId)
        let viewModal = self.cardData[sender.tag]
        
        print("Select")
        
        //        else{
        //            checkBtnStatus = false
        //            self.selectedIndex = sender.tag
        //            setdefaultCardApi(card_id: viewModal?.id ?? "", is_default: "2")
        //            print("UNSelect")
        //        }
    }
}
