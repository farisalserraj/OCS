USE master;
GO

--  Create database
CREATE DATABASE OnCallSystem;
GO

--  Select database
USE OnCallSystem;
GO

-- Create schema
IF OBJECT_ID(N'ocs') IS NOT NULL DROP SCHEMA ocs;
GO
CREATE SCHEMA ocs AUTHORIZATION dbo;
GO

--  Create tables
CREATE TABLE ocs.Actions
(
  Id INT NOT NULL IDENTITY(1,1)
    CONSTRAINT P_Actions_Id PRIMARY KEY,
  Action VARCHAR(50) NOT NULL
    CONSTRAINT U_Actions_Name UNIQUE,
);
CREATE NONCLUSTERED INDEX IDX_Actions
    ON ocs.Actions (Id ASC)
    INCLUDE (Action);
GO

CREATE TABLE ocs.Users
(
  Id INT NOT NULL IDENTITY(1,1)
    CONSTRAINT P_Users_Id PRIMARY KEY,
  Title VARCHAR(8) NOT NULL
    CONSTRAINT U_Users_Title UNIQUE,
  Forename VARCHAR(15) NOT NULL,
  Surname VARCHAR(20) NOT NULL,
  Email VARCHAR(75) NOT NULL
    CONSTRAINT U_Users_Email UNIQUE,
  Active BIT NOT NULL
    CONSTRAINT D_Users_Active DEFAULT(1)
);
CREATE NONCLUSTERED INDEX IDX_Users
  ON ocs.Users (Id ASC)
    INCLUDE (Surname,Forename,Email,Active);
GO

CREATE TABLE ocs.UserLogin
(
  Id INT NOT NULL IDENTITY(1,1)
    CONSTRAINT P_UserLogin_Id PRIMARY KEY,
  UsersId INT NOT NULL
    CONSTRAINT F_UserLogin_UsersId REFERENCES ocs.Users(Id),
  Username VARCHAR(40) NOT NULL
    CONSTRAINT U_UserLogin_Username UNIQUE,
  PasswordHash VARCHAR(80) NOT NULL,
  Salt VARCHAR(30) NOT NULL,
  ResetPasswordHash VARCHAR(80) NULL,
  RememberPassword BIT NOT NULL
);
CREATE NONCLUSTERED INDEX IDX_UserLogin
  ON ocs.UserLogin (Id ASC)
    INCLUDE (UsersId,Username,RememberPassword);
GO

CREATE TABLE ocs.Location
(
  Id INT NOT NULL IDENTITY(1,1)
    CONSTRAINT P_Location_Id PRIMARY KEY,
  Ward VARCHAR(25) NOT NULL
    CONSTRAINT U_Location_Ward UNIQUE,
  Active BIT NOT NULL 
    CONSTRAINT D_Location_Active DEFAULT(1),
);
CREATE NONCLUSTERED INDEX IDX_Location
  ON ocs.Location (Id ASC)
    INCLUDE (Ward,Active);
GO

CREATE TABLE ocs.Priority
(
  Id INT NOT NULL IDENTITY(1,1)
    CONSTRAINT P_Priority_Id PRIMARY KEY,
  Preeminence VARCHAR (15) NOT NULL
    CONSTRAINT U_Priority_Preeminence UNIQUE,
  Active BIT NOT NULL
    CONSTRAINT D_Priority_Active DEFAULT(1)
);
CREATE NONCLUSTERED INDEX IDX_Priority
  ON ocs.Priority (Id ASC)
    INCLUDE (Preeminence,Active);
GO

CREATE TABLE ocs.ConsultationRequest
(
  Id INT NOT NULL IDENTITY(1,1)
    CONSTRAINT P_ConsultationRequest_Id PRIMARY KEY,
  PatientNameHash VARCHAR(80) NOT NULL,
  LocationId INT NOT NULL
    CONSTRAINT F_ConsultationRequest_LocationId REFERENCES ocs.Location(Id),
  PriorityId INT NOT NULL 
    CONSTRAINT F_ConsultationRequest_PriorityId REFERENCES ocs.Priority(Id),
  PatientDOBHash VARCHAR(80) NOT NULL,
  RequestersName VARCHAR(80) NOT NULL,
  RequestersNumber VARCHAR(11) NOT NULL,
);
CREATE NONCLUSTERED INDEX IDX_ConsultationRequest
  ON ocs.ConsultationRequest (Id ASC)
    INCLUDE (LocationId,PriorityId,RequestersName);
GO

CREATE TABLE ocs.AuditLog
(
  Id INT NOT NULL IDENTITY(1,1)
    CONSTRAINT P_AuditLog_Id PRIMARY KEY,
  ActionsId INT NOT NULL
    CONSTRAINT F_AuditLog_ActionsId REFERENCES ocs.Actions(Id),
  UserLoginId INT NOT NULL
    CONSTRAINT F_AuditLog_UserLoginId REFERENCES ocs.UserLogin(Id),
  AuditTime DATETIME2 NOT NULL
    CONSTRAINT D_AuditLog_AuditTime DEFAULT(GETDATE()),
  ComputerName VARCHAR(40) NOT NULL,
  ComputerUsername VARCHAR(50) NOT NULL,
  ComputerIP VARCHAR (15) NOT NULL,
  ConsultationRequestId INT NULL
    CONSTRAINT F_AuditLog_ConsultationRequestId REFERENCES ocs.ConsultationRequest(Id),
  UsersId INT NULL 
    CONSTRAINT F_AuditLog_UsersId REFERENCES ocs.Users(Id),
  PriorityId INT NULL
    CONSTRAINT F_AuditLog_PriorityId REFERENCES ocs.Priority(Id)
);
CREATE NONCLUSTERED INDEX IDX_AuditLog
  ON ocs.AuditLog (Id ASC)
  INCLUDE(ActionsId,UserLoginId,AuditTime,ComputerUsername,ComputerName,ComputerIp);
GO