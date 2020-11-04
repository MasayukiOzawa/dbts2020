SELECT
    SYSDATETIME() AS collect_date,
    CASE
        WHEN wait_type = 'SOS_SCHEDULER_YIELD' 
            THEN 'CPU'
        WHEN wait_type = 'THREADPOOL' 
            THEN 'Worker Thread'
        WHEN wait_type LIKE 'LCK_M_%' 
            THEN 'Lock'
        WHEN wait_type LIKE 'LATCH_%' 
            THEN 'Latch'
        WHEN wait_type LIKE 'PAGELATCH_%' 
            THEN 'Buffer Latch'
        WHEN wait_type LIKE 'PAGEIOLATCH_%' 
            THEN 'Buffer IO'
        WHEN wait_type ='RESOURCE_SEMAPHORE_QUERY_COMPILE' 
            THEN 'Compilation'
        WHEN wait_type LIKE 'CLR%' or wait_type LIKE 'SQLCLR%' 
            THEN 'SQL CLR'
        WHEN wait_type LIKE 'DBMIRROR%' 
            THEN 'Mirroring'
        WHEN wait_type LIKE 'XACT%'OR wait_type LIKE 'DTC%' OR wait_type LIKE 'TRAN_MARKLATCH_%' OR wait_type LIKE 'MSQL_XACT_%' OR wait_type = 'TRANSACTION_MUTEX' 
            THEN 'Transaction'
        WHEN wait_type LIKE 'SLEEP_%'
                OR wait_type IN(
                    'LAZYWRITER_SLEEP', 'SQLTRACE_BUFFER_FLUSH', 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP', 'SQLTRACE_WAIT_ENTRIES', 'FT_IFTS_SCHEDULER_IDLE_WAIT', 'XE_DISPATCHER_WAIT', 'REQUEST_FOR_DEADLOCK_SEARCH', 'LOGMGR_QUEUE', 'ONDEMAND_TASK_QUEUE', 'CHECKPOINT_QUEUE', 'XE_TIMER_EVENT'
                    ) 
            THEN 'Idle'
        WHEN wait_type LIKE 'PREEMPTIVE_%' 
            THEN 'Transaction'
        WHEN wait_type LIKE 'BROKER_%' AND wait_type <> 'BROKER_RECEIVE_WAITFOR' 
            THEN 'Service Broker'
        WHEN wait_type IN(
                        'LOGMGR', 'LOGBUFFER', 'LOGMGR_RESERVE_APPEND', 'LOGMGR_FLUSH', 'LOGMGR_PMM_LOG', 'CHKPT', 'WRITELOG'
                    ) 
            THEN 'Tran Log IO'
        WHEN wait_type IN(
                    'ASYNC_NETWORK_IO', 'NET_WAITFOR_PACKET', 'PROXY_NETWORK_IO', 'EXTERNAL_SCRIPT_NETWORK_IOF') 
            THEN 'Network IO'
        WHEN wait_type IN(
                    'CXPACKET', 'EXCHANGE'
                    )
                OR wait_type LIKE 'HT%'  OR wait_type LIKE 'BMP%' OR wait_type LIKE 'BP%'
            THEN 'Parallelism'
        WHEN wait_type IN(
                    'RESOURCE_SEMAPHORE', 'CMEMTHREAD', 'CMEMPARTITIONED', 'EE_PMOLOCK', 'MEMORY_ALLOCATION_EXT', 'RESERVED_MEMORY_ALLOCATION_EXT', 'MEMORY_GRANT_UPDATE'
                    ) 
            THEN 'Memory'
        WHEN wait_type IN(
                    'WAITFOR', 'WAIT_FOR_RESULTS', 'BROKER_RECEIVE_WAITFOR'
                    ) 
            THEN 'User Wait'
        WHEN wait_type IN(
                    'TRACEWRITE', 'SQLTRACE_LOCK', 'SQLTRACE_FILE_BUFFER', 'SQLTRACE_FILE_WRITE_IO_COMPLETION', 'SQLTRACE_FILE_READ_IO_COMPLETION', 'SQLTRACE_PENDING_BUFFER_WRITERS', 'SQLTRACE_SHUTDOWN', 'QUERY_TRACEOUT', 'TRACE_EVTNOTIFF'
                    ) 
            THEN 'Tracing'
        WHEN wait_type IN(
                    'FT_RESTART_CRAWL', 'FULLTEXT GATHERER', 'MSSEARCH', 'FT_METADATA_MUTEX', 'FT_IFTSHC_MUTEX', 'FT_IFTSISM_MUTEX', 'FT_IFTS_RWLOCK', 'FT_COMPROWSET_RWLOCK', 'FT_MASTER_MERGE', 'FT_PROPERTYLIST_CACHE', 'FT_MASTER_MERGE_COORDINATOR', 'PWAIT_RESOURCE_SEMAPHORE_FT_PARALLEL_QUERY_SYNC'
                    ) 
            THEN 'Full Text Search'
        WHEN wait_type IN(
                    'ASYNC_IO_COMPLETION', 'IO_COMPLETION', 'BACKUPIO', 'WRITE_COMPLETION', 'IO_QUEUE_LIMIT', 'IO_RETRY'
                    ) 
            THEN 'Other Disk IO'
        WHEN wait_type LIKE 'SE_REPL_%'  OR (wait_type LIKE 'HADR%' AND wait_type <> 'HADR_THROTTLE_LOG_RATE_GOVERNOR')
                OR wait_type LIKE 'REPL_%' 
                OR wait_type LIKE 'PWAIT_HADR_%' OR 
                wait_type IN('REPLICA_WRITES', 'FCB_REPLICA_WRITE', 'FCB_REPLICA_READ', 'PWAIT_HADRSIM'
                    ) 
            THEN 'Replication'
        WHEN wait_type IN(
                    'LOG_RATE_GOVERNOR', 'POOL_LOG_RATE_GOVERNOR', 'HADR_THROTTLE_LOG_RATE_GOVERNOR', 'INSTANCE_LOG_RATE_GOVERNOR'
                    ) 
            THEN 'Log Rate Governor'
        WHEN wait_type LIKE 'BACKUP%' AND wait_type <> 'BACKUPBUFFER' 
            THEN 'Backup'
        WHEN wait_Type LIKE 'WAIT_RBIO%' 
            THEN 'hs_remote_block_io'
    ELSE 'Unknown'
    END AS wait_category,
    w.wait_type,
    w.waiting_tasks_count,
    w.wait_time_ms,
    w.max_wait_time_ms,
    w.signal_wait_time_ms
