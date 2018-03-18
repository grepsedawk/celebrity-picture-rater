SELECT
  point_results.winning_picture_id,
  point_results.celebrity_id,
  COUNT(*) AS points
FROM (
  SELECT
    CASE
    WHEN least_picture_wins > greatest_picture_wins THEN
      least_picture_id
    WHEN greatest_picture_wins > least_picture_wins THEN  
      greatest_picture_id
    END winning_picture_id,
    picture_wins.celebrity_id
  FROM (
    SELECT
      LEAST(left_picture_id, right_picture_id) AS least_picture_id,
      GREATEST(left_picture_id, right_picture_id) AS greatest_picture_id,
      COALESCE(SUM(CASE chosen_picture_id WHEN LEAST(left_picture_id, right_picture_id) THEN 1 END), 0) as least_picture_wins,
      COALESCE(SUM(CASE chosen_picture_id WHEN GREATEST(left_picture_id, right_picture_id) THEN 1 END), 0) AS greatest_picture_wins,
      votes.celebrity_id
    FROM votes
    GROUP BY LEAST(left_picture_id, right_picture_id), GREATEST(left_picture_id, right_picture_id), votes.celebrity_id
    ORDER BY COUNT(*) DESC
  ) picture_wins
) point_results
WHERE winning_picture_id IS NOT NULL
GROUP BY winning_picture_id, point_results.celebrity_id
ORDER BY points DESC
