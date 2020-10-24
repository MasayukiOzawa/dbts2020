-- Create Table
IF OBJECT_ID('DBAccess') IS NULL
BEGIN
    SELECT
        SYSDATETIME() AS collect_date,
        DB_NAME() AS database_name,
        f.name,
        f.type_desc,
        vf.num_of_reads,
        vf.num_of_bytes_read,
        vf.io_stall_read_ms,
        vf.io_stall_queued_read_ms,
        vf.num_of_writes,
        vf.num_of_bytes_written,
        vf.io_stall_write_ms,
        vf.io_stall_queued_write_ms,
        vf.io_stall,
        vf.size_on_disk_bytes
    INTO 
        DBAccess 
    FROM
        sys.database_files AS f
        OUTER APPLY sys.dm_io_virtual_file_stats(DB_ID(), f.file_id) AS vf
    WHERE 1=0;
END
GO
CREATE CLUSTERED INDEX CIX_DBAccess ON DBAccess(collect_date) WITH(DATA_COMPRESSION=PAGE);
GO