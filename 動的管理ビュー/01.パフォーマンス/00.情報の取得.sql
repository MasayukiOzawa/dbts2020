SELECT 
    SYSDATETIME() AS collect_date,
    RTRIM(object_name) AS object_name,
    RTRIM(counter_name) AS counter_name,
    RTRIM(instance_name) AS instance_name,
    cntr_value,
    cntr_type
FROM 
    sys.dm_os_performance_counters;