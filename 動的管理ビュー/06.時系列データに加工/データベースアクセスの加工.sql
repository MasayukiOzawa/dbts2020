SELECT
    collect_date,
    name,
    num_of_reads,
    num_of_bytes_read,
    io_stall_read_ms,
    io_stall_read_ms / CASE num_of_reads WHEN 0 THEN 1 ELSE num_of_reads END AS avg_io_stall_read_ms,
    num_of_writes,
    num_of_bytes_written,
    io_stall_write_ms,
    io_stall_write_ms / CASE num_of_writes WHEN 0 THEN 1 ELSE num_of_writes END AS avg_io_stall_write_ms
FROM
(
    SELECT
        collect_date,
        name,
        num_of_reads - LAG(num_of_reads, 1, num_of_reads) OVER (ORDER BY collect_date ASC) AS num_of_reads,
        num_of_bytes_read - LAG(num_of_bytes_read, 1, num_of_bytes_read) OVER (ORDER BY collect_date ASC) AS num_of_bytes_read,
        io_stall_read_ms - LAG(io_stall_read_ms, 1, io_stall_read_ms) OVER (ORDER BY collect_date ASC) AS io_stall_read_ms,
        num_of_writes - LAG(num_of_writes, 1, num_of_writes) OVER (ORDER BY collect_date ASC) AS num_of_writes,
        num_of_bytes_written - LAG(num_of_bytes_written, 1, num_of_bytes_written) OVER (ORDER BY collect_date ASC) AS num_of_bytes_written,
        io_stall_write_ms - LAG(io_stall_write_ms, 1, io_stall_write_ms) OVER (ORDER BY collect_date ASC) AS io_stall_write_ms
    FROM 
        DBAccess
    WHERE 
        name = 'data_0'
) AS T