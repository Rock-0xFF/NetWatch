import pyodbc
import subprocess
from datetime import datetime

# Database connection function

def get_connection():
    return pyodbc.connect(
        'DRIVER={ODBC Driver 17 for SQL Server};'
        'SERVER=;'
        'DATABASE=NetworkDB;'
        'UID=sa;'
        'PWD=123;'
        'Encrypt=yes;'
        'TrustServerCertificate=yes;'
    )

# Ping a single device

def ping_device(ip_address):
    result = subprocess.run(
        ["ping", "-n", "1", "-w", "1000", ip_address],
        capture_output=True
    )
    return "Online" if result.returncode == 0 else "Offline"

# Main function: scan all devices and update results

def scan_all_devices():
    conn = get_connection()
    cursor = conn.cursor()

    # 1) Get all registered devices from the database
    cursor.execute("SELECT DeviceID, DeviceName, IPAddress FROM Devices")
    devices = cursor.fetchall()

    print(f"Scanning {len(devices)} devices...")

    for device in devices:
        device_id = device.DeviceID
        ip = device.IPAddress

        # 2) Ping the device
        status = ping_device(ip)

        # 3) Update Devices table (current status)
        cursor.execute("""
            UPDATE Devices 
            SET Status = ?, LastSeen = ? 
            WHERE DeviceID = ?
        """, status, datetime.now(), device_id)

        # 4) Insert into ScanLogs table (historical record)
        cursor.execute("""
            INSERT INTO ScanLogs (DeviceID, ScanTime, Status)
            VALUES (?, ?, ?)
        """, device_id, datetime.now(), status)

        print(f"   {ip} -> {status}")

    # 5) Save all changes at once
    conn.commit()
    conn.close()
    print("✅ Scan finished")

# run script 
if __name__ == "__main__":
    scan_all_devices()