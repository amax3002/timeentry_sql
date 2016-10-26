
--Find all time entries.
SELECT * FROM time_entries

--Find the developer who joined most recently.
SELECT * FROM developers
ORDER BY created_at DESC
LIMIT 1

--Find the number of projects for each client.
SELECT c.name AS client_name, count(p.client_id) AS counter FROM clients AS c
LEFT JOIN projects AS p ON c.id = p.client_id
GROUP BY c.name
ORDER BY counter DESC

--Find all time entries, and show each one's client name next to it.
SELECT te.*, c.name FROM time_entries AS te
LEFT JOIN projects AS p ON te.project_id = p.id
LEFT JOIN clients AS c ON c.id = p.client_id

--Find all developers in the "Ohio sheep" group.
SELECT d.*, g.name FROM developers AS d
LEFT JOIN group_assignments AS ga ON ga.developer_id = d.id
LEFT JOIN groups AS g ON g.id = ga.group_id
WHERE g.name = 'Ohio sheep'


--Find the total number of hours worked for each client.
SELECT c.name, sum(te.duration) AS total_hours FROM time_entries AS te
LEFT JOIN projects AS p ON te.project_id = p.id
LEFT JOIN clients AS c ON c.id = p.client_id
GROUP BY c.name

--Find the client for whom Mrs. Lupe Schowalter (the developer) has worked the greatest number of hours.
SELECT d.*, c.name, sum(te.duration) AS total_hours FROM time_entries AS te
LEFT JOIN developers AS d ON te.developer_id = d.id
LEFT JOIN projects AS p ON te.project_id = p.id
LEFT JOIN clients AS c ON c.id = p.client_id
GROUP BY c.name, c.name
ORDER BY total_hours DESC
LIMIT 1

-- List all client names with their project names (multiple rows for one client is fine). Make sure that clients still show up even if they have no projects.
SELECT c.name, p.name FROM clients AS c
LEFT JOIN projects AS p ON c.id = p.client_id

--Find all developers who have written no comments.
SELECT d.*, ct.comment FROM developers AS d
LEFT JOIN comments AS ct ON ct.developer_id = d.id
WHERE ct.comment IS NULL

--HARD
--Find all developers with at least five comments.
SELECT d.*, count(developer_id) FROM comments as ct
LEFT JOIN developers as d on d.id = ct.developer_id
GROUP BY ct.developer_id
HAVING count(developer_id)>= 5

--Find the developer who worked the fewest hours in January of 2015.
SELECT d.*, c.name as client_name, sum(te.duration) AS total_hours FROM time_entries AS te
LEFT JOIN developers AS d ON te.developer_id = d.id
LEFT JOIN projects AS p ON te.project_id = p.id
LEFT JOIN clients AS c ON c.id = p.client_id
WHERE te.worked_on >= '2015-01-01' AND te.worked_on <= '2015-01-30'
GROUP BY c.name
ORDER BY total_hours asc

--Find all time entries which were created by developers who were not assigned to that time entry's project.
SELECT d.*, pa.project_id, te.project_id FROM time_entries AS te
LEFT JOIN project_assignments AS pa ON pa.developer_id = te.developer_id AND
pa.project_id = te.project_id
LEFT JOIN developers AS d ON d.id = te.developer_id
WHERE pa.project_id IS NULL

--Find all developers with no time put towards at least one of their assigned projects.
SELECT d.*, pa.project_id, te.project_id, te.duration FROM time_entries AS te
LEFT JOIN project_assignments AS pa ON pa.developer_id = te.developer_id AND
pa.project_id = te.project_id
LEFT JOIN developers AS d ON d.id = te.developer_id
WHERE pa.project_id IS NOT NULL AND te.duration = 0

--Find all pairs of developers who are in two or more different groups together.
SELECT * FROM developers
WHERE id IN
	(SELECT developer_id
	FROM group_assignments
GROUP BY group_id
HAVING count(group_id) >= 2)

--For all clients, find the duration of the time entry which was entered most recently for that particular client.
SELECT c.name as client_name, te.duration, max(te.worked_on) as most_recent_date FROM time_entries AS te
LEFT JOIN projects AS p ON te.project_id = p.id
LEFT JOIN clients AS c ON c.id = p.client_id
GROUP BY c.name
order by most_recent_date

-*
--Did this a second way to include the 3 clients that have no time entries
SELECT c.name as client_name,te.duration, max(te.worked_on) as most_recent_date  FROM clients as c
LEFT JOIN projects AS p ON  c.id = p.client_id
LEFT JOIN time_entries AS te ON te.project_id = p.id
GROUP BY c.name
order by most_recent_date DESC
