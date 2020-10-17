SELECT r.pull_request_id, count(r.event_db_id) AS comment_count
FROM (
         SELECT *
         FROM pull_requests
     ) AS prs,
     (
         SELECT pull_request_id, event_db_id, comment_author_name, comment_author_type
         FROM pull_request_review_comments
         WHERE comment_created_at = comment_updated_at
           AND comment_author_name NOT IN (SELECT username FROM bots)
         UNION
         SELECT pull_request_id, event_db_id, comment_author_name, comment_author_type
         FROM pull_request_comments
         WHERE comment_created_at = comment_updated_at
           AND comment_author_name NOT IN (SELECT username FROM bots)
     ) AS r
WHERE r.pull_request_id = prs.pull_request_id
GROUP BY r.pull_request_id;