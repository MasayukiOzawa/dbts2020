SELECT TOP 1000
     collect_date, 
    [Backup] - LAG([Backup], 1, [Backup]) OVER (ORDER BY collect_date ASC) AS [Backup],
    [Buffer IO] - LAG([Buffer IO], 1, [Buffer IO]) OVER (ORDER BY collect_date ASC) AS [Buffer IO],
    [Buffer Latch] - LAG([Buffer Latch], 1, [Buffer Latch]) OVER (ORDER BY collect_date ASC) AS [Buffer Latch],
    [Compilation] - LAG([Compilation], 1, [Compilation]) OVER (ORDER BY collect_date ASC) AS [Compilation],
    [CPU] - LAG([CPU], 1, [CPU]) OVER (ORDER BY collect_date ASC) AS [CPU],
    [Full Text Search] - LAG([Full Text Search], 1, [Full Text Search]) OVER (ORDER BY collect_date ASC) AS [Full Text Search],
--    [Idle] - LAG([Idle], 1, [Idle]) OVER (ORDER BY collect_date ASC) AS [Idle],
    [Latch] - LAG([Latch], 1, [Latch]) OVER (ORDER BY collect_date ASC) AS [Latch],
    [Lock] - LAG([Lock], 1, [Lock]) OVER (ORDER BY collect_date ASC) AS [Lock],
    [Log Rate Governor] - LAG([Log Rate Governor], 1, [Log Rate Governor]) OVER (ORDER BY collect_date ASC) AS [Log Rate Governor],
    [Memory] - LAG([Memory], 1, [Memory]) OVER (ORDER BY collect_date ASC) AS [Memory],
    [Mirroring] - LAG([Mirroring], 1, [Mirroring]) OVER (ORDER BY collect_date ASC) AS [Mirroring],
    [Network IO] - LAG([Network IO], 1, [Network IO]) OVER (ORDER BY collect_date ASC) AS [Network IO],
    [Other Disk IO] - LAG([Other Disk IO], 1, [Other Disk IO]) OVER (ORDER BY collect_date ASC) AS [Other Disk IO],
    [Parallelism] - LAG([Parallelism], 1, [Parallelism]) OVER (ORDER BY collect_date ASC) AS [Parallelism],
    [Replication] - LAG([Replication], 1, [Replication]) OVER (ORDER BY collect_date ASC) AS [Replication],
    [Service Broker] - LAG([Service Broker], 1, [Service Broker]) OVER (ORDER BY collect_date ASC) AS [Service Broker],
    [SQL CLR] - LAG([SQL CLR], 1, [SQL CLR]) OVER (ORDER BY collect_date ASC) AS [SQL CLR],
    [Tracing] - LAG([Tracing], 1, [Tracing]) OVER (ORDER BY collect_date ASC) AS [Tracing],
    [Tran Log IO] - LAG([Tran Log IO], 1, [Tran Log IO]) OVER (ORDER BY collect_date ASC) AS [Tran Log IO],
    [Transaction] - LAG([Transaction], 1, [Transaction]) OVER (ORDER BY collect_date ASC) AS [Transaction],
--    [Unknown] - LAG([Unknown], 1, [Unknown]) OVER (ORDER BY collect_date ASC) AS [Unknown],
    [User Wait] - LAG([User Wait], 1, [User Wait]) OVER (ORDER BY collect_date ASC) AS [User Wait],
    [Worker Thread] - LAG([Worker Thread], 1, [Worker Thread]) OVER (ORDER BY collect_date ASC) AS [Worker Thread]
FROM
(
SELECT
    collect_date,
    wait_category,
    wait_time_ms
FROM 
    [dbo].[WaitStats]
) AS T
PIVOT(
    SUM(wait_time_ms)
    FOR wait_category IN (
        [Backup],[Buffer IO],[Buffer Latch],[Compilation],[CPU],[Full Text Search],[Idle],[Latch],
        [Lock],[Log Rate Governor],[Memory],[Mirroring],[Network IO],[Other Disk IO],[Parallelism],
        [Replication],[Service Broker],[SQL CLR],[Tracing],[Tran Log IO],[Transaction],[Unknown],[User Wait],[Worker Thread]
    )
) AS P
