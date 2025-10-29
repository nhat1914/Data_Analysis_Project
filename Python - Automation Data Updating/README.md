# Automated Email Data Append System

This project automates the process of **retrieving, updating, and appending business data** from email attachments directly into structured CSV and Excel files.  
It is designed to run continuously, checking for new Gmail attachments every 15 minutes, and updating key operational datasets such as **Sales**, **Orders**, **On Hand Stock**, and **Product Master** files.

## Project Overview

### Objective
To eliminate manual downloads and file merges by creating an **automated pipeline** that:
- Connects securely to Gmail via IMAP.
- Detects and downloads new attachments from predefined subjects.
- Appends or updates local datasets automatically.
- Maintains synchronization between store sales, on-hand quantities, and product master data.

### Key Features
- Continuous 15-minute polling loop using Python’s `time.sleep()`.
- Automatic email parsing and attachment handling (`imaplib`, `email`).
- Smart CSV appending — preserves all previous data.
- Intelligent Excel updates — replaces or merges based on file type.
- Product-level update logic for new or existing SKUs.
- Detailed console logging and optional skipped file tracking.

## Data Sources & Email Mapping

| File Name | Description | Source Email Subject | Required Columns / Structure |
|------------|--------------|----------------------|------------------------------|
| **`sales from 1st DEC.csv`** | Consolidated sales data received from stores. Updated automatically via Gmail attachment with the subject **“AAA - Sales Up to Date”**. | `AAA - Sales Up to Date` | `product_id`, `product name`, `case_quantity`, `quantity sold`, `timestamp` |
| **`store order.csv`** | Store-level order data received from outlet managers. | `AAA - Store Order` | `product_id`, `product name`, `quantity ordered`, `timestamp`, `store_name` *(optional)* |
| **`LW Qty On Hand.xlsx`** | Warehouse and store on-hand stock quantities. Replaces existing file with the latest upload. | `AAA - WH qty on hand` | `Product Name`, `Product ID`, `Outlet`, `Case Quantity`, `On Hand`, `Last Updated` |
| **`All products.xlsx`** | Product master list including names, categories, and tags. Automatically appended or updated. | `AAA - All products` | `Product Name`, `Category`, `Tags`, `Details` |
| **`skipped_files_log.txt`** | Log file for any attachments skipped due to missing headers or file lock. | — | `filename`, `reason`, `timestamp` |

> The script depends on **correct subject prefixes** and **consistent column headers** for all attachments.  
> CSVs are **appended**, while Excel files (`.xlsx`) are either **updated** or **replaced** depending on the subject.  
> Each attachment must include at least the **Required Columns** listed above for the automation to complete successfully.

## Functional Workflow

1. **Connect to Gmail**
   - Uses IMAP protocol to access the `INBOX` folder.
   - Authenticates using Gmail App Password (not standard password).

2. **Search for New Emails**
   - Looks for all **unread emails (`UNSEEN`)**.
   - Filters subjects that match the predefined mapping dictionary.

3. **Attachment Handling**
   - `.csv` files → passed to `append_to_csv()`.
   - `.xlsx` files → passed to `update_on_hand_xlsx()` or `update_all_products_xlsx()` depending on subject prefix.

4. **Data Integration**
   - New CSV rows are appended below existing data.
   - New Excel sheets overwrite or merge with consistent headers.
   - Products are updated or added based on `"Product Name"` matching.

5. **Continuous Execution**
   - After processing, the script sleeps for **900 seconds (15 minutes)**.
   - Displays the next scheduled run time.

## Tech Stack

| Category | Tools / Libraries |
|-----------|------------------|
| **Language** | Python |
| **Email Handling** | `imaplib`, `email` |
| **Data Processing** | `pandas`, `openpyxl` |
| **Utilities** | `time`, `datetime`, `os`, `glob`, `io.BytesIO` |
| **Environment** | Any Python environment with Gmail IMAP access enabled |

## Requirements

| Library | Version | Purpose |
|----------|----------|----------|
| **pandas** | >= 2.0.0 | Data reading, appending, and cleaning |
| **openpyxl** | >= 3.1.2 | Excel file writing and updating |
| **imaplib** | (built-in) | IMAP protocol for Gmail access |
| **email** | (built-in) | Parsing and decoding email MIME structure |
| **time / datetime** | (built-in) | Scheduling and timestamping |
| **glob / io** | (built-in) | File search and byte stream handling |

## Subject–File Mapping Logic

| Email Subject Prefix | Target File | Action Type |
|----------------------|-------------|--------------|
| `AAA - Sales Up to Date` | `sales from 1st DEC.csv` | Append |
| `AAA - Store Order` | `store order.csv` | Append |
| `AAA - WH qty on hand` | `LW Qty On Hand.xlsx` | Replace existing with new data |
| `AAA - All products` | `All products.xlsx` | Update or add new products |

## 🧾 Example Console Output

```
Connecting to imap.gmail.com:993...
Checking for new emails...
Processing email: AAA - Sales Up to Date → Target file: sales from 1st DEC.csv
Reading new data from CSV attachment for sales from 1st DEC.csv...
Existing data shape: (10234, 5)
Combined data shape: (10456, 5)
2025-10-29 14:35:21 - Data appended successfully to sales from 1st DEC.csv.
Next run scheduled at: 2025-10-29 14:50:21
Waiting for next run...
```

## Notes & Recommendations

- Do not keep target CSV or Excel files open during script execution — it will cause **PermissionError**.  
- Always maintain consistent **column headers** across datasets.  
- Ensure Gmail IMAP is enabled under *Settings → Forwarding and POP/IMAP → Enable IMAP*.
- The script can be run 24/7 on a background server or Raspberry Pi.

## Author

**Author:** [Frank Dinh]  
**Email:** [dinh.qnhat@gmail.com]  
**Affiliation:** Individual Automation Project  
**Year:** 2025  

> © 2025 All Rights Reserved. Unauthorized reuse or redistribution of this code is prohibited.
