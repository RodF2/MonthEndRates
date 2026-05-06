query = """
SELECT
    EFFECTIVE_BUSINESS_DATE AS DATE,
    TICKER,
    INSTRUMENT_NAME,
    PX_LAST AS PRICE
FROM
    SPD.MARKET_DATA.INSTRUMENT_PRICE_VIEW IPV
WHERE IPV.TICKER IN (
    'TSFR1M',
    'TSFR3M',
    'TSFR6M',
    'USOSFR1',
    'USOSFR2',
    'USOSFR3',
    'USOSFR5',
    'USOSFR7',
    'USOSFR10',
    'USGG1M',
    'USGG3M',
    'USGG6M',
    'USGG12M',
    'USGG2YR',
    'USGG3YR',
    'USGG5YR',
    'USGG7YR',
    'USGG10YR',
    'USGG30YR'
)
AND EFFECTIVE_BUSINESS_DATE = CASE
    WHEN DAYOFWEEK(DATEADD(DAY, -1, DATE_TRUNC('MONTH', CURRENT_DATE()))) = 0 THEN
        DATEADD(DAY, -2, DATEADD(DAY, -1, DATE_TRUNC('MONTH', CURRENT_DATE())))
    WHEN DAYOFWEEK(DATEADD(DAY, -1, DATE_TRUNC('MONTH', CURRENT_DATE()))) = 6 THEN
        DATEADD(DAY, -1, DATEADD(DAY, -1, DATE_TRUNC('MONTH', CURRENT_DATE())))
    ELSE
        DATEADD(DAY, -1, DATE_TRUNC('MONTH', CURRENT_DATE()))
END
ORDER BY
    IPV.TICKER,
    EFFECTIVE_BUSINESS_DATE
"""

from sspjump.auth import get_snowflake_connection

# When we create or instantiate our Snowflake connection, SSP Jump is doing work for us in the background.
my_snowflake_connection = get_snowflake_connection(role="SPD_READONLY", environment="prod", warehouse="ABF_WH")

# Now we can get retreive data from snowflake
cursor = my_snowflake_connection.cursor()
cursor.execute(query)
df = cursor.fetch_pandas_all()
df