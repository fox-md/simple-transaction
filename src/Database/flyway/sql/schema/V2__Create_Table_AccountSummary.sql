IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountSummary]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AccountSummary](
	[AccountNumber] [int] NOT NULL,
	[Balance] [decimal](19,2) NOT NULL,
	[Currency] [varchar](3) NOT NULL
	CONSTRAINT [PK_AccountSummary] PRIMARY KEY CLUSTERED([AccountNumber])
 );
END
GO