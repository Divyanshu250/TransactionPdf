//
//  TransactionListTableViewCell.swift
//  PDFReport
//
//  Created by Divyanshu Jadon on 02/08/25.
//

import UIKit

class TransactionListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var transactionTypeImageView: UIImageView!
    @IBOutlet weak var transactionTypeLabel: UILabel!
    @IBOutlet weak var transactionAmountLabel: UILabel!
    @IBOutlet weak var transactionDateLabel: UILabel!
    @IBOutlet weak var transactionNameLabel: UILabel!
    @IBOutlet weak var transactionStatusImageView: UIImageView!
    @IBOutlet weak var transactionIdLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialSetUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initialSetUp(){
        colorSetUp()
        fontSetUp()
        viewSetUp()
    }
        
    func colorSetUp(){
        transactionTypeLabel.textColor = Colors.blackColor.color
        transactionAmountLabel.textColor = Colors.blackColor.color
        transactionDateLabel.textColor = Colors.blackColor.color
        transactionNameLabel.textColor = Colors.blackColor.color
        transactionIdLabel.textColor = Colors.blackColor.color
    }
    
    func fontSetUp(){
        transactionTypeLabel.font = UIFont.customFont(family: .monaSansRegular, size: .size14)
        transactionAmountLabel.font = UIFont.customFont(family: .monaSansSemiBold, size: .size18)
        transactionDateLabel.font = UIFont.customFont(family: .monaSansRegular, size: .size14)
        transactionNameLabel.font = UIFont.customFont(family: .monaSansSemiBold, size: .size18)
        transactionIdLabel.font = UIFont.customFont(family: .monaSansRegular, size: .size14)
    }
    
    func viewSetUp(){
        bottomView.backgroundColor = Colors.greyColor.color
    }
    
    func configureCell(data: TransactionModel?){
        if let type = data?.transactionType {
            transactionTypeLabel.text = (type == "DEBIT") ? HistoryScreenText.paidTo : HistoryScreenText.receivedFrom
            transactionTypeImageView.image = (type == "DEBIT") ? UIImage(systemName: "arrowshape.right.circle.fill") : UIImage(systemName: "arrowshape.left.circle.fill")
        }
        if let status = data?.status{
            transactionStatusImageView.image = (status == "PENDING") ? TransactionImage.paymentPending : TransactionImage.paymentComplete
        }
        transactionNameLabel.text = data?.transactionCategory
        transactionDateLabel.text = data?.formattedDate
        transactionIdLabel.text = "ID: \(data?.transactionID ?? "")"
        transactionAmountLabel.text = "$ \(data?.amount ?? "")"
    }
    
}
