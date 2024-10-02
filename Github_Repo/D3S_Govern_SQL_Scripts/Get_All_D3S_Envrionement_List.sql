WITH CompanyLogin (LastUserLoginTime, CompanyID)
AS
(
SELECT MAX(LastLoggedInOn) AS LastUserLoginTime, CompanyID
FROM dbo.CompanyResource
GROUP BY CompanyID
)
SELECT
cl.name as Client,
-- c.status as Status,
concat('https://',cds.urlPrefix,'.data3sixty.com') as URL,
case
when c.environmentLevel = 0 then 'preview'
when c.environmentLevel = 1 then 'dev'
when c.environmentLevel = 2 then 'uat'
when c.environmentLevel = 3 then 'prod'
else 'Unknown'
end as Environment,
case
when cds.authenticationType = 1 then 'Non-SSO'
when cds.authenticationType = 2 then 'SSO'
when cds.authenticationType = 3 then 'Precisely SSO'
else 'Unknown'
end as Authentication,
ds.server as DatabaseServer,
c.id as CompanyId,
concat('D3S_',c.id) as DatabaseName,
COALESCE(c.notes, '') as Notes,
CONVERT(VARCHAR(40), cmlogin.[LastUserLoginTime], 120) AS LastUserLoginTime
from
companyDomainSetting cds, company c, client cl, databaseserver ds, CompanyLogin cmlogin
where
c.databaseserverid = ds.id and cmlogin.CompanyID = c.ID and
cds.companyId = c.id and c.clientId = cl.id and [status] != 'Inactive'
order by cl.name, c.environmentLevel, cds.urlPrefix;