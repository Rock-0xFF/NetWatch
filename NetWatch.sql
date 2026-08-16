-- Create DB
CREATE DATABASE NetworkDB;
GO

USE NetworkDB;
GO

--  Device info
CREATE TABLE Devices (
    DeviceID INT PRIMARY KEY IDENTITY(1,1),
    DeviceName VARCHAR(100) NOT NULL,
    IPAddress VARCHAR(15) NOT NULL UNIQUE,
    MACAddress VARCHAR(17) NULL,
    DeviceType VARCHAR(50) NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Unknown',
    LastSeen DATETIME NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE() -- to write date by default
);



CREATE TABLE ScanLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    DeviceID INT NOT NULL,
    ScanTime DATETIME NOT NULL DEFAULT GETDATE(),
    ResponseTime INT NULL,
    Status VARCHAR(20) NOT NULL,
    CONSTRAINT FK_ScanLogs_Devices FOREIGN KEY (DeviceID) 
        REFERENCES Devices(DeviceID)
);



INSERT INTO Devices (DeviceName, IPAddress, DeviceType)
VALUES 
     
    ('Main Router', '192.168.5.1', 'Router'),
    ('My PC', '192.168.5.10', 'PC');





BACKUP DATABASE NetworkDB 
TO DISK = 'C:\Backup\NetworkDB_Full.bak'
WITH INIT, 
     NAME = 'NetworkDB-Full Backup';


BACKUP DATABASE NetworkDB 
TO DISK = 'C:\Backup\NetworkDB_Diff.bak'
WITH DIFFERENTIAL, 
     NOINIT,
     NAME = 'NetworkDB-Differential Backup';

SELECT * FROM Devices;