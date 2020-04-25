IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountTransaction]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AccountTransaction](
	[TransactionId] [int] IDENTITY(1,1) NOT NULL,
	[AccountNumber] [int] NOT NULL,
	[Date] DATETIME CONSTRAINT [DF_AccountTransaction_Date] DEFAULT (getutcdate()) NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[TransactionType] [varchar](10) NOT NULL,
	[Amount] [decimal](19,2) NOT NULL
	CONSTRAINT [PK_AccountTransaction] PRIMARY KEY CLUSTERED ([TransactionId] ASC),
	CONSTRAINT [FK_AccountTransaction_AccountNumber] FOREIGN KEY ([AccountNumber]) REFERENCES [dbo].[AccountSummary] ([AccountNumber]) 
 );
END
GO