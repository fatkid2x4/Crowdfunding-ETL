CREATE TABLE "campaign" (
    "cd_id" int   NOT NULL,
    "contact_id" int   NOT NULL,
    "company_name" varchar(100)   NOT NULL,
    "description" text   NOT NULL,
    "goal" numeric(10,2)   NOT NULL,
    "pledged" numeric(10,2)   NOT NULL,
    "outcome" varchar(50)   NOT NULL,
    "backers_count" int   NOT NULL,
    "country" varchar(10)   NOT NULL,
    "currency" varchar(10)   NOT NULL,
    "launch_date" date   NOT NULL,
    "end_date" date   NOT NULL,
    "category_id" varchar(10)   NOT NULL,
    "subcategory_id" varchar(10)   NOT NULL,
    CONSTRAINT "pk_campaign" PRIMARY KEY (
        "cd_id"
     )
);

CREATE TABLE "category" (
    "category_id" varchar(10)   NOT NULL,
    "category_name" varchar(50)   NOT NULL,
    CONSTRAINT "pk_category" PRIMARY KEY (
        "category_id"
     )
);

CREATE TABLE "contacts" (
    "contact_id" int   NOT NULL,
    "first_name" varchar(50)   NOT NULL,
    "last_name" varchar(50)   NOT NULL,
    "email" varchar(100)   NOT NULL,
    CONSTRAINT "pk_contacts" PRIMARY KEY (
        "contact_id"
     )
);
SELECT * FROM contacts;

CREATE TABLE "subcategory" (
    "subcategory_id" varchar(10)   NOT NULL,
    "subcategory_name" varchar(50)   NOT NULL,
    CONSTRAINT "pk_subcategory" PRIMARY KEY (
        "subcategory_id"
     )
);

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_contact_id" FOREIGN KEY("contact_id")
REFERENCES "contacts" ("contact_id");

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_category_id" FOREIGN KEY("category_id")
REFERENCES "category" ("category_id");

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_subcategory_id" FOREIGN KEY("subcategory_id")
REFERENCES "subcategory" ("subcategory_id");




create table backer
(
backer_id varchar(50) not null,
cf_id int not null,
first_name varchar(100) not null,
last_name varchar(100) not null,
email varchar(200) not null,
primary key (backer_id)
);

ALTER TABLE "backer" ADD CONSTRAINT "fk_backer_cf_id" FOREIGN KEY("cf_id")
REFERENCES "campaign" ("cf_id");

select*from backer

-- Challenge Bonus queries.
-- 1. (2.5 pts)
-- Retrieve all the number of backer_counts in descending order for each `cf_id` for the "live" campaigns. 
SELECT cf_id, backers_count , outcome
FROM campaign
WHERE outcome='live'
ORDER BY backers_count DESC ;

select * from campaign


-- 2. (2.5 pts)
-- Using the "backers" table confirm the results in the first query.
select cf_id, count(backers_id)
from backers
group by (cf_id)


-- 3. (5 pts)
-- Create a table that has the first and last name, and email address of each contact.
-- and the amount left to reach the goal for all "live" projects in descending order. 

select contacts.first_name,contacts.last_name,contacts.email,campaign.goal-campaign.pledged as remaining_goal_amount
into email_contacts_remaining_goal_amount
from campaign
inner join contacts
on contacts.contact_id=campaign.contact_id
where outcome='live' 
order by remaining_goal_amount DESC



-- Check the table
select *from email_contacts_remaining_goal_amount

-- 4. (5 pts)
-- Create a table, "email_backers_remaining_goal_amount" that contains the email address of each backer in descending order, 
-- and has the first and last name of each backer, the cf_id, company name, description, 
-- end date of the campaign, and the remaining amount of the campaign goal as "Left of Goal". 


-- 5. last request by Britta for sending email to each backer to tell them how much of goal is left
select backers.email,backers.first_name,backers.last_name,
campaign.cf_id,campaign.company_name,campaign.description,campaign.end_date,campaign.goal-campaign.pledged as left_of_goal
into email_backers_remaining_goal_amount
from campaign
left join backers
on campaign.cf_id= backers.cf_id
where outcome='live'
GROUP BY backers.email,backers.first_name,backers.last_name,campaign.cf_id,campaign.company_name,campaign.description,campaign.end_date,left_of_goal
order by backers.email DESC

-- Check the table
select * from email_backers_remaining_goal_amount

