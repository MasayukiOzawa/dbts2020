-- Create Table
IF OBJECT_ID('PerfLog') IS NULL
BEGIN
    SELECT 
        CAST(SYSDATETIME() AS datetime2(3)) AS collect_date,
        CAST(object_name AS nvarchar(128)) AS object_name,
        CAST(counter_name AS nvarchar(128)) AS counter_name,
        CAST(instance_name AS nvarchar(128)) AS instance_name,
        cntr_value,
        cntr_type
    INTO 
        PerfLog 
    FROM 
        sys.dm_os_performance_counters 
    WHERE 
        1=0;
END
GO
CREATE CLUSTERED INDEX CIX_PerfLog ON PerfLog(collect_date) WITH(DATA_COMPRESSION=PAGE);
CREATE INDEX NCIX_PerfLog_CounterInfo ON PerfLog(object_name, counter_name) WITH(DATA_COMPRESSION=PAGE);
GO
