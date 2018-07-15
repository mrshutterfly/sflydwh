DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS sitevisits CASCADE;
DROP TABLE IF EXISTS imageuploads CASCADE;
DROP TABLE IF EXISTS orders CASCADE;

-- CUSTOMERS
CREATE TABLE customers
(
        customer_id VARCHAR(50) NOT NULL PRIMARY KEY,
        event_time TIMESTAMP NOT NULL,
        last_name VARCHAR(50),
        adr_city VARCHAR(50),
        adr_state CHAR(2)
);

INSERT INTO customers VALUES
('96f55c7d8f42', '2018-01-01 00:00:39.123', 'A', 'Middletown', 'AK'),
('96f55c7d8f43', '2018-01-02 00:00:39.123', 'B', 'Fremont', 'CA'),
('96f55c7d8f44', '2018-01-03 00:00:39.123', 'C', 'Oakland', 'CA'),
('96f55c7d8f45', '2018-01-04 00:00:39.123', 'D', 'Sanjose', 'CA'),
('96f55c7d8f46', '2018-01-05 00:00:39.123', 'E', 'Sunnvyvale', 'CA'),
('96f55c7d8f47', '2018-01-06 00:00:39.123', 'F', 'Santaclara', 'CA')
;

-- Site Visits
CREATE TABLE sitevisits
(
        page_id VARCHAR(50) NOT NULL PRIMARY KEY,
        event_time TIMESTAMP NOT NULL,
        customer_id VARCHAR(50) NOT NULL,
        tags VARCHAR(255)
);

ALTER TABLE sitevisits
        ADD CONSTRAINT fk_sitevisits
                FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

-- Considering 5 weeks time range (2017 Dec 25-31, 2018 Jan 1-7, 8-14, 15-21, 22-28) to allign with week of calander year
INSERT INTO sitevisits VALUES
-- Customer 96f55c7d8f42 will have at least one visit in every week
-- Week 2017 Dec 25-31,
('abcdee', '2017-12-27 23:00:39.123', '96f55c7d8f42', '{''name1'':''value1'', ''name2'':''value2''}'),

-- Week 2018 Jan 1-7
('abcdef', '2018-01-01 00:00:39.123', '96f55c7d8f42', '{''name1'':''value1'', ''name2'':''value2''}'),
('abcdeg', '2018-01-02 01:00:39.123', '96f55c7d8f42', '{''name1'':''value1'', ''name2'':''value2''}'),
('abcdeh', '2018-01-03 02:00:39.123', '96f55c7d8f42', '{''name1'':''value1'', ''name2'':''value2''}'),
('abcdei', '2018-01-07 23:00:39.123', '96f55c7d8f42', '{''name1'':''value1'', ''name2'':''value2''}'),

-- Week 2018 Jan 8-14

('abcdej', '2018-01-08 00:00:39.123', '96f55c7d8f42', '{''name1'':''value1'', ''name2'':''value2''}'),
('abcdek', '2018-01-13 01:00:39.123', '96f55c7d8f42', '{''name1'':''value1'', ''name2'':''value2''}'),

-- Week 2018 Jan 15-21

('abcdel', '2018-01-21 02:00:39.123', '96f55c7d8f42', '{''name1'':''value1'', ''name2'':''value2''}'),
('abcdem', '2018-01-21 23:00:39.123', '96f55c7d8f42', '{''name1'':''value1'', ''name2'':''value2''}'),

-- Week 2018 Jan 22-28
('abcden', '2018-01-25 02:00:39.123', '96f55c7d8f42', '{''name1'':''value1'', ''name2'':''value2''}'),

-- Customer 96f55c7d8f43 may not have visit every week
-- Week 2017 Dec 25-31,
('bbcdee', '2017-12-28 23:00:39.123', '96f55c7d8f43', '{''name1'':''value1'', ''name2'':''value2''}'),

-- Week 2018 Jan 1-7
('bbcdef', '2018-01-01 00:00:39.123', '96f55c7d8f43', '{''name1'':''value1'', ''name2'':''value2''}'),

-- Week 2018 Jan 8-14

('bbcdej', '2018-01-08 00:00:39.123', '96f55c7d8f43', '{''name1'':''value1'', ''name2'':''value2''}'),
('bbcdek', '2018-01-13 01:00:39.123', '96f55c7d8f43', '{''name1'':''value1'', ''name2'':''value2''}'),

-- Week 2018 Jan 15-21

('bbcdel', '2018-01-21 02:00:39.123', '96f55c7d8f43', '{''name1'':''value1'', ''name2'':''value2''}'),

-- Week 2018 Jan 22-28

-- Customer 96f55c7d8f44 only 3 visits out of 5 weeks
-- Week 2017 Dec 25-31,
('cbcdee', '2017-12-28 23:00:39.123', '96f55c7d8f44', '{''name1'':''value1'', ''name2'':''value2''}'),

-- Week 2018 Jan 1-7
('cbcdef', '2018-01-01 00:00:39.123', '96f55c7d8f44', '{''name1'':''value1'', ''name2'':''value2''}'),

-- Week 2018 Jan 8-14

-- Week 2018 Jan 15-21

('cbcdel', '2018-01-21 02:00:39.123', '96f55c7d8f44', '{''name1'':''value1'', ''name2'':''value2''}'),

-- Week 2018 Jan 22-28

