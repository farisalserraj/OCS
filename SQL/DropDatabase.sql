USE master;

--  Set database to single user mode to delete in development environment only.
--  Only use this in live if you need to close connections to make changes
--  to the database that could impact connected users. Then ensure that you 
--  put the database back into MULTI_USER mode when completed.
IF DB_ID(N'OnCallSystem') IS NOT NULL ALTER DATABASE OnCallSystem SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO

--  IF DB_ID(N'OTMS') IS NOT NULL ALTER DATABASE OTMS set MULTI_USER
--  GO

--  Drop database (Do not use in live environment)
IF DB_ID(N'OnCallSystem') IS NOT NULL DROP DATABASE OnCallSystem;
GO