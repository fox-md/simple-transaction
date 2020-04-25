IF NOT EXISTS (SELECT * FROM dbo.AccountSummary WHERE AccountNumber = 3628101)
BEGIN
    Insert Into dbo.AccountSummary(AccountNumber, Balance, Currency) 
	Values(3628101, 25000, 'EUR')
END
GO

IF NOT EXISTS (SELECT * FROM dbo.AccountSummary WHERE AccountNumber = 3637897)
BEGIN
    Insert Into dbo.AccountSummary(AccountNumber, Balance, Currency) 
	Values(3637897, 1500, 'EUR')
END
GO

IF NOT EXISTS (SELECT * FROM dbo.AccountSummary WHERE AccountNumber = 3648755)
BEGIN
    Insert Into dbo.AccountSummary(AccountNumber, Balance, Currency) 
	Values(3648755, 17600, 'EUR')
END
GO