FROM
    sys.dm_os_wait_stats AS w
WHERE
    w.wait_type IN(
        'SOS_SCHEDULER_YIELD', 
        'THREADPOOL', 
        'RESOURCE_SEMAPHORE_QUERY_COMPILE', 
        'LAZYWRITER_SLEEP', 'SQLTRACE_BUFFER_FLUSH', 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP', 'SQLTRACE_WAIT_ENTRIES', 'FT_IFTS_SCHEDULER_IDLE_WAIT', 'XE_DISPATCHER_WAIT', 'REQUEST_FOR_DEADLOCK_SEARCH', 'LOGMGR_QUEUE', 'ONDEMAND_TASK_QUEUE', 'CHECKPOINT_QUEUE', 'XE_TIMER_EVENT',
        'LOGMGR','LOGBUFFER','LOGMGR_RESERVE_APPEND','LOGMGR_FLUSH','LOGMGR_PMM_LOG','CHKPT','WRITELOG', 
        'ASYNC_NETWORK_IO', 'NET_WAITFOR_PACKET', 'PROXY_NETWORK_IO', 'EXTERNAL_SCRIPT_NETWORK_IOF', 
        'CXPACKET', 'EXCHANGE', 
        'RESOURCE_SEMAPHORE', 'CMEMTHREAD', 'CMEMPARTITIONED', 'EE_PMOLOCK', 'MEMORY_ALLOCATION_EXT', 'RESERVED_MEMORY_ALLOCATION_EXT', 'MEMORY_GRANT_UPDATE',
        'WAITFOR', 'WAIT_FOR_RESULTS', 'BROKER_RECEIVE_WAITFOR', 
        'TRACEWRITE', 'SQLTRACE_LOCK', 'SQLTRACE_FILE_BUFFER', 'SQLTRACE_FILE_WRITE_IO_COMPLETION', 'SQLTRACE_FILE_READ_IO_COMPLETION', 'SQLTRACE_PENDING_BUFFER_WRITERS', 'SQLTRACE_SHUTDOWN', 'QUERY_TRACEOUT', 'TRACE_EVTNOTIFF',
        'FT_RESTART_CRAWL', 'FULLTEXT GATHERER', 'MSSEARCH', 'FT_METADATA_MUTEX', 'FT_IFTSHC_MUTEX', 'FT_IFTSISM_MUTEX', 'FT_IFTS_RWLOCK', 'FT_COMPROWSET_RWLOCK', 'FT_MASTER_MERGE', 'FT_PROPERTYLIST_CACHE', 'FT_MASTER_MERGE_COORDINATOR', 'PWAIT_RESOURCE_SEMAPHORE_FT_PARALLEL_QUERY_SYNC',
        'ASYNC_IO_COMPLETION', 'IO_COMPLETION', 'BACKUPIO', 'WRITE_COMPLETION', 'IO_QUEUE_LIMIT', 'IO_RETRY',
        'REPLICA_WRITES', 'FCB_REPLICA_WRITE', 'FCB_REPLICA_READ', 'PWAIT_HADRSIM',
        'LOG_RATE_GOVERNOR', 'POOL_LOG_RATE_GOVERNOR', 'HADR_THROTTLE_LOG_RATE_GOVERNOR', 'INSTANCE_LOG_RATE_GOVERNOR'
    )
    OR w.wait_type LIKE 'LCK_M_%'
    OR w.wait_type LIKE 'LATCH_%'
    OR w.wait_type LIKE 'PAGELATCH_%'
    OR w.wait_type LIKE 'PAGEIOLATCH_%'
    OR w.wait_type LIKE 'CLR%' OR w.wait_type LIKE 'SQLCLR%'
    OR w.wait_type LIKE 'DBMIRROR%'
    OR w.wait_type LIKE 'XACT%' OR w.wait_type LIKE 'DTC%' OR w.wait_type LIKE 'TRAN_MARKLATCH_%' OR w.wait_type LIKE 'MSQL_XACT_%' OR w.wait_type LIKE 'TRANSACTION_MUTEX'
    OR w.wait_type LIKE 'SLEEP_%'
    OR w.wait_type LIKE 'PREEMPTIVE_%'
    OR w.wait_type LIKE 'BROKER_%'
    OR w.wait_type LIKE 'HT%' OR w.wait_type LIKE 'BMP%' OR w.wait_type LIKE 'BP%'
    OR w.wait_type LIKE 'SE_REPL_%' OR w.wait_type LIKE 'REPL_%'
    OR w.wait_type LIKE 'HADR_%' OR w.wait_type LIKE 'PWAIT_HADR_%'
    OR w.wait_type LIKE 'BACKUP%'
    OR w.wait_type LIKE 'WAIT_RBIO%'
ORDER BY
    wait_type ASC
