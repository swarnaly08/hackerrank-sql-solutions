SELECT 
    s1.submission_date,
    
    (
        SELECT COUNT(DISTINCT s2.hacker_id)
        FROM Submissions s2
        WHERE (
            SELECT COUNT(DISTINCT s3.submission_date)
            FROM Submissions s3
            WHERE s3.hacker_id = s2.hacker_id
              AND s3.submission_date <= s2.submission_date
        ) = DATEDIFF(s2.submission_date, '2016-03-01') + 1
        AND s2.submission_date = s1.submission_date
    ) AS total_hackers,

    (
        SELECT s4.hacker_id
        FROM Submissions s4
        WHERE s4.submission_date = s1.submission_date
        GROUP BY s4.hacker_id
        ORDER BY COUNT(*) DESC, s4.hacker_id ASC
        LIMIT 1
    ) AS hacker_id,

    (
        SELECT h.name
        FROM Hackers h
        WHERE h.hacker_id = (
            SELECT s5.hacker_id
            FROM Submissions s5
            WHERE s5.submission_date = s1.submission_date
            GROUP BY s5.hacker_id
            ORDER BY COUNT(*) DESC, s5.hacker_id ASC
            LIMIT 1
        )
    ) AS name

FROM (SELECT DISTINCT submission_date FROM Submissions) s1
ORDER BY s1.submission_date;