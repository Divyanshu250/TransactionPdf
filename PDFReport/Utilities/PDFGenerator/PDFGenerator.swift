//
//  PDFGenerator.swift
//  PDFReport
//
//  Created by Divyanshu Jadon on 02/08/25.
//

import UIKit
import PDFKit
import CoreGraphics

class PDFGenerator {
    
    static func generate(transactions: [TransactionModel], completion: @escaping (URL?) -> Void) {
        let pdfMetaData = [
            kCGPDFContextCreator: "PDFReport",
            kCGPDFContextAuthor: "OmniCard"
        ]
        
        let pageWidth: CGFloat = 595.2
        let pageHeight: CGFloat = 841.8
        let margin: CGFloat = 20
        let columnWidths: [CGFloat] = [90, 100, 130, 80, 70, 70]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)
        
        let logoImage = TransactionImage.omniLogo
        
        let rowHeight: CGFloat = 25
        let headerHeight: CGFloat = 25
        
        var currentY: CGFloat = margin
        var pageIndex = 0
        
        let data = renderer.pdfData { ctx in
            ctx.beginPage()
            
            // Static content on first page
            drawLogo(logoImage, pageWidth: pageWidth, margin: margin)
            
            // Draw static user info
            let userInfo = """
            Name : Divyanshu Jadon
            Email : jadondivyanshu765@gmail.com
            Mobile Number : 7982563560
            Card Number : **** **** **** 6217
            Card Type : PERSONAL
            Address : Delhi
            """
            userInfo.draw(in: CGRect(x: margin, y: currentY, width: pageWidth - 2 * margin, height: 150),
                          withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
            currentY += 110
            
            // Draw title
            let title = "Transaction Report : 01-Jan-2025 to 01-Apr-2025"
            title.draw(in: CGRect(x: margin, y: currentY, width: pageWidth - 2 * margin, height: 30),
                       withAttributes: [.font: UIFont.boldSystemFont(ofSize: 13)])
            currentY += 30
            
            // Draw table header
            drawTableRow(["Date", "Narration", "Transaction ID", "Status", "Credit", "Debit"],
                         atY: currentY,
                         columnWidths: columnWidths,
                         isHeader: true)
            currentY += headerHeight
            
            for tx in transactions {
                // Check if next row fits
                if currentY + rowHeight > pageHeight - 60 {
                    // Draw footer before page ends
                    let footer = "Page \(pageIndex + 1)"
                    let footerSize = (footer as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
                    let footerX = (pageWidth - footerSize.width) / 2
                    footer.draw(at: CGPoint(x: footerX, y: pageHeight - 40),
                                withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
                    
                    // Start new page
                    ctx.beginPage()
                    pageIndex += 1
                    currentY = margin
                    
                    // Draw table header again
                    drawTableRow(["Date", "Narration", "Transaction ID", "Status", "Credit", "Debit"],
                                 atY: currentY,
                                 columnWidths: columnWidths,
                                 isHeader: true)
                    currentY += headerHeight
                }
                
                let date = formatDate(tx.transactionDate ?? "")
                let narration = tx.transactionCategory ?? ""
                let txId = tx.transactionID ?? ""
                let status = tx.status ?? ""
                let credit = (tx.transactionType?.uppercased() == "CREDIT") ? (tx.amount ?? "") : ""
                let debit = (tx.transactionType?.uppercased() == "DEBIT") ? (tx.amount ?? "") : ""
                let row = [date, narration, txId, status, credit, debit]
                
                let height = drawTableRow(row, atY: currentY, columnWidths: columnWidths)
                currentY += height
            }
            
            // Final footer
            let footer = "Page \(pageIndex + 1)"
            let footerSize = (footer as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
            let footerX = (pageWidth - footerSize.width) / 2
            footer.draw(at: CGPoint(x: footerX, y: pageHeight - 40),
                        withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
        }
        
        let fileName = "Transaction_Report_\(Int(Date().timeIntervalSince1970)).pdf"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            completion(fileURL)
        } catch {
            print("❌ PDF generation failed: \(error)")
            completion(nil)
        }
    }
    
    @discardableResult
    private static func drawTableRow(_ texts: [String], atY y: CGFloat, columnWidths: [CGFloat], isHeader: Bool = false)-> CGFloat {
        var x: CGFloat = 20
        let font = isHeader ? UIFont.boldSystemFont(ofSize: 10) : UIFont.systemFont(ofSize: 10)
        let textColor = isHeader ? UIColor.white : UIColor.black
        let backgroundColor = isHeader ? UIColor.darkGray : UIColor.clear

        // Paragraph Style (centered)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineBreakMode = .byWordWrapping

        // Calculate the max height for the row
        var maxHeight: CGFloat = 0
        for (i, text) in texts.enumerated() {
            let columnWidth = columnWidths[i]
            let boundingRect = NSString(string: text).boundingRect(
                with: CGSize(width: columnWidth - 8, height: CGFloat.greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [
                    .font: font,
                    .paragraphStyle: paragraph
                ],
                context: nil
            )
            maxHeight = max(maxHeight, ceil(boundingRect.height + 10)) // top+bottom padding
        }

        // Draw each column
        x = 20
        for (i, text) in texts.enumerated() {
            let columnWidth = columnWidths[i]
            let rect = CGRect(x: x, y: y, width: columnWidth, height: maxHeight)
            let path = UIBezierPath(rect: rect)
            UIColor.black.setStroke()
            path.lineWidth = 0.5
            path.stroke()

            if isHeader {
                backgroundColor.setFill()
                path.fill()
            }

            let textRect = rect.insetBy(dx: 4, dy: 5)
            NSString(string: text).draw(in: textRect, withAttributes: [
                .font: font,
                .foregroundColor: textColor,
                .paragraphStyle: paragraph
            ])

            x += columnWidth
        }
        return maxHeight
    }


    private static func drawLogo(_ image: UIImage?, pageWidth: CGFloat, margin: CGFloat) {
        guard let image = image else { return }

        let logoWidth: CGFloat = 80
        let logoHeight: CGFloat = 30
        let x = pageWidth - logoWidth - margin
        let y: CGFloat = margin
        let rect = CGRect(x: x, y: y, width: logoWidth, height: logoHeight)
        image.draw(in: rect)
    }

    private static func formatDate(_ raw: String) -> String {
        guard let date = DateFormatters.iso8601WithMillis.date(from: raw) else {
            return raw
        }
        return DateFormatters.displayFormatter.string(from: date)
    }
}

extension PDFGenerator {
    static func encryptPDF(at sourceURL: URL, withPassword password: String) -> URL? {
        guard let sourceData = try? Data(contentsOf: sourceURL),
              let provider = CGDataProvider(data: sourceData as CFData),
              let document = CGPDFDocument(provider)
        else {
            print("❌ Failed to load PDF for encryption")
            return nil
        }

        let encryptedURL = FileManager.default.temporaryDirectory.appendingPathComponent("Encrypted_Report.pdf")
        guard let consumer = CGDataConsumer(url: encryptedURL as CFURL) else { return nil }

        let options: [CFString: Any] = [
            kCGPDFContextUserPassword: password,
            kCGPDFContextOwnerPassword: password,
            kCGPDFContextAllowsCopying: false,
            kCGPDFContextAllowsPrinting: true
        ]

        guard let context = CGContext(consumer: consumer, mediaBox: nil, options as CFDictionary) else {
            print("❌ Encryption context creation failed")
            return nil
        }

        for i in 1...document.numberOfPages {
            if let page = document.page(at: i) {
                var mediaBox = page.getBoxRect(.mediaBox)
                context.beginPage(mediaBox: &mediaBox)
                context.drawPDFPage(page)
                context.endPage()
            }
        }

        context.closePDF()
        return encryptedURL
    }
}

