SELECT
    r.session_id,
    t.exec_context_id,
    t.scheduler_id,
    s.host_name,
    s.program_name,
    r.status AS request_status,
    w.status AS worker_status,
    w.state,
    t.task_state,
    r.command,
    s.host_process_id,
    s.client_interface_name,
    s.login_name,
    t.context_switches_count,
    s.last_request_start_time,
    s.last_request_end_time,
    r.request_id,
    r.start_time,
    DB_NAME(r.database_id) AS database_name,
    r.user_id,
    r.connection_id,
    r.blocking_session_id,
    r.wait_type AS request_wait_type,
    r.wait_time AS request_wait_time,
    r.last_wait_type,
    w.last_wait_type AS worker_last_wait_type,
    r.wait_resource,
    r.open_transaction_count,
    r.open_resultset_count,
    r.transaction_id,
    r.percent_complete,
    r.estimated_completion_time,
    r.cpu_time,
    r.total_elapsed_time,
    r.scheduler_id,
    r.task_address,
    r.reads AS request_reds,
    s.reads AS session_reads,
    r.writes AS request_writes,
    s.writes AS session_writes,
    r.logical_reads AS request_logical_reads,
    s.logical_reads AS session_logical_reads,
    t.pending_io_count,
    t.pending_io_byte_count,
    t.pending_io_byte_average,
    r.lock_timeout,
    r.deadlock_priority,
    r.row_count AS request_row_count,
    s.row_count AS session_row_count,
    s.open_transaction_count,
    r.granted_query_memory,
    r.group_id,
    r.query_hash,
    r.query_plan_hash,
    r.statement_context_id,
    r.dop,
    SUBSTRING(st.text, (r.statement_start_offset/2)+1,
    ((CASE r.statement_end_offset  
        WHEN -1 THEN DATALENGTH(st.text)  
        ELSE r.statement_end_offset  
        END - r.statement_start_offset)/2) + 1) AS statement_text,
    qp.query_plan
FROM
    sys.dm_exec_requests AS r
    INNER JOIN sys.dm_exec_sessions AS s
        ON r.session_id = s.session_id
        AND s.is_user_process = 1 AND s.program_name <> 'TdService'
    INNER JOIN sys.dm_os_tasks AS t
        ON t.session_id = s.session_id
    INNER JOIN sys.dm_os_workers AS w
        ON w.worker_address = t.worker_address
    OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
    OUTER APPLY sys.dm_exec_query_plan(r.plan_handle) AS qp
WHERE

    r.session_id <> @@SPID
ORDER BY
    r.session_id, t.exec_context_id