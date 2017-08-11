--  Select database
USE OnCallSystem;
GO

-- Add action  list for the audit log
INSERT INTO ocs.Actions (ACTION)
VALUES ('Logged In'),
('Created User'),
('Deactivated User'),
('Activated User'),
('Completed Consultation Request'),
('Added Location'),
('Activated Location'),
('Deactivated Location'),
('Added Priority'),
('Activated Priority'),
('Deactivated Priority'),
('Consultation Requested')

INSERT INTO ocs.Location (Ward)
VALUES ('GP Practice'),
('Emergency'),
('Maternity'),
('Medical Assessment Unit')

INSERT INTO ocs.Priority (Preeminence)
VALUES ('Immediate'),
('Urgent'),
('Normal'),
('Low')