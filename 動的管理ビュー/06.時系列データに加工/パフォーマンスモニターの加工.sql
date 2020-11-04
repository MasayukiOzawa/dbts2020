SELECT TOP 100
    [collect_date],
    [Page lookups/sec] * 8 / interval AS [Page lookups KB/sec],
    [Page reads/sec] * 8 / interval AS [Page reads KB/sec],
    [Readahead pages/sec] * 8 / interval AS [Readahead pages KB/sec]
FROM
(
    SELECT
        [collect_date],
        DATEDIFF(SECOND, LAG([collect_date],1,[collect_date]) OVER (ORDER BY [collect_date] ASC), [collect_date]) AS interval,
        [Page lookups/sec] - LAG([Page lookups/sec],1,[Page lookups/sec]) OVER (ORDER BY [collect_date] ASC) AS [Page lookups/sec],
        [Page reads/sec] - LAG([Page reads/sec],1,[Page reads/sec]) OVER (ORDER BY [collect_date] ASC) AS [Page reads/sec],
        [Readahead pages/sec] - LAG([Readahead pages/sec],1,[Readahead pages/sec]) OVER (ORDER BY [collect_date] ASC) AS [Readahead pages/sec]
    FROM
    (
        SELECT collect_date, counter_name,cntr_value 
        FROM PerfLog
        WHERE object_name = 'Buffer Manager'
    ) AS T
    PIVOT
    (
        MAX(cntr_value)
        FOR counter_name IN(
            [Page lookups/sec], [Page reads/sec], [Readahead pages/sec]
        )
    ) AS P
) AS T2
WHERE 
    T2.interval <> 0
ORDER BY
    collect_date ASC