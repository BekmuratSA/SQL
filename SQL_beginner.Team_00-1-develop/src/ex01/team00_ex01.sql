CREATE VIEW journey AS 
(WITH RECURSIVE way AS 
    (SELECT point1::bpchar AS tour,
            point1,
            point2,
            cost AS sum
     FROM graph
     WHERE point1 = 'a'
     UNION
     SELECT prev.tour || ',' || prev.point2 AS tour,
            curr.point1,
            curr.point2,
            curr.cost + prev.sum AS sum
     FROM graph curr
        JOIN way prev ON curr.point1 = prev.point2
     WHERE prev.tour NOT LIKE '%' || prev.point2 || '%')
 SELECT * FROM way);


SELECT sum AS total_cost,
      '{' || tour || ',' || point2 || '}' AS tour
FROM journey
WHERE point2 = 'a' AND 
      sum = (SELECT min(sum)
             FROM journey
             WHERE length(tour) = 7 AND point2 = 'a')
ORDER BY 1, 2;

(SELECT sum AS total_cost,
       '{' || tour || ',' || point2 || '}' AS tour
FROM journey
WHERE point2 = 'a' AND 
      sum = (SELECT min(sum)
               FROM journey
               WHERE length(tour) = 7 AND point2 = 'a')
ORDER BY 1, 2)
UNION 
(SELECT sum AS total_cost,
       '{' || tour || ',' || point2 || '}' AS tour
FROM journey 
WHERE point2 = 'a' AND 
      sum = (SELECT max(sum)
             FROM journey
             WHERE length(tour) = 7 AND point2 = 'a')
ORDER BY 1, 2);
                    