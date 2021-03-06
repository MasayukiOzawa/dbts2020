SELECT
    SYSDATETIME() AS collect_date,
    OBJECT_SCHEMA_NAME(i.object_id) AS schema_name,
    OBJECT_NAME(i.object_id) AS object_name,
    i.index_id,
    i.name,
    ps.partition_number,
    i.type_desc,
    p.data_compression_desc,
    ps.row_count,
    ps.used_page_count,
    i.is_unique,
    i.allow_page_locks,
    i.allow_row_locks,
    i.compression_delay,
    i.auto_created,
    ps.in_row_data_page_count,
    ps.in_row_used_page_count,
    ps.in_row_reserved_page_count,
    ps.lob_used_page_count,
    ps.lob_reserved_page_count,
    ps.row_overflow_used_page_count,
    ps.row_overflow_reserved_page_count,
    ps.reserved_page_count,
    ius.user_seeks,
    ius.user_scans,
    ius.user_lookups,
    ius.user_updates,
    ius.last_user_seek,
    ius.last_user_scan,
    ius.last_user_lookup,
    ius.last_user_update,
    ius.system_seeks,
    ius.system_scans,
    ius.system_lookups,
    ius.system_updates,
    ius.last_system_seek,
    ius.last_system_scan,
    ius.last_system_lookup,
    ius.last_system_update,
    ios.leaf_insert_count,
    ios.leaf_delete_count,
    ios.leaf_update_count,
    ios.leaf_ghost_count,
    ios.nonleaf_insert_count,
    ios.nonleaf_delete_count,
    ios.nonleaf_update_count,
    ios.leaf_allocation_count,
    ios.nonleaf_allocation_count,
    ios.leaf_page_merge_count,
    ios.nonleaf_page_merge_count,
    ios.range_scan_count,
    ios.singleton_lookup_count,
    ios.forwarded_fetch_count,
    ios.lob_fetch_in_pages,
    ios.lob_fetch_in_bytes,
    ios.lob_orphan_create_count,
    ios.lob_orphan_insert_count,
    ios.row_overflow_fetch_in_pages,
    ios.row_overflow_fetch_in_bytes,
    ios.column_value_push_off_row_count,
    ios.column_value_pull_in_row_count,
    ios.row_lock_count,
    ios.row_lock_wait_count,
    ios.row_lock_wait_in_ms,
    ios.page_lock_count,
    ios.page_lock_wait_count,
    ios.page_lock_wait_in_ms,
    ios.index_lock_promotion_attempt_count,
    ios.index_lock_promotion_count,
    ios.page_latch_wait_count,
    ios.page_latch_wait_in_ms,
    ios.page_io_latch_wait_count,
    ios.page_io_latch_wait_in_ms,
    ios.tree_page_latch_wait_count,
    ios.tree_page_latch_wait_in_ms,
    ios.tree_page_io_latch_wait_count,
    ios.tree_page_io_latch_wait_in_ms,
    ios.page_compression_attempt_count,
    ios.page_compression_success_count,
    ios.version_generated_inrow,
    ios.version_generated_offrow,
    ios.ghost_version_inrow,
    ios.ghost_version_offrow,
    ios.insert_over_ghost_version_inrow,
    ios.insert_over_ghost_version_offrow
FROM
    sys.indexes AS i
    INNER JOIN sys.objects AS o
        ON o.object_id = i.object_id AND o.is_ms_shipped = 0
    INNER JOIN sys.dm_db_partition_stats AS ps
        ON ps.object_id = i.object_id AND ps.index_id = i.index_id
    INNER JOIN sys.partitions AS p
        ON p.object_id = i.object_id AND p.index_id = i.index_id AND p.partition_number = ps.partition_number
    LEFT JOIN sys.dm_db_index_usage_stats AS ius
        ON ius.database_id = DB_ID() AND ius.object_id = i.object_id AND ius.index_id = i.index_id
    OUTER APPLY sys.dm_db_index_operational_stats(DB_ID(), i.object_id, i.index_id, ps.partition_number) AS ios
    
ORDER BY
   schema_name, object_name