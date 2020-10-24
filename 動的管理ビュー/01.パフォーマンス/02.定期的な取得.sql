-- Collect Data
SET NOCOUNT ON;

WHILE(0=0)
BEGIN
    INSERT INTO PerfLog 
    SELECT 
        SYSDATETIME() AS collect_date,
        RTRIM(object_name) AS object_name,
        RTRIM(counter_name) AS counter_name,
        RTRIM(instance_name) AS instance_name,
        cntr_value,
        cntr_type
    FROM 
        sys.dm_os_performance_counters;
    WAITFOR DELAY '00:01:00';
END