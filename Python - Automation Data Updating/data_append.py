import imaplib
import email
import os
import pandas as pd
import time
from datetime import datetime
from io import BytesIO
import glob


# ========== Email (Gmail) and Folder Settings ==========
EMAIL_ACCOUNT = "example@gmail.com"
EMAIL_PASSWORD = "abcd"  # App Password

IMAP_SERVER = "imap.gmail.com"
IMAP_PORT = 993
FOLDER = "INBOX"

# ========== Subject-to-File Mapping ==========
# Note: For CSV attachments we use append_to_csv().
# For XLSX attachments we use update_xlsx functions (selected by subject prefix).
SUBJECT_FILE_MAPPING = {
    "AAA - Sales Up to Date": "sales from 1st DEC.csv",
    "AAA - Store Order": "store order.csv",
    "AAA - WH qty on hand": "LW Qty On Hand.xlsx",
    "AAA - All products": "All products.xlsx"
}

# ========== Email Connection ==========
def connect_mailbox():
    try:
        print(f"Connecting to {IMAP_SERVER}:{IMAP_PORT}...")
        mail = imaplib.IMAP4_SSL(IMAP_SERVER, IMAP_PORT)
        mail.login(EMAIL_ACCOUNT, EMAIL_PASSWORD)
        mail.select(FOLDER)
        return mail
    except imaplib.IMAP4.error as e:
        print(f"IMAP login failed: {e}")
        return None
    except Exception as e:
        print(f"Other error: {e}")
        return None

# ========== Main Email Attachments Processor ==========
def fetch_email_attachments():
    mail = connect_mailbox()
    if not mail:
        print("Failed to connect to the mail server.")
        return

    status, email_ids = mail.search(None, 'UNSEEN')
    if status != "OK":
        print("No new emails found.")
        return

    email_ids = email_ids[0].split()
    successful_processes = 0
    failed_files = []

    for e_id in email_ids:
        status, msg_data = mail.fetch(e_id, "(RFC822)")
        if status != "OK":
            continue

        raw_email = msg_data[0][1]
        msg = email.message_from_bytes(raw_email)
        subject = msg["Subject"]
        if not subject:
            continue

        # Determine if this email subject matches any of our defined prefixes.
        matching_file = None
        for prefix, file_name in SUBJECT_FILE_MAPPING.items():
            if subject.lower().startswith(prefix.lower()):
                matching_file = file_name
                break

        if matching_file:
            print(f"Processing email: {subject} → Target file: {matching_file}")
            attachment_found = False  

            for part in msg.walk():
                if part.get_content_maintype() == "multipart":
                    continue

                if part.get("Content-Disposition") is not None:
                    filename = part.get_filename()
                    if not filename:
                        print(f"Attachment in {subject} has no filename, skipping.")
                        continue  

                    # Process based on file type:
                    if filename.lower().endswith(".csv"):
                        attachment_found = True
                        file_data = part.get_payload(decode=True)
                        success = append_to_csv(file_data, matching_file)
                        if success:
                            successful_processes += 1
                        else:
                            failed_files.append(filename)
                    elif filename.lower().endswith(".xlsx"):
                        attachment_found = True
                        file_data = part.get_payload(decode=True)
                        # Decide which XLSX update function to call based on subject:
                        if subject.lower().startswith("aaa - wh qty on hand"):
                            success = update_on_hand_xlsx(file_data, matching_file)
                        elif subject.lower().startswith("aaa - all products"):
                            success = update_all_products_xlsx(file_data, matching_file)
                        else:
                            print(f"Unhandled XLSX attachment for subject: {subject}")
                            success = False
                        if success:
                            successful_processes += 1
                        else:
                            failed_files.append(filename)

            if not attachment_found:
                print(f"No .csv or .xlsx attachment found in: {subject}")
        else:
            print(f"Skipping email: {subject}")

    mail.logout()
    print(f"Summary: {successful_processes} successful processes.")
    if failed_files:
        print("Failed files:", ", ".join(failed_files))

