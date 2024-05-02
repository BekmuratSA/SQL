-- DDL

CREATE TABLE graph
(
    id     BIGINT PRIMARY KEY,
    point1 VARCHAR NOT NULL,
    point2 VARCHAR NOT NULL,
    cost   INT     NOT NULL
);

INSERT INTO graph VALUES (1, 'a', 'b', 10);
INSERT INTO graph VALUES (2, 'a', 'c', 15);
INSERT INTO graph VALUES (3, 'a', 'd', 20);

INSERT INTO graph VALUES (4, 'b', 'a', 10);
INSERT INTO graph VALUES (5, 'b', 'c', 35);
INSERT INTO graph VALUES (6, 'b', 'd', 25);

INSERT INTO graph VALUES (7, 'c', 'a', 15);
INSERT INTO graph VALUES (8, 'c', 'b', 35);
INSERT INTO graph VALUES (9, 'c', 'd', 30);

INSERT INTO graph VALUES (10, 'd', 'a', 20);
INSERT INTO graph VALUES (11, 'd', 'b', 25);
INSERT INTO graph VALUES (12, 'd', 'c', 30);

-- DML

WITH RECURSIVE p(last_point, tour) AS (
	SELECT
		point1,
		ARRAY[point1]::char(1)[], 0 AS cost
	FROM graph
	WHERE point1 = 'a'

	UNION

	SELECT
		graph.point2 AS last_point,
		(p.tour || ARRAY[graph.point2])::char(1)[] AS tour,
		p.cost + graph.cost
	FROM graph, p
	WHERE graph.point1 = p.last_point
	AND NOT graph.point2 = ANY(p.tour)
), result_path AS (
	SELECT
		array_append(tour, 'a') AS tour,
		cost + (SELECT cost FROM graph WHERE point1 = p.last_point AND point2 = 'a') as cost
	FROM p
	WHERE (SELECT array_length(p.tour, 1)) = 4
)
SELECT
	cost AS total_cost,
	tour
FROM result_path
WHERE cost = (SELECT MIN(cost) FROM result_path)
ORDER BY total_cost, tour;