-- Customer 96f55c7d8f45 only 2 visits out of 5 weeks

-- Week 2017 Dec 25-31,

-- Week 2018 Jan 1-7
('dbcdef', '2018-01-01 00:00:39.123', '96f55c7d8f45', '{''name1'':''value1'', ''name2'':''value2''}'),

-- Week 2018 Jan 8-14

-- Week 2018 Jan 15-21

('dbcdel', '2018-01-21 02:00:39.123', '96f55c7d8f45', '{''name1'':''value1'', ''name2'':''value2''}'),

-- Week 2018 Jan 22-28

-- Customer 96f55c7d8f46 only 1 visits out of 5 weeks

-- Week 2017 Dec 25-31,

-- Week 2018 Jan 1-7
('ebcdef', '2018-01-01 00:00:39.123', '96f55c7d8f46', '{''name1'':''value1'', ''name2'':''value2''}')

-- Week 2018 Jan 8-14

-- Week 2018 Jan 15-21

-- Week 2018 Jan 22-28

-- Customer 96f55c7d8f47 has 0 visits out of 5 weeks
;


-- image upload
CREATE TABLE imageuploads
(
        image_id VARCHAR(50) NOT NULL PRIMARY KEY,
        event_time TIMESTAMP NOT NULL,
        customer_id VARCHAR(50) NOT NULL,
        camera_make VARCHAR(50),
        camera_model VARCHAR(50)
);

ALTER TABLE imageuploads
        ADD CONSTRAINT fk_imageuploads
                FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

INSERT INTO imageuploads VALUES ('abcdef','2018-01-01 00:00:39.123',  '96f55c7d8f46', 'Canon', 'EOS 80D');
-- order

CREATE TABLE orders
(
        order_id VARCHAR(50) NOT NULL PRIMARY KEY,
        event_time TIMESTAMP NOT NULL,
        customer_id VARCHAR(50) NOT NULL,
        total_amount DOUBLE PRECISION NOT NULL
);

ALTER TABLE orders
        ADD CONSTRAINT fk_orders
                FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

INSERT INTO orders VALUES
-- customer 96f55c7d8f42 made 3 orders
('abcdef', '2017-12-27 23:10:39.123', '96f55c7d8f42', 10000.50),
('abcdeg', '2018-01-05 23:10:39.123', '96f55c7d8f42', 150.75),
('abcdeh', '2018-01-20 23:10:39.123', '96f55c7d8f42', 3939.39),

-- customer 96f55c7d8f43 made 4 orders
('bbcdef', '2017-12-28 23:58:39.123', '96f55c7d8f43', 10000.50),
('bbcdeg', '2018-01-01 23:10:39.123', '96f55c7d8f43', 150.75),
('bbcdeh', '2018-01-08 23:10:39.123', '96f55c7d8f43', 3939.39),
('bbcdei', '2018-01-13 23:10:39.123', '96f55c7d8f43', 43939.39),

-- customer 96f55c7d8f44 made 2 orders
('cbcdef', '2017-12-28 23:58:39.123', '96f55c7d8f44', 10000.50),
('cbcdeg', '2018-01-01 23:10:39.123', '96f55c7d8f44', 150.75),

-- customer 96f55c7d8f45 made 1 orders
('dbcdef', '2018-01-21 23:58:39.123', '96f55c7d8f45', 10000.50)
;

-- customer 96f55c7d8f46 don't have any orders

-- Get the customer expendeture per visit
-- for better readability to reuse of common expressions I am using CTE
WITH num_of_weeks AS
(
        SELECT
                -- Using Year, week of year combination to handle the input data where events span between multiple years
                -- As week of year will be repetead across different years
                COUNT(DISTINCT CAST(EXTRACT(YEAR FROM event_time) AS CHAR(4))||CAST(EXTRACT(WEEK FROM event_time) AS CHAR(2))) AS week_count
        FROM
                sitevisits
),
cust_total_visits_and_visits_per_week AS
(
        SELECT
                customer_id,
                -- Since page_ids are unique there is no need to worry about duplicates
                COUNT(page_id) AS total_visits,
                COUNT(page_id)*1.0/week_count AS cust_visits_per_week
        FROM
                sitevisits
        JOIN
                num_of_weeks
        ON
                1 = 1
        GROUP BY
                customer_id,
                week_count -- Added in group by as SQL forces to use aggr function if not included in group by clause
),
cust_expendeture_per_visit AS
(
        SELECT
                o.customer_id,
                SUM(total_amount)*1.0/total_visits AS cust_expendeture_per_visit
        FROM
                orders o
        JOIN
                cust_total_visits_and_visits_per_week cv
        ON
                o.customer_id = cv.customer_id
        GROUP BY
                o.customer_id,
                total_visits
)
SELECT
        c.customer_id,
        last_name,
        adr_city,
        adr_state,
        COALESCE(52 * (cust_expendeture_per_visit * cust_visits_per_week) * 10.0, CAST(0.0 AS DOUBLE PRECISION)) AS cust_LTV
FROM
        customers c
LEFT JOIN
        cust_total_visits_and_visits_per_week cvpw
ON
        c.customer_id = cvpw.customer_id
LEFT JOIN
        cust_expendeture_per_visit cepw
ON
        c.customer_id = cepw.customer_id
ORDER BY
        cust_ltv DESC
;