# ========== CSV Appending Function ==========
def append_to_csv(file_data, file_name):
    try:
        print(f"Reading new data from CSV attachment for {file_name}...")
        new_data = pd.read_csv(BytesIO(file_data), encoding='utf-8', dtype=str)
        print(f"New data shape: {new_data.shape}")
        new_data = new_data.iloc[:-1]
        print(f"New data shape after removing last row: {new_data.shape}")
        if new_data.empty:
            print(f"All rows were removed from {file_name}. Skipping appending.")
            return False

        if os.path.exists(file_name):
            print(f"Reading existing CSV file: {file_name}")
            existing_data = pd.read_csv(file_name, encoding='utf-8', dtype=str)
            print(f"Existing data shape: {existing_data.shape}")
            combined_data = pd.concat([existing_data, new_data], ignore_index=True)
            print(f"Combined data shape: {combined_data.shape}")
        else:
            print(f"Creating new CSV file: {file_name}")
            combined_data = new_data

        combined_data.to_csv(file_name, index=False, encoding='utf-8')
        now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"{now} - Data appended successfully to {file_name}.")
        return True
    except PermissionError:
        print(f"Cannot write to {file_name}: File is open in another program. Close it and retry.")
        return False
    except Exception as e:
        print(f"Error processing CSV file {file_name}: {e}")
        return False

# ========== XLSX Update for LW Qty On Hand ==========
def update_on_hand_xlsx(file_data, file_name):
    try:
        print(f"Updating product on hand from XLSX attachment for {file_name}...")
        # Read new data from attachment
        new_data = pd.read_excel(BytesIO(file_data), dtype=str)
        new_data.fillna('', inplace=True)
        # If the target file exists, read its header (columns)
        if os.path.exists(file_name):
            print(f"Reading existing on-hand file: {file_name}")
            existing_data = pd.read_excel(file_name, dtype=str)
            existing_data.fillna('', inplace=True)
            header = list(existing_data.columns)
            # Ensure the new data has the same header (if not, force it)
            new_data = new_data.reindex(columns=header, fill_value='')
        else:
            print(f"Creating new on-hand file: {file_name}")
        # Write the new data overwriting any existing data (thus preserving header from existing file if applicable)
        new_data.to_excel(file_name, index=False)
        print(f"Product on hand updated successfully in {file_name}.")
        return True
    except PermissionError:
        print(f"Cannot write to {file_name}: File is open in another program. Close it and retry.")
        return False
    except Exception as e:
        print(f"Error updating on-hand file {file_name}: {e}")
        return False

# ========== XLSX Update for All Products ==========
def update_all_products_xlsx(file_data, file_name):
    try:
        print(f"Updating All Products from XLSX attachment for {file_name}...")
        # Read new products data from attachment
        new_df = pd.read_excel(BytesIO(file_data), dtype=str)
        new_df.fillna('', inplace=True)
        # If the All Products file exists, read it; otherwise, create a new one with the new data.
        if os.path.exists(file_name):
            existing_df = pd.read_excel(file_name, dtype=str)
            existing_df.fillna('', inplace=True)
            # For each product in the new file:
            for idx, new_row in new_df.iterrows():
                prod_name = new_row.get("Product Name", "").strip()
                if not prod_name:
                    continue
                # Find rows in existing_df that match on "Product Name"
                match = existing_df["Product Name"].str.strip() == prod_name
                if not match.any():
                    # New product: append it
                    existing_df = existing_df.append(new_row, ignore_index=True)
                    print(f"Appended new product: {prod_name}")
                else:
                    # Product exists: update if necessary.
                    i = existing_df.index[match][0]
                    # For each field that we care about update: "Product Name", "Category", "Tags", "Details"
                    for col in ["Product Name", "Category", "Tags", "Details"]:
                        # If existing cell is blank and new cell is not, then update.
                        existing_val = existing_df.at[i, col] if col in existing_df.columns else ''
                        new_val = new_row.get(col, '')
                        if existing_val.strip() == '' and new_val.strip() != '':
                            existing_df.at[i, col] = new_val
                            print(f"Updated {col} for product: {prod_name}")
                        # Optionally: if product name is not exactly the same, update it.
                        elif col == "Product Name" and existing_val.strip() != new_val.strip():
                            existing_df.at[i, col] = new_val
                            print(f"Corrected product name for: {prod_name}")

            # Write the updated dataframe back to file.
            existing_df.to_excel(file_name, index=False)
            print(f"All Products file updated successfully.")
        else:
            # File doesn't exist; just create one.
            new_df.to_excel(file_name, index=False)
            print(f"All Products file created successfully.")
        return True
    except PermissionError:
        print(f"Cannot write to {file_name}: File is open in another program. Close it and retry.")
        return False
    except Exception as e:
        print(f"Error updating All Products file {file_name}: {e}")
        return False

# ========== Main Loop ==========
if __name__ == "__main__":
    while True:
        print("\nChecking for new emails...")
        fetch_email_attachments()
        
        next_run_time = datetime.now() + pd.Timedelta(hours=0.25)
        print(f"Next run scheduled at: {next_run_time.strftime('%Y-%m-%d %H:%M:%S')}")
        
        print("Waiting for next run...\n")
        time.sleep(900